extends Timer

signal metabolism_tick

# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("timeout", self, "_on_RespirationTimer_timeout")
	
func _on_RespirationTimer_timeout():
	if Global.Glucose > 0:
		if not Global.organelles_unlocked["Mitochondria"]:
			Global.Glucose -= 1
			Global.ATP += 2 # Glycolysis only - replace with more complex logic based on mitochondria active
		#update_ui()
		else: # Mitochondria present
			# Emit the metabolism_tick signal every time the timer times out
			emit_signal("metabolism_tick")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
