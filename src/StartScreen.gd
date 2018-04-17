extends Control

onready var global = get_node("/root/Global")

#Themes to use
export(Resource) var carnivalTheme
export(Resource) var spaceTheme

#Background to use
export(Texture) var spaceBackground
export(Texture) var carnivalBackground

#When the program loads, prep the theme and targets
func _ready():
	#Download and parse the target JSON file
	if !global.targetsParsed:
		$HTTPRequest.request(global.address + "target_hunter/targetFile.json")
	
	#Set the theme and background
	$Panel.theme = global.currentTheme
	$background.texture = global.currentBackground

#Start a new game for the user
func _on_New_Game_pressed():
	#Ensure the target parser is done, then change the scene
	if global.targetsParsed:
		get_tree().change_scene("res://screens/PlayScreen.tscn")

	#Target parser is not done, need to wait
	else:
		print("Loading Targets")

#Change to the high score scene
func _on_High_Scores_pressed():
	get_tree().change_scene("res://screens/ScoreScreen.tscn")

#When the target file is done downloading, parse it
func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	global.parseTargets( body.get_string_from_utf8() )


#Change the theme based on which is currently is
func _on_ChangeTheme_pressed():
	if global.availableThemes == "Both":
		#Switch to Space
		if global.themeLabel == "Carnival":
			global.themeLabel   = "Space"
			global.currentTheme = spaceTheme
			global.currentBackground = spaceBackground
		
		#Switch to Carnival
		elif global.themeLabel == "Space":
			global.themeLabel   = "Carnival"
			global.currentTheme = carnivalTheme
			global.currentBackground = carnivalBackground
		
		#Update the background and the UI to match the current theme
		$background.texture = global.currentBackground
		$Panel.theme = global.currentTheme
	else:
		print("Theme restricted by admin")


#Exit button was clicked, try to exit the game
func _on_Exit_pressed():
	#If we are in an HTML file, then call the javascript
	if global.jsEnv:
		JavaScript.eval("exit()", true)
	
	#Otherwise, just close the window
	else:
		get_tree().quit()
