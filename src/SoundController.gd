#	Code Produced as part of a project for Dr. Joe Chase
#	Radford University: ITEC370
#	Date: 	April 22nd, 2018
#	By: 	Andrew McGuiness, Ryan Kelley, Andrew Albanese, Michael Hall
#	All rights are reserved by the above entities.
#
#	Purpose: When a target is destroyed, a sound is played using a sound 
#	player.  This script loads the sounds selected by the creator, and when
#	a target is destroyed, a sound is selected and played.  Which sound
#	is selected based on the current theme.

extends Node2D

onready var global = get_node("/root/Global")

# Sound player scene
export(PackedScene)var exposionScene

# Space Explosion sounds
export(Resource)var spaceExp1
export(Resource)var spaceExp2
export(Resource)var spaceExp3
var spaceSounds = []

# Carnival Explosion sounds
export(Resource)var carnivalExp1
export(Resource)var carnivalExp2
export(Resource)var carnivalExp3
var carnivalSounds = []

# Load the sounds
func _ready():
	prepSounds()

# Create a new sound player instance to play the sound
func playSound():
	# Spawn a sound player
	var e = exposionScene.instance()
	
	# Set the sound and play it
	e.stream = selectSound()
	add_child(e)
	e.playing = true

# Parse and load the sounds into memory
func prepSounds():
	spaceSounds.append(spaceExp1)
	spaceSounds.append(spaceExp2)
	spaceSounds.append(spaceExp3)
	
	carnivalSounds.append(carnivalExp1)
	carnivalSounds.append(carnivalExp2)
	carnivalSounds.append(carnivalExp3)

# Randomly select a sound to play
func selectSound():
	var i = randi() % 3
	
	if global.themeLabel == "Space":
		return spaceSounds[i]
	elif global.themeLabel == "Carnival":
		return carnivalSounds[i]