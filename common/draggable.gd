class_name Draggable
extends Area2D


signal drag_started()
signal drag_stopped()

@export var drop_group_name: String = "Drop Area"
@export var move_speed: float = 24.0
@export var reset_speed: float = 12.0
@export var snap_distance: float = 16.0

var selectable: bool = true

var _selected: bool = false
@onready var _anchor: Node2D = get_anchor()
@onready var _rest_point: Vector2 = global_position


func _ready() -> void:
	_snap_to_anchor()


func _physics_process(delta: float) -> void:
	if _selected:
		global_position = global_position.lerp(get_global_mouse_position(), move_speed * delta)
	else:
		global_position = global_position.lerp(_rest_point, reset_speed * delta)


func _input(event: InputEvent) -> void:
	if not event.is_action_released("click"):
		return

	drag_stopped.emit()
	_selected = false

	var previous_anchor = _anchor
	_snap_to_anchor()

	# Free the previous anchor.
	if previous_anchor and previous_anchor != _anchor:
		previous_anchor.usable = true


func get_anchor() -> Node2D:
	var anchor: Node2D = null
	var shortest_distance := snap_distance  # Must be within snapping distance.

	for drop_zone in get_tree().get_nodes_in_group(drop_group_name):
		var distance := global_position.distance_to(drop_zone.global_position)
		if distance < shortest_distance and drop_zone.usable:
			anchor = drop_zone

	return anchor


func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("click") and selectable:
		drag_started.emit()
		_selected = true


func _snap_to_anchor() -> void:
	var snap_anchor := get_anchor()
	if snap_anchor:
		_anchor = snap_anchor

		global_position = _anchor.global_position
		_rest_point = _anchor.global_position
		_anchor.usable = false
