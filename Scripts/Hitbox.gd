extends Area2D

var canHit : bool

func _init():
	canHit = true

func ResetBoora(area : Area2D):
	if canHit == false:
		return
	
	get_tree().root.get_child(1).SwapRoomIndex(0, area.startPos)
	area.ResetBoora()
