extends AnimatableBody2D
@onready var game = $".."

@onready var animationchegando = $Animationchegando
@onready var carta = $"../carta"
signal personalidade
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if game.tem_carta == false and game.carta_chegando == false:
		animationchegando.play("chegando")


func _on_button_pressed():
	animationchegando.play("RESET")
	carta.visible = true
	game.tem_carta = true
	emit_signal("personalidade")
	
