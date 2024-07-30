extends Sprite2D

@export var shakeTime : float
@export var shakeMag : float
@export var shakeSpeed : float 
@export var shakeFalloffCurve : Curve

var isShaking : bool 
var shakeTimer : float
var timer : float 

func _ready():
	shakeTimer = 0
	isShaking = false

func _process(delta):
	if isShaking:
		var sLerp = shakeFalloffCurve.sample(timer / shakeTime) 
		position.x = sin(shakeTimer) * sLerp * shakeMag
		
		shakeTimer += shakeSpeed * delta
		timer += delta  
		
		if timer >= shakeTime:
			ResetShaker()

func ResetShaker():
	timer = 0
	shakeTimer = 0
	isShaking = false

func ShakeArena():
	isShaking = true
