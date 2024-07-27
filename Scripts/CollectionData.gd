extends Sprite2D

@export var collectible : Types.CollectType
@export var bobHeight = -10
@export var bobSpeed = 1
@export var bobCurve : Curve

var origin : Vector2;
var bobLerp : float
var bobIncrease : bool

var wobbleLimits = Vector2(-.1, .1)
var wobbleSpeed = 5
var wobbleLerp = 0.5
var wobbleIncrease : bool
var canWobble : bool

var vfx 
var loadedVFX

func _ready():
	vfx = load("res://Prefabs/Appear_cloud.tscn")
	loadedVFX = vfx.instantiate()
	add_child(loadedVFX)
	loadedVFX.position = Vector2(0,0)
	loadedVFX.set_emitting(true)
	
	origin = position;
	canWobble = false

func _process(delta):
	Bobbing(delta)
	Wobble(delta)

func Bobbing(delta : float):
	position = lerp(origin, origin + Vector2(0, bobHeight), bobCurve.sample(bobLerp) )
	if bobIncrease:
		bobLerp += delta * bobSpeed
		if bobLerp >= 1:
			bobLerp = 1
			bobIncrease = false
	else:
		bobLerp -= delta * bobSpeed
		if bobLerp <= 0:
			bobLerp = 0
			bobIncrease = true

func Wobble(delta):
	if canWobble == false:
		return
	
	rotation = lerp(wobbleLimits.x, wobbleLimits.y, wobbleLerp)
	if wobbleIncrease:
		wobbleLerp += delta * wobbleSpeed
		if wobbleLerp >= 1:
			wobbleLerp = 1
			wobbleIncrease = false
	else:
		wobbleLerp -= delta * wobbleSpeed
		if wobbleLerp <= 0:
			wobbleLerp = 0
			wobbleIncrease = true

func StartWobble(area : Area2D):
	canWobble = true

func StopWobble(area : Area2D):
	canWobble = false
	wobbleLerp = 0.5
	rotation = 0
