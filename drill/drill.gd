class_name Drill
extends Node2D


const RETRACT_STEP_TIME: float = 0.2

@onready var _head: DrillHead = $Head
@onready var _body: Node2D = $Body
@onready var _original_head_rotation: float = _head.rotation
var _body_nodes: Array[Node2D] = []
var _retracting: bool = false

@onready var body_scene: PackedScene = preload("res://drill/drill_body/drill_body.tscn")

@onready var drill_moved: AudioStream = preload("res://drill/drill_moved.wav")
@onready var drill_blocked: AudioStream = preload("res://drill/drill_blocked.wav")


func _ready() -> void:
	Events.level_completed.connect(_on_level_completed)
	Events.level_failed.connect(_on_level_failed)


func has_body() -> bool:
	return !_body_nodes.is_empty()


func retract() -> void:
	if _retracting:
		return

	_retracting = true
	_head.can_move = false

	while not _body_nodes.is_empty():
		var node: Node2D = _body_nodes.back()
		await get_tree().create_timer(RETRACT_STEP_TIME).timeout
		if not is_instance_valid(_head):
			return
		_on_head_move_requested(_head.global_position, node.global_position)

	_head.can_move = true


func _create_body(global_pos: Vector2) -> void:
	var node: DrillBody = body_scene.instantiate()
	node.global_position = global_pos
	_body_nodes.push_back(node)
	_body.add_child(node)


func _on_head_move_requested(old_global_pos: Vector2, new_global_pos: Vector2) -> void:
	# Don't move out of the ground.
	if new_global_pos.y < 0:
		AudioPlayer.play(drill_blocked)
		return

	# Allow the drill to be retracted.
	var last_node: DrillBody = _body_nodes.back() if not _body_nodes.is_empty() else null
	if _head.can_retract_on_next_move and last_node and last_node.global_position == new_global_pos:
		_body_nodes.pop_back()
		last_node.queue_free()
		_head.move_to_position(new_global_pos)
		Events.drill_moved.emit(self, old_global_pos, new_global_pos)
		AudioPlayer.play(drill_moved)

		# Update rotation when retracting over a turn.
		var next_last_node = _body_nodes.back() if not _body_nodes.is_empty() else null
		_head.rotation = next_last_node.global_position.angle_to_point(new_global_pos) if next_last_node else _original_head_rotation

		return

	# Don't move into colliding body.
	if _body_nodes.any(func(node): return node.global_position == new_global_pos):
		AudioPlayer.play(drill_blocked)
		return

	_create_body(old_global_pos)
	_head.move_to_position(new_global_pos)
	_head.can_retract_on_next_move = true
	Events.drill_moved.emit(self, old_global_pos, new_global_pos)
	AudioPlayer.play(drill_moved)


func _on_level_completed() -> void:
	_head.can_move = false
	retract()


func _on_level_failed(_level: Level, _reason: String) -> void:
	_head.can_move = false
