class_name BounceComponent
extends Node

@export var move_component: MoveComponent 
@export var actor: Node2D

var screen_height = ProjectSettings.get_setting("display/window/size/viewport_height")

func _process(delta):
	if actor.position.y >= screen_height:
		move_component.velocity.y *= -1
	elif actor.position.y < 0:
		move_component.velocity.y *= -1
		
