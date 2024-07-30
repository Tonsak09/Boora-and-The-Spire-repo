extends Node2D

@export var Inventory : Area2D
@export var itemsParent : Node2D
@export var collectCirc : Node2D
@export var audioCompelte : AudioStreamPlayer2D
var key

var count : int;
var hasSpawnedKey : bool

func _ready():
	key = load("res://Prefabs/Key.tscn")
	hasSpawnedKey = false

func OnCheckInventor(area : Area2D):
	area.PlayChainVFX()
	for item in Inventory.items:
		match item.itemType:
			Types.CollectType.DNA:
				item.StartAbsorb(Inventory)
				#item.get_parent().queue_free()
				count += 1
			Types.CollectType.TONGUE:
				item.StartAbsorb(Inventory)
				#item.get_parent().queue_free()
				count += 1
			Types.CollectType.SKULL:
				item.StartAbsorb(Inventory)
				#item.get_parent().queue_free()
				count += 1
			_:
				item.Reset()
	Inventory.items = [] # Clear inventory 
	
	if count >= 3 && hasSpawnedKey == false:
		var instance = key.instantiate()
		itemsParent.add_child(instance)
		hasSpawnedKey = true
		collectCirc.queue_free()
		audioCompelte.play()
