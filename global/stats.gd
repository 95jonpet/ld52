extends Node


signal stats_changed()

var level_steps: int = 0:
	set(value):
		level_steps = value
		stats_changed.emit()

var total_steps: int = 0:
	set(value):
		total_steps = value
		stats_changed.emit()

var _playing: bool = false


func _ready() -> void:
	Events.drill_moved.connect(_on_drill_moved)
	Events.level_started.connect(_on_level_started)
	Events.level_completed.connect(_on_level_completed)


func _on_drill_moved(_drill: Drill, _old_pos: Vector2, _new_pos: Vector2) -> void:
	if not _playing:
		return

	level_steps += 1
	total_steps += 1


func _on_level_started(_level: Level) -> void:
	_playing = true
	level_steps = 0


func _on_level_completed() -> void:
	_playing = false
