extends Area2D

@export var itemType : Types.CollectType
@export var absorbTime : float 
@export var absorbCurve : Curve

@export var audio : AudioStreamPlayer2D

var isAbsorbing : bool 
var timer : float 

var target : Node2D
var startPos : Vector2



func _init():
	timer = 0

func StartAbsorb (target : Node2D):
	audio.play()
	self.target = target
	startPos = get_parent().global_position
	
	isAbsorbing = true
	timer = 0
	
	monitorable = false

func _process(delta):
	
	if isAbsorbing:
		timer += delta
		var lerp = clamp(timer / absorbTime, 0, 1) 
		get_parent().global_position = lerp(startPos, target.global_position, lerp) 
