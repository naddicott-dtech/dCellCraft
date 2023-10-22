extends Button


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"
var is_paused = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func _on_PauseButton_pressed() -> void:
	print("Pause button pressed")
	if is_paused == false:
		print("Pausing Game")
		get_tree().paused = true
		is_paused = true
	else:
		print("resuming Game")
		is_paused = false
		get_tree().paused = false
