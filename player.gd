class_name Player
extends RigidBody3D

func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("ui_accept"):
		var local_up: Vector3 = basis.y
		apply_central_force(local_up * delta * 1000)
	
	var torque_vector: Vector3 = Vector3.ZERO
	
	if Input.is_action_pressed("ui_left"):
		torque_vector += Vector3.FORWARD
		
	if Input.is_action_pressed("ui_right"):
		torque_vector += Vector3.BACK
		
	apply_torque(torque_vector * delta * 100)
