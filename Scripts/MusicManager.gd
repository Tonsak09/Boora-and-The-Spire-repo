extends Node2D

@export var musicStreamers : Array[AudioStreamPlayer2D]
@export var connectorToBoss : Node2D
@export var transitionTime : float
var curr = 0
var next = -1

var trans : bool
var vTimer : float

func _init():
	vTimer = 0

func _process(delta):
	if trans:
		vTimer += delta
		var vLerp = vTimer / transitionTime
		musicStreamers[curr].volume_db = lerp(-2, -80, vLerp)
		musicStreamers[next].volume_db = lerp(-80, -2, vLerp)
		
		if vLerp >= delta:
			musicStreamers[curr].volume_db = -80
			musicStreamers[curr].stop()
			musicStreamers[next].volume_db = -2
			vTimer = 0
			curr = next 
			trans = false

func SwapToBoss(area : Area2D):
	if connectorToBoss.canGo:
		SwapTune(1)

func SwapTune(index : int):
	next = index
	trans = true
	musicStreamers[next].volume_db = -80
	musicStreamers[next].play()
	#musicStreamers[curr].volume_db
	#musicStreamers[curr].stop()
	#musicStreamers[index].play()
	#curr = index
