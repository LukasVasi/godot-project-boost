class_name Player
extends RigidBody3D

@onready var explosion_audio: AudioStreamPlayer = $ExplosionAudio
@onready var success_audio: AudioStreamPlayer = $SuccessAudio
@onready var rocket_audio: AudioStreamPlayer3D = $RocketAudio
@onready var booster_particles: GPUParticles3D = $BoosterParticles
@onready var right_booster_particles: GPUParticles3D = $RightBoosterParticles
@onready var left_booster_particles: GPUParticles3D = $LeftBoosterParticles
@onready var explosion_particles: GPUParticles3D = $ExplosionParticles
@onready var success_particles: GPUParticles3D = $SuccessParticles

@export_category("Rocket movement")

## The magnitude of the force applied when boosting
@export var boost_force: float = 1000

## The magnituted of the torque applied when rotating
@export var rotation_torque: float = 100

@export_category("Crash threshold")

## The linear velocity threshold. 
## If the player collides with the landing pad at this or higher velocity, it counts as a crash.
@export var crash_linear_velocity: float = 2

@export_category("Fuel")

## The amount of fuel the rocket has for boosting and rotating
@export var fuel_amount: float = 100

## The amount of fuel that is lost per second while firing the rocket
@export var fuel_loss: float = 10

@export_category("Level")

@export var current_level: int = 0

## The time that has passed since the player started playing the level in seconds
var level_time: float = 0.0

## Flag that determines if the rocket is firing (either moving or rotating)
var _is_firing: bool = false

var _is_transitioning: bool = false

## Flag used to determine if the player has started playing (moving). Used to start score timer.
var _playing: bool = false

func _ready() -> void:
	if current_level:
		var previous_time = SaveManager.get_level_data(str(current_level))
		if previous_time > 0:
			print("Previous best time is " + str(previous_time))
		else:
			print("No previously set time was found")


func _process(delta: float) -> void:
	if _playing:
		level_time += delta
	
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()


func _physics_process(delta: float) -> void:
	_is_firing = false
	
	if fuel_amount > 0:
		# Process boosting
		if Input.is_action_pressed("boost"):
			var local_up: Vector3 = basis.y
			apply_central_force(local_up * delta * boost_force)
			booster_particles.emitting = true
			_is_firing = true
		else:
			booster_particles.emitting = false
		
		var torque_vector: Vector3 = Vector3.ZERO
		
		# Process rotation
		if Input.is_action_pressed("rotate_left"):
			torque_vector += Vector3.BACK
			right_booster_particles.emitting = true
			_is_firing = true
		else:
			right_booster_particles.emitting = false
			
		if Input.is_action_pressed("rotate_right"):
			torque_vector += Vector3.FORWARD
			left_booster_particles.emitting = true
			_is_firing = true
		else:
			left_booster_particles.emitting = false
		
		apply_torque(torque_vector * delta * rotation_torque)
	
	if _is_firing:
		fuel_amount -= delta * fuel_loss
		
		if not rocket_audio.playing:
			rocket_audio.play()
			
		if not _playing:
			_playing = true
	else:
		rocket_audio.stop()


func _on_body_entered(body: Node) -> void:
	if not _is_transitioning:
		if body.is_in_group("Hazard") || linear_velocity.length() >= crash_linear_velocity:
			_is_transitioning = true
			_handle_crash()
			return
			
		if body.is_in_group("Goal"):
			_is_transitioning = true
			_playing = false
			set_physics_process(false)
			success_audio.play()
			success_particles.emitting = true
			if current_level:
				SaveManager.update_level_data(str(current_level), level_time)
			# Check if there is a next level
			if "next_level_path" in body and body.next_level_path:
				print("Level complete!")
				_complete_level(body.next_level_path)
			else:
				print("You win!")


func _handle_crash() -> void:
	_playing = false
	set_physics_process(false)
	print("You crashed")
	explosion_audio.play()
	explosion_particles.emitting = true
	var tween: Tween = create_tween()
	tween.tween_interval(2.0)
	tween.tween_callback(get_tree().reload_current_scene)	


func _complete_level(next_level_path: String) -> void:
	var tween: Tween = create_tween()
	tween.tween_interval(2.0)
	tween.tween_callback(get_tree().change_scene_to_file.bind(next_level_path))	
