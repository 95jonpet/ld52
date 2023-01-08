class_name Ore
extends StaticBody2D


@onready var ore_pickup: AudioStream = preload("res://minerals/ore/ore_pickup.wav")


func _ready() -> void:
	Events.drill_moved.connect(_on_drill_moved)


func _on_drill_moved(_drill: Drill, _old_pos: Vector2, new_pos: Vector2) -> void:
	if global_position != new_pos:
		return

	Events.ore_collected.emit(self)
	AudioPlayer.play(ore_pickup)
	queue_free()


func _on_hurtbox_hurt(_actor: Node2D) -> void:
	Events.ore_destroyed.emit()
	queue_free()
