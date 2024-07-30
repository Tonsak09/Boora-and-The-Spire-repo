extends CPUParticles2D

@export var moveTime : float 
@export var moveCurve : Curve 

var parent : Node2D
var timer : float 
var startPos : Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	parent = get_parent()
	timer = 0
	startPos = parent.get_parent().boss.global_position # Get boss arena 


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	timer += delta 
	
	var mLerp = moveCurve.sample(timer / moveTime)
	global_position = lerp(startPos, parent.global_position, mLerp)
	
	if mLerp >= 1:
		queue_free()
