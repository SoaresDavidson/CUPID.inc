extends Node

@onready var carta_chegando = $Carta_chegando
@onready var carta_saindo = $Carta_saindo
@onready var animation_player = $AnimationPlayer
@onready var texto = $texto

var traicao = 0 #quando alguem ta traindo,tem texto especial
var proposta=0 #identificar se ele recebeu proposta de outra empres
var cobranca=0 #identificar se o chefe cobrou algo
var meta = 10 
var trabalhando = 0 #determina se está operando alguma carta no momento
var diaacabou = 0 #determina se o dia acabou
var errou = 0 #determina quantos erros ocorreram
var processosfeitos = 0 #determina o número de processos enviados, descartados não contam
var i = randi_range(7, 14) #determina o index das músicas da rádio
var invasivo:bool = false #se auma carta for invasiva isso se torna true
var alcance = 0
var combinam:bool = false
var veneno:bool = false
#name bank de nomes masculinos
var namebankM = ["Carlos","Cauê","Paulo","Felipe","Pedro","Gabriel","Manuel",
"Waldecy","Gilvan","João","Guilherme","Lucas","Davi","Luís","Jorge","Antônio",
"Marcelo","Marcio","Fernando","Jordão","Luciano","Cleber","Arthur","Alan"]

#name bank de nomes femininos
var namebankF = ["Lara","Beatriz","Maria","Marília","Marcia","Raquel","Luciana",
"Carla","Luísa","Luana","Clara","Laura","Giovanna","Júlia","Giulia","Ana","Gabriela",
"Fernanda","Amanda","Beatriz","Lia","Francisca","Cecília","Eduarda"]

#personalidades das cartas padrões
var personalidades = [["happy","positive"],["shy","nerd"],["geek","gamer"],["silly",
"funny"],["sensitive","emotional"],["romantic","reader"],["creative","artistic"],["calm",
"thinking"],["silent","talkative"]]

var grupo_remetente = []

var grupo_destinatario = []


func _ready():
	GlobalVars.scoreatual += 1 #toda vez que inicia o dia, é adicionado um dia no score atual
	if GlobalVars.scoreatual>GlobalVars.highscore:
		GlobalVars.save_hiscore()
	GlobalVars.load_score()
	$Pontos.text = str(GlobalVars.scoreatual) #projeção do score na parede
	MenuMusic.get_child(18).play()
	if GlobalVars.scoreatual == 1:
		$Label.show()
		await get_tree().create_timer(30.0).timeout
		$Label.hide()
	else:
		$Label.hide()
		await get_tree().create_timer(2.0).timeout
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
	$"botãocartachegando".show()

func dia_acabou():
	$Livro.hide()
	$Livrinho.hide()
	MenuMusic.get_child(i).stop()
	$AnimationPlayer.play("Fadeout")
	await get_tree().create_timer(2.0).timeout
	if errou == 0: #determina os finais baseado em erros e processos feitos
		if processosfeitos < meta:
			get_tree().change_scene_to_file("res://scenes/incompetente.tscn")
		else:
			get_tree().change_scene_to_file("res://scenes/transição.tscn")
			GlobalVars.dia += 1
	else:
		if processosfeitos < meta:
			get_tree().change_scene_to_file("res://scenes/incompetentefracasso.tscn")
		else:
			get_tree().change_scene_to_file("res://scenes/fracasso.tscn")

func _on_botãocartachegando_pressed():
	invasivo = false
	veneno = false
	trabalhando = 1 #inicia o processo da carta
	combinam = false
	var j = randi_range(0,12 + GlobalVars.dia)
	if j < 6: #dando maior chance de ocorrer uma carta padrão ao invés de um evento especial
		cartapadrão()
		completa_cartapadrao()
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
	if (invasivo or not combinam) or veneno: #se for invasivo e for aceito,perde
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
	$Meta2.text= str(processosfeitos) +"/"+ str(meta)

func _on_botãonegar_pressed():
	if (combinam and not invasivo) or veneno:
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
	$Meta2.text= str(processosfeitos) +"/"+ str(meta)

func _on_fechar_pressed():
	$cartaReabrir.show()
	texto.visible = false
	$"botãoaceitar".show()
	$"botãonegar".show() #minimizar a carta quando aberta na tela
	$Lixeira.show()
	$Livrinho.show()
	MenuMusic.get_child(1).play()
	$Meta2.text= str(processosfeitos) +"/"+ str(meta)

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
	MenuMusic.get_child(20).play()
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
	$Meta2.text= str(processosfeitos) +"/"+ str(meta)

func _on_fechar_livro_pressed(): #fechar livro de regras 
	MenuMusic.get_child(21).play()
	$Livro.hide()
	if $"botãocartachegando".visible: #questão de organização só
		$"botãoaceitar".hide()
		$"botãocartachegando".show()
		$"botãonegar".hide()
		$cartaReabrir.hide()
		$Lixeira.hide()
		$Livrinho.show()
	else: #isso também
		if $Label.visible:
			$"botãoaceitar".hide()
			$"botãonegar".hide()
			$cartaReabrir.hide()
			$Lixeira.hide()
			$Livrinho.show()
		else:
			$"botãoaceitar".show()
			$"botãonegar".show()
			$cartaReabrir.show()
			$Lixeira.show()
			$Livrinho.show()

