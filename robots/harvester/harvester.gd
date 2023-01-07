class_name Harvester
extends CharacterBody2D

@export var speed: float = 2.0

var _marker_queue: Array[Node] = []
@onready var _target_position := global_position


func _physics_process(delta: float) -> void:
	if global_position.distance_squared_to(_target_position) < speed * speed:
		global_position = _target_position  # Snap to the marker

		# Target the next marker.
		if not _marker_queue.is_empty():
			var marker: Node = _marker_queue.pop_front()
			_target_position = marker.global_position
			rotation = global_position.angle_to_point(_target_position)

	global_position = global_position.lerp(_target_position, speed * delta)


func play_marker_sequence(markers: Array[Node]) -> void:
	_marker_queue = markers
