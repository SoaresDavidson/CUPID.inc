extends Node

@onready var carta_chegando = $Carta_chegando
@onready var carta_saindo = $Carta_saindo
@onready var animation_player = $AnimationPlayer
@onready var texto = $texto
@onready var remetente = $texto/remetente
@onready var destinatario = $texto/destinatario

signal personalidade

func _ready():
	GlobalVars.dificuldade = 1
	GlobalVars.pontos = 0
	GlobalVars.meta = 5
	await get_tree().create_timer(2.0).timeout
	animation_player.play("chegando")

func _on_botãocartachegando_pressed():
	animation_player.play("RESET")
	texto.visible = true
	
	person_remetente.clear()
	person_destinatario.clear()
	
	random_person(person_remetente)
	random_person(person_destinatario)
	
	var destinatario_grupo = []
	var remetente_grupo = []
	
	for i in range(4):#esse range seria a quantidade de caracteristicas
		destinatario_grupo.append(grupo(person_destinatario[i]))
		remetente_grupo.append(grupo(person_remetente[i]))
	
	for i in range(4): #mesmo do de cima
		if destinatario_grupo[i] not in remetente_grupo:
			GlobalVars.dificuldade += 1
		
	GlobalVars.meta *= GlobalVars.dificuldade 
	
	remetente.text= "eu sou:\n"+str(person_remetente[0])+"\n"+str(person_remetente[1])+"\n"+str(person_remetente[2])+"\n"+str(person_remetente[3])+"\n"
	destinatario.text = "meu amor e:\n"+str(person_destinatario[0])+"\n"+str(person_destinatario[1])+"\n"+str(person_destinatario[2])+"\n"+str(person_destinatario[3])+"\n"

var person = [
	["a","B","c","d"],#person[0]
	[4,5,6,7],#person[1]
	[8,9,10,11],#person[2]
	[12,13,14,15]#person[3]
]


var person_remetente = []

var person_destinatario = []

func grupo(element): #procura o grupo do elemento no alcance de person
	for i in person.size():
		if element in person[i]:
			return i
		

func random_person(person_carta: Array):
	for i in range(4):#esse range uma hora tem que ser substituido pela quant de traços
		var escolha = randi() % person.size()
		var sub_escolha = randi() % person[escolha].size()
		
		while person[escolha][sub_escolha] in person_carta: #equanto tiver numero repetido vai rerolar os traços
			escolha = randi() % person.size()
			sub_escolha = randi() % person[escolha].size()
			
		person_carta.append(person[escolha][sub_escolha])

func _on_botãoaceitar_pressed():
	texto.visible = false
	animation_player.play("saindo")
	carta_saindo.play("aceita")
	await get_tree().create_timer(1.0).timeout
	get_tree().change_scene_to_file("res://scenes/space_shooter.tscn")

func _on_botãonegar_pressed():
	texto.visible = false
	animation_player.play("saindo")
	await get_tree().create_timer(1.0).timeout
	get_tree().change_scene_to_file("res://scenes/jogo_2.tscn")
