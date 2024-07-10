class_name MoveComponent
extends Node

#cliquem no script e vai aparecer as opções pra escolher
@export var actor: Node2D #qual objeto vai se mover
@export var velocity: Vector2 #vector que contém a velocidade do x e do y do objeto(vai ser criado em outro script)


func _process(delta):
	#move
	actor.position += velocity * delta * GlobalVars.playing 