func evento(j:int):
	if j == 6:
		stalker()
	elif j == 7:
		cartadeodio()
	elif j == 8:
		empresarival()
	elif j == 9:
		bomba()
	elif j == 10:
		cartadeseixo()
	elif j == 11:
		cartadetraicao()
	elif j >= 12:
		cobrançachefe()
	
func cartapadrão():
	var w = randi_range(0, 1)#
	var l = randi_range(0, 1)#
	var x = randi_range(0, 23)#index nome do remetente
	var y = randi_range(0, 23)#index nome do par
	var z = randi_range(0, 1)
	if w == 0:
		%remetente.text = "From: " + namebankM[x]
		%destinatario.text = "To: " + namebankF[y]
		if l == 0:
			%textinho.text = "I'm " + random_person(grupo_remetente) + " and she is the " + sorteia(z) + " kind"
		else:
			%textinho.text = "I love her " + random_person(grupo_remetente) + " way. Personally, i'm " + sorteia(z)
	else:
		%remetente.text = "From: " + namebankF[x]
		%destinatario.text = "To: " + namebankM[y]
		if l == 0:
			%textinho.text = "I'm " + random_person(grupo_remetente) + " and he is the " + sorteia(z) + " kind"
		else:
			%textinho.text = "I love his " + random_person(grupo_remetente) + " way. Personally, i'm " + sorteia(z) 
	print(grupo_destinatario)

	
func empresarival():
	if GlobalVars.scoreatual > 1:
		%remetente.text = "From: SA INC." 
		%destinatario.text = "To: You"
		%textinho.text ="We want you with us! We're going to lower your quota!"
		meta -= 1
	else:
		cartapadrão()
		completa_cartapadrao()

func cobrançachefe():
	if GlobalVars.scoreatual > 1:
		%remetente.text = "From: Cupid" 
		%destinatario.text = "To: You"
		%textinho.text = "Since you're new around here, we'll be a little rougher. Stay on your toes!"
		meta += 1
	else:
		cartapadrão()
		completa_cartapadrao()

func stalker():
	cartapadrão()
	var creepy = [
		". They never wanted me, but this time it's different.",
		". I'm not taking 'no' for an answer.",
		". No matter how hard they try to stay away..."
	]
	%textinho.text +=  creepy[randi_range(0, creepy.size()-1)]
	invasivo = true

func cartadeodio():
	if GlobalVars.cartasnegadas > 0:
		MenuMusic.get_child(1).play()
		
		var chances = ["You idiot! Why didn't you send it? We were made for each other... ",
		"YOU RUINED MY LIFE I'M GOING TO GET YOU",
		"Your work is trash! I'm never recommending this place to anyone.",
		"Do you think you can do whatever you want with other's lives? You make me sick.",
		"I liked him so much... Now it's all over.",
		]
		%remetente.text = " "
		%destinatario.text = " "
		var i = randi_range(0, chances.size()-1)
		%textinho.text = chances[i]
		texto.visible = true
	else:
		cartapadrão()
		completa_cartapadrao()

func bomba():
	%remetente.text = "From: Unknown"
	%destinatario.text = "To: You"
	%textinho.text = "Do you know how to disarm a bomb?"

func cartadeseixo():
	var w = randi_range(0,1)#
	var x = randi_range(0,23)#index nome do remetente
	if w == 0:
		%remetente.text = "From: " + namebankM[x]
	else :
		%remetente.text = "From: " + namebankF[x]
	%destinatario.text = "To: "+ "Anyone"
	%textinho.text = "I just want someone, i can't spend another sunday night alone..."
	veneno = true

func cartadetraicao():
	var w = randi_range(0,1)#
	var l = randi_range(0,1)#
	var x = randi_range(0,23)#index nome do remetente
	var y = randi_range(0,23)#index nome do par
	
	
	if w == 0:
		
		%remetente.text = "From: " + namebankM[x]
		%destinatario.text = "To: " + namebankF[y]
		if l == 0:
			%textinho.text = "I know im married, but i can still mess around, right?"
		else:
			%textinho.text = "I know you don't mind cheating, right? That's why you're the best."
	else:
		%remetente.text = "From: " + namebankF[x]
		%destinatario.text = "To: " + namebankM[y]
		if l == 0:
			%textinho.text = "It's not cheating! Even though i do like messing around..."
		else:
			%textinho.text = "It's not cheating, they called me first! I'm not refusing."


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

func completa_cartapadrao():
	if randi_range(0,1) == 0:
		%textinho.text += ". Send this, please!"
	else:
		%textinho.text += ". Do we work out?"
		
func sorteia(z: int):
	if z == 0:
		return random_person(grupo_destinatario)
	else:
		print("deu certo")
		grupo_destinatario.append(grupo_remetente[0])
		return grupo_destinatario[0][randi_range(0, 1)]
