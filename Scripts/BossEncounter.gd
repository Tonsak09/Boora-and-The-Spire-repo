extends Node2D

# Target 
@export var timeToTarget : float
@export var moveTime : float
@export var moveCurve : Curve 
@export var points : Array[Node2D] # Where boss can go to target 
var isMoving : bool # In process of moving to another point 

# Charge
@export var backTime : float
@export var backCurve : Curve
@export var chageTime : float
@export var chargeCurve : Curve  

# Stunned 
@export var stunTime : float 

# Recover 
@export var recoverTime : float
@export var recoverCurve : Curve 

@export var state : BossStates
enum BossStates {TARGET, CHARGE, STUNNED, RECOVER, DEFEAT}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match state:
		BossStates.TARGET:
			pass
		BossStates.CHARGE:
			pass
		BossStates.STUNNED:
			pass
		BossStates.RECOVER:
			pass
		BossStates.DEFEAT:
			pass
