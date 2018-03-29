extends Control


func _on_New_Game_pressed():
	get_tree().change_scene("res://screens/PlayScreen.tscn")


func _on_High_Scores_pressed():
	get_tree().change_scene("res://screens/ScoreScreen.tscn")
