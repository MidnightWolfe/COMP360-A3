extends RigidBody3D

##NOTE: Nothing in here really, all of this stuff is in origin

#var force = Vector3(0, -150, 0) #Force applied to arm1
#var position1 = Vector3(0,0,0) #Position of arm1 to begin
#var impulse = Vector3(500,0,0) #The impulse of arm1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	#var force = Vector3(0, 150, 0) #Force applied to arm1
	#var position1 = Vector3(0,100,0) #Position of arm1 to begin
	#apply_force(force, position1)
	#set_mass(1.5) #Setting the mass of the rigid body
	##Testing
	#arm1.axis_lock_angular_y = true #Locking the y axis to test without twisting
	#arm1.axis_lock_angular_x = true #Locking the x axis to test without twisting
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	#_integrate_forces(state)
	#apply_impulse(position1, impulse)
	#apply_force(force, position1)
	pass
