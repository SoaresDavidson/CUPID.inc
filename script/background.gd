extends ParallaxBackground
@onready var parallax_layer = $ParallaxLayer
@export var dificuldade: float
var speed: float = Global.speed
@export var dia: int

func _process(delta):
	parallax_layer.motion_offset.x -= dificuldade * speed * delta * dia
