class_name HUD
extends CanvasLayer

@onready var player: Player = $".."
@onready var velocity_label: Label = $VelocityLabel
@onready var fuel_label: Label = $FuelLabel

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	velocity_label.text = str(round(player.linear_velocity.length())) + " m/s"
	fuel_label.text = str(round(player.fuel_amount))
