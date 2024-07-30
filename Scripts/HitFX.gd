extends CPUParticles2D

@export var moveTime : float 
@export var moveCurve : Curve 
@export var pauseBeforeFree : float

var parent : Node2D
var timer : float 
var startPos : Vector2
var reachedTarget : bool 

# Called when the node enters the scene tree for the first time.
func _ready():
	parent = get_parent()
	timer = 0
	startPos = parent.get_parent().Boora.global_position # Get boss arena
	emitting = true 


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	timer += delta 
	
	if reachedTarget:
		if timer >= pauseBeforeFree:
			queue_free() 
		return
	
	var mLerp = moveCurve.sample(timer / moveTime)
	global_position = lerp(startPos, parent.global_position, mLerp)

	if mLerp >= 1:
		reachedTarget = true
		timer = 0
