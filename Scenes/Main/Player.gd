extends Node2D

var amplitude = 30.0
var target_amplitude = 40.0
var amplitude_change_speed = 0.5 # Adjust this for faster or slower transitions
var frequency = 0.7
var target_frequency = 1.1 # This can be adjusted based on your desired effect
var frequency_change_speed = 0.2 # Adjust this for faster or slower transitions
var time_passed = 0.0
var osc_speed = 0.1
var noise = OpenSimplexNoise.new() # Godot has built-in Simplex noise  
var noise_period = 0.7
var target_noise_period = 0.8
var noise_period_change_speed = 0.005 # Adjust this for faster or slower transitions
																		  
# Declare curve at class scope
var curve: Curve2D = null

func add_wavy_points(curve, point1, point2, num_intermediate_points, time):
	var step = 1.0 / (num_intermediate_points + 1)
	for i in range(1, num_intermediate_points + 1):
		var t = i * step
		var base_point = point1.linear_interpolate(point2, t)
		var offset_value = noise.get_noise_2d(base_point.x + time, base_point.y + time)
		var offset = Vector2(offset_value * amplitude, offset_value * amplitude)
		var wavy_point = base_point + offset
		curve.add_point(wavy_point)

func _on_ControlArea_control_pressed(control_node):
	#Here, control-node the the ControlArea that was pressed
	#We will use this to determine where to start drawing the arrow, etc.
	print("ControlArea pressed: ", control_node.name)

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
	
	# Initialize the Curve2D resource
	curve = Curve2D.new()
	
	# Get the positions of the control points and add them to the curve
	var control_point1 = amoeba_shape.get_node("ControlPoint1").position
	var control_point2 = amoeba_shape.get_node("ControlPoint2").position
	var control_point3 = amoeba_shape.get_node("ControlPoint3").position
	var control_point4 = amoeba_shape.get_node("ControlPoint4").position
	var control_point5 = amoeba_shape.get_node("ControlPoint5").position
	var control_point6 = amoeba_shape.get_node("ControlPoint6").position
	var control_point7 = amoeba_shape.get_node("ControlPoint7").position
	var control_point8 = amoeba_shape.get_node("ControlPoint8").position
	
	curve.add_point(control_point1)
	add_wavy_points(curve, control_point1, control_point2, 3, time_passed)
	curve.add_point(control_point2)
	add_wavy_points(curve, control_point2, control_point3, 3, time_passed)
	curve.add_point(control_point3)
	add_wavy_points(curve, control_point3, control_point4, 3, time_passed)
	curve.add_point(control_point4)
	add_wavy_points(curve, control_point4, control_point5, 3, time_passed)
	curve.add_point(control_point5)
	add_wavy_points(curve, control_point5, control_point6, 3, time_passed)
	curve.add_point(control_point6)
	add_wavy_points(curve, control_point6, control_point7, 3, time_passed)
	curve.add_point(control_point7)
	add_wavy_points(curve, control_point7, control_point8, 3, time_passed)
	curve.add_point(control_point8)
	add_wavy_points(curve, control_point8, control_point1, 3, time_passed)
	curve.add_point(control_point1)
	# Assign the curve to the AmoebaShape (Path2D) node
	amoeba_shape.curve = curve
	update()


func _process(delta): 
	time_passed += delta
	var amoeba_shape = get_node("AmoebaShape")  # Adjusted the path
	var change_interval = 10.0 #change target(s) every 10s
	
	if fmod(time_passed, change_interval) < delta: #we've just passed an interval
		target_noise_period = rand_range(0.7, 0.8)
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
	if frequency < target_frequency:
		frequency += frequency_change_speed * delta
		if frequency > target_frequency:
			frequency = target_frequency
	elif frequency > target_frequency:
		frequency -= frequency_change_speed * delta
		if frequency < target_frequency:
			frequency = target_frequency
			
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


	# Clear the existing points from the curve and re-add them with the new undulation
	curve.clear_points()
	var control_point1 = amoeba_shape.get_node("ControlPoint1").position
	var control_point2 = amoeba_shape.get_node("ControlPoint2").position
	var control_point3 = amoeba_shape.get_node("ControlPoint3").position
	var control_point4 = amoeba_shape.get_node("ControlPoint4").position
	var control_point5 = amoeba_shape.get_node("ControlPoint5").position
	var control_point6 = amoeba_shape.get_node("ControlPoint6").position
	var control_point7 = amoeba_shape.get_node("ControlPoint7").position
	var control_point8 = amoeba_shape.get_node("ControlPoint8").position
	
	curve.add_point(control_point1)
	add_wavy_points(curve, control_point1, control_point2, 3, time_passed)
	curve.add_point(control_point2)
	add_wavy_points(curve, control_point2, control_point3, 3, time_passed)
	curve.add_point(control_point3)
	add_wavy_points(curve, control_point3, control_point4, 3, time_passed)
	curve.add_point(control_point4)
	add_wavy_points(curve, control_point4, control_point5, 3, time_passed)
	curve.add_point(control_point5)
	add_wavy_points(curve, control_point5, control_point6, 3, time_passed)
	curve.add_point(control_point6)
	add_wavy_points(curve, control_point6, control_point7, 3, time_passed)
	curve.add_point(control_point7)
	add_wavy_points(curve, control_point7, control_point8, 3, time_passed)
	curve.add_point(control_point8)
	add_wavy_points(curve, control_point8, control_point1, 3, time_passed)
	curve.add_point(control_point1)
	# Trigger the _draw() method to render the updated curve
	update()


func _draw():
	#print("Entering _draw function")  # Debug message
	var amoeba_shape = $AmoebaShape  # Adjusted the path
	var curve = amoeba_shape.curve
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

	draw_polyline(points, Color(0, 0, 0), 5)
	#print("Exiting _draw function")  # Debug message
