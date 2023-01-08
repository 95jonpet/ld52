class_name Lock
extends StaticBody2D


const NO_COLLISIONS: int = 0

var locked: bool = false: set = _set_locked

@onready var lock_locked: AudioStream = preload("res://modifiers/lock/lock_locked.wav")
@onready var _detector: Area2D = $Detector
@onready var _original_collision_layer: int = collision_layer


func _ready() -> void:
	_set_locked(locked)


func _set_locked(value: bool) -> void:
	if locked != value:
		AudioPlayer.play(lock_locked)

	locked = value

	collision_layer = _original_collision_layer if locked else NO_COLLISIONS
	_detector.set_deferred("monitoring", not locked)
	modulate.a = 1.0 if locked else 0.25


func _on_detector_body_entered(body: Node2D) -> void:
	locked = true

	# Prevent the drill from touching the lock and retracting.
	# This would otherwise result in a new obstruction without trapping the drill.
	if body is DrillHead:
		var head: DrillHead = body
		head.can_retract_on_next_move = false
