extends Camera2D
@export var target : Node2D
@export var speed : float
@export var disTillMove : float
@export var maxDis : float
@export var maxDisCurve : Curve
@export var vertContraints : Vector2

@export var offsetY : float

# Called when the node enters the scene tree for the first time.
func _ready():
	#offsetY = position.y - target.position.y
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if(abs((target.position.y + offsetY) - position.y) >= disTillMove):
		var dis = abs((target.position.y + offsetY) - position.y)
		var l = maxDisCurve.sample(dis / maxDis)
		var vel = speed * l
		
		position.y = clamp( move_toward(position.y, target.position.y + offsetY, delta * vel), vertContraints.x, vertContraints.y)
