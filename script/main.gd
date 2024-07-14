extends Node

@onready var carta_chegando = $Carta_chegando
@onready var carta_saindo = $Carta_saindo
@onready var animation_player = $AnimationPlayer
@onready var texto = $texto


var trabalhando = 0 #determina se está operando alguma carta no momento
var diaacabou = 0 #determina se o dia acabou
var errou = 0 #determina quantos erros ocorreram
var processosfeitos = 0 #determina o número de processos enviados, descartados não contam
var i = randi_range(7, 10) #determina o index das músicas da rádio
var invasivo:bool = false #se auma carta for invasiva isso se torna true
var alcance = 0
var combinam:bool = false
#name bank de nomes masculinos
var namebankM = ["Carlos","Cauê","Paulo","Felipe","Pedro","Gabriel","Manuel",
"Waldecy","Gilvan","João","Guilherme","Lucas","Davi","Luís","Jorge","Antônio",
"Marcelo","Marcio","Fernando","Jordão","Luciano","Cleber","Arthur","Alan"]

#name bank de nomes femininos
var namebankF = ["Lara","Beatriz","Maria","Marília","Marcia","Raquel","Luciana",
"Carla","Luísa","Luana","Clara","Laura","Giovanna","Júlia","Giulia","Ana","Gabriela",
"Fernanda","Amanda","Beatriz","Lia","Francisca","Cecília","Eduarda"]

#personalidades das cartas padrões
var personalidades = [["Alegre","Positivo"],["Tímido","Nerd"],["Geek","Lolzeiro"],["Bobo",
"Engraçado"],["Sensível","Emotivo"],["Romântico","Leitor"],["Criativo","Artista"],["Calmo",
"Pensativo"],["Calado","Falante"]]

var grupo_remetente = []

var grupo_destinatario = []


func _ready():
	MenuMusic.get_child(18).play()
	GlobalVars.scoreatual += 1 #toda vez que inicia o dia, é adicionado um dia no score atual
	if GlobalVars.scoreatual>GlobalVars.highscore:
			GlobalVars.save_hiscore()
	GlobalVars.load_score()
	$Pontos.text = str(GlobalVars.scoreatual) #projeção do score na parede
	await get_tree().create_timer(1.0).timeout
	MenuMusic.get_child(6).play()
	await get_tree().create_timer(2.6).timeout
	MenuMusic.get_child(i).play()
	gerarcarta()
	 

func gerarcarta():
	trabalhando = 0 #não está operando uma carta no momento
	if diaacabou == 1:
		dia_acabou() #faz com que o dia acabe de vez caso o tempo já tenha acabado
		return
	await get_tree().create_timer(1.0).timeout
	$Carta_chegando.play("normal")
	MenuMusic.get_child(5).play()
	await get_tree().create_timer(0.5).timeout
	if $Livro.visible: #acesso ao livro de instruções durante essa fase
		$"botãocartachegando".hide()
	else:
		$"botãocartachegando".show()

func dia_acabou():
	$Livro.hide()
	$Livrinho.hide()
	MenuMusic.get_child(i).stop()
	$AnimationPlayer.play("Fadeout")
	await get_tree().create_timer(2.0).timeout
	if errou == 0: #determina os finais baseado em erros e processos feitos
		if processosfeitos < 5:
			get_tree().change_scene_to_file("res://scenes/incompetente.tscn")
		else:
			get_tree().change_scene_to_file("res://scenes/transição.tscn")
			GlobalVars.dia += 1
	else:
		if processosfeitos < 5:
			get_tree().change_scene_to_file("res://scenes/incompetentefracasso.tscn")
		else:
			get_tree().change_scene_to_file("res://scenes/fracasso.tscn")

func _on_botãocartachegando_pressed():
	invasivo = false
	trabalhando = 1 #inicia o processo da carta
	combinam = false
	var j = randi_range(5,6)
	print(j)
	if j > 6: #dando maior chance de ocorrer uma carta padrão ao invés de um evento especial
		cartapadrão()
		if j % 2 == 0:
			%textinho.text += ". Se você acha que tenho chances, manda a carta."
		else:
			%textinho.text += ". Combina?"
	else: #chamando uma função especial
		evento(j)
		
	if grupo_remetente == grupo_destinatario:
		combinam = true
		print ("combinam")
	grupo_remetente.clear()
	grupo_destinatario.clear()
		
	$"botãoaceitar".hide()
	$"botãonegar".hide()
	$"botãocartachegando".hide()
	$Lixeira.hide()
	$Livrinho.hide()
	$Carta_chegando.play("nada")
	texto.visible = true #aparecer carta aberta na tela
	$Carta_mesa.play("normal")
	MenuMusic.get_child(1).play()
	

func _on_botãoaceitar_pressed():
	if invasivo or not combinam: #se for invasivo e for aceito,perde
		errou += 1
		print(errou)
	processosfeitos += 1 #aumenta o número de processos feitos
	$"botãoaceitar".hide()
	$"botãonegar".hide()
	$cartaReabrir.hide()
	$Lixeira.hide()
	$Livrinho.show()
	$Carta_mesa.play("nada")
	MenuMusic.get_child(15).play() #faz sons e animações
	$Carta_saindo.play("aceita")
	MenuMusic.get_child(2).play()
	await get_tree().create_timer(1.0).timeout
	MenuMusic.get_child(4).play()
	$Carta_saindo.play("nada")
	gerarcarta() #reinicia o loop do jogo

