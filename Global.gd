extends Node

var TargetData = preload("res://TargetData.gd")

var themeLabel = "Carnival"

var currentTheme = preload("res://CarnivalTheme.tres")
var currentBackground = preload("res://assets/carnivalBG.jpg")

var id = -1
var jsEnv = false
var targets = []
var targetCount = 0
var targetsParsed = false
var thread = Thread.new()


func _ready():
	if OS.get_name() == "HTML5":
		jsEnv = true
		
		#Send call to make a new ID
		#getNewID()

func uploadTargetHit(number, time, miss, total):
	if jsEnv && number != null && time != null && miss != null && total != null:
		if id == -1:
			id = int(JavaScript.eval("getID()"))
		
		if id > -1:
			print("uploadTargetHit(", id, ",", number, ",", time, ",", miss, ", ", total, ")")
			JavaScript.eval(str("uploadTargetHit(", id, ",", number, ",", time, ",", miss, ", ", total ,")"))

func uploadScore(score):
	if jsEnv && score != null:
		if id == -1:
			id = int(JavaScript.eval("getID()"))
		
		if id > -1:
			print("uploadScore(", id, ",", score, ")")
			JavaScript.eval(str("uploadScore(", id, ",", score, ")"))

func parseTargetData( text ):
	var p = JSON.parse(text)
	
	var targetRaw = p.get_result()
	#file.close()
	
	targetCount = targetRaw.size()
	for i in range(0, targetRaw.size()):
		var t = TargetData.new( targetRaw[i]["ID"], targetRaw[i]["DIR"], targetRaw[i]["DIST"], targetRaw[i]["SIZE"])
		targets.append(t)

func parseTargets( result ):
	parseTargetData( result)
	targetsParsed = true

func getNewID():
	if jsEnv:
		id = -1
		JavaScript.eval("generateID()")
