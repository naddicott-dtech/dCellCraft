extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func _ready():
	Global.ATP = 500
	Global.Glucose_Spawn_Rate = 0.1
	Global.Glucose_Spawn_Count = 0 
	Global.Glucose_Max_Spawn = 150
	
	Global.organelles_unlocked["Mitochondria"] = true


func _process(_delta):
	# Game logic here
	pass

# UI update function
func update_ui():
	pass

# Function to handle game over
func game_over():
	pass

# Function to handle level completion
func level_complete():
	pass


