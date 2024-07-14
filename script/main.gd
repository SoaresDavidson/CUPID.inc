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

#name bank de nomes masculinos
var namebankM = ["Carlos","Cauê","Paulo","Felipe","Pedro","Gabriel","Manuel",
"Waldecy","Gilvan","João","Guilherme","Lucas","Davi","Luís","Jorge","Antônio",
"Marcelo","Marcio","Fernando","Jordão","Luciano","Cleber","Arthur","Alan"]

#name bank de nomes femininos
var namebankF = ["Lara","Beatriz","Maria","Marília","Marcia","Raquel","Luciana",
"Carla","Luísa","Luana","Clara","Laura","Giovanna","Júlia","Giulia","Ana","Gabriela",
"Fernanda","Amanda","Beatriz","Lia","Francisca","Cecília","Eduarda"]

#personalidades das cartas padrões
var personalidades = ["Alegre","Positivo","Tímido","Geek","Nerd","Lolzeiro","Bobo",
"Engraçado","Sensível","Emotivo","Romântico","Leitor","Criativo","Artista","Calmo",
"Pensativo","Calado","Falante"]

#array de eventos randômicos possíveis
var eventos = [cartapadrão(),empresarival(),cobrançachefe(),stalker(),cartadeodio(),
bomba(),cartadeseixo(),cartadetraicao()]

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
	gerarcarta() #fazer com que a carta chegue na caixa

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

func _on_botãocartachegando_pressed():
	trabalhando = 1 #inicia o processo da carta
	var j = randi_range(0,14)
	if j > 6: #dando maior chance de ocorrer uma carta padrão ao invés de um evento especial
		cartapadrão()
	else: #chamando uma função especial
		eventos[j].call()
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
	GlobalVars.cartasnegadas -= 1
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

func cartapadrão():
	var w = randi_range(0,1)
	if w == 0:
		var l = randi_range(0,1)
		var x = randi_range(0,23)
		var y = randi_range(0,23)
		var z = randi_range(0,17)
		var v = randi_range(0,17)
		%remetente.text = "De: " + str(namebankM[x])
		%destinatario.text = "Para: " + str(namebankF[y])
		if l == 0:
			%textinho.text = "Eu sou " + str(personalidades[z]) + " e ela é " + str(personalidades[v]) + ". Se você acha que a gente tem chances, manda essa carta pra ela."
		else:
			%textinho.text = "Eu adoro o jeitinho " + str(personalidades[z]) + "dela. Eu, pessoalmente, sou " + str(personalidades[v]) + ". Combina?"
	else:
		var l = randi_range(0,1)
		var x = randi_range(0,23)
		var y = randi_range(0,23)
		var z = randi_range(0,17)
		var v = randi_range(0,17)
		%remetente.text = "De: " + str(namebankF[x])
		%destinatario.text = "Para: " + str(namebankM[y])
		if l == 0:
			%textinho.text = "Eu sou " + str(personalidades[z]) + " e ele é " + str(personalidades[v]) + ". Se você acha que a gente tem chances, manda essa carta pra ele."
		else:
			%textinho.text = "Eu adoro o jeitinho " + str(personalidades[z]) + "dele. Eu, pessoalmente, sou " + str(personalidades[v]) + ". Combina?"

func empresarival():
	pass

func cobrançachefe():
	pass

func stalker():
	pass

func cartadeodio():
	pass

func bomba():
	pass

func cartadeseixo():
	pass

func cartadetraicao():
	pass
