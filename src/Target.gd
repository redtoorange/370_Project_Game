extends Node2D

onready var global = get_node("/root/Global")

#Texture to use for the carnival theme
export(Texture) var carnivalTex

#Texture to use for the space theme
export(Texture) var spaceTex

#When the target loads, the theme is used to determine which texture to use
func _ready():
	if global.themeLabel == "Space":
		$TargetSprite.texture = spaceTex
	else:
		$TargetSprite.texture = carnivalTex