class_name Snail
extends CharacterBody2D


@onready var _sprite: Sprite2D = $Sprite2D
@onready var _target_ray: RayCast2D = $TargetRay
@onready var _target_floor_ray: RayCast2D = $TargetFloorRay

var _can_move: bool = true


func _ready() -> void:
	Events.drill_moved.connect(_on_drill_moved)
	Events.level_completed.connect(_on_level_completed)


func _process(_delta: float) -> void:
	_sprite.flip_v = rotation >= TAU * 0.25 and rotation < TAU * 0.75


func _move() -> void:
	if not _can_move:
		return

	if _target_ray.is_colliding() or not _target_floor_ray.is_colliding():
		_flip()

		if _target_ray.is_colliding() or not _target_floor_ray.is_colliding():
			_flip()  # Reset rotation if stuck.

		return  # Don't move if a rotation was applied.

	var distance := Vector2.from_angle(rotation) * Constants.GRID_SIZE
	position += distance


func _flip() -> void:
	rotation = wrapf(rotation + PI, 0, TAU)

	var rotated := rotation >= TAU * 0.25 and rotation < TAU * 0.75
	var abs_target_y_pos: float = abs(_target_floor_ray.target_position.y)
	_target_floor_ray.target_position.y = -abs_target_y_pos if rotated else abs_target_y_pos

	# Raycasts are invalidated when rotating, and must be updated.
	_target_ray.force_raycast_update()
	_target_floor_ray.force_raycast_update()


func _on_drill_moved(_drill: Drill, _old_pos: Vector2, _new_pos: Vector2) -> void:
	_move()


func _on_hurtbox_body_entered(_body: Node2D) -> void:
	Events.snail_killed.emit()
	queue_free()


func _on_level_completed() -> void:
	_can_move = false
