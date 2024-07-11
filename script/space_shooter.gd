extends Node2D

@onready var animation_player = $AnimationPlayer
var dificuldade = GlobalVars.dificuldade
func _ready():
	MenuMusic.get_child(4).stop()
	MenuMusic.get_child(7).play()
	GlobalVars.playing = 0

func _process(delta):
	pass

func _on_button_pressed():
	MenuMusic.get_child(3).play()
	$AnimationPlayer.play("Fadeout2")
	await get_tree().create_timer(2.5).timeout
	get_tree().change_scene_to_file("res://scenes/menu.tscn")
