extends Node

@onready var veneno = $Veneno
@onready var carta_chegando = $Carta_chegando
@onready var carta_saindo = $Carta_saindo
@onready var animation_player = $AnimationPlayer
@onready var texto = $texto
@onready var remetente = $texto/remetente
@onready var destinatario = $texto/destinatario
var diaacabou = 0
var errou = 0
var processosfeitos = 0
var i = randi_range(7, 10)
var alcance:int
var carta:bool = true
var evento_namoro = 0
@onready var timer_2 = $Timer2


func _ready():
	carta = true
	MenuMusic.get_child(18).play()
	GlobalVars.scoreatual += 1
	if GlobalVars.scoreatual>GlobalVars.highscore:
			GlobalVars.save_hiscore()
	GlobalVars.load_score()
	$Pontos.text = str(GlobalVars.scoreatual)
	alcance = GlobalVars.botão_pressionado
	print(alcance)
	print(GlobalVars.botão_pressionado)
	if alcance >= 4:
		alcance = 4
	await get_tree().create_timer(1.0).timeout
	MenuMusic.get_child(6).play()
	await get_tree().create_timer(2.6).timeout
	MenuMusic.get_child(i).play()
	gerarcarta()

func gerarcarta():
	if diaacabou == 1:
		dia_acabou()
		return
	await get_tree().create_timer(2.0).timeout
	$Carta_chegando.play("normal")
	MenuMusic.get_child(5).play()
	await get_tree().create_timer(0.5).timeout
	$"botãocartachegando".show()
	
	
	

func dia_acabou():
	MenuMusic.get_child(i).stop()
	$AnimationPlayer.play("Fadeout")
	await get_tree().create_timer(2.0).timeout
	
	if errou == 0:
		if processosfeitos < 10:
			get_tree().change_scene_to_file("res://scenes/incompetente.tscn")
		else:
			get_tree().change_scene_to_file("res://scenes/transição.tscn")
			GlobalVars.dia += 1
	else:
		if processosfeitos < 10:
			get_tree().change_scene_to_file("res://scenes/incompetentefracasso.tscn")
		else:
			get_tree().change_scene_to_file("res://scenes/fracasso.tscn")
			
func namoro():
	#esse evento usa o timer2 quando o timer acaba é hora do nome da carta normal ser substituido por um nome ja usado
	#pra dar sinal disso evento_namoro se torna 1 e quando na carta aparece o nome ja usado evento namoro se torna 2
	#se o jogador aprovar uma carta mas evento namoro é 2 então ele automaticamente erra
	namorado.append(nome_usado[randi_range(0, nome_usado.size()-1)])
	remetente.text = "Olá,me chamo " + namorado[-1] + "Estou lhe escrevendo pois enviei uma carta para sua empresa um tempo atrás,mas hoje estou comprometido
	por isso peço que caso receba minha carta recuse-a já que ja estou muito feliz no relacionamento que estou.\nDesde já agradeço a compreensão"
	destinatario.text = ""
	timer_2.start(randf_range(20, 40))


func printar_personalidade(person: Array, label:Label):
	#gera um nome aleatorio com os nomes e sobrenomes
	var nome_gerado = nome[randi_range(0, nome.size())-1] + " "+ sobrenome[randi_range(0, sobrenome.size()-1)] + "\n"
	while nome_gerado in nome_usado:
		nome_gerado = nome[randi_range(0, nome.size())-1] + " "+ sobrenome[randi_range(0, sobrenome.size()-1)] + "\n"
	nome_usado.append(nome_gerado)
	#o while impede que tenham nomes repetidos,checa se existe em nome_usado,array so de nomes usados
	#quando o evento namoro acontecer o nome do remetente vai ser substituido por um ja usado,o nome ja é tirado da lista de nomes de namorados
	#e recolocado na lista de nomes usados
	if evento_namoro:
		var nome = randi_range(0, namorado.size()-1)
		label.text += namorado[nome]
		nome_usado.append(nome)
		namorado.erase(nome)
		evento_namoro += 1
	else:
		label.text += nome_usado[-1]
		
	if person == person_destinatario:
		label.text += template_amor[randi_range(0, template_amor.size()-1)]
	else:
		label.text += template_remetente[randi_range(0, template_remetente.size()-1)]
	for i in person:
		label.text += i+"\n"

