extends Node2D


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func _on_RespirationTimer_metabolism_tick() -> void:
	if Global.Glucose > 0: #add check for health later
		Global.Glucose -= 1
		Global.ATP += 38
	# add production of free radicals later
