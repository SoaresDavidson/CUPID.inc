class_name HurtBoxComponent
extends Area2D

@export var actor:Node2D

func _ready():
	area_entered.connect(hurt)
	
func hurt(area):
	actor.queue_free()

