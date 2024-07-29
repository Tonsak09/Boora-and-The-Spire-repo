extends Node2D

@export var target : Node2D
@export var head : Node2D
@export var mag : float

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var dir = (target.global_position - global_position).normalized()
	head.global_position = global_position + dir * mag

