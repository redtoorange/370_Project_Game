extends Node2D

export var length = 1.0
var elapsed = 0.0

func _ready():
	pass

func _process(delta):
	elapsed += delta
	if elapsed >= length:
		queue_free()
	else:
		modulate.a = (1-(elapsed/length))

func play(what):
	$Label.text = what
	show()