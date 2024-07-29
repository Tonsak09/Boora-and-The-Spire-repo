extends Node2D

@export var Boora : Node2D

@export var gate : Sprite2D
@export var openGate : Texture2D

@export var leftKey : Node2D
@export var rightKey : Node2D

@export var audio : AudioStreamPlayer2D

var key
var count : int;
var hasSpawnedKey : bool

func _ready():
	key = load("res://Prefabs/Key.tscn")
	hasSpawnedKey = false
	gate.canWobble = false

func OnCheckInventor(area : Area2D):
	var oneCollected = false
	for item in area.items:
		match item.itemType:
			Types.CollectType.KEY:
				
				# Don't take both keys if two in inventory 
				if !oneCollected:
					oneCollected = true
					item.get_parent().queue_free()
					audio.play()
					CollectKey()
				else: 
					item.Reset()
			_:
				item.Reset()
	area.items = [] # Clear inventory 
	
	if count >= 2 && hasSpawnedKey == false:
		gate.texture = openGate;
		gate.canWobble = true

func CollectKey():
	count += 1
	
	if count == 1:
		if (Boora.global_position - leftKey.global_position).length_squared() < (Boora.global_position - rightKey.global_position).length_squared():
			leftKey.queue_free()
		else:
			rightKey.queue_free()
	else :
		if is_instance_valid(leftKey):
			leftKey.queue_free()
		else:
			rightKey.queue_free()
