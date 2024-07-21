extends Node2D

@export var itemType : CollectType
@export var absorbTime : float 
@export var absorbCurve : Curve

var isAbsorbing : bool 
var timer : float 

var target : Node2D
var startPos : Vector2

enum CollectType {ROCK_GOLEM, CRYSTAL, DICE, MUSCHROOM, BOTTLE, BOOK, CANDLE, LIGHTBUBL}


func _init():
	timer = 0
	

func StartAbsorb (target : Node2D):
	self.target = target
	isAbsorbing = true

func _process(delta):
	
	if isAbsorbing:
		timer += delta
		var lerp = clamp(timer / absorbTime, 0, 1) 
		print_debug(lerp)
		get_parent().global_position = lerp(startPos, target.global_position, lerp) 
	else:
		startPos = get_parent().global_position
