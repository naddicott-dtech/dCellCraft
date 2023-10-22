extends Camera2D


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.z_index = 0
#	self.set_process_input(false)
#	self.set_process_unhandled_input(false)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		print("Mouse click detected!")
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
