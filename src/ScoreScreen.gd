extends Control

onready var global = get_node("/root/Global")

var filter = false

func _ready():
	$"Score Panel".theme = global.currentTheme
	$background.texture = global.currentBackground
	
	$HTTPRequest.request( global.address + "db_connect/getHighscores.php?skill=&age=&input=")
	$HighestScore.text = str("Score: ", global.highestScore)

func _on_Button_pressed():
	get_tree().change_scene("res://screens/Start Screen.tscn")


func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	parseScores( body.get_string_from_utf8() )

func clearScores():
	for i in range(1, 11):
		var n = get_node(str("Score Panel/VBoxContainer/Score_", i))
		print(i)
		n.text = ""

func parseScores(text):
	var p = JSON.parse(text)
	var targetRaw = p.get_result()
	
	clearScores()
	
	for i in range(0, targetRaw.size()):
		var n = get_node(str("Score Panel/VBoxContainer/Score_", (i+1)))
		n.text = str("Player ", (i+1), ": ", targetRaw[i]["score"])

func applyFilter():
	if !filter:
		filter = true
		var s = str("db_connect/getHighscores.php?skill=", global.skill, "&age=", global.age, "&input=", global.input)
		$HTTPRequest.request( global.address + s )
	else:
		filter = false
		$HTTPRequest.request( global.address + "db_connect/getHighscores.php?skill=&age=&input=")