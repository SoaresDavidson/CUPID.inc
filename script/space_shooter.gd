extends Node2D

@onready var timer = $Timer
var dificuldade = GlobalVars.dificuldade
func _ready():
	timer.start(dificuldade * 40)

func _on_timer_timeout():
	if GlobalVars.pontos > GlobalVars.meta:
		print("carta enviada")
	else:
		print("rejeitado :(")
	get_tree().quit()
