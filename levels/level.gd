class_name Level
extends Node2D

@export var level_name: String = ""
@export_multiline var description: String = ""

@onready var _background: Sprite2D = $Background
@onready var _sky: Sprite2D = $Sky

@onready var _borders: Node2D = $Borders
@onready var _rocks: Node2D = $Rocks

@onready var noclip_scene = preload("res://levels/noclip.tscn")
@onready var rock_scene = preload("res://minerals/rock/rock.tscn")


func _ready() -> void:
	var grid_size := 16
	var max_depth := grid_size * 64
	var ground_level := grid_size * 2
	var width := 20

	# Adjust background size.
	_background.position = Vector2(grid_size * (-width / 2.0 - 0.5), ground_level - grid_size / 2.0)
	_background.scale = Vector2(width + 1, max_depth -_background.position.y)

	# Adjust sky size.
	var sky_height := 36
	var sky_width := width * 2
	_sky.position = Vector2((-sky_width / 2.0 - 0.5) * grid_size, ground_level - (sky_height - 0.5) * grid_size)
	_sky.scale = Vector2(sky_width + 1, sky_height - 1)

	# Generate borders.
	var border_x_coordinates := [
		grid_size * (-width / 2.0 - 1),
		grid_size * (width / 2.0 + 1),
	]
	for x in border_x_coordinates:
		for y in range(-ground_level, max_depth, grid_size):
			var border: Node2D = noclip_scene.instantiate()
			border.position = Vector2(x, y)
			_borders.add_child(border)

	# Generate rock.
	for x in range(grid_size * -10, grid_size * 10 + 1, grid_size):
		for y in range(grid_size * 2, max_depth, grid_size):
			var rock: Node2D = rock_scene.instantiate()
			rock.position = Vector2(x, y)
			_rocks.add_child(rock)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_text_backspace"):
		get_tree().reload_current_scene()
