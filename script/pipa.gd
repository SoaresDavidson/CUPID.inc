extends Enemy

func _ready():
	move_component.velocity.x = -GlobalVars.speed_background * dificuldade
