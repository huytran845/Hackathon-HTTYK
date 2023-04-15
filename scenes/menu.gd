extends Control


func _on_exit_game_pressed():
	get_tree().quit()

func _on_exit_menu_pressed():
	self.queue_free()
