extends Control

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _on_New_Game_pressed():
	get_tree().change_scene("res://screens/PlayScreen.tscn")


func _on_High_Scores_pressed():
	get_tree().change_scene("res://screens/ScoreScreen.tscn")
