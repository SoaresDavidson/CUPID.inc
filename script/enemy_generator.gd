class_name EnemyGenerator
extends Node2D

@export var placeholder: PackedScene

@onready var spawn_component = $SpawnComponent
@onready var placeholder_timer = $PlaceholderTimer

func _ready():
	placeholder_timer.timeout.connect(spawn_component.spawn.bind(placeholder))

	
