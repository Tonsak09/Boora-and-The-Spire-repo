extends Sprite2D

@export var speed : float
@export var speedUpRate : float
@export var speedDownRate : float
@export var speedCurve : Curve

@export var happyRange : float
@export var threshold : float
@export var thresholdCurve : Curve

@export var bodyRect : Rect2
@export var containerRect : Rect2

@export var visTimeScale : float
@export var visTimeCurve : Curve

@export var visWobbleRange : Vector2
@export var visWobbleCurve : Curve

var visTime : Vector2
var dir : Vector2
var speedLerp : float


# Called when the node enters the scene tree for the first time.
func _ready():
	SetContainer(containerRect)
	#containerRect.position.x -= containerRect.size.x / 2.0
	#containerRect.position.y -= containerRect.size.y / 2.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	visTime += delta * dir * (visTimeScale * visTimeCurve.sample(speedLerp))
	
	material.set_shader_parameter("VisTime", visTime)
	material.set_shader_parameter("SizeScaler", lerp(visWobbleRange.x, visWobbleRange.y, visWobbleCurve.sample(speedLerp)))
	
	bodyRect.position = position
	Movement(delta)

func Movement(delta):
	# Mouse in viewport coordinates.
	if Input.is_mouse_button_pressed( 1 ):
		speedLerp = clamp(speedLerp + speedUpRate * delta, 0, 1)
	else:
		speedLerp = clamp(speedLerp - speedDownRate * delta, 0, 1)
	
	var diff = get_global_mouse_position() - position;
	var vel = speedCurve.sample(speedLerp) * speed;
	
	if diff.length() > happyRange:
		dir = diff.normalized()
		
		# Slower closer to center 
		var threshVar = thresholdCurve.sample(diff.length() / threshold) 
		
		var target = position + dir * vel * delta * threshVar
		target = Vector2(
			clamp(target.x, containerRect.position.x, containerRect.position.x + containerRect.size.x), 
			clamp(target.y, containerRect.position.y, containerRect.position.y + containerRect.size.y))
		
		position = target
		
	else:
		speedLerp = clamp(speedLerp - speedDownRate * delta, 0, 1)

func SetContainer(container : Rect2):
	containerRect.position.x = container.position.x - container.size.x / 2.0
	containerRect.position.y = container.position.y - container.size.y / 2.0
	
	containerRect.size = container.size

