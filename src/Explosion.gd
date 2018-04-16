extends Sprite

export var frames = 63
export var duration = 1.0
var time = 0.0

func _process(delta):
	time += delta
	if time > duration / frames:
		time -= duration / frames
		frame += 1
	
	if frame == frames:
		queue_free()
