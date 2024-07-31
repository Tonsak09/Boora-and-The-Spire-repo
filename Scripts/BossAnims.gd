extends Node2D

@export var scaleInTime : float 
@export var scaleInCurve : Curve

@export var scaleOutTime : float 
@export var scaleOutCurve : Curve

@export var bossMusic : AudioStreamPlayer2D
@export var finalVid : VideoStreamPlayer

var isAnim : bool
var scaleIn : bool

var timer : float 

# Called when the node enters the scene tree for the first time.
func _ready():
	isAnim = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !isAnim:
		return
	
	if scaleIn:
		scale = lerp(Vector2(0,0), Vector2(1,1), scaleInCurve.sample(timer / scaleInTime))
		
		if timer >= scaleInTime:
			isAnim = false
			timer = 0
	else:
		scale = lerp(Vector2(1,1), Vector2(0,0), scaleOutCurve.sample(timer / scaleOutTime))
		
		if timer >= scaleOutTime:
			bossMusic.stop()
			finalVid.play()
			queue_free()
	
	timer += delta

func ScaleIn():
	timer = 0
	scaleIn = true
	isAnim = true
	

func ScaleOutAndCleanup():
	timer = 0
	scaleIn = false
	isAnim = true
