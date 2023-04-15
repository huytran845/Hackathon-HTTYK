extends Control

@onready var menuInstance = load("res://scenes/menu.tscn")
@onready var titleInstance = preload("res://scenes/title_screen.tscn")
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
	
	#player.toggle_inventory.connect(toggle_inventory_interface)
	#player_inventory.set_inventory_data(inventory_data)

func _process(delta):
	if Input.is_action_pressed("escape") and inBattle == false:
		var menuScene = menuInstance.instantiate()
		add_child(menuScene)

func loadLevel1():
	var level1Instance = preload("res://scenes/level_1.tscn")
	var level1Scene = level1Instance.instantiate()
	$CanvasLayer.add_child(level1Scene)
	$CanvasLayer/titleScene.queue_free()

func saveGame():
	pass
