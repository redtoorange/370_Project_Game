#	Code Produced as part of a project for Dr. Joe Chase
#	Radford University: ITEC370
#	Date: 	April 22nd, 2018
#	By: 	Andrew McGuiness, Ryan Kelley, Andrew Albanese, Michael Hall
#	All rights are reserved by the above entities.
#
#	Purpose: When a target is destroyed, a sound player is spawned into the scene.
#	This sound player immediately plays it sound, once finished it will create 
#	a finished event.  This script is designed to handle that event by free
#	the sound player resources.

extends AudioStreamPlayer2D

# Respond to the sound's finished event by deleting the sound player
func _on_ExplosionSound_finished():
	queue_free()
