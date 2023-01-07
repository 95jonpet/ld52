class_name Camera
extends Camera2D


@export var speed: float = 2.0
@export_range(0.0, 1.0) var deadzone: float = 0.0

@onready var target_position: Vector2 = global_position


func _ready() -> void:
	Events.drill_moved.connect(_on_drill_moved)


func _physics_process(delta: float) -> void:
	var old_position := global_position
	var camera_position := global_position.lerp(target_position, 1.0 - deadzone)
	global_position = global_position.lerp(camera_position, delta * speed)

	if global_position != old_position:
		Events.camera_moved.emit(self, old_position, global_position)


func _on_drill_moved(_drill: Drill, _old_global_pos: Vector2, new_global_pos: Vector2) -> void:
	target_position = new_global_pos
