extends Label

var currentScore = 0

func _ready():
	updateText()

func addScore(amount):
	currentScore += amount
	updateText()

func clearScore():
	currentScore = 0
	updateText()

func updateText():
	text = str("Score: ", currentScore)