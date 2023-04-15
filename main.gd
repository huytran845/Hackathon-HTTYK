extends Control

@onready var menuInstance = load("res://scenes/menu.tscn")
@onready var titleInstance = preload("res://scenes/title_screen.tscn")
@onready var saveFile = SaveGame.gameData #From the auto load, this lets us reference the script we setup in main

var inBattle = false
var soundSave = 100
var musicSave = 100
var save = {
	soundSave = soundSave,
	musicSave = musicSave
}

func _ready():
	var titleScene = titleInstance.instantiate()
	$CanvasLayer.add_child(titleScene)
	titleScene.set_name("titleScene")
	
func _process(delta):
	if Input.is_action_pressed("escape") and inBattle == false:
		var menuScene = menuInstance.instantiate()
		add_child(menuScene)

func loadLevel1():
	var level1Instance = preload("res://scenes/level_1.tscn")
	var level1Scene = level1Instance.instantiate()
	$CanvasLayer.add_child(level1Scene)
	$CanvasLayer/titleScene.queue_free()


func _on_button_pressed():
	saveFile.pHealth += 1
	SaveGame.saveData()
	
func _physics_process(_delta):
	print(saveFile.pHealth)
