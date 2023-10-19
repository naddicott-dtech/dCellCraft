extends Area2D


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"
signal control_pressed
signal control_released

var is_pressed = false
#dynamically fetch the ControlSprite child
onready var control_sprite = get_node("ControlSprite" + name.replace("ControlArea", ""))
onready var control_collision = get_node("ControlCollision" + name.replace("ControlArea", ""))

func _input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		var distance_to_center = event.position.distance_to(control_collision.global_position)
		if event.pressed:
			if distance_to_center <= control_collision.shape.radius:
				emit_signal("control_pressed", self)
				#change sprite to "pressed" state when clicked
				control_sprite.frame = 1
				is_pressed = true
		else:
			if is_pressed:
				emit_signal("control_released", self)
				control_sprite.frame = 0
				# print("let go")
				is_pressed = false
			#revert sprite to default state when button is released
			

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("mouse_entered", self, "_on_ControlArea_mouse_entered")
	connect("mouse_exited", self, "_on_ControlArea_mouse_exited")
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
