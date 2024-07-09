extends Node2D
@onready var texto = $"."



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



func _on_carta_chegando_personalidade():
	texto.visible = false