func _on_botãonegar_pressed():
	if combinam and not invasivo:
		errou += 1
		print(errou)
	
	processosfeitos += 1
	$"botãoaceitar".hide()
	$"botãonegar".hide()
	$cartaReabrir.hide()
	$Lixeira.hide()
	$Livrinho.show() #mesma coisa do de cima só que com a recusa da carta
	$Carta_mesa.play("nada")
	GlobalVars.cartasnegadas += 1
	MenuMusic.get_child(15).play()
	$Carta_saindo.play("recusada")
	MenuMusic.get_child(2).play()
	await get_tree().create_timer(1.0).timeout
	MenuMusic.get_child(4).play()
	$Carta_saindo.play("nada")
	gerarcarta()

func _on_fechar_pressed():
	$cartaReabrir.show()
	texto.visible = false
	$"botãoaceitar".show()
	$"botãonegar".show() #minimizar a carta quando aberta na tela
	$Lixeira.show()
	$Livrinho.show()
	MenuMusic.get_child(1).play()

func _on_timer_timeout(): #fim do tempo do dia
	print(processosfeitos)
	MenuMusic.get_child(i).stop()
	MenuMusic.get_child(16).play()
	diaacabou = 1

func _on_carta_reabrir_pressed(): #reabertura da carta depois de minimizada mas antes de processada
	$"botãoaceitar".hide()
	$"botãonegar".hide()
	$cartaReabrir.hide()
	$Lixeira.hide()
	$Livrinho.hide()
	texto.visible = true
	MenuMusic.get_child(1).play()

func _on_livrinho_pressed(): #abertura do livrinho de regras
	$"botãocartachegando".hide()
	$Livro.show()
	$"botãoaceitar".hide()
	$"botãonegar".hide()
	$cartaReabrir.hide()
	$Lixeira.hide()
	$Livrinho.hide()

func _on_lixeira_pressed(): #botar carta na lixeira
	$"botãoaceitar".hide()
	$"botãonegar".hide()
	$cartaReabrir.hide()
	$Lixeira.hide()
	$Livrinho.show()
	$Carta_mesa.play("nada")
	MenuMusic.get_child(19).play()
	$Carta_saindo.play("nada")
	gerarcarta()

func _on_fechar_livro_pressed(): #fechar livro de regras 
	$Livro.hide()
	if trabalhando == 0: #questão de organização só
		$"botãoaceitar".hide()
		$"botãocartachegando".show()
		$"botãonegar".hide()
		$cartaReabrir.hide()
		$Lixeira.hide()
		$Livrinho.show()
	else: #isso também
		$"botãoaceitar".show()
		$"botãonegar".show()
		$cartaReabrir.show()
		$Lixeira.show()
		$Livrinho.show()
		
		
func evento(j:int):
	if j == 6:
		stalker()
	elif j == 5:
		cartadeodio()
	elif j == 4:
		empresarival()
	elif j == 3:
		bomba()
	elif j == 2:
		cartadeseixo()
	elif j == 1:
		cartadetraicao()
	elif j == 0:
		cobrançachefe()
	
func cartapadrão():
	var w = randi_range(0,1)#
	var l = randi_range(0,1)#
	var x = randi_range(0,23)#index nome do remetente
	var y = randi_range(0,23)#index nome do par
	
	
	if w == 0:
		
		%remetente.text = "De: " + namebankM[x]
		%destinatario.text = "Para: " + namebankF[y]
		if l == 0:
			%textinho.text = "Eu sou " + random_person(grupo_remetente) + " e ela é " + random_person(grupo_destinatario)
		else:
			%textinho.text = "Eu adoro o jeitinho " + random_person(grupo_remetente) + " dela. Eu, pessoalmente, sou " + random_person(grupo_destinatario)
	else:
		%remetente.text = "De: " + namebankF[x]
		%destinatario.text = "Para: " + namebankM[y]
		if l == 0:
			%textinho.text = "Eu sou " + random_person(grupo_remetente) + " e ele é " + random_person(grupo_destinatario)
		else:
			%textinho.text = "Eu adoro o jeitinho " + random_person(grupo_remetente) + " dele. Eu, pessoalmente, sou " + random_person(grupo_destinatario) 


	
func empresarival():
	cartapadrão()

func cobrançachefe():
	cartapadrão()

func stalker():
	cartapadrão()
	var creepy = [
		". Sempre sou rejeitado mas dessa vez vai ser diferente",
		". Não vou aceitar um não como resposta",
		". Não vou desistir de nosso amor"
		
	]
	%textinho.text +=  creepy[randi_range(0, creepy.size()-1)]
	invasivo = true

func cartadeodio():
	if GlobalVars.cartasnegadas > 0:
		
		MenuMusic.get_child(i).stop()
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
		%remetente.text = " "
		%destinatario.text = " "
		var i = randi_range(0, chances.size()-1)
		%textinho.text = chances[i]
		texto.visible = true
	else:
		cartapadrão()
		if randi_range(0,1) == 0:
			%textinho.text += ". Se você acha que tenho chances, manda a carta."
		else:
			%textinho.text += ". Combina?"

func bomba():
	cartapadrão()

func cartadeseixo():
	cartapadrão()

func cartadetraicao():
	cartapadrão()




func random_person(grupo) -> String:
	#resumindante pega o array de arrays personalidade e pega um array e depois um elemento desse array
	var escolha = randi() % personalidades.size()
	var sub_escolha = randi() % personalidades[escolha].size()
	grupo.append(grupo(personalidades[escolha][sub_escolha]))
	return personalidades[escolha][sub_escolha]
		

func grupo(element): #checa o grupo da personalidade pra depois comparar 
	for i in personalidades:
		if element in i:
			return i
