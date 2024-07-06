class_name HitboxComponent
extends Area2D

@export var actor:Node2D

func _ready():
	area_entered.connect(hit)
	
func hit(area):
	pass

