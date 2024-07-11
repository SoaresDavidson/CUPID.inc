class_name ClampPositionComponent
extends Node

@export var actor: Node2D
var screen_height = ProjectSettings.get_setting("display/window/size/viewport_height")
var screen_width = ProjectSettings.get_setting("display/window/size/viewport_width")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	actor.position.y = clamp(actor.position.y, 0, screen_height)
	actor.position.x = clamp(actor.position.x, 0, screen_width)
