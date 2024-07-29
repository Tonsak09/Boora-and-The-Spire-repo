extends Area2D

@export var items : Array
@export var maxCapacity : int

@export var invenFill : Sprite2D
@export var invenGrad : Gradient

@export var followPoints : Array[Node2D]
@export var followVFX : Array[CPUParticles2D]
@export var audioReset : AudioStreamPlayer2D

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
			area.StartAbsorb(followPoints[items.size()])
			items.append(area)


func _process(delta):
	var interp = (float(items.size()) / float(maxCapacity))
	invenFill.material.set_shader_parameter("Color", invenGrad.sample(interp))

func ResetBoora():
	#get_parent().position = startPos
	audioReset.play()
	for item in items:
		item.Reset()
	
	items = []

func PlayChainVFX():
	for n in items.size():
		followVFX[n].set_emitting(true)
