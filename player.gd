class_name Player
extends RigidBody3D

## The magnitude of the force applied when boosting
@export var boost_force: float = 1000

## The magnituted of the torque applied when rotating
@export var rotation_torque: float = 100

var _is_transitioning: bool = false

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
	if not _is_transitioning:
		if body.is_in_group("Goal"):
			_is_transitioning = true
			set_physics_process(false)
			# Check if there is a next level
			if "next_level_path" in body and body.next_level_path:
				print("Level complete!")
				_complete_level(body.next_level_path)
			else:
				print("You win!")
				
		if body.is_in_group("Hazard"):
			_is_transitioning = true
			_handle_crash()

func _handle_crash() -> void:
	set_physics_process(false)
	print("You crashed")
	var tween: Tween = create_tween()
	tween.tween_interval(1.0)
	tween.tween_callback(get_tree().reload_current_scene)	
	
func _complete_level(next_level_path: String) -> void:
	var tween: Tween = create_tween()
	tween.tween_interval(1.0)
	tween.tween_callback(get_tree().change_scene_to_file.bind(next_level_path))	
