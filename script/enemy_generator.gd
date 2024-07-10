class_name EnemyGenerator
extends Node2D

const PONTOS = preload("res://scenes/pontos.tscn")
const DRONE = preload("res://enemys_scenes/drone.tscn")
const POMBO = preload("res://enemys_scenes/pombo.tscn")
const PIPA = preload("res://enemys_scenes/pipa.tscn")

@onready var spawn_component = $SpawnComponent

@onready var pontos_timer = $PontosTimer
@onready var pombo_timer = $PomboTimer
@onready var drone_timer = $DroneTimer
@onready var pipa_timer = $PipaTimer

var dia = GlobalVars.dia
var dificuldade = GlobalVars.dificuldade

func _ready():
	
	if dificuldade >= 2:
		pombo_timer.process_mode = Node.PROCESS_MODE_INHERIT
	if dificuldade >= 3:
		drone_timer.process_mode = Node.PROCESS_MODE_INHERIT
	
	pombo_timer.timeout.connect(spawn_component.spawn.bind(POMBO, pombo_timer, 2.0))
	drone_timer.timeout.connect(spawn_component.spawn.bind(DRONE, drone_timer, 5.0))
	pipa_timer.timeout.connect(spawn_component.spawn.bind(PIPA, pipa_timer))
	pontos_timer.timeout.connect(spawn_component.spawn.bind(PONTOS, pontos_timer))

	
