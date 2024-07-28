extends Node2D
@export var sprite : Sprite2D
@export var wobCurve : Curve

var wobbleLimits = Vector2(-.3, .3)
var wobbleSpeed = 1
var wobbleLerp = 0.5
var wobbleIncrease : bool
var canWobble : bool



func _init():
	canWobble = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	Wobble(delta)

func Wobble(delta):
	if canWobble == false:
		return
	
	sprite.rotation = lerp(wobbleLimits.x, wobbleLimits.y, wobCurve.sample(wobbleLerp))
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
