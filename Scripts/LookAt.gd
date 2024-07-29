extends Node2D

@export var pupil : Node2D
@export var mag : float

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var dir = (get_global_mouse_position() - global_position).normalized()
	pupil.global_position = global_position + dir * mag
