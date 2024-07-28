extends Node2D

@export var lineRenderer : Line2D
@export var connection : Node2D

@export var timeChange : float
@export var segementCount : int 

@export var offsetPerpRange : Vector2

@export var segements : Array[Vector2]
var dir : Vector2
var perp : Vector2

var rng = RandomNumberGenerator.new()
var timer : float

func _ready():
	timer = 0.0
	
	var dis = (connection.position - position).length()
	dir = (connection.position - position).normalized()
	perp = dir.rotated(PI / 2)
	
	for n in segementCount - 1:
		segements.push_back(dir * (dis / segementCount) * (n + 1) )
	
	SendToLineRenderer()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	timer += delta
	
	if timer >= timeChange:
		SendToLineRenderer()
		timer = 0


func SendToLineRenderer():
	var points : Array[Vector2]
	
	points.push_back(Vector2(0,0))
	for point in segements:
		points.push_back(point + perp * rng.randf_range(offsetPerpRange.x, offsetPerpRange.y))
	points.push_back(connection.position - position)
	
	lineRenderer.points = points
