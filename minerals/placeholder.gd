extends Node2D


func _ready() -> void:
	Events.drill_moved.connect(_on_drill_moved)


func _on_drill_moved(_drill: Drill, _old_global_pos: Vector2, new_global_pos: Vector2) -> void:
	if global_position == new_global_pos:
		queue_free()
