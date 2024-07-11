class_name InputComponent
extends Node

@export var move_component: MoveComponent
@export var speed: int
func _input(event: InputEvent):
	var input_axis= Input.get_axis("up", "down")
	var input_axis2 = Input.get_axis("left", "right")
	move_component.velocity = Vector2(input_axis2, input_axis).normalized() * speed
	

