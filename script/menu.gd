extends Control

@onready var label_2 = $Label2

func _ready():
	GlobalVars.playing = 1
	label_2.text = "highscore: " + str(GlobalVars.highscore)

func _on_button_pressed():
	get_tree().change_scene_to_file("res://scenes/jogo_2.tscn")


func _on_button_2_pressed():
	get_tree().quit()
