extends Area2D


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"
var x_grid_coord : int = -1
var y_grid_coord : int = -1
var zone_populated : bool = false
var spatial_data = []

const ZONE_SIZE : float = 500.0
const GRID_SPACING : float = 50.0 #points every 50 pixels, adjust as needed


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Extract grid coordinates from the node name
	var name_parts = self.name.split("_")
	if name_parts.size() >= 3:
		x_grid_coord = int(name_parts[1])
		y_grid_coord = int(name_parts[2])
		#print("zone " + str(x_grid_coord) + ", " + str(y_grid_coord) + " reporting")
	else:
		print("Invalid node name format for zone: " + self.name)
	# Initialize the spatial data
	_initialize_spacial_data()
	#print(spatial_data)
	
	# Connect the body_entered signal to our custom function
	var _err = connect("body_entered", self, "_on_Zone_body_entered")

func _initialize_spacial_data():
	for i in range(0, ZONE_SIZE, GRID_SPACING):
		for j in range(0, ZONE_SIZE, GRID_SPACING):
			var global_pos = (self.global_position + Vector2(i - int(ZONE_SIZE/2), j - int(ZONE_SIZE/2)))
			var point_data = {
				"globalPos": global_pos,
				"has_resource": false,
				"resource_type": "Null",
				"resource_quantity": -1
			}
			spatial_data.append(point_data)

func _on_Zone_body_entered(body: PhysicsBody2D):
	if body is RigidBody2D and not zone_populated:
		print("player entered zone " + str(x_grid_coord) + ", " + str(y_grid_coord))
		_populate_Zone()
		zone_populated = true # To prevent multiple resource spawns

func _populate_Zone():
	for point_data in spatial_data:
		if not point_data["has_resource"] and randf() < Global.Glucose_Spawn_Rate:
			if Global.Glucose_Spawn_Count >= Global.Glucose_Max_Spawn:
				break
			var glucose_instance = preload("res://Scenes/Main/Glucose.tscn").instance()
			glucose_instance.global_position = point_data["globalPos"]
			call_deferred("add_child", glucose_instance)
			#print("child spawned")
			
			point_data["has_resource"] = true
			point_data["resource_type"] = "Glucose"
			point_data["resource_quantity"] = int(randf()*5)+1 #maybe more variability here?
			# more code to prepare glucose_instance for it's role
			glucose_instance.g_quantity = point_data["resource_quantity"]
			Global.Glucose_Spawn_Count += point_data["resource_quantity"]
	#print("final count" + str(Global.Glucose_Spawn_Count))
	#print("spacial data has points = " + str(ZONE_SIZE/GRID_SPACING))
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
