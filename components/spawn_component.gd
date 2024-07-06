class_name SpawnComponent
extends Node

var screen_height = ProjectSettings.get_setting("display/window/size/viewport_height")
var screen_width = ProjectSettings.get_setting("display/window/size/viewport_width")
@onready var enemy_generator = $".."


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func coordinates() -> Vector2:
	var yPos: float = randf_range(0, screen_height)
	return Vector2(screen_width , yPos)
	
	
func spawn(scene: PackedScene,global_spawn_position: Vector2 = coordinates(), parent: Node = get_tree().current_scene) -> Node:
	var instance = scene.instantiate()
	parent.add_child(instance)
	instance.global_position = global_spawn_position
	return instance
	
	
