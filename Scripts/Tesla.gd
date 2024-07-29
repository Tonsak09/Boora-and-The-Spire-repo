extends Node2D

@export var lineRenderer : Line2D
@export var connection : Node2D

@export var timeChange : float
@export var segementCount : int 

@export var offsetPerpRange : Vector2

@export var hitBox : Area2D
@export var timeActive : float
@export var timeUnactive : float


var segements : Array[Vector2]
var dir : Vector2
var perp : Vector2

var rng = RandomNumberGenerator.new()
var timerSeg : float
var timerActive : float

var isActive : bool

func _ready():
	timerSeg = 0
	timerActive = 0
	
	var dis = (connection.position - position).length()
	dir = (connection.position - position).normalized()
	perp = dir.rotated(PI / 2)
	
	for n in segementCount - 1:
		segements.push_back(dir * (dis / segementCount) * (n + 1) )
	
	SendToLineRenderer()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	SegAnim(delta)
	CycleActive(delta)

func SegAnim(delta):
	
	if isActive == false:
		lineRenderer.points = []
		return
	
	timerSeg += delta
	if timerSeg >= timeChange:
		SendToLineRenderer()
		timerSeg = 0

func CycleActive(delta):
	timerActive += delta 
	if isActive:
		if timerActive >= timeActive:
			# Set hitbox off
			timerActive = 0
			isActive = false
			hitBox.canHit = false
	else:
		if timerActive >= timeUnactive:
			# Set hitbox on
			timerActive = 0
			isActive = true
			hitBox.canHit = true

func SendToLineRenderer():
	var points : Array[Vector2]
	
	points.push_back(Vector2(0,0))
	for point in segements:
		points.push_back(point + perp * rng.randf_range(offsetPerpRange.x, offsetPerpRange.y))
	points.push_back(connection.position - position)
	
	lineRenderer.points = points
