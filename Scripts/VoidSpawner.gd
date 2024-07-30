extends Node2D

var voidCharge

func _ready():
	voidCharge = load("res://Prefabs/Void_charge.tscn")
	var instance = voidCharge.instantiate()
	add_child(instance) 
