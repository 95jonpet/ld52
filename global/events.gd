extends Node

signal level_completed()

signal planning_completed()

signal camera_moved(camera: Camera, old_global_pos: Vector2, new_global_pos: Vector2)

signal drill_moved(drill: Drill, old_global_pos: Vector2, new_global_pos: Vector2)

signal ore_collected(ore: Ore)

signal mineral_drilled(mineral: Node2D)
