#	Code Produced as part of a project for Dr. Joe Chase
#	Radford University: ITEC370
#	Date: 	April 22nd, 2018
#	By: 	Andrew McGuiness, Ryan Kelley, Andrew Albanese, Michael Hall
#	All rights are reserved by the above entities.
#
# 	Purpose: The code in this file is designed to animate a set of text.  The text
#	will be displayed at a location determined by this class's parent.  The text
#	will fade away in "length" seconds.

extends Node2D

# Duration of the animation in seconds
export var length = 1.0

# How much of the animation that has played so far
var elapsed = 0.0

# Update the animation time each frame
func _process(delta):
	elapsed += delta
	
	# Once the animation has finished, free the asset
	if elapsed >= length:
		queue_free()
	# Increase the Text's alpha (transparency)
	else:
		modulate.a = (1-(elapsed/length))

# Play the animation with the text that was passed as an argument
func play(what):
	$Label.text = what
	show()