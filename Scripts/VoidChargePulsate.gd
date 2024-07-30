extends Node2D

@export var partA : Node2D
@export var partB : Node2D
@export var pulsateSpeed : float 

var timer : float 

# Called when the node enters the scene tree for the first time.
func _ready():
	timer = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	timer += pulsateSpeed * delta
	
	partA.scale.x = sin(timer)
	partB.scale.x = cos(timer)
