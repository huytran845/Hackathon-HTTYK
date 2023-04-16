extends Node2D

@onready var saveFile = SaveGame.gameData #Referencing a potential save that occurred

func _on_new_game_butt_pressed():
	get_tree().change_scene_to_file("res://scenes//level_1.tscn")

func _on_continue_butt_pressed():
	SaveGame.loadData()
	get_tree().change_scene_to_file("res://scenes//level_1.tscn")
	
func _on_credits_butt_pressed():
	pass
