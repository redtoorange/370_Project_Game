extends Panel

var jsEnv = false

func _ready():
	if OS.get_name() == "HTML5":
		jsEnv = true


func _on_upload_pressed():
	var id = $ID_Text.text
	var number = $Target_Text.text
	var time = $Time_Text.text
	var dist = $Dist_Text.text
	
	if jsEnv && number != null && time != null && dist != null:
		JavaScript.eval(str("uploadScore(", id, ",", number, ",", time, ",", dist, ")"))
	else:
		print("JavaScript not supported or a field is empty")