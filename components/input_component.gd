class_name InputComponent
extends Node

@export var move_component: MoveComponent
@export var speed: int

func _input(event: InputEvent):
	var input_axis = Input.get_axis("ui_up", "ui_down")
	move_component.velocity = Vector2(0, input_axis * speed)
	

