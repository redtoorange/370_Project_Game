#	Code Produced as part of a project for Dr. Joe Chase
#	Radford University: ITEC370
#	Date: 	April 22nd, 2018
#	By: 	Andrew McGuiness, Ryan Kelley, Andrew Albanese, Michael Hall
#	All rights are reserved by the above entities.
#
#	Purpose: When the game begins, a JSON file is downloaded and imported
#	into the game.  That file contains the data needed to spawn targets
#	for the player to click.  Each target is unique and will have a
#	separate object created for it.  This class represents a single target
#	and it's corresponding data.

var index
var direction
var distance
var size

# Create a new target based on the JSON data passed in
func _init( i, dir, dis, sz):
	index = i
	direction = dir
	distance = dis
	size = sz

# Debug function to print the target's data that was read from the file
func printData():
	print("Target: ", index, " ", direction, " ", distance, " ", size)
