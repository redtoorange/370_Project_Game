extends Node2D

export var PIXEL_DIST = 64
export var numScenes = 4

onready var global = get_node("/root/Global")

export(NodePath) var scoreLabelPath
var scoreLabel

export(PackedScene) var redBalloon
export(PackedScene) var blueBalloon
export(PackedScene) var greenBalloon
export(PackedScene) var blackBalloon

export(PackedScene) var textScene

export(PackedScene) var explosion

export var marginLeft = 10
export var marginRight = 10
export var marginTop = 10
export var marginBottom = 10

export var maxScale = .5
export var minScale = .1

var current
var windowSize
var currentRect

var targetVisible = false
var time = 0.0
var misses = 0

var balloonNumber = 1
var balloonID = -1
var playing = true

var focusPosition
var targetsAlreadyHit = []

func _ready():
	global.getNewID()
	
	windowSize = get_viewport().size
	
	#Find the central location
	focusPosition = windowSize / 2
	
	balloonID = generateTarget()
	
	scoreLabel = get_node(scoreLabelPath)
	scoreLabel.clearScore()

func _process(delta):
	if targetVisible:
		time += delta

func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			mouseClicked(event.position)
	elif event is InputEventScreenTouch:
		screenTouched(event.position)

func mouseClicked(clickPosition):
	if !playing:
		return
	var distance = clickPosition.distance_to(current.position)
	
	var t = textScene.instance()
	t.position = current.position
	add_child(t)
	
	if currentRect.has_point( clickPosition ):
		t.play("Hit!")
		
		var e = explosion.instance()
		add_child(e)
		e.position = current.position
		e.scale = current.get_node("Balloon Sprite").scale * 2
		e.play()
		current.queue_free()
		targetVisible = false
		
		scoreLabel.addScore(int(100 * (10/(distance+1))))
		
		uploadTargetHit(balloonID, time, misses, balloonNumber)
		
		balloonNumber += 1
		if balloonNumber > global.targetCount:
			endGame()
		else:
			misses = 0
			time = 0.0
			balloonID = generateTarget()
	else:
		t.play("Miss!")
		misses += 1

func makeBalloon(spawnPos, sz):
	#Generate a new Balloon
	var i = randi() % numScenes
	
	if i == 0:
		current = redBalloon.instance()
	elif i == 1:
		current = blueBalloon.instance()
	elif i == 2:
		current = blackBalloon.instance()
	else:
		current = greenBalloon.instance()
	
	print("Target Number: ", balloonNumber)
	
	current.position = spawnPos
	add_child(current)
	
	var node = current.get_node("Balloon Sprite")
	#var s = rand_range(minScale, maxScale)
	
	var size = node.texture.get_size()
	node.scale.x = sz.x / size.x
	node.scale.y = sz.y / size.y
	
	focusPosition = current.position
	var pos = current.position
	pos.x -= sz.x/2
	pos.y -= sz.y/2
	currentRect = Rect2(pos, sz)
	targetVisible = true

func uploadTargetHit( num, time, miss, total):
	global.uploadTargetHit(num, time, miss, total)

func endGame():
	playing  = false
	get_parent().get_node("RoundCompletePanel").show()
	global.uploadScore( scoreLabel.currentScore )

func _on_PlayAgain_pressed():
	global.getNewID()
	
	#create a new row in the database
	scoreLabel.clearScore()
	get_parent().get_node("RoundCompletePanel").hide()
	balloonNumber = 1
	targetsAlreadyHit = []
	focusPosition = windowSize / 2
	targetVisible = false
	
	misses = 0
	time = 0.0
	balloonID = generateTarget()
	playing  = true




func generateTarget():
	var valid = false
	var targetNum
	var attempts = 0
	
	while !valid and attempts < 100:
		targetNum = generateUniqueNumber()
		
		# Convert the raw target data into real data
		var direction = directionToVector(global.targets[targetNum].direction)
		var size = float(global.targets[targetNum].size)
		var distance = int(global.targets[targetNum].distance)
		
		var pos = focusPosition + (direction * (distance-1) * PIXEL_DIST)
		var rectSize = size * Vector2(PIXEL_DIST, PIXEL_DIST)
		
		var testRect = Rect2(pos, rectSize)
		
		valid = get_viewport_rect().encloses(testRect)
		if valid:
			#spawn the balloon
			makeBalloon(pos, rectSize)
		else:
			#Sentry to avoid infinite looping
			attempts += 1
			if attempts > 10:
				focusPosition = windowSize / 2
	
	if !valid && attempts >= 100:
		print("Failed to place target")
		print( targetsAlreadyHit )
	
	global.targets[targetNum].printData()
	targetsAlreadyHit.append(targetNum)
	return targetNum


func directionToVector( dir ):
	if dir == "NE":
		return Vector2(1, -1)
	elif dir == "NW":
		return Vector2(-1, -1)
	elif dir == "SE":
		return Vector2(1, 1)
	elif dir == "SW":
		return Vector2(-1, 1)


# generate an ID that hasn't been used yet
func generateUniqueNumber():
	var numberValid = false
	var targetNum = -1
	
	while !numberValid:
		#generate random
		targetNum = (randi() % global.targetCount + 1) - 1 
		
		#check if it's already been used
		if targetsAlreadyHit.has(targetNum):
			#already used, regenerate
			numberValid = false
		else:
			#new number, good to use
			numberValid = true
	
	return targetNum
