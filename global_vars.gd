extends Node
var speed_enemy:float = -80 #velociodade dos inimigos
var speed_background:float = 100 #velocidade do paralax dando efeito de velocidade da carta
var playing:int = 1 #se for 1 o mundo se mexe quando o jogador morre vai ser setado pra 0 dando efeito de que a carta parou de voar
var pontos:int = 0 
var dia:float = 1 #os dois são float pra fazer divisão racional
var dificuldade:float = 9 + dia #valor provisorio pegar do papers please
var meta = 5*dificuldade
