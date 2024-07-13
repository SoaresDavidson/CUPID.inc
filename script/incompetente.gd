extends Node2D


func _ready():
	MenuMusic.get_child(17).play()
	$Label.text = "Não fez os processos a tempo. Você manteve o emprego por " + str(GlobalVars.scoreatual) + " dias."
	await get_tree().create_timer(1.0).timeout
	$Button.show()


func _on_button_pressed():
	$Button.hide()
	$AnimationPlayer.play("FadeOut")
	MenuMusic.get_child(17).stop()
	await get_tree().create_timer(1.0).timeout
	GlobalVars.scoreatual = 0
	get_tree().change_scene_to_file("res://scenes/menu.tscn")
