extends ParallaxBackground
@onready var score_label = $ScoreLabel
@onready var dificuldade_label = $DificuldadeLabel

@onready var nuvens = $Nuvens
@onready var predios_longe = $PrediosLonge
@onready var predios_perto = $PrediosPerto


var dificuldade  = GlobalVars.dificuldade 
var pontos = GlobalVars.pontos

func _ready():
	dificuldade_label.text = "dificuldade: " + str(dificuldade)
	
	
func _process(delta):
	#A velocidade do cenário é calculada a partir do dia e da dificuldade
	#nuvens.motion_offset.x -= dificuldade * speed * delta * GlobalVars.playing
	nuvens.motion_offset.x -=  2.5 * (GlobalVars.speed_background/2) * dificuldade * delta * GlobalVars.playing
	predios_longe.motion_offset.x -= 2.5 * (GlobalVars.speed_background/4) * dificuldade * delta * GlobalVars.playing
	predios_perto.motion_offset.x -= 2.5 * GlobalVars.speed_background * dificuldade * delta * GlobalVars.playing
	
	score_label.text = "meta: " + str(GlobalVars.pontos) +"/" + str(GlobalVars.meta)

