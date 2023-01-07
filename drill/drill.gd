class_name Drill
extends Node2D


@onready var _head: DrillHead = $Head
@onready var _body: Node2D = $Body
var _body_nodes: Array[Node2D] = []

@onready var body_scene: PackedScene = preload("res://drill/drill_body.tscn")

@onready var drill_moved: AudioStream = preload("res://drill/drill_moved.wav")
@onready var drill_blocked: AudioStream = preload("res://drill/drill_blocked.wav")


func _create_body(global_pos: Vector2) -> void:
	var node: Node2D = body_scene.instantiate()
	node.global_position = global_pos
	_body_nodes.push_back(node)
	_body.add_child(node)


func _on_head_move_requested(old_global_pos: Vector2, new_global_pos: Vector2) -> void:
	# Allow the drill to be retracted.
	var last_node: Node2D = _body_nodes.back() if not _body_nodes.is_empty() else null
	if last_node and last_node.global_position == new_global_pos:
		_body_nodes.pop_back()
		last_node.queue_free()
		_head.move_to_position(new_global_pos)
		Events.drill_moved.emit(self, old_global_pos, new_global_pos)
		AudioPlayer.play(drill_moved)

		# Update rotation when retracting over a turn.
		var next_last_node = _body_nodes.back() if not _body_nodes.is_empty() else null
		if next_last_node:
			_head.rotation = next_last_node.global_position.angle_to_point(new_global_pos)

		return

	# Don't move into colliding body.
	if _body_nodes.any(func(node): return node.global_position == new_global_pos):
		AudioPlayer.play(drill_blocked)
		return

	_create_body(old_global_pos)
	_head.move_to_position(new_global_pos)
	Events.drill_moved.emit(self, old_global_pos, new_global_pos)
	AudioPlayer.play(drill_moved)
