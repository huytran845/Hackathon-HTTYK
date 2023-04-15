extends Control

var mainScene

func _ready():
	mainScene = get_tree().get_root().get_node("Main")

func _on_credits_butt_pressed():
	mainScene.loadLevel1()


func _on_continue_butt_pressed():
	pass # Replace with function body.


func _on_new_game_butt_pressed():
	pass # Replace with function body.
