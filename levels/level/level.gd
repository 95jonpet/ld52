class_name Level
extends Node2D

@export var level_name: String = ""
@export_multiline var description: String = ""

@onready var _remaining_ore: int = len(get_tree().get_nodes_in_group("Ore"))


func _ready() -> void:
	Events.ore_collected.connect(_on_ore_collected)


func _handle_completion() -> void:
	if _remaining_ore > 0:
		return

	Events.level_completed.emit()


func _on_ore_collected(_ore: Ore) -> void:
	_remaining_ore -= 1
	_handle_completion()
