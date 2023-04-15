extends Control

@onready var menuInstance = load("res://scenes/menu.tscn")
var inBattle = false
var soundSave = 100
var musicSave = 100
var save = {
	soundSave = soundSave,
	musicSave = musicSave
}

func _ready():
	pass # Replace with function body.

func _process(delta):
	if Input.is_action_pressed("escape") and inBattle == false:
		var menuScene = menuInstance.instiniate()
		add_child(menuScene)

func saveGame():
	pass
