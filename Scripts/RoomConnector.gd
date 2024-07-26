extends Area2D

@export var RoomLoader : Node2D
@export var roomToload : int
@export var posToMove : Node2D

func OnCollLoadRoom(area : Area2D):
	RoomLoader.SwapRoomIndex(roomToload, posToMove.global_position)
