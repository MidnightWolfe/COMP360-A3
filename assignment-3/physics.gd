extends Node3D

# The 2 objects in the physical system
@onready var ball1 = $pendulum/mass1
@onready var ball2 = $pendulum/mass2

@onready var camera = $Camera3D
@onready var pendulum = $pendulum
var counter = 1.0
var points : PackedVector3Array

# Gravity
var gravity = 9.8

# Masses
var mass1 = 2.0
var mass2 = 1.0

# Starting angles
var angle1 = PI/6.0
var angle2 = PI/3.0

# Starting angular velocities
var angularVelocity1 = 3.0
var angularVelocity2 = 2.0

# Length of strings between pivots
var length1 = 3.0
var length2 = 1.0

# Scales the size of the masses relative to their mass
func _ready() -> void:
	ball1.scale = ball1.scale * mass1
	ball2.scale = ball2.scale * mass2

func _physics_process(delta: float) -> void:
	
	# Store angles and angular velocities in a vector for easier modification
	var y = Vector4(angle1, angle2, angularVelocity1, angularVelocity2)
	
	# RK4 constants
	var k1 = _lagrangeRightHandSide(y)
	var k2 = _lagrangeRightHandSide(y + delta * k1 / 2.0)
	var k3 = _lagrangeRightHandSide(y + delta * k2 / 2.0)
	var k4 = _lagrangeRightHandSide(y + delta * k3)
	
	# Combination of RK4 constants give new angles and angular velocities
	var R = 1.0/6.0 * delta * (k1 + 2.0 * k2 + 2.0 * k3 + k4)
	
	# Update angles and angular velocities
	angle1 = angle1 + R[0]
	angle2 = angle2 + R[1]
	angularVelocity1 = angularVelocity1 + R[2]
	angularVelocity2 = angularVelocity2 + R[3]
	
	
	points.append(ball2.global_position)
	
	# Update the positions of masses based on angles
	ball1.position = Vector3(length1 * sin(angle1), -length1 * cos(angle1), 0)
	ball2.position = Vector3(ball1.position.x + length2 * sin(angle2), ball1.position.y - length2 * cos(angle2), 0)
	
	points.append(ball2.global_position)
	
	if points.size() > 1000:
		points.remove_at(0)
		points.remove_at(1)
	
	# Draw trail of ball2
	var trail_mesh = ImmediateMesh.new()
	trail_mesh.surface_begin(Mesh.PRIMITIVE_LINES)
	for i in points.size():
		trail_mesh.surface_add_vertex(points[i])
	trail_mesh.surface_end()
	$trail.mesh = trail_mesh

# In the _proccess function a mesh is drawn from the pivot to ball1 to ball2
func _process(_delta: float) -> void:
	var immediate_mesh = ImmediateMesh.new()
	immediate_mesh.clear_surfaces()
	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES)
	immediate_mesh.surface_add_vertex(Vector3(0,0,0))
	immediate_mesh.surface_add_vertex(ball1.position)
	immediate_mesh.surface_add_vertex(ball1.position)
	immediate_mesh.surface_add_vertex(ball2.position)
	immediate_mesh.surface_end()
	$pendulum/line.mesh = immediate_mesh
	
	# Make the camera orbit
	camera.position.x = 6 * cos(counter / 1000.0)
	camera.position.z = 6 * sin(counter / 1000.0)
	camera.look_at(Vector3(0,0,0))
	
	# Rotate pendulum in z-axis
	pendulum.rotation.x = (sin(counter / 200))
	counter = counter + 1.0

 # Potential energy = mass * gravity * height
func _potentialEnergy() -> float:
	var height1 = -length1 * cos(angle1)
	var height2 = height1 - length2 * cos(angle2)
	return mass1 * gravity * height1 + mass2 * gravity * height2

# Kinetic energy = 1/2 * mass * velocity squared
# Velocity of ball2 is more complicated as its movement is based on ball1
func _kineticEnergy() -> float:
	var kinetic1 = 0.5 * mass1 * pow((length1 * angularVelocity1),2)
	var kinetic2 = 0.5 * mass2 * (pow((length1 * angularVelocity1),2) + pow((length2 * angularVelocity2),2) + 2 * length1 * length2 * angularVelocity1 * angularVelocity2 * cos(angle1 - angle2))
	return kinetic1 + kinetic2

# Mechanical energy = Potential energy + Kinetic energy
func _mechanicalEnergy() -> float:
	return _potentialEnergy() + _kineticEnergy()

func _lagrangeRightHandSide(array :Vector4) -> Vector4:
	# Angles
	var theta1 = array.x
	var theta2 = array.y
	
	# Angular velocity
	var omega1 = array.z
	var omega2 = array.w
	
	# Scalars
	var scalar1 = (length2 / length1) * (mass2 / (mass1 + mass2)) * cos(theta1 - theta2)
	var scalar2 = (length1 / length2) * cos(theta1 - angle2)
	
	# Forces on each mass
	var force1 = -(length2 / length1) * (mass2 / (mass1 + mass2)) * pow(omega2,2) * sin(theta1 - theta2) - (gravity / length1) * sin(theta1)
	var force2 = (length1 / length2) * pow(omega1,2) * sin(theta1 - theta2) - (gravity / length2) * sin(theta2)
	
	# Angular accelerations
	var angularAcceleration1 = (force1 - scalar1 * force2) / (1 - scalar1 * scalar2)
	var angularAcceleration2 = (force2 -scalar2 * force1) / (1 - scalar1 * scalar2)
	
	# Store result in a vector for easier use in calculation
	var result = Vector4(omega1, omega2, angularAcceleration1, angularAcceleration2)
	return result
