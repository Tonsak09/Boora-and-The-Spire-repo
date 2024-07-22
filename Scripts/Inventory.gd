extends Area2D

@export var items : Array
@export var maxCapacity : int

@export var invenFill : Sprite2D
@export var invenGrad : Gradient

func _on_area_entered(area):
	if items.size() < maxCapacity:
		area.StartAbsorb(self)
		items.append(area)

func _process(delta):
	var interp = (float(items.size()) / float(maxCapacity))
	invenFill.material.set_shader_parameter("Color", invenGrad.sample(interp))
