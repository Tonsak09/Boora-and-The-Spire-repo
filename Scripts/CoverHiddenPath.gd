extends Sprite2D

@export var sprite : Sprite2D
@export var animateSpeed : float;

var showPath : bool
var lerp : float

func _init():
	lerp = 0;
	showPath = false

func _process(delta):
	if showPath:
		lerp = clamp(lerp - animateSpeed * delta, 0, 1) 
	else:
		lerp = clamp(lerp + animateSpeed * delta, 0, 1) 
	
	sprite.material.set_shader_parameter("Alpha", lerp)

func ShowPath(area : Area2D):
	showPath = true

func HidePath(area : Area2D):
	showPath = false
