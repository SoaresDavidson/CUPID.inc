extends Node

@onready var remetente = $texto/remetente
@onready var destinario = $texto/destinario


var tem_carta = false
var carta_chegando = false
var carta_saindo = false
var escolha = 0
var randperson=0

var person1=[0,1,2,3]

var person2=[4,5,6,7]

var person3=[8,9,10,11]

var person4=[12,13,14,15]

var person_remetente=[]

var person_destinatario=[]
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_carta_chegando_personalidade():
	
	for lista in range(4):
		escolha = randi() % 4
		if escolha==0:
			randperson = randi_range(0,3)
			person_remetente.append(person1[randperson])
		if escolha==1:
			randperson = randi_range(0,3)
			person_remetente.append(person2[randperson])
		if escolha==2:
			randperson = randi_range(0,3)
			person_remetente.append(person3[randperson])
		if escolha==3:
			randperson = randi_range(0,3)
			person_remetente.append(person4[randperson])
		
		

	escolha = 0
	randperson = 0
	for lista in range(4):
		escolha = randi_range(0, 3)
		if escolha==0:
			randperson = randi_range(0,3)
			person_destinatario.append(person1[randperson])
		if escolha==1:
			randperson = randi_range(0,3)
			person_destinatario.append(person2[randperson])
		if escolha==2:
			randperson = randi_range(0,3)
			person_destinatario.append(person3[randperson])
		if escolha==3:
			randperson = randi_range(0,3)
			person_destinatario.append(person4[randperson])
		
		
	escolha=0
	randperson=0
	
	remetente.text= "eu sou:\n"+str(person_remetente[0])+"\n"+str(person_remetente[1])+"\n"+str(person_remetente[2])+"\n"+str(person_remetente[3])+"\n"
	destinario.text = "meu amor e:\n"+str(person_destinatario[0])+"\n"+str(person_destinatario[1])+"\n"+str(person_destinatario[2])+"\n"+str(person_destinatario[3])+"\n"


