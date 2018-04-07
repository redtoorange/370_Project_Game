extends Control

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	$HTTPRequest.request("http://localhost:8080/db_connect/highscores.php")

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