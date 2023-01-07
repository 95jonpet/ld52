class_name Level
extends Node2D

@export var level_name: String = ""
@export_multiline var description: String = ""

@onready var _borders: Node2D = $Borders
@onready var _rocks: Node2D = $Rocks

@onready var border_scene = preload("res://minerals/border/border.tscn")
@onready var rock_scene = preload("res://minerals/rock/rock.tscn")


func _ready() -> void:
	var grid_size := 16
	var max_depth := grid_size * 64

	# Generate borders.
	for x in [grid_size * -12, grid_size * -11, grid_size * 11, grid_size * 12]:
		for y in range(0, max_depth, grid_size):
			var border: Node2D = border_scene.instantiate()
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
