class_name MovingObstacle
extends AnimatableBody3D

@export var destination_offset: Vector3 = Vector3.ZERO
@export var duration: float = 0.0
@export var delay: float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var tween = create_tween().set_loops().set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "global_position", global_position + destination_offset, duration).set_delay(delay)
	tween.tween_property(self, "global_position", global_position, duration).set_delay(delay)
