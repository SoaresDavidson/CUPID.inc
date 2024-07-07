extends ParallaxBackground
@onready var score_label = $ScoreLabel
@onready var dificuldade_label = $DificuldadeLabel


@onready var parallax_layer = $ParallaxLayer
var speed: float = GlobalVars.speed_background
var dificuldade  = GlobalVars.dificuldade
var pontos = GlobalVars.pontos
func _ready():
	dificuldade_label.text = "dificuldade: " + str(dificuldade)
	
	
func _process(delta):
	#A velocidade do cenário é calculada a partir do dia e da dificuldade
	parallax_layer.motion_offset.x -= dificuldade * speed * delta * GlobalVars.playing
	score_label.text = "meta: " + str(GlobalVars.pontos) +"/" + str(GlobalVars.meta)

