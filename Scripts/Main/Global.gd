extends Node

var player_score = 0
# resources
var ATP = 0
var AminoAcids = 0
var Glucose = 0
var FattyAcids = 0
var Nucleotides = 0

#game state
var current_level = 0
var furthest_level = 0
var game_mode = ""
var time_elapsed
var zoom = Vector2(1,1)

#environment information
var current_temperature = 25 #degrees celcius
var active_injector_virus = 0
var active_invader_virus = 0
var active_infester_virus = 0
var sunlight = false
var toxinlevel = 0
var radicals = false

#Player Upgrades
var organelles_unlocked = {
	"Centrosome": false,
	"Mitochondria": false,
	"Nucleus": false,
	"Ribosome": false,
	"EndoplasmicReticulum": false,
	"GolgiApparatus": false,
	"Lysosome": false,
	"Peroxisome": false,
	"Chloroplast": false
}

#Spawning
var Glucose_Spawn_Rate = 0.0
var Glucose_Spawn_Count = 0
var Glucose_Max_Spawn = 0

# zone_stuff
var last_four_zones = [[-1,-1], [-1,-1], [-1,-1], [-1,-1]] # init to void

func add_zone_to_recent(z):
	#remove the oldest zone (last in the list)
	last_four_zones.remove(3) 
	#add the new zone to the front
	last_four_zones.insert(0, z)
	
func check_zone_in_recent(z):
	for zone in last_four_zones:
		if zone == z:
			return true
	return false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
