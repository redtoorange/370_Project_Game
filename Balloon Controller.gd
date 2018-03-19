extends Node2D

export var numScenes = 4

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

func _ready():
	windowSize = get_viewport().size
	makeBalloon()

func _process(delta):
	if targetVisible:
		time += delta

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			print("Click received...")
			mouseClicked(event.position)
	elif event is InputEventScreenTouch:
		print("Touch received...")
		screenTouched(event.position)



func mouseClicked(clickPosition):
	var distance = clickPosition.distance_to(current.position)
	
	print("Distance: ", distance, " pixels")
	print("Time: ", time, " seconds")
	
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
	else:
		t.play("Miss!")
	
	print(" ")
	
	targetVisible = false
	time = 0.0
	current.queue_free()
	makeBalloon()

func makeBalloon():
	#Generate a new Balloon
	var i = randi() % numScenes
	
	var x = rand_range( marginLeft,  windowSize.x - marginRight)
	var y = rand_range( marginTop,  windowSize.y - marginBottom)
	
	if i == 0:
		current = redBalloon.instance()
	elif i == 1:
		current = blueBalloon.instance()
	elif i == 2:
		current = blackBalloon.instance()
	else:
		current = greenBalloon.instance()
	
	current.position = Vector2(x, y)
	add_child(current)
	
	var node = current.get_node("Balloon Sprite")
	var s = rand_range(minScale, maxScale)
	
	var size = node.texture.get_size()
	node.scale.x = s
	node.scale.y = s
	
	size.x *= s
	size.y *= s
	
	var pos = current.position
	pos.x -= size.x/2
	pos.y -= size.y/2
	currentRect = Rect2(pos, size)
	targetVisible = true