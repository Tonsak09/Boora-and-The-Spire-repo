extends Area2D

@export var items : Array
@export var maxCapacity : int

func _on_area_entered(area):
	if items.size() < maxCapacity:
		area.StartAbsorb(self)
		items.append(area)
