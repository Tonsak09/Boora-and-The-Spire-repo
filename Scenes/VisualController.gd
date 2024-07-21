extends Sprite2D

@export var speed : float
@export var speedUpRate : float
@export var speedDownRate : float
@export var speedCurve : Curve


@export var happyRange : float

var speedLerp : float

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	material.set_shader_parameter("TimeScale", 1.0)
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
			position += diff.normalized() * vel * delta
