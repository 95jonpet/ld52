class_name Hurtbox
extends Area2D


signal hurt(actor: Node2D)


func _on_body_entered(body: Node2D) -> void:
	hurt.emit(body)


func _on_area_entered(area: Area2D) -> void:
	hurt.emit(area)
