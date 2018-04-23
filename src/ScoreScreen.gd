#	Code Produced as part of a project for Dr. Joe Chase
#	Radford University: ITEC370
#	Date: 	April 22nd, 2018
#	By: 	Andrew McGuiness, Ryan Kelley, Andrew Albanese, Michael Hall
#	All rights are reserved by the above entities.
#
#	Purpose:  This is the primary controller for the High Score Screen.
#	Scores are downloaded from the database and then parsed and 
#	displayed.  The user can toggle a filter that will limit which
#	scores are displayed.

extends Control

onready var global = get_node("/root/Global")

# Is the filter toggled on?
var filter = false

# Download the top 10 scores from the database
func _ready():
	# initialize the theme
	$"Score Panel".theme = global.currentTheme
	$background.texture = global.currentBackground
	
	# Download the scores
	$HTTPRequest.request( global.address + "db_connect/getHighscores.php?skill=&age=&input=")

	# Initialize all the labels
	$HighestScore.text = str("Score: ", global.highestScore)

# Handle the exit button being pressed
func _on_Button_pressed():
	get_tree().change_scene("res://screens/Start Screen.tscn")


# Once the scores have been downloaded, parse them
func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	parseScores( body.get_string_from_utf8() )

# Reset all scores labels to empty
func clearScores():
	for i in range(1, 11):
		var n = get_node(str("Score Panel/VBoxContainer/Score_", i))
		n.text = ""

# High Scores come in as a JSON file, parse that into the labels
func parseScores(text):
	# Convert the text into a JSON object
	var p = JSON.parse(text)
	var targetRaw = p.get_result()
	
	# Blank all labels
	clearScores()
	
	# Go through the JSON file and populate the score labels
	for i in range(0, targetRaw.size()):
		var n = get_node(str("Score Panel/VBoxContainer/Score_", (i+1)))
		n.text = str("Player ", (i+1), ": ", targetRaw[i]["score"])

# The user toggled the score filter
func applyFilter():
	# The filter was off, the user turned it on
	if !filter:
		# Change the button text
		$"Score Panel/FilterButton".text = "View All Scores"
		filter = true

		# Download the filtered scores
		var s = str("db_connect/getHighscores.php?skill=", global.skill, "&age=", global.age, "&input=", global.input)
		$HTTPRequest.request( global.address + s )
	
	# The filter was on, the user turned it off
	else:
		# Change the button text
		$"Score Panel/FilterButton".text = "View Group Scores"
		filter = false

		# Download the scores again
		$HTTPRequest.request( global.address + "db_connect/getHighscores.php?skill=&age=&input=")