extends AnimatableBody2D
@onready var carta = $"."
@onready var texto = $"../texto"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_pressed():
	carta.get_node("AnimatedSprite2D").play("abri_carta")
	texto.visible = true
