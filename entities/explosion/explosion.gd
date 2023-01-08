class_name Explosion
extends CharacterBody2D


func _on_timer_timeout() -> void:
	queue_free()
