extends Node2D

@export var Boora : Node2D
@export var inventory : Area2D
@export var boss : Node2D
@export var chainOrigin : Node2D
@export var itemsParent : Node2D
@export var arena : Node2D

@export var crashAudioPlayer : AudioStreamPlayer2D
@export var damageAudioplayer : AudioStreamPlayer2D

# Intro 
@export var introTime : float 

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

# Defeat 
@export var draggedTime : float
@export var draggedCurve : Curve

@export var state : BossStates
@export var isActive : bool

@export var bossVisuals : Node2D
@export var bosSprite : Sprite2D
@export var chillTexture : Texture2D
@export var chillEyeSet : Node2D
@export var attacTexture : Texture2D
@export var attacEyeSet : Node2D


var voidCharge
var hitFX

var timer : float 
var stateTimer : float

var bufferCount : int # Holds onto damage until FX is done 
var bufferTimer : float
var timeTillDamage : float 
var count : int
var startPosBeforeDragged : Vector2

enum BossStates {INTRO, TARGET, CHARGE, STUNNED, RECOVER, DEFEAT, IDLE}

func _ready():
	voidCharge = load("res://Prefabs/Void_spawner.tscn")
	hitFX = load("res://Prefabs/Hit_fx.tscn")
	
	timeTillDamage = 1.3
	bufferTimer = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !isActive:
		return
	
	DamageManage(delta)
	
	match state:
		BossStates.INTRO:
			SetVisualState(true)
			Intro(delta)
		BossStates.TARGET:
			SetVisualState(true)
			Target(delta)
		BossStates.CHARGE:
			SetVisualState(false)
			Charge(delta)
		BossStates.STUNNED:
			SetVisualState(false)
			Stunned(delta)
		BossStates.RECOVER:
			SetVisualState(false)
			Recover(delta)
		BossStates.DEFEAT:
			SetVisualState(true)
			Defeat(delta)
		BossStates.IDLE:
			return

func DamageManage(delta):
	if bufferCount > 0:
		bufferTimer += delta
		if bufferTimer >= timeTillDamage:
			bufferCount -= 1
			count += 1
			bufferTimer = 0
			bossVisuals.ShakeArena()
			damageAudioplayer.play()
	
	if count >= 4 && ((state != BossStates.DEFEAT) && (state != BossStates.IDLE)):
		startPosBeforeDragged = boss.global_position
		bufferTimer = 0
		state = BossStates.DEFEAT

# 
func Intro(delta):
	timer += delta
	boss.global_position = chainOrigin.global_position
	boss.ScaleIn()
	if timer >= introTime:
		timer = 0
		state = BossStates.TARGET

# Tracks the player on a horizontal line 
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

# Charges forward towards the player in a column 
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
			arena.ShakeArena()
			state = BossStates.STUNNED
			
			crashAudioPlayer.play()
			SpawnVoidCharge()
			
			return
		
		boss.global_position = lerp(
			points[currPoint].global_position + Vector2(0, backDis), 
			points[currPoint].global_position + 
			Vector2(0, chargeDis), cLerp)
		timer += delta

# Reached the end of a charge. Pauses before returning 
func Stunned(delta):
	if stateTimer >= stunTime:
		stateTimer = 0
		timer = 0
		state = BossStates.RECOVER
		return
	
	stateTimer += delta

# Returns back to the targetting line 
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

# Gets dragged back into the pit. Good riddance! 
func Defeat(delta):
	boss.global_position = points[currPoint].global_position
	
	var dLerp = draggedCurve.sample(timer / draggedTime)
	
	if dLerp >= 1:
		boss.global_position = chainOrigin.global_position
		timer = 0
		state = BossStates.IDLE
		boss.ScaleOutAndCleanup()
		#boss.queue_free() # Destory boss object 
		return
	
	boss.global_position = lerp(
		startPosBeforeDragged, 
		chainOrigin.global_position, dLerp)
	
	timer += delta

# Creates a void charge collectible on the boss's position 
func SpawnVoidCharge():
	var instance = voidCharge.instantiate()
	add_child(instance)
	instance.position = boss.position

func SetVisualState (isChill : bool):
	
	chillEyeSet.visible = isChill
	attacEyeSet.visible = !isChill
	
	if isChill:
		bosSprite.texture = chillTexture
	else:
		bosSprite.texture = attacTexture

func GetVoidCharge(area : Area2D):
	inventory.PlayChainVFX()
	var instance 
	
	for item in inventory.items:
		match item.itemType:
			Types.CollectType.KEY:
				#item.StartAbsorb(boss)
				item.get_parent().queue_free() 
				
				instance = hitFX.instantiate()
				instance.global_position = boss.global_position
				chainOrigin.add_child(instance)
				
				bufferCount += 1
			_:
				item.Reset()
	inventory.items = [] # Clear inventory 

func ActivateBoss(area : Area2D):
	isActive = true

# Resets boss on hitting Boora 
func ResetBoss(area : Area2D):
	isActive = false
	count = 0
	bufferCount = 0
	state = BossStates.TARGET
