extends AudioStreamPlayer2D

func _on_ExplosionSound_finished():
	print(str("Done playing: ", stream))
	queue_free()
