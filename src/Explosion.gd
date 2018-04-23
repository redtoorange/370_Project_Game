#	Code Produced as part of a project for Dr. Joe Chase
#	Radford University: ITEC370
#	Date: 	April 22nd, 2018
#	By: 	Andrew McGuiness, Ryan Kelley, Andrew Albanese, Michael Hall
#	All rights are reserved by the above entities.
#
#	Purpose: When the player clicks a target, an explosion animation is spawned
#	into the scene.  Once that animation has finished, the finished event
#	will be spawned.  This script handles that event by free the explosion
#	resources.

extends AnimatedSprite

# Respond to the animation's finished event by deleting the sprite
func _on_AnimatedSprite_animation_finished():
	queue_free()
