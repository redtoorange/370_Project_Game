extends Control

onready var global = get_node("/root/Global")

func _ready():
	if !global.targetsParsed:
		$HTTPRequest.request("http://localhost:8080/target_hunter/targetFile.json")

func _on_New_Game_pressed():
	if global.targetsParsed:
		get_tree().change_scene("res://screens/PlayScreen.tscn")
	else:
		print("Loading Targets")


func _on_High_Scores_pressed():
	get_tree().change_scene("res://screens/ScoreScreen.tscn")


func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	global.parseTargets( body.get_string_from_utf8() )
