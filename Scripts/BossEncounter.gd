extends Node2D

@export var Boora : Node2D
@export var inventory : Area2D
@export var boss : Node2D
@export var itemsParent : Node2D

# Target 
@export var targetingTime : float # Time in target mode 
@export var moveTime : float
@export var moveCurve : Curve 
@export var points : Array[Node2D] # Where boss can go to target 
var isMoving : bool # In process of moving to another point 
var currPoint : int # Index into points
var holdPos : Vector2 

# Charge
@export var backTime : float
@export var backCurve : Curve
@export var backDis : float 
@export var chargeTime : float
@export var chargeCurve : Curve   
@export var chargeDis : float 
var isMoveBack : bool

# Stunned 
@export var stunTime : float 

# Recover 
@export var recoverTime : float
@export var recoverCurve : Curve 

@export var state : BossStates
@export var isActive : bool

var voidCharge

var timer : float 
var stateTimer : float

var count : int

enum BossStates {TARGET, CHARGE, STUNNED, RECOVER, DEFEAT}

func _ready():
	voidCharge = load("res://Prefabs/Void_spawner.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !isActive:
		false
	
	match state:
		BossStates.TARGET:
			Target(delta)
		BossStates.CHARGE:
			Charge(delta)
		BossStates.STUNNED:
			Stunned(delta)
		BossStates.RECOVER:
			Recover(delta)
		BossStates.DEFEAT:
			Defeat()

func Target(delta):
	stateTimer += delta
	
	# Shifting to new spot 
	if isMoving:
		var mLerp = moveCurve.sample(timer / moveTime) 
		if mLerp >= 1:
			boss.global_position = points[currPoint].global_position
			isMoving = false
			timer = 0
			return
		
		boss.global_position = lerp(holdPos, points[currPoint].global_position, mLerp)
		
		timer += delta
		return;
	
	
	# Check if time to change states 
	if stateTimer >= targetingTime:
		stateTimer = 0
		state = BossStates.CHARGE
		return
	
	# Find closest point 
	# Brute force search 
	var dis = (Boora.global_position - points[0].global_position).length_squared()
	var holdIndex = 0
	for n in points.size():
		var curr = (Boora.global_position - points[n].global_position).length_squared()
		if dis > curr:
			dis = curr
			holdIndex = n
	
	if holdIndex != currPoint:
		holdPos = boss.global_position
		currPoint = holdIndex
		isMoving = true
	

func Charge(delta):
	if isMoveBack:
		var bLerp = backCurve.sample(timer / backTime)
		
		if bLerp >= 1:
			boss.global_position = points[currPoint].global_position + Vector2(0, backDis)
			timer = 0
			isMoveBack = false
			return
		
		boss.global_position = lerp(
			points[currPoint].global_position, 
			points[currPoint].global_position + 
			Vector2(0, backDis), bLerp)
		
		timer += delta
	else:
		var cLerp = chargeCurve.sample(timer / chargeTime)
		
		if cLerp >= 1:
			boss.global_position = points[currPoint].global_position + Vector2(0, chargeDis)
			timer = 0
			isMoveBack = true
			state = BossStates.STUNNED
			
			SpawnVoidCharge()
			
			return
		
		boss.global_position = lerp(
			points[currPoint].global_position + Vector2(0, backDis), 
			points[currPoint].global_position + 
			Vector2(0, chargeDis), cLerp)
		timer += delta

func Stunned(delta):
	if stateTimer >= stunTime:
		stateTimer = 0
		timer = 0
		state = BossStates.RECOVER
		return
	
	stateTimer += delta

func Recover(delta):
	boss.global_position = points[currPoint].global_position
	#state = BossStates.TARGET
	
	var rLerp = recoverCurve.sample(timer / recoverTime)
	
	if rLerp >= 1:
		boss.global_position = points[currPoint].global_position
		timer = 0
		state = BossStates.TARGET
		return
		
	boss.global_position = lerp(
		points[currPoint].global_position + Vector2(0, chargeDis), 
		points[currPoint].global_position, rLerp)
		
	timer += delta

func Defeat():
	pass

func SpawnVoidCharge():
	var instance = voidCharge.instantiate()
	add_child(instance)
	instance.position = boss.position

func GetVoidCharge(area : Area2D):
	inventory.PlayChainVFX()
	for item in inventory.items:
		match item.itemType:
			Types.CollectType.KEY:
				item.StartAbsorb(boss)
				#item.get_parent().queue_free()
				count += 1
			_:
				item.Reset()
	inventory.items = [] # Clear inventory 
	
	if count >= 3:
		state = BossStates.DEFEAT
