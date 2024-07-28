extends Area2D


func ResetBoora(area : Area2D):
	get_tree().root.get_child(1).SwapRoomIndex(0, area.startPos)
	area.ResetBoora()
