extends Node2D

#Duration of the animation
export var length = 1.0

#How much of the animation that has played
var elapsed = 0.0

# Update the animation time each frame
func _process(delta):
	elapsed += delta

	#once the animation has finished, free the asset
	if elapsed >= length:
		queue_free()
	else:
		modulate.a = (1-(elapsed/length))

# Play the animation
func play(what):
	$Label.text = what
	show()