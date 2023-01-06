class_name Level
extends Node2D


@onready var _harvester: Harvester = $Harvester


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		start_level()


func start_level() -> void:
	var markers := get_tree().get_nodes_in_group("Markers")
	_harvester.play_marker_sequence(markers)
