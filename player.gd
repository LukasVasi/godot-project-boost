class_name Player
extends RigidBody3D

## The magnitude of the force applied when boosting
@export var boost_force: float = 1000

## The magnituted of the torque applied when rotating
@export var rotation_torque: float = 100

func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("boost"):
		var local_up: Vector3 = basis.y
		apply_central_force(local_up * delta * boost_force)
	
	var torque_vector: Vector3 = Vector3.ZERO
	
	if Input.is_action_pressed("rotate_left"):
		torque_vector += Vector3.FORWARD
		
	if Input.is_action_pressed("rotate_right"):
		torque_vector += Vector3.BACK
		
	apply_torque(torque_vector * delta * rotation_torque)


func _on_body_entered(body: Node) -> void:
	if body.is_in_group("Goal"):
		# Check if there is a next level
		if "next_level_path" in body and body.next_level_path:
			print("Level complete!")
			_complete_level(body.next_level_path)
		else:
			print("You win!")
		
	if body.is_in_group("Hazard"):
		_handle_crash()

func _handle_crash() -> void:
	print("You crashed")
	get_tree().reload_current_scene()
	
func _complete_level(next_level_path: String) -> void:
	get_tree().change_scene_to_file(next_level_path)
