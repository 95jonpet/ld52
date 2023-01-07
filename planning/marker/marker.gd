class_name Marker
extends Draggable

@icon("res://planning/marker/marker.png")


func _ready() -> void:
	Events.planning_completed.connect(_on_planning_completed)


func _on_planning_completed() -> void:
	selectable = false
