extends Polygon2D


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"
onready var ATPCostLabel = $ATPCostLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ATPCostLabel.visible = false # hide


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	#if self.visible == true:
		#position set in Player.gd
		#ATPCostLabel.text = "Hello World"
