extends Node2D


func _ready():
	MenuMusic.get_child(17).play()
	$Label.text = "When leaving work today, your boss stopped you and gave you a firing letter. You made mistakes in your delivery today and compromised the integrity of the company. You kept the job for " + str(GlobalVars.scoreatual) + " days. Now you are jobless and living life aimlessly."
	await get_tree().create_timer(1.0).timeout
	$Button.show()


func _on_button_pressed():
	$Button.hide()
	$AnimationPlayer.play("FadeOut")
	MenuMusic.get_child(17).stop()
	await get_tree().create_timer(1.0).timeout
	GlobalVars.scoreatual = 0
	get_tree().change_scene_to_file("res://scenes/menu.tscn")
