#	Code Produced as part of a project for Dr. Joe Chase
#	Radford University: ITEC370
#	Date: 	April 22nd, 2018
#	By: 	Andrew McGuiness, Ryan Kelley, Andrew Albanese, Michael Hall
#	All rights are reserved by the above entities.
#
#	Purpose:  The score label is the label in the lower left corner of the
#	screen that displays the user's score.  This script is designed to simplify
#	updating and getting the user's score.

extends Label

# The user's current score amount
var currentScore = 0

# When the Score Label is created, update it's text
func _ready():
	updateText()

# Increment the score displayed by amount
func addScore(amount):
	currentScore += amount
	updateText()

# Reset the score is display 0
func clearScore():
	currentScore = 0
	updateText()

# Change the text in the label
func updateText():
	text = str("Score: ", currentScore)