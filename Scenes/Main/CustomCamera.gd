extends Node2D


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"
var target: Node2D = null
var lerp_factor: float = 0.1 #adjust as needed

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	target = get_node("../OtherOrganelles")



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if target:
		# Calculate the desired position
		var desired_position = -target.global_position + get_viewport().size * 0.5
		
		# Lerp the current position to the desired position
		var new_position = position.linear_interpolate(desired_position, lerp_factor)
		
		# Set the position
		position = new_position
		
		# Adjust the viewport's canvas transform
		get_viewport().canvas_transform.origin = position
		
func _input(event: InputEvent) -> void:
	var target_node = get_node("../CellMembrane/AmoebaShape/ControlPoint1/ControlArea1")
	target_node._input(event) #pass on inputs to target
