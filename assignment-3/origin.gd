extends Node3D
@onready var pivot1 = $pivot1
@onready var pivot2 = $pivot2
@onready var arm1 = $arm1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var force = Vector3(0, 150, 0) #Force applied to arm1
	var position = Vector3(0,100,0) #Position of arm1 to begin
	arm1.apply_force(force, position)
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	pass 
