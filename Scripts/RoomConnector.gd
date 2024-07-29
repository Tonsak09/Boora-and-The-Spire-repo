extends Area2D

@export var RoomLoader : Node2D
@export var roomToload : int
@export var posToMove : Node2D
@export var canGo = true

func OnCollLoadRoom(area : Area2D):
	if canGo:
		RoomLoader.SwapRoomIndex(roomToload, posToMove.global_position)
