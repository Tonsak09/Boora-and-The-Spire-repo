@tool
# Having a class name is required for a custom node.
class_name VisualShaderNodeVoronoi
extends VisualShaderNodeCustom

@export var uv : Vector2
@export var size : Vector2
@export var key : int

func _get_name():
	return "Voronoi"


func _get_category():
	return ""


func _get_description():
	return ""


func _get_return_icon_type():
	return PORT_TYPE_VECTOR_2D


func _get_input_port_count():
	return 3


func _get_input_port_name(port):
	
	match port:
		0:
			return "UV"
		1:
			return "Size"
		2:
			return "Key"
		_:
			print("NA")
		

func _get_input_port_type(port):
	
	match port:
		0:
			return PORT_TYPE_VECTOR_2D
		1:
			return PORT_TYPE_VECTOR_2D
		2:
			return PORT_TYPE_SCALAR_INT
		_:
			print("NA")


func _get_output_port_count():
	return 1


func _get_output_port_name(port):
	return ""


func _get_output_port_type(port):
	return PORT_TYPE_VECTOR_2D


func _get_code(input_vars, output_vars,
		mode, type):
			
	# Main variables 
	var uv = input_vars[0]; 
	#var columns = input_vars[1].x
	#var rows 	= input_vars[1].y 
	#var key 	= input_vars[2];
	
	return output_vars[0] + " = vec2(0.0, 0.0);"
