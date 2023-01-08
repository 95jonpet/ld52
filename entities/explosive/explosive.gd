class_name Explosive
extends Area2D


@onready var explosion_scene: PackedScene = preload("res://entities/explosion/explosion.tscn")
@onready var explosion_sound: AudioStream = preload("res://entities/explosive/explosion.wav")

@onready var _trigger_timer: Timer = $TriggerTimer


func explode(triggering_actor: Node2D) -> void:
	var offsets := [
		Vector2.LEFT * Constants.GRID_SIZE,
		Vector2.RIGHT * Constants.GRID_SIZE,
		Vector2.UP * Constants.GRID_SIZE,
		Vector2.DOWN * Constants.GRID_SIZE,
	]

	# Only target directions from which the collider did not come.
	if triggering_actor:
		var move_dir := Vector2.from_angle(triggering_actor.rotation) * Constants.GRID_SIZE
		offsets = offsets.filter(func (offset): return not offset.is_equal_approx(-move_dir))

	if offsets.is_empty():
		return

	for offset in offsets:
		var explosion: Explosion = explosion_scene.instantiate()
		explosion.position = position + offset
		call_deferred("add_sibling", explosion)

	AudioPlayer.play(explosion_sound)
	queue_free()


func _on_body_entered(body: Node2D) -> void:
	explode(body)


func _on_hurtbox_hurt(_actor) -> void:
	set_deferred("monitorable", false)
	_trigger_timer.start()


func _on_trigger_timer_timeout() -> void:
	explode(null)
