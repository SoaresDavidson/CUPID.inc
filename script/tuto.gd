extends Node2D

func _ready():
	MenuMusic.get_child(0).play()

func _on_button_pressed():
	get_tree().change_scene_to_file("res://scenes/menu.tscn")
