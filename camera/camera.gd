class_name Camera
extends Camera2D


@export var speed: float = 5.0

@onready var target_position: Vector2 = global_position

# The smooth camera rounds global_position, so its raw value must be stored separately.
@onready var current_position: Vector2 = global_position


func _ready() -> void:
	Events.drill_moved.connect(_on_drill_moved)
	Events.level_started.connect(_on_level_started)


func _process(delta: float) -> void:
	var old_position := current_position

	current_position = current_position.lerp(target_position, delta * speed)

	global_position = current_position
	if global_position != old_position:
		Events.camera_moved.emit(self, old_position, global_position)


func _on_drill_moved(_drill: Drill, _old_global_pos: Vector2, new_global_pos: Vector2) -> void:
	target_position = new_global_pos


func _on_level_started(_level: Level) -> void:
	target_position = Vector2.ZERO
