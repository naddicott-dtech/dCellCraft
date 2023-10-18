extends Node2D

var amplitude = 10.0
var frequency = 1.0
var time_passed = 0.0
var osc_speed = 0.5
var noise = OpenSimplexNoise.new() # Godot has built-in Simplex noise                                                                            
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


func _ready():
	# Access the AmoebaShape (Path2D) node
	var amoeba_shape = get_node("AmoebaShape")  # Adjusted the path
	self.z_index = 1  # Set to a higher value than Moving Background
	
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
	
	print("Control Point 1: ", control_point1)
	print("Control Point 2: ", control_point2)
	print("Control Point 3: ", control_point3)
	print("Control Point 4: ", control_point4)
	
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

func _draw():
	print("Entering _draw function")  # Debug message
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
	print("Exiting _draw function")  # Debug message
