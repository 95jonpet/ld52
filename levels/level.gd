class_name Level
extends Node2D

enum PlanItem {
	Move,
	Wait,
}

@export var level_name: String = ""
@export_multiline var description: String = ""

@export var plan: Array[PlanItem] = []

@onready var _harvester: Harvester = $Harvester


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		start_level()
	if event.is_action_pressed("ui_text_backspace"):
		get_tree().reload_current_scene()


func start_level() -> void:
	Events.planning_completed.emit()
	var markers := get_tree().get_nodes_in_group("Markers")
	_harvester.play_marker_sequence(markers)
