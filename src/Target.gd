extends Node2D

onready var global = get_node("/root/Global")

export(Texture) var carnivalTex
export(Texture) var spaceTex

func _ready():
	if global.themeLabel == "Space":
		$TargetSprite.texture = spaceTex
	else:
		$TargetSprite.texture = carnivalTex