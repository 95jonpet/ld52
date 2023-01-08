class_name Game
extends Node2D


@onready var _level: Node2D = $Level  # Type is Level after starting the game.
var _level_index: int = 0
var _level_completed: bool = false

@onready var level_completed_sound: AudioStream = preload("res://game/level_completed.wav")
@onready var level_failed_sound: AudioStream = preload("res://game/level_failed.wav")


func _ready() -> void:
	Events.level_completed.connect(_on_level_completed)
	Events.level_failed.connect(_on_level_failed)
	Events.drill_moved.connect(_on_drill_moved)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("restart"):
		_restart_level()

	if event.is_action("ui_end") and OS.is_debug_build():
		var index := 0
		while true:
			var level_path := "res://levels/level_%02d.tscn" % (index + 1)
			if not ResourceLoader.exists(level_path):
				break
			index += 1

		_level_index = index - 1
		_goto_next_level()



func start() -> void:
	_goto_next_level()


func _goto_next_level() -> void:
	_level_index += 1
	var level_path := "res://levels/level_%02d.tscn" % _level_index

	# Check if the completed level was the last level.
	if not ResourceLoader.exists(level_path):
		_level_index = 0
		_goto_next_level()
		return

	# Load the next level.
	var level_scene: PackedScene = load(level_path)
	var level_node: Level = level_scene.instantiate()

	# Replace the level in the node tree.
	_level.add_sibling(level_node)
	_level.queue_free()
	_level = level_node
	_level_completed = false

	Events.level_started.emit(_level)


func _restart_level() -> void:
	_level_index -= 1
	_goto_next_level.call_deferred()


func _on_drill_moved(drill: Drill, _old_pos: Vector2, _new_pos: Vector2) -> void:
	if not _level_completed or drill.has_body():
		return

	_goto_next_level()


func _on_level_completed() -> void:
	_level_completed = true
	AudioPlayer.play(level_completed_sound)


func _on_level_failed(_lvl: Level, _reason: String) -> void:
	AudioPlayer.play(level_failed_sound)
	await get_tree().create_timer(1.0).timeout
	_restart_level()
