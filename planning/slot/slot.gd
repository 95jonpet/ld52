class_name Slot
extends DropArea


@onready var _sprite: Sprite2D = $Sprite2D


func _ready() -> void:
	Events.planning_completed.connect(_on_planning_completed)


func _process(_delta: float) -> void:
	_sprite.modulate.a = 1.0 if usable else 0.25


func _on_planning_completed() -> void:
	queue_free()
