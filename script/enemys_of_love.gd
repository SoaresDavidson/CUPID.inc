class_name Enemy
extends Node2D

@onready var move_component = $MoveComponent


# Called when the node enters the scene tree for the first time.
func _ready():
	move_component.velocity.x = -80


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
