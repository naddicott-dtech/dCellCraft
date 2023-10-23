extends CollisionShape2D


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var rect_shape = RectangleShape2D.new() 
	rect_shape.extents = Vector2(250,250) #make the right size
	self.shape = rect_shape


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
