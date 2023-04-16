extends Control


func _ready():
	$Button.disabled = true

func _on_animation_player_animation_finished(anim_name):
	$Button.disabled = false
	$Button.grab_focus()


func _on_button_pressed():
	get_tree().change_scene_to_file("res://scenes/level_1.tscn")
	self.queue_free()
