class_name DrillBody
extends StaticBody2D


var invincible: bool = false: set = _set_invincible

@onready var _hurtbox: Hurtbox = $Hurtbox


func _ready() -> void:
	_set_invincible(invincible)


func _on_hurtbox_hurt(_actor: Node2D) -> void:
	Events.drill_damaged.emit()


func _set_invincible(value: bool) -> void:
	invincible = value
	_hurtbox.monitoring = not invincible


func _on_shield_area_body_entered(_body: Node2D) -> void:
	invincible = true


func _on_shield_area_body_exited(_body: Node2D) -> void:
	invincible = false
