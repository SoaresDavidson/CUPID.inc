extends Node

var dia:float = 1 #os dois são float pra fazer divisão racional
var highscore = 0
var scoreatual = 0
var botão_pressionado = 2
var cartasnegadas = 0
var errou = 0
var processos_feitos = 0
const SAVEFILE= "user://save.data"

func save_hiscore():
	var file = FileAccess.open(SAVEFILE,FileAccess.WRITE)
	file.store_32(GlobalVars.scoreatual)
	
func load_score():
	var file = FileAccess.open(SAVEFILE,FileAccess.READ)
	if file != null:
		GlobalVars.highscore = file.get_32()
		
	else:
		GlobalVars.highscore = 0
		save_hiscore()
