extends Node

var id = 5

var jsEnv = false


func _ready():
	if OS.get_name() == "HTML5":
		jsEnv = true
		id = int(JavaScript.eval("getID()"))
		print("Your id is: ", id)

func pushToDB(number, time, dist):
	if jsEnv && number != null && time != null && dist != null:
		print("uploadScore(", id, ",", number, ",", time, ",", dist, ")")
		JavaScript.eval(str("uploadScore(", id, ",", number, ",", time, ",", dist, ")"))
	else:
		print("JavaScript not supported or a field is empty")