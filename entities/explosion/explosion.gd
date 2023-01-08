class_name Explosion
extends CharacterBody2D


const NO_COLLISIONS: int = 0


func _on_life_timer_timeout() -> void:
	queue_free()


func _on_collision_timer_timeout() -> void:
	collision_layer = NO_COLLISIONS
