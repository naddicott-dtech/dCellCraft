extends Label


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	#update the label to show the current value of Global.ATP
	self.text = "%s ATP" % Global.ATP
	if Global.ATP == 0:
		self.add_color_override("font_color", Color(1,  0, 0)) #red
	else:
		self.add_color_override("font_color", Color(1,  1, 1))
