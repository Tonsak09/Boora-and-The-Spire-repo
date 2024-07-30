extends Node2D

@export var chain : Array[Node2D]
@export var circDis : float # Distance between each circle 
@export var target : Node2D
@export var origin : Node2D 


func _ready():
	pass 

func _process(delta):
	
	if !is_instance_valid(target):
		queue_free()
		return
	
	var diff = (target.global_position - origin.global_position)
	var dir = diff.normalized()
	var dis = diff.length()
	var seglength = dis / chain.size()
	
	for n in chain.size():
		var l = n / chain.size()
		chain[n].global_position = origin.global_position + dir * seglength * n
