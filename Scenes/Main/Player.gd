extends Node2D

var amplitude = 20.0
var target_amplitude = 25.0
var amplitude_change_speed = 0.5 # Adjust this for faster or slower transitions
#var frequency = 0.3
#var target_frequency = 0.5 # This can be adjusted based on your desired effect
#var frequency_change_speed = 0.1 # Adjust this for faster or slower transitions
var time_passed = 0.0
var osc_speed = 0.1
var noise = OpenSimplexNoise.new() # Godot has built-in Simplex noise  
var noise_period = 0.7
var target_noise_period = 0.8
var noise_period_change_speed = 0.005 # Adjust this for faster or slower transitions
var is_control_pressed = false #track mousedown state
var last_control_pressed = null
var initial_mouse_position: Vector2 = Vector2()
var max_impulse_strength: float = 200.0 #Adjust based on your needs
var impulse_active = false
var impulse_done_distance = 15.0
var distance_per_ATP = 20
var initial_COM = Vector2()
var previous_COM = Vector2()
  
# Declare curve at class scope
var curve: Curve2D = null
onready var arrow = $AmoebaShape/ImpulseArrow
onready var arrowhead = $AmoebaShape/ArrowHead
onready var ATPCostLabel = $AmoebaShape/ArrowHead/ATPCostLabel
var control_points_names = ["ControlPoint1", "ControlPoint2", "ControlPoint3", "ControlPoint4", "ControlPoint5", "ControlPoint6", "ControlPoint7", "ControlPoint8"]

func add_wavy_points(new_curve, point1, point2, num_intermediate_points, time):
	var step = 1.0 / (num_intermediate_points + 1)
	for i in range(1, num_intermediate_points + 1):
		var t = i * step
		var base_point = point1.linear_interpolate(point2, t)
		var offset_value = noise.get_noise_2d(base_point.x + time, base_point.y + time)
		var offset = Vector2(offset_value * amplitude, offset_value * amplitude)
		var wavy_point = base_point + offset
		new_curve.add_point(wavy_point)

func update_arrowhead():
	#compute direction of the arrow
	var dir = (arrow.points[1] - arrow.points[0]).normalized() #arrow direction
	var size = 20 #size of the arrowhead
	
	var arrow_end_global = arrow.global_position + arrow.points[1]
	var arrow_end_local = arrowhead.to_local(arrow_end_global)
	
	var base_position = arrow_end_local - dir * size
	
	var p1 = base_position + Vector2(-dir.y, dir.x) * size * 0.5
	var p2 = base_position - Vector2(-dir.y, dir.x) * size * 0.5
	
	# Update the Polygon2D points to form the arrowhead
	arrowhead.polygon = [arrow_end_local, p1, p2]
	# Update the ATPCostLabel Position
	ATPCostLabel.rect_position = base_position

func _on_ControlArea_control_pressed(control_node):
	#Here, control-node the the ControlArea that was pressed
	#We will use this to determine where to start drawing the arrow, etc.
	#print("ControlArea pressed: ", control_node.name)
	is_control_pressed = true
	last_control_pressed = control_node
	initial_mouse_position = get_global_mouse_position()

func _on_ControlArea_control_released(control_node) -> void:
	is_control_pressed = false
	last_control_pressed = null
	var center_of_mass = compute_center_of_mass()
	var mouse_position = get_global_mouse_position()
	
	var initial_distance = center_of_mass.distance_squared_to(initial_mouse_position)
	var current_distance = center_of_mass.distance_squared_to(mouse_position)
	if current_distance > initial_distance: #arrow is outside the cell
		var mouse_delta = mouse_position - initial_mouse_position
		var impulse_strength = mouse_delta.length()
		
		#Limit the impulse strength to maximum value
		if impulse_strength > max_impulse_strength:
			mouse_delta = mouse_delta.normalized() * max_impulse_strength
			
		#Pay the ATP (and limit again if needed)	
		var ATPCost = mouse_delta.length() / distance_per_ATP
		if ATPCost > Global.ATP:
			mouse_delta = (Global.ATP / ATPCost) * mouse_delta
			Global.ATP = 0
		else: # have enough to pay
			Global.ATP -= round(ATPCost)
		# get the control point and apply the impulse
		var control_point = control_node.get_parent()
		control_point.apply_impulse(Vector2(), mouse_delta) #apply the impulse
		impulse_active = true
		
	

