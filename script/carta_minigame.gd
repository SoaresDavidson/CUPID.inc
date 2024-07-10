class_name Player
extends Node2D
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var move_component = $MoveComponent
@onready var input_component = $InputComponent
@onready var replay = $"../Replay"
@onready var animation_player = $"../AnimationPlayer"


# Called when the node enters the scene tree for the first time.
func _ready():
	animation_player.play("RESET")
	await get_tree().create_timer(0.0001).timeout
	animation_player.play("Default")
	await get_tree().create_timer(3.0).timeout
	GlobalVars.playing = 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



func _on_hurt_box_component_area_entered(area):
	if area.get_parent() is Enemy:
		animated_sprite_2d.play("death")
		GlobalVars.playing = 0
		await get_tree().create_timer(1.5).timeout
		animation_player.play("Fadeout")
		await get_tree().create_timer(1.0).timeout
		replay.visible = true
	else:
		GlobalVars.pontos += 1
		area.get_parent().queue_free()
		if GlobalVars.pontos >= GlobalVars.meta:
			print("carta enviada")
			GlobalVars.highscore += GlobalVars.pontos
			GlobalVars.playing = 0
			animation_player.play("Coração")
			await get_tree().create_timer(3.0).timeout
			animation_player.play("Fadeout")
			await get_tree().create_timer(2.0).timeout
			get_tree().change_scene_to_file("res://scenes/jogo_2.tscn")

