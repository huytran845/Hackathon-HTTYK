extends Control

var isPlayerIn = false
var mainScene

func _ready():
	mainScene = get_tree().get_root().get_node("Main")

func _process(delta):
	if Input.is_action_pressed("ui_accept") and isPlayerIn:
		mainScene.saveGame()


func _on_body_entered(body):
	isPlayerIn = true


func _on_body_exited(body):
	isPlayerIn = false
