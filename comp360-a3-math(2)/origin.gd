extends Node3D

###Objects
@onready var pivot1 = $pivot1
@onready var pivot2 = $pivot2
@onready var arm1 = $pivot1/arm1 #To get the properties of arm1
@onready var arm2 = $pivot2/arm2 #To get the properties of arm2

###Global variables
var force1 = Vector3(0, -150, 0) #Force applied to arm1
var position1 = Vector3(0,100,0) #Position of arm1 to begin / go around
var impulse1 = Vector3(200,0,0) #The impulse of arm1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	arm1.set_gravity_scale(1.0) #Scale of the global gravity for arm1
	arm1.set_mass(0.5) #Setting the mass of the rigid body arm1
	arm1.apply_impulse(position1, impulse1) #Applying impulse to arm1, not called every frame
	arm2.set_mass(0.5) #Setting the mass of the rigid body arm1
	##Testing
	#arm1.axis_lock_angular_y = true #Locking the y axis to test without twisting
	#arm1.axis_lock_angular_x = true #Locking the x axis to test without twisting
	pass


# Called every 60 frames. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	##Forces / physic movements for arm1
	arm1.apply_force(force1, position1) #Applying force to keep arm1 moving
	##NOTE: This is not a smooth looking motion, but it does work
	arm1.apply_torque(Vector3(5,5,0)) #Applying torque to keep the first arm rotating
	
	##Forces / physics movements for arm2
	
	pass 
