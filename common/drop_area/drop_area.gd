class_name DropArea
extends Area2D


signal use_changed(used: bool)


var usable: bool = true: set = _set_usable


func _set_usable(value: bool) -> void:
	if usable != value:
		use_changed.emit(value)

	usable = value
