extends Node2D

func _ready():
	$Sprite2D.play("direita")
	$Direita.show()
	$Esquerda.hide()
	$Label.show()
	$Label2.show()
	$Label3.show()
	$Label4.hide()
	$Label5.hide()
	$"Coração".show()

func _on_direita_pressed():
	$Sprite2D.play("esquerda")
	$Direita.hide()
	$Esquerda.show()
	$Label.hide()
	$Label2.hide()
	$Label3.hide()
	$Label4.show()
	$Label5.show()
	$"Coração".hide()

func _on_esquerda_pressed():
	$Sprite2D.play("direita")
	$Direita.show()
	$Esquerda.hide()
	$Label.show()
	$Label2.show()
	$Label3.show()
	$Label4.hide()
	$Label5.hide()
	$"Coração".show()
