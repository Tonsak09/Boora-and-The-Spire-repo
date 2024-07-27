extends Node2D

@export var Inventory : Area2D
var key

var count : int;

func _ready():
	key = load("res://Prefabs/Key.tscn")
	pass

func OnCheckInventor(area : Area2D):
	for item in Inventory.items:
		match item.itemType:
			Types.CollectType.DNA:
				print_debug("Got DNA!")
				item.get_parent().queue_free()
				count += 1
			Types.CollectType.TONGUE:
				print_debug("Got Tongue!")
				item.get_parent().queue_free()
				count += 1
			Types.CollectType.SKULL:
				print_debug("Got Skull!")
				item.get_parent().queue_free()
				count += 1
			_:
				item.Reset()
	Inventory.items = [] # Clear inventory 
	
	if count >= 3:
		print_debug("Complete!")
		var instance = key.instantiate()
		add_child(instance)
