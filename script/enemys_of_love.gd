class_name Enemy

extends Node2D
@onready var move_component = $MoveComponent


var dificuldade = GlobalVars.dificuldade * 2.5
var dia = GlobalVars.dia
# Called when the node enters the scene tree for the first time.
func _ready():
	#multiplica a velocidade dos inimigos pela velocidade
	move_component.velocity *= dificuldade 
	#decide uma direção vertical para inimigos(so afeta quem anda na vertical [drone])
	var direction = randi_range(-1, 1)
	while direction == 0:
		direction = randi_range(-1, 1)
	move_component.velocity.y *= direction

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()


func _on_hit_box_component_area_entered(area):
	pass
