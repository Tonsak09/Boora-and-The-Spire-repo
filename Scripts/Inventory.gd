extends Area2D

@export var items : Array
@export var maxCapacity : int

@export var invenFill : Sprite2D
@export var invenGrad : Gradient

var canCollect : bool

var startPos : Vector2

func _init():
	canCollect = false

func _ready():
	startPos = get_parent().position

func _on_area_entered(area):
	if !canCollect:
		return;
	
	if area.has_meta("CollType"):
		return;
	
	if area.isAbsorbing:
		return
	
	if area.get_parent().get_meta("CollType") == "CollCollect":
		if items.size() < maxCapacity:
			area.StartAbsorb(self)
			items.append(area)

func _process(delta):
	var interp = (float(items.size()) / float(maxCapacity))
	invenFill.material.set_shader_parameter("Color", invenGrad.sample(interp))

func ResetBoora():
	#get_parent().position = startPos
	
	for item in items:
		item.Reset()
	items = []
