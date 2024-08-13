class_name HUD
extends CanvasLayer

@onready var player: Player = $".."
@onready var velocity_label: Label = $VelocityLabel
@onready var fuel_label: Label = $FuelLabel
@onready var time_label: Label = $TimeLabel

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	velocity_label.text = "%03d m/s" % round(player.linear_velocity.length())
	fuel_label.text = "%03d %%" % round(player.fuel_amount)
	var time: float = player.level_time
	var minutes: int = floor(time/60)
	var seconds: int = floor(time - minutes * 60)
	var centiseconds: int = round((time - floor(time)) * 100)
	time_label.text = "%02d:%02d:%03d" % [minutes, seconds, centiseconds]
