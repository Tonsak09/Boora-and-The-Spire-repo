extends Node2D

@export var targetFollow : Node2D
@export var targetRadius : float 

@export var speed : float
@export var disThreshold : float
@export var disThreshCurve : Curve

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var dirToTarget = (position - targetFollow.position).normalized()
	var target = targetFollow.position + dirToTarget * targetRadius
	
	var dir = (target - position).normalized()
	var dis = (target - position).length()
	var disMult = disThreshCurve.sample(dis / disThreshold)
	position += dir * speed * delta * disMult
