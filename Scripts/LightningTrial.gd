extends Node2D

@export var crown : Node2D
@export var collectCirc : Node2D
@export var audioComplete : AudioStreamPlayer2D

var key
var hasSpawnedKey : bool

var keyPos;

func _ready():
	key = load("res://Prefabs/Key.tscn")
	hasSpawnedKey = false
	
	keyPos = crown.position

func OnCheckInventor(area : Area2D):
	area.PlayChainVFX()
	for item in area.items:
		match item.itemType:
			Types.CollectType.CROWN:
				var instance = key.instantiate()
				instance.position = keyPos
				add_child(instance)
				hasSpawnedKey = true
				item.get_parent().queue_free()
				collectCirc.queue_free()
				audioComplete.play()
			_:
				item.Reset()
	area.items = [] # Clear inventory 
	

