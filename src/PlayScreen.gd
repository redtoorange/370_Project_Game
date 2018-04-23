#	Code Produced as part of a project for Dr. Joe Chase
#	Radford University: ITEC370
#	Date: 	April 22nd, 2018
#	By: 	Andrew McGuiness, Ryan Kelley, Andrew Albanese, Michael Hall
#	All rights are reserved by the above entities.
#
#	Purpose: The purpose of this script is to handle the quit buttons
#	being pressed and setting up the theme for the round.  Most of the
#	game logic is handled by the two controllers.

extends Node

onready var global = get_node("/root/Global")

# When the rounds starts, set the background and the UI based on the theme
func _ready():
	$RoundCompletePanel.theme = global.currentTheme
	$background.texture = global.currentBackground

# Handle the exit button being pressed
func _on_Button_pressed():
	get_tree().change_scene("res://screens/Start Screen.tscn")