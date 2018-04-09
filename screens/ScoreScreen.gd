extends Control

onready var global = get_node("/root/Global")

func _ready():
	$"Score Panel".theme = global.currentTheme
	$background.texture = global.currentBackground
	
	$HTTPRequest.request( global.address + "db_connect/getHighscores.php")
	$HighestScore.text = str("Score: ", global.highestScore)

func _on_Button_pressed():
	get_tree().change_scene("res://screens/Start Screen.tscn")


func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	parseScores( body.get_string_from_utf8() )


func parseScores(text):
	var p = JSON.parse(text)
	var targetRaw = p.get_result()
	
	for i in range(0, targetRaw.size()):
		var n = get_node(str("Score Panel/VBoxContainer/Score_", (i+1)))
		n.text = str("Player ", (i+1), ": ", targetRaw[i]["score"])