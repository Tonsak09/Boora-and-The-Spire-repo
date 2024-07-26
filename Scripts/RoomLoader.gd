extends Node2D

@export var cam : Camera2D
@export var Boora : Node2D

@export var introRoom : Array[Node2D]		# 0
@export var introCamContraints : Vector2
@export var introBooraRect : Rect2

@export var riddleRoom : Array[Node2D]		# 1
@export var riddleCamContraints : Vector2
@export var riddleBooraRect : Rect2

@export var lightningRoom : Array[Node2D]	# 2
@export var lightningCamContraints : Vector2
@export var lightningBooraRect : Rect2

@export var keyRoom : Array[Node2D] 		# 3 
@export var keyCamContraints : Vector2
@export var keyBooraRect : Rect2

@export var bossRoom : Array[Node2D]		# 4
@export var bossCamContraints : Vector2
@export var bossBooraRect : Rect2

var currentRoom : Array[Node2D]


func _ready():
	SetInactive(introRoom)
	SetInactive(riddleRoom)
	SetInactive(lightningRoom)
	SetInactive(keyRoom)
	SetInactive(bossRoom)
	
	SwapRoom(introRoom)

func SetInactive(room : Array[Node2D]):
	for item in room:
		item.position = Vector2(9999,9999)

# Manual change of rooms 
func SwapRoom(nextRoom : Array[Node2D]):
	print_debug(nextRoom)
	
	# Move so far offscreen it doesn't even matter 
	for room in currentRoom:
		room.position = Vector2(99999, 0)
	
	# Set new current
	for room in nextRoom:
		room.position = Vector2(0,0)
	currentRoom = nextRoom;

# Change the contraints of camera and Boora 
func SwapConstraints(camConstraints : Vector2, booraContraints : Rect2):
	cam.vertContraints = camConstraints
	Boora.SetContainer(booraContraints)

func SwapRoomIndex(room : int, pos : Vector2):
	match room:
		0:
			SwapRoom(introRoom)
			SwapConstraints(introCamContraints, introBooraRect)
		1:
			SwapRoom(riddleRoom)
			SwapConstraints(riddleCamContraints, riddleBooraRect)
		2:
			SwapRoom(lightningRoom)
			SwapConstraints(lightningCamContraints, lightningBooraRect)
		3:
			SwapRoom(keyRoom)
			SwapConstraints(keyCamContraints, keyBooraRect)
		4:
			SwapRoom(bossRoom)
			SwapConstraints(bossCamContraints, bossBooraRect)
	Boora.global_position = pos;