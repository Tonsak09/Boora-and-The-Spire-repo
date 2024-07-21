extends Area2D

@export var items : Array

func _on_area_entered(area):
	area.StartAbsorb(self)
	items.append(area.itemType)

