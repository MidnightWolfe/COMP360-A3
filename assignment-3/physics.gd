extends Node3D

@onready var ball1 = $mass1
@onready var ball2 = $mass2

var g = 9.8
var mass1 = 2.0
var mass2 = 1.0
var angle1 = PI/6.0
var angle2 = PI/3.0
var av1 = 3.0
var av2 = 2.0
var length1 = 3.0
var length2 = 1.0

func _ready() -> void:
	ball1.scale = ball1.scale * mass1
	ball2.scale = ball2.scale * mass2

func _physics_process(_delta: float) -> void:
	var y = Vector4(angle1, angle2, av1, av2)
	var k1 = lagrangeRightHandSide(y.x, y.y, y.z, y.w)
	var y1 = y + 1.0/60.0 * k1 / 2.0
	var k2 = lagrangeRightHandSide(y1.x, y1.y, y1.z, y1.w)
	var y2 = y + 1.0/60.0 * k2 / 2.0
	var k3 = lagrangeRightHandSide(y2.x, y2.y, y2.z, y2.w)
	var y3 = y + 1.0/60.0 * k3
	var k4 = lagrangeRightHandSide(y3.x, y3.y, y3.z, y3.w)
	var R = 1.0/6.0 * 1.0/60.0 * (k1 + 2.0 * k2 + 2.0 * k3 + k4)
	
	angle1 = angle1 + R[0]
	angle2 = angle2 + R[1]
	av1 = av1 + R[2]
	av2 = av2 + R[3]
	
	ball1.position.x = length1 * sin(angle1)
	ball1.position.y = -length1 * cos(angle1)
	
	ball2.position.x = ball1.position.x + length2 * sin(angle2)
	ball2.position.y = ball1.position.y - length2 * cos(angle2)

func _process(_delta: float) -> void:
	var immediate_mesh = ImmediateMesh.new()
	immediate_mesh.clear_surfaces()
	
	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES)
	immediate_mesh.surface_add_vertex(Vector3(0,0,0))
	immediate_mesh.surface_add_vertex(ball1.position)
	immediate_mesh.surface_add_vertex(ball1.position)
	immediate_mesh.surface_add_vertex(ball2.position)
	immediate_mesh.surface_end()
	$line.mesh = immediate_mesh

func _potentialEnergy() -> float:
	var height1 = -length1 * cos(angle1)
	var height2 = height1 - length2 * cos(angle2)
	return mass1 * g * height1 + mass2 * g * height2

func _kineticEnergy() -> float:
	var kinetic1 = 0.5 * mass1 * pow((length1 * av1),2)
	var kinetic2 = 0.5 * mass2 * (pow((length1 * av1),2) + pow((length2 * av2),2) + 2 * length1 * length2 * av1 * av2 * cos(angle1 - angle2))
	return kinetic1 + kinetic2

func _mechanicalEnergy() -> float:
	return _potentialEnergy() + _kineticEnergy()

func lagrangeRightHandSide(t1, t2, w1, w2) -> Vector4:
	var a1 = (length2 / length1) * (mass2 / (mass1 + mass2)) * cos(t1 - t2)
	var a2 = (length1 / length2) * cos(t1 - angle2)
	
	var f1 = -(length2 / length1) * (mass2 / (mass1 + mass2)) * pow(w2,2) * sin(t1 - t2) - (g / length1) * sin(t1)
	var f2 = (length1 / length2) * pow(w1,2) * sin(t1 - t2) - (g / length2) * sin(t2)
	
	var g1 = (f1 - a1 * f2) / (1 - a1 * a2)
	var g2 = (f2 -a2 * f1) / (1 - a1 * a2)
	
	var array = Vector4(w1, w2, g1, g2)
	return array
