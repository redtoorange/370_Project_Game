extends Node

func _ready():
	pass

func _on_Button_pressed():
	get_tree().change_scene("res://screens/Start Screen.tscn")

func _on_Quit_pressed():
	get_tree().change_scene("res://screens/Start Screen.tscn")