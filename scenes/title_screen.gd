extends Control

var mainScene
@onready var saveFile = SaveGame.gameData #From the auto load, this lets us reference the script we setup in main

func _ready():
	mainScene = get_tree().get_root().get_node("Main")

func _on_new_game_butt_pressed():
	mainScene.loadLevel1()


func _on_continue_butt_pressed():
	mainScene.loadLevel1()


func _on_credits_butt_pressed():
	saveFile.pHealth -= 1 
	print(saveFile.pHealth)
	SaveGame.saveData()
	print(saveFile.pHealth)
