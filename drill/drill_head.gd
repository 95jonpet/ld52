class_name DrillHead
extends CharacterBody2D


signal move_requested(old_global_pos: Vector2, new_global_pos: Vector2)

var can_move: bool = true
var can_retract_on_next_move = true

@onready var _ray: RayCast2D = $RayCast2D


func _input(event: InputEvent) -> void:
	if not can_move:
		return

	var move_direction := Vector2.ZERO

	if event.is_action_pressed("move_left"):
		move_direction += Vector2.LEFT
	if event.is_action_pressed("move_right"):
		move_direction += Vector2.RIGHT
	if event.is_action_pressed("move_up"):
		move_direction += Vector2.UP
	if event.is_action_pressed("move_down"):
		move_direction += Vector2.DOWN

	# Diagonal movement is not allowed.
	if move_direction.length() != 1:
		return

	var new_global_pos := global_position + move_direction * Constants.GRID_SIZE

	# Ensure that there is no collision.
	_ray.target_position = to_local(new_global_pos)
	_ray.force_raycast_update()
	if _ray.is_colliding():
		return

	move_requested.emit(global_position, new_global_pos)


func move_to_position(new_global_pos: Vector2) -> void:
	rotation = global_position.angle_to_point(new_global_pos)
	global_position = new_global_pos