func _ready():
	# loop through all the children of the Player node
	for child in get_children():
		if child is Area2D and "ControlArea" in child.name:
			#connect the signals to the Player script
			child.connect("control_pressed", self, "_on_ControlArea_pressed")
			child.connect("control_pressed", self, "_on_ControlArea_released")
	# Access the AmoebaShape (Path2D) node
	var amoeba_shape = get_node("AmoebaShape")  # Adjusted the path
	self.z_index = 1  # Set to a higher value than Moving Background
	noise.set_period(noise_period)
	arrow.hide()
	arrowhead.hide()
	
	# Initialize the Curve2D resource
	curve = Curve2D.new()
	
	# List to store control points' positions
	var control_points_positions = []
	
	# get the positions (with a for loop)
	for name in control_points_names:
		control_points_positions.append(amoeba_shape.get_node(name).position)

	#add points to the curve (with a for loop)
	for i in range(control_points_positions.size()):
		var current_point = control_points_positions[i]
		var next_point = control_points_positions[(i+ 1) % control_points_positions.size()] #loop back to the first point after the last point
		curve.add_point(current_point)
		add_wavy_points(curve, current_point, next_point, 3, time_passed)
	curve.add_point(control_points_positions[0])
	
	# Assign the curve to the AmoebaShape (Path2D) node
	amoeba_shape.curve = curve
	initial_COM = compute_center_of_mass()
	previous_COM = initial_COM
	update()
#	for i in range(1, 9):
#		var start_point = $AmoebaShape.get_node("ControlPoint" + str(i)).position
#		var end_point
#		if i == 8: # for the 8th, the next one is the 1st
#			end_point = $AmoebaShape/ControlPoint1.position
#		else:
#			end_point = $AmoebaShape.get_node("ControlPoint" + str(i+1)).position
#		var distance = start_point.distance_to(end_point)
#		var angle_rad = start_point.angle_to_point(end_point) + PI / 2 
#		var angle_deg = rad2deg(angle_rad)
#
#		print("Distance between ControlPoint%d and ControlPoint%d: %f" % [i, i+1 if i < 8 else 1, distance])
#		print("Origin for Joint%dto%d: %f, %f" % [i, i+1 if i < 8 else 1, start_point.x, start_point.y])
#		print("Angle for Joint%dto%d: %f degrees" % [i, i+1 if i<8 else 1, angle_deg])
			
	#crossbeam6to4 deets
#	var cpA_pos = $AmoebaShape/ControlPoint6.position
#	var cpB_pos = $AmoebaShape/ControlPoint4.position
#	var distance_AtoB = cpA_pos.distance_to(cpB_pos)
#	var angle_rad_AtoB = cpA_pos.angle_to_point(cpB_pos) + PI / 2
#	var angle_deg_AtoB = rad2deg(angle_rad_AtoB)
#
#	print("Distance 6 to 4: %f" % distance_AtoB)
#	print("Origin 2: %f, %f" % [cpA_pos.x, cpA_pos.y])
#	print("Angle for 2 to 6: %f degrees" % angle_deg_AtoB)


func _process(delta): 
	time_passed += delta
	var amoeba_shape = get_node("AmoebaShape")  # Adjusted the path
	var change_interval = 10.0 #change target(s) every 10s

	if is_control_pressed and last_control_pressed:
		var mouse_pos = get_global_mouse_position()
		var last_control_pressed_global = last_control_pressed.global_position
		var center_of_mass = compute_center_of_mass()
		var initial_distance = center_of_mass.distance_to(initial_mouse_position)
		var current_distance = center_of_mass.distance_to(mouse_pos)
		var vector_to_mouse = mouse_pos - last_control_pressed_global
		var ATPCost = vector_to_mouse.length() / distance_per_ATP
		
		# Limit the arrow length to max impulse strength
		if vector_to_mouse.length() > max_impulse_strength:
				vector_to_mouse = vector_to_mouse.normalized() * max_impulse_strength
				mouse_pos = last_control_pressed_global + vector_to_mouse
		
		if current_distance > initial_distance:
			arrow.show()
			ATPCostLabel.visible = true
			ATPCostLabel.text = "- " + str(round(ATPCost)) + " ATP"
			#Turn Label Red if out of ATP
			if ATPCost > Global.ATP:
				ATPCostLabel.add_color_override("font_color", Color(1,  0, 0)) #red
			else:
				ATPCostLabel.add_color_override("font_color", Color(1,  1, 1)) #white
			arrow.global_position = last_control_pressed_global
			arrow.points = [Vector2(0,0), mouse_pos - last_control_pressed_global]
			update_arrowhead() # make sure arrowhead position and direction are correct
			arrowhead.show()
