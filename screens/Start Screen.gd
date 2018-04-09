extends Control

export(Resource) var carnivalTheme
export(Resource) var spaceTheme

export(Texture) var spaceBackground
export(Texture) var carnivalBackground

onready var global = get_node("/root/Global")


func _ready():
	if !global.targetsParsed:
		$HTTPRequest.request(global.address + "target_hunter/targetFile.json")
	
	$Panel.theme = global.currentTheme
	$background.texture = global.currentBackground

func _on_New_Game_pressed():
	if global.targetsParsed:
		get_tree().change_scene("res://screens/PlayScreen.tscn")
	else:
		print("Loading Targets")


func _on_High_Scores_pressed():
	get_tree().change_scene("res://screens/ScoreScreen.tscn")


func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	global.parseTargets( body.get_string_from_utf8() )


func _on_ChangeTheme_pressed():
	if global.themeLabel == "Carnival":
		global.themeLabel   = "Space"
		global.currentTheme = spaceTheme
		global.currentBackground = spaceBackground
	elif global.themeLabel == "Space":
		global.themeLabel   = "Carnival"
		global.currentTheme = carnivalTheme
		global.currentBackground = carnivalBackground
	
	$background.texture = global.currentBackground
	$Panel.theme = global.currentTheme
