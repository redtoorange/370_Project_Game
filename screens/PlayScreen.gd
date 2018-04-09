extends Node

onready var global = get_node("/root/Global")

func _ready():
	$RoundCompletePanel.theme = global.currentTheme
	$background.texture = global.currentBackground

func _on_Button_pressed():
	get_tree().change_scene("res://screens/Start Screen.tscn")

func _on_Quit_pressed():
	get_tree().change_scene("res://screens/Start Screen.tscn")