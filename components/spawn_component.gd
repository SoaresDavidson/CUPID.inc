class_name SpawnComponent
extends Node

var screen_height = ProjectSettings.get_setting("display/window/size/viewport_height")
var screen_width = ProjectSettings.get_setting("display/window/size/viewport_width")
@onready var enemy_generator = $".."
var dificuldade = GlobalVars.dificuldade

func coordinates() -> Vector2:
	var yPos: float = randf_range(0, screen_height)
	return Vector2(get_parent().position.x, yPos)
	
	
func spawn(scene: PackedScene,timer: Timer,time_offset: float = 1.0, parent: Node = get_tree().current_scene) -> Node:
	#honestamente são poucas coisas que eu sei explicar nessa parte so confia no pai
	var instance = scene.instantiate()
	parent.add_child(instance)
	instance.global_position = coordinates()
	var spawn_rate = time_offset / (0.5 + (dificuldade * 0.1))
	timer.start(spawn_rate + randf_range(0.25, 0.5))
	return instance
	
	
