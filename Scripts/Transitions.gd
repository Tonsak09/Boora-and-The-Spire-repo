extends Node2D

@export var topSaw : Node2D
@export var botSaw : Node2D

@export var transOutTime : float
@export var transOutCurve : Curve
@export var transInTime : float
@export var transInCurve : Curve

@export var closedTop : Vector2
@export var closedBot : Vector2

@export var pauseBeforeOpen : float # Pause at the very beginning 

var topStart : Vector2
var botStart : Vector2

var animTimer : float
var doneAnim : bool

var state : transStates
enum transStates {IDLE, TRANS_IN, TRANS_OUT}


var hasBegun : bool 
var begunTimer : float 

func _init():
	doneAnim = true
	hasBegun = false
	begunTimer = 0
	state = transStates.IDLE

func _ready():
	topStart = topSaw.position
	botStart = botSaw.position
	SetSawPos(1)
	

func _process(delta):
	if !hasBegun:
		begunTimer += delta
		
		if begunTimer >= pauseBeforeOpen:
			hasBegun = true
			TransitionIn()
		else:
			return 
	
	match state:
		transStates.IDLE:
			return 
		transStates.TRANS_IN:
			animTimer += delta
			
			SetSawPos(transInCurve.sample(1 - animTimer / transInTime) )
			
			if animTimer >= transInTime:
				doneAnim = true;
				state = transStates.IDLE
				animTimer = 0
		transStates.TRANS_OUT:
			animTimer += delta
			
			SetSawPos(transOutCurve.sample(animTimer / transInTime))
			
			if animTimer >= transInTime:
				doneAnim = true;
				state = transStates.IDLE
				animTimer = 0

func SetSawPos(lerp : float):
	topSaw.position = lerp(topStart, closedTop, lerp)
	botSaw.position = lerp(botStart, closedBot, lerp)

func TransitionOut():
	if state != transStates.IDLE:
		return
	state = transStates.TRANS_OUT
	doneAnim = false

func TransitionIn():
	if state != transStates.IDLE:
		return
	state = transStates.TRANS_IN
	doneAnim = false
