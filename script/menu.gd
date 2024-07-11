extends Control

#@onready var label_2 = $Label2

func _ready():
	GlobalVars.load_score()
	var hi = GlobalVars.highscore
	$Recorde.text = str(hi)
	GlobalVars.playing = 1
	#label_2.text = "highscore: " + str(GlobalVars.highscore)

func _on_button_pressed():
	MenuMusic.get_child(0).stop()
	MenuMusic.get_child(3).play()
	$AnimationPlayer.play("Fadeout")
	await get_tree().create_timer(2.5).timeout
	get_tree().change_scene_to_file("res://scenes/jogo_2.tscn")

func _on_button_2_pressed():
	get_tree().quit()
