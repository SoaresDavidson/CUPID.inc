extends Node

@onready var veneno = $texto2/Veneno
@onready var texto_2 = $texto2
@onready var carta_chegando = $Carta_chegando
@onready var carta_saindo = $Carta_saindo
@onready var animation_player = $AnimationPlayer
@onready var texto = $texto
@onready var remetente = $texto/remetente
@onready var destinatario = $texto/destinatario
var alcance:int
signal personalidade

func _ready():
	GlobalVars.load_score()
	$MetaDoDia/Pontos.text ="R$" + str(GlobalVars.scoreatual)
	alcance = GlobalVars.botão_pressionado
	print(alcance)
	print(GlobalVars.botão_pressionado)
	if alcance >= 4:
		alcance = 4
	GlobalVars.dificuldade = 1
	GlobalVars.pontos = 0
	GlobalVars.meta = 5
	await get_tree().create_timer(2.0).timeout
	animation_player.play("chegando")
	MenuMusic.get_child(2).play()
	await get_tree().create_timer(1.0).timeout
	$"botãocartachegando".show()

func printar_personalidade(person: Array, label):
	for i in person:
		label.text += i+"\n"

func _on_botãocartachegando_pressed():
	$"botãocartachegando".hide()
	animation_player.play("RESET")
	if GlobalVars.cartasnegadas != 0:
		var sorteio = randi_range(0, 2)
		if sorteio == 1:
			cartadeodio()
			return
	texto.visible = true
	MenuMusic.get_child(1).play()
	
	
	person_remetente.clear()
	person_destinatario.clear()
	
	random_person(person_remetente)
	random_person(person_destinatario)
	
	var destinatario_grupo = []
	var remetente_grupo = []
	
	for i in range(alcance):#esse range seria a quantidade de caracteristicas
		destinatario_grupo.append(grupo(person_destinatario[i]))
		remetente_grupo.append(grupo(person_remetente[i]))
	
	for i in range(alcance): #mesmo do de cima
		if destinatario_grupo[i] not in remetente_grupo:
			GlobalVars.dificuldade += 1
		
	GlobalVars.meta *= GlobalVars.dificuldade 
	
	remetente.text= "Eu sou:\n"
	printar_personalidade(person_remetente,remetente)#+"\n"+str(person_remetente[1])+"\n"+str(person_remetente[2])+"\n"+str(person_remetente[3])+"\n"
	destinatario.text = "Meu amor é:\n"#+"\n"+str(person_destinatario[1])+"\n"+str(person_destinatario[2])+"\n"+str(person_destinatario[3])+"\n"
	printar_personalidade(person_destinatario,destinatario)
var person = [
	["Sociável","Extrovertido","Falante", "Tagarela"],#person[0]
	["Imaginativo","Original","Criativo"],#person[1]
	["Confiável","Leal","Responsável"],#person[2]
	["Persistente","Ambicioso","Obstinado"],#person[3]
	["Carinhoso","Atencioso","Amoroso","Fofo"],
	["Alegre","Energético","Animado"],
	["Tímido","Introvertido","Calado","Quieto"],
	["Nerd","Estudioso","Lolzeiro","Geek"]
]


var person_remetente = []

var person_destinatario = []

func grupo(element): #procura o grupo do elemento no alcance de person
	for i in person.size():
		if element in person[i]:
			return i

func random_person(person_carta: Array):
	for i in range(alcance):
		var escolha = randi() % person.size()
		var sub_escolha = randi() % person[escolha].size()
		while person[escolha][sub_escolha] in person_carta:
			escolha = randi() % person.size()
			sub_escolha = randi() % person[escolha].size()
		person_carta.append(person[escolha][sub_escolha])

func _on_botãoaceitar_pressed():
	GlobalVars.botão_pressionado += 1
	texto.visible = false
	MenuMusic.get_child(1).play()
	animation_player.play("saindo")
	carta_saindo.play("aceita")
	MenuMusic.get_child(2).play()
	await get_tree().create_timer(1.0).timeout
	$AnimationPlayer.play("Fadeout")
	await get_tree().create_timer(2.5).timeout
	MenuMusic.get_child(4).stop()
	get_tree().change_scene_to_file("res://scenes/space_shooter.tscn")

func _on_botãonegar_pressed():
	GlobalVars.cartasnegadas += 1
	texto.visible = false
	MenuMusic.get_child(1).play()
	GlobalVars.scoreatual -= 5 
	if GlobalVars.scoreatual <= 0:
		GlobalVars.scoreatual = 0
	animation_player.play("saindo")
	MenuMusic.get_child(2).play()
	await get_tree().create_timer(1.0).timeout
	_ready()

func cartadeodio():
	MenuMusic.get_child(4).stop()
	MenuMusic.get_child(1).play()
	var chances = ["Seu imbecil! Porquê você recusou minha carta? Eu e ela éramos feito um para o outro... ",
	"Seu @!#$#!, QUEM TU PENSA QUE É SEU !#@#@!@$ VAI A !#@#!#",
	"VOCÊ ESTRAGOU MINHA VIDA, EU VOU TE PEGAR SEU PALHAÇO!",
	"Extremamente improfissional. Te peço para realizar somente um serviço de envio simples, e você recusa? Nunca mais conte comigo."]
	var i = randi_range(0, chances.size()-1)
	veneno.text = chances[i]
	texto_2.visible = true
	

func _on_fechar_pressed():
	MenuMusic.get_child(4).play()
	GlobalVars.cartasnegadas -= 1
	texto_2.visible = false
	MenuMusic.get_child(1).play()
	await get_tree().create_timer(1.0).timeout
	_ready()
