class_name Player
extends Node2D
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var move_component = $MoveComponent
@onready var input_component = $InputComponent
@onready var replay = $"../Replay"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



func _on_hurt_box_component_area_entered(area):
	if area.get_parent() is Enemy:
		animated_sprite_2d.play("death")
		GlobalVars.playing = 0
		await get_tree().create_timer(1.5).timeout
		replay.visible = true
	else:
		GlobalVars.pontos += 1
		area.get_parent().queue_free()
