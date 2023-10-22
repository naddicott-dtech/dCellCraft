extends Node2D

var cell_membrane

# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#get a reference to the CellMembrane Node
	cell_membrane = get_node("../CellMembrane")
	
	
	self.z_index = 2  # Set to a higher value than cell membrane
	
	
func _process(delta: float) -> void:
	# get the center of mass from the CellMembrane's control points
	var com = compute_center_of_mass()
	
	#update OtherOrganelle's position to match the COM
	global_position = com

func _input(event: InputEvent) -> void:
	pass
	
func compute_center_of_mass():
	var total_mass = 0.0
	var com = Vector2()
	
	#iterate over the children of the AmoebaShape to get each control point
	for control_point in cell_membrane.get_node("AmoebaShape").get_children():
		if control_point is RigidBody2D:
			com += control_point.global_position
			total_mass += 1.0 #assuming equal mass for each control point
	# calculate center of mass
	if total_mass > 0:
		com /= total_mass
	return com


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
