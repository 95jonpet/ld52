class_name Toggle
extends StaticBody2D


@export var active: bool = false: set = _set_active
@export var turns_until_trigger: int = 2

@export var active_turns: int = 2
@export var inactive_turns: int = 2

const NO_COLLISIONS: int = 0

@onready var _original_collision_layer: int = collision_layer


func _ready() -> void:
	Events.drill_moved.connect(_on_drill_moved)


func _tick() -> void:
	turns_until_trigger -= 1
	if turns_until_trigger > 0:
		return

	active = not active
	turns_until_trigger = active_turns if active else inactive_turns


func _set_active(value: bool) -> void:
	active = value

	collision_layer = _original_collision_layer if active else NO_COLLISIONS
	modulate.a = 1.0 if active else 0.25

func _on_drill_moved(_drill: Drill, _old_pos: Vector2, _new_pos: Vector2) -> void:
	_tick()