#			print("Arrow Start Global Position: ", arrow.global_position)
#			print("Control Point Global Position: ", last_control_pressed.global_position)

		else:
			ATPCostLabel.visible = false
			arrow.hide()
			arrowhead.hide()
	else:
		arrow.hide()
		arrowhead.hide()

	if impulse_active == false:	#make the amoeba more undulating when it's not getting free undulation from movement
		if fmod(time_passed, change_interval) < delta: #we've just passed an interval
			target_noise_period = rand_range(0.7, 0.8)
			target_amplitude = rand_range(20.0, 25.0)
#			target_frequency = rand_range(0.3, 0.5)
			# more target shifts here
	
		# Adjust amplitude towards target
		if amplitude < target_amplitude:
			amplitude += amplitude_change_speed * delta
			if amplitude > target_amplitude:
				amplitude = target_amplitude
		elif amplitude > target_amplitude:
			amplitude -= amplitude_change_speed * delta
			if amplitude < target_amplitude:
				amplitude = target_amplitude

		# Adjust frequency towards target
#		if frequency < target_frequency:
#			frequency += frequency_change_speed * delta
#			if frequency > target_frequency:
#				frequency = target_frequency
#		elif frequency > target_frequency:
#			frequency -= frequency_change_speed * delta
#			if frequency < target_frequency:
#				frequency = target_frequency
		
		# Adjust noise period towards target
		if noise_period < target_noise_period:
			noise_period += noise_period_change_speed * delta
			if noise_period > target_noise_period:
				noise_period = target_noise_period
		elif noise_period > target_noise_period:
			noise_period -= noise_period_change_speed * delta
			if noise_period < target_noise_period:
				noise_period = target_noise_period

		noise.set_period(noise_period)
	else: #imuplse active true
		#check to see if impulse is over
		if fmod(time_passed, change_interval) < delta:		
			var current_COM = compute_center_of_mass()
			var distance = current_COM.distance_to(previous_COM)
			#print("distance: %f" % distance)
			if distance < impulse_done_distance:
				impulse_active = false
				#print("impulse over")
			previous_COM = current_COM # compare distance for next time
		
	# Clear the existing points from the curve and re-add them with the new undulation
	curve.clear_points()
	
	var control_points_positions = []
	
	# get current control positions
	for name in control_points_names:
		control_points_positions.append(amoeba_shape.get_node(name).position)
	# add points to the curve
	for i in range(control_points_positions.size()):
		var current_point = control_points_positions[i]
		var next_point = control_points_positions[(i + 1) % control_points_positions.size()] # loop back to the first at the end
		curve.add_point(current_point)
		add_wavy_points(curve, current_point, next_point, 3, time_passed)
	curve.add_point(control_points_positions[0])
	
	# Trigger the _draw() method to render the updated curve
	update()

func _draw():
	#print("Entering _draw function")  # Debug message
	#var amoeba_shape = $AmoebaShape  # Adjusted the path
	#var curve = amoeba_shape.curve
	#var length = curve.get_baked_length()
	#print("Curve baked length: ", length)  # Debug message
	
	var num_segments = 80  # The number of segments you want
	var step = curve.get_baked_length() / num_segments  # Adjust this for smoother or rougher curves
	#var point = Vector2(0,0)
	#var control_point1 = amoeba_shape.get_node("ControlPoint1").position
	var points = []
	#var prev_point = curve.interpolate_baked(0)
	#print("Initial point: ", prev_point)  # Debug message
	
	for t in range(num_segments+1):  # Adjusted the loop condition
		points.append(curve.interpolate_baked(t * step))
		#print("Drawing line from ", prev_point, " to ", point)  # Debug message

	var interior_color = Color(0.6, 0.8, 1) # Light blue
	var outline_color = Color(0, 0.2, 0.6)  # Dark blue
	var color_array = PoolColorArray()
	for i in points.size():
		color_array.append(interior_color)

	draw_polygon(points, color_array)
	draw_polyline(points, outline_color, 7)  # Outer wider line
	draw_polyline(points, interior_color, 5)  # Inner narrower line

	#print("Exiting _draw function")  # Debug message

func compute_center_of_mass():
	var total_mass = 0
	var com = Vector2.ZERO
	var amoeba_shape = get_node("AmoebaShape")
	
	for i in range(1,9): # iterate from ControlPoint1 to ControlPoint8
		var point = amoeba_shape.get_node("ControlPoint" + str(i))
		com += point.global_position # using global position
		total_mass += 1 #if all points have equal mass
	return com / total_mass

