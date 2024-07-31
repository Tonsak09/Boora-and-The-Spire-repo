extends Area2D

@export var videoThanks : VideoStreamPlayer
@export var musicPlayer : AudioStreamPlayer2D
@export var textDis : Label

var hasStarted : bool 

func _ready():
	hasStarted = false

func OnPlay(area : Area2D):
	
	if  !hasStarted:
		if !videoThanks.is_playing():
			textDis.text = ""
			videoThanks.play()
			hasStarted = true
	else:
		if !videoThanks.is_playing() && !musicPlayer.playing:
			musicPlayer.play()
	

func _process(delta):
	if hasStarted && !videoThanks.is_playing():
		textDis.text = "Play Victory Music"
