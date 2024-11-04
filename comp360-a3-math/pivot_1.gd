extends Node3D
@onready var arm1 = $arm1
@onready var arm2 = $arm2
@onready var sphere1 = $sphere1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var force = Vector3(0, 200, 0) #Force applied to arm1
	#var position = Vector3(0,100,0) #Position of arm1 to begin
	arm1.apply_central_force(force)
	#arm2.apply_force(force, position)
	arm2.apply_central_force(force)
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	delta = 1
	print(delta)
	#var force = Vector3(0, 0, 0) #Force applied to arm1 - Play with this to see the results
	#arm2.add_constant_torque(force)
	pass
