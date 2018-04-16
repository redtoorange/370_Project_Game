extends Node2D

onready var global = get_node("/root/Global")

#Pixel Dist is the constant used by all screens to scale the targets
export var PIXEL_DIST = 64
export var numScenes = 4

#Score handler
export(NodePath) var scoreLabelPath
var scoreLabel

#Scenes for the targets
export(PackedScene) var redBalloon
export(PackedScene) var blueBalloon
export(PackedScene) var greenBalloon
export(PackedScene) var blackBalloon

#Scenes for the text and explosion
export(PackedScene) var textScene
export(PackedScene) var explosion

#data for the current target
var current
var windowSize
var currentRect
var focusPosition

#data for the current round
var targetVisible = false
var time = 0.0
var misses = 0

#Track which target is displayed and when one is next
var balloonNumber = 1
var balloonID = -1
var playing = true

#Tracks which targets have already been hit
var targetsAlreadyHit = []

#Initialize the scene and begin the game
func _ready():
	global.getNewID()
	windowSize = get_viewport().size
	#Find the central location
	focusPosition = windowSize / 2
	balloonID = generateTarget()
	scoreLabel = get_node(scoreLabelPath)
	scoreLabel.clearScore()

#Update the target timer
func _process(delta):
	if targetVisible:
		time += delta

#When the user clicks/taps, handle the input
func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			mouseClicked(event.position)
	elif event is InputEventScreenTouch:
		screenTouched(event.position)

#Handle the click/touch event
func mouseClicked(clickPosition):
	if !playing:
		return
	var distance = clickPosition.distance_to(current.position)
	
	var t = textScene.instance()
	t.position = current.position
	add_child(t)
	
	#Test to see if the click is inside the target's bounds
	if currentRect.has_point( clickPosition ):
		t.play("Hit!")
		
		var e = explosion.instance()
		add_child(e)
		e.position = current.position
		e.scale = current.get_node("TargetSprite").scale * 2
		e.play()
		
		#Spawn and play a new sound
		get_parent().get_node("SoundController").playSound()
		
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
	
	#The user clicked outside of the bounds, so it was a miss
	else:
		t.play("Miss!")
		misses += 1

#Create a new target for the user
func makeBalloon(spawnPos, sz):
	#Generate random index
	var i = randi() % numScenes
	
	#Select the new target
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
	
	#Get a reference to the target
	var node = current.get_node("TargetSprite")
	
	#Scale the target
	var size = node.texture.get_size()
	node.scale.x = sz.x / size.x
	node.scale.y = sz.y / size.y
	
	#Move the target into position
	focusPosition = current.position
	var pos = current.position
	pos.x -= sz.x/2
	pos.y -= sz.y/2

	#Create a rect for the target's bounds checking
	currentRect = Rect2(pos, sz)
	targetVisible = true

#Send target data and score to the DB
func uploadTargetHit( num, time, miss, total):
	global.uploadTargetHit(num, time, miss, total)
	global.uploadScore( scoreLabel.currentScore )

#The player has hit the required number of targets, end the round
func endGame():
	playing  = false
	get_parent().get_node("RoundCompletePanel").show()
	global.uploadScore( scoreLabel.currentScore )


#Start a new round for the player
func _on_PlayAgain_pressed():
	#Generate a new row in the DB
	global.getNewID()
	
	#hide the modal
	get_parent().get_node("RoundCompletePanel").hide()

	#reset the round variables
	balloonNumber = 1
	targetsAlreadyHit = []
	focusPosition = windowSize / 2
	targetVisible = false
	scoreLabel.clearScore()
	misses = 0
	time = 0.0

	#Create a new balloon and display it
	balloonID = generateTarget()
	playing  = true


#Generate a new valid target
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


#Convert the plain text from the target into a vector direction
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
