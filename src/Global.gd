#	Code Produced as part of a project for Dr. Joe Chase
#	Radford University: ITEC370
#	Date: 	April 22nd, 2018
#	By: 	Andrew McGuiness, Ryan Kelley, Andrew Albanese, Michael Hall
#	All rights are reserved by the above entities.
#
#	Purpose: The global script is loaded before the engine actually fully loads.  It
#	can be accessed from all scripts and acts as a singleton.  This script is used to
#	handle all Database connections and it manages all data/state that must last outside
#	of a single scene.

extends Node

# Where to look for the target data at
var address = "http://localhost:8080/"

# Target Class file
var TargetData = preload("res://src/TargetData.gd")

# Initialize the theme to Carnival by default
var themeLabel = "Carnival"
var availableThemes

# Preload the theme files
var currentTheme = preload("res://themes/CarnivalTheme.tres")
var currentBackground = preload("res://assets/carnivalBG.jpg")

# User's DB ID
var id = -1

# Is this a JS environment
var jsEnv = false

# Targets that were loaded in
var targets = []

# Number of targets hit so far
var targetCount = 0

# Is the target file done being parsed?
var targetsParsed = false

# User's Highest Score in all rounds
var highestScore = 0

# Data that the user supplied before the game was loaded
var input
var age
var skill

# Run when the game first loads, populate some variables and the theme
func _ready():
	# Is the game being loaded in a browser?
	if OS.get_name() == "HTML5":
		# Yes, so we can use JS
		jsEnv = true
		
		# Load in the user's input from the previous page
		input = JavaScript.eval("input")
		age = JavaScript.eval("age")
		skill = JavaScript.eval("skill")
		address = JavaScript.eval("server")

		# Pull the available theme from PHP into JS and then into the game
		availableThemes = JavaScript.eval("theme")

		# Set the theme based on what is allowed
		if availableThemes != "Both":
			themeLabel = availableThemes	
			
		if themeLabel == "Carnival":
			currentTheme = preload("res://themes/CarnivalTheme.tres")
			currentBackground = preload("res://assets/carnivalBG.jpg")

		elif themeLabel == "Space":
			currentTheme = preload("res://themes/SpaceTheme.tres")
			currentBackground = preload("res://assets/spaceBG.jpg")
	else:
		# No, so just use default everything
		availableThemes = "Both"


# When a target is hit and needs to be pushed to the DB
func uploadTargetHit(number, time, miss, total):
	if jsEnv && number != null && time != null && miss != null && total != null:
		# If the user doesn't have an ID yet, get one
		if id == -1:
			id = int(JavaScript.eval("getID()"))
		
		# If the User has an ID, use it to upload the data
		if id > -1:
			JavaScript.eval(str("uploadTargetHit(", id, ",", number, ",", time, ",", miss, ", ", total ,")"))

# When the score changes and needs to be pushed to the DB
func uploadScore(score):
	if jsEnv && score != null:
		# If the user doesn't have an ID yet, get one
		if id == -1:
			id = int(JavaScript.eval("getID()"))
		
		# If the User has an ID, use it to upload the data
		if id > -1:
			JavaScript.eval(str("uploadScore(", id, ",", score, ")"))
			checkHighestScore(score)


# Parse the target file that is loaded at runtime
func parseTargetData( text ):
	# Parse the text into a JSON Array
	var p = JSON.parse(text)
	
	var targetRaw = p.get_result()
	
	# Parse each JSON Object into a Target Object
	targetCount = targetRaw.size()
	for i in range(0, targetRaw.size()):
		var t = TargetData.new( targetRaw[i]["ID"], targetRaw[i]["DIR"], targetRaw[i]["DIST"], targetRaw[i]["SIZE"])
		targets.append(t)

# Called when the HTTP Client downloads the target fata file
func parseTargets( result ):
	# parse the targets
	parseTargetData( result )
	targetsParsed = true

# Create a new DB row and get a new ID for that row
func getNewID():
	if jsEnv:
		id = -1
		var q = str("generateID(\"", themeLabel, "\")")
		JavaScript.eval(q)

# Check that the high score variable is still the highest score
func checkHighestScore(score):
	highestScore = max(score, highestScore)
