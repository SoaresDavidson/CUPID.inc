extends Node2D

@onready var animation_player = $AnimationPlayer
var dificuldade = GlobalVars.dificuldade
func _ready():
	GlobalVars.playing = 0

func _process(delta):
	pass

func _on_button_pressed():
	$AnimationPlayer.play("Fadeout2")
	await get_tree().create_timer(2.5).timeout
	get_tree().change_scene_to_file("res://scenes/menu.tscn")
