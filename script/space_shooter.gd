extends Node2D

var dificuldade = GlobalVars.dificuldade
func _ready():
	pass

func _process(delta):
	if GlobalVars.pontos >= GlobalVars.meta:
		print("carta enviada")
		GlobalVars.highscore += GlobalVars.pontos
		get_tree().change_scene_to_file("res://scenes/jogo_2.tscn")

func _on_button_pressed():
	get_tree().change_scene_to_file("res://scenes/menu.tscn")
