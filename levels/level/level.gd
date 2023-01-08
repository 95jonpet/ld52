class_name Level
extends Node2D

@export var level_name: String = ""
@export_multiline var description: String = ""

var _remaining_ore: int = 1


func _ready() -> void:
	Events.ore_collected.connect(_on_ore_collected)
	Events.ore_destroyed.connect(_on_ore_destroyed)
	Events.drill_damaged.connect(_on_drill_damaged)
	Events.snail_killed.connect(_on_snail_killed)

	var ores := 0
	for ore in get_tree().get_nodes_in_group("Ore"):
		if not is_ancestor_of(ore):
			continue
		ores += 1
	_remaining_ore = ores


func _handle_completion() -> void:
	if _remaining_ore > 0:
		return

	Events.level_completed.emit()


func _on_ore_collected(_ore: Ore) -> void:
	_remaining_ore -= 1
	_handle_completion()


func _on_ore_destroyed() -> void:
	Events.level_failed.emit(self, "some ore was destroyed")


func _on_drill_damaged() -> void:
	Events.level_failed.emit(self, "the drill was damaged")


func _on_snail_killed() -> void:
	Events.level_failed.emit(self, "a snail was killed")