func _on_botãocartachegando_pressed():
	$"botãoaceitar".hide()
	$"botãonegar".hide()
	$"botãocartachegando".hide()
	$Carta_chegando.play("nada")
	
	#if GlobalVars.cartasnegadas != 0:
		#var sorteio = randi_range(0, 1)
		#if sorteio == 1:
			#cartadeodio()
			#return
		
	
	texto.visible = true
	$Carta_mesa.play("normal")
	MenuMusic.get_child(1).play()
	if processosfeitos == 1:
		namoro()
		return

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
			carta = false
		
	remetente.text = "Nome:"
	printar_personalidade(person_remetente,remetente)
	destinatario.text = "Nome do par: "
	printar_personalidade(person_destinatario,destinatario)
	destinatario.text += "\n" + template[randi_range(0, template.size()-1)]
	



var nome = [
	"Carlos","Cauã","Paulo","Felipe","Pedro","Gabriel","Lara","Beatriz","Manuel", 
	"Clotilde"
]

var sobrenome = [
	"da Silva","Pinkman","dos Santos","Silveira","Sousa","Soares","Matos","Oliveira" 
]

var template_remetente =[
	"Eu sou:\n","me considero:\n","meus amigos dizem que sou:\n","acredito que seja:\n"
	
]

var template_amor = [
	"meu amor é:\n","meu amado é\n","sempre quis alguém:\n"
]

var template = [
	"não sei como me aproximar dessa pessoa,me ajudem por favor","essa pessoa já me recusou muitas vezes vocês são minha ultima experança","vi essa pessoa poucas vezes mas sinto que foi amor a primeira vista",
	
]

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

var namorado = []

var nome_usado = []

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
	if not carta or evento_namoro == 2:
		errou += 1
	processosfeitos += 1
	$"botãoaceitar".hide()
	$"botãonegar".hide()
	$cartaReabrir.hide()
	$Carta_mesa.play("nada")
	GlobalVars.botão_pressionado += 1
	MenuMusic.get_child(15).play()
	$Carta_saindo.play("aceita")
	MenuMusic.get_child(2).play()
	await get_tree().create_timer(1.0).timeout
	MenuMusic.get_child(4).play()
	$Carta_saindo.play("nada")
	gerarcarta()

func _on_botãonegar_pressed():
	if carta:
		errou += 1
	processosfeitos += 1
	$"botãoaceitar".hide()
	$"botãonegar".hide()
	$cartaReabrir.hide()
	$Carta_mesa.play("nada")
	GlobalVars.cartasnegadas += 1
	MenuMusic.get_child(15).play()
	GlobalVars.scoreatual -= 5 
	if GlobalVars.scoreatual <= 0:
		GlobalVars.scoreatual = 0
	$Carta_saindo.play("recusada")
	MenuMusic.get_child(2).play()
	await get_tree().create_timer(1.0).timeout
	MenuMusic.get_child(4).play()
	$Carta_saindo.play("nada")
	gerarcarta()

func cartadeodio():
	MenuMusic.get_child(4).stop()
	MenuMusic.get_child(1).play()
	
	var chances = ["Seu imbecil! Porquê você recusou minha carta? Eu e ela éramos feito um para o outro... ",
	"Seu @!#$#!, QUEM TU PENSA QUE É SEU !#@#@!@$ VAI A !#@#!#",
	"VOCÊ ESTRAGOU MINHA VIDA, EU VOU TE PEGAR SEU PALHAÇO!",
	"Extremamente improfissional. É só um serviço de envio simples, e você recusa? Nunca mais conte comigo.",
	"Seu serviço é um lixo! Vou falar pra todo mundo que essa empresa não presta.",
	"Incompetente.",
	"Você acha que pode fazer o que quiser com as nossas vidas? Você me dá nojo.",
	"Gostava tanto dele... Agora tudo acabou.",
	"Você vai ser demitido, rapazinho! Vou falar com seu chefe, aí você vai ver...",
	"Nunca mais sigo recomendações do meu tio. Essa empresa é uma #@!#$."
	]
	
	var i = randi_range(0, chances.size()-1)
	veneno.text = chances[i]
	texto.visible = true
	

func _on_fechar_pressed():
	$cartaReabrir.show()
	GlobalVars.cartasnegadas -= 1
	texto.visible = false
	$"botãoaceitar".show()
	$"botãonegar".show()
	MenuMusic.get_child(1).play()

func _on_timer_timeout():
	print(processosfeitos)
	MenuMusic.get_child(i).stop()
	MenuMusic.get_child(16).play()
	diaacabou = 1

func _on_carta_reabrir_pressed():
	$"botãoaceitar".hide()
	$"botãonegar".hide()
	$cartaReabrir.hide()
	texto.visible = true
	MenuMusic.get_child(1).play()


func _on_timer_2_timeout():
	evento_namoro += 1
