extends Node2D

onready var global = get_node("/root/Global")

export(PackedScene)var exposionScene

export(Resource)var spaceExp1
export(Resource)var spaceExp2
export(Resource)var spaceExp3
var spaceSounds = []

export(Resource)var carnivalExp1
export(Resource)var carnivalExp2
export(Resource)var carnivalExp3
var carnivalSounds = []

func _ready():
	prepSounds()
	selectSound()

func playSound():
	var e = exposionScene.instance()
	print(str("Playing: ", e.stream))
	e.stream = selectSound()
	add_child(e)
	e.playing = true

func prepSounds():
	spaceSounds.append(spaceExp1)
	spaceSounds.append(spaceExp2)
	spaceSounds.append(spaceExp3)
	
	carnivalSounds.append(carnivalExp1)
	carnivalSounds.append(carnivalExp2)
	carnivalSounds.append(carnivalExp3)

func selectSound():
	var i = randi() % 3
	
	if global.themeLabel == "Space":
		return spaceSounds[i]
	elif global.themeLabel == "Carnival":
		return carnivalSounds[i]