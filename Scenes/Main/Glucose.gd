extends Node2D


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"
var g_quantity = 0
onready var glucose_Label = $GlucoseLabel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.z_index = 1  # Set to a higher value than Moving Background
#	glucose_Label.z_index = 2
	glucose_Label.visible = true
	glucose_Label.text = str(g_quantity) + "G"
	#print("label position =" + str(glucose_Label.rect_global_position.x))


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func _on_GlucoseArea_body_entered(body: Node) -> void:
	# Check if the body entering is of the type RigidBody2D
	if body is RigidBody2D:
		# Increase the global glucose value
		Global.Glucose += g_quantity  # Make sure GlobalGlucose is accessible
		
		# Despawn the glucose
		queue_free()  # This will remove the Glucose node from the scene

