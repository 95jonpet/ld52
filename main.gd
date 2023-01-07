class_name Main
extends Node


@onready var _game: Game = $SubViewportContainer/SubViewport/Game
@onready var _viewport_container: SubViewportContainer = $SubViewportContainer

@onready var _level_labels: VBoxContainer = $LevelLabels
@onready var _level_title_label: Label = $LevelLabels/LevelTitleLabel
@onready var _level_description_label: Label = $LevelLabels/LevelDescriptionLabel


func _ready() -> void:
	Events.camera_moved.connect(_on_camera_moved)
	Events.level_started.connect(_on_level_started)

	_game.start()


func _on_camera_moved(camera: Camera, _old_pos: Vector2, new_pos: Vector2) -> void:
	var subpixel_position: Vector2 = new_pos.round() - new_pos
	camera.global_position = new_pos.round()
	_viewport_container.material.set_shader_parameter("camera_offset", subpixel_position)

	# Fade out level text.
	if new_pos.y <= Constants.GRID_SIZE:
		_level_labels.modulate.a = 1.0
	else:
		_level_labels.modulate.a = max(1 - (new_pos.y / (Constants.GRID_SIZE * 2)), 0)


func _on_level_started(level: Level) -> void:
	_level_title_label.text = level.level_name
	_level_description_label.text = level.description
