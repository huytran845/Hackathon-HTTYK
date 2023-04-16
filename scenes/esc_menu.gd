extends ColorRect

@onready var animation : AnimationPlayer = $AnimationPlayer #References the animation object in that part
@onready var resumeButton : Button = find_child("ResumeButt")
@onready var quitButton :  Button = find_child("QuitButt")

func _ready():
	resumeButton.pressed.connect(unPause)
	quitButton.pressed.connect(get_tree().quit)

func unPause():
	animation.play("Unpause") #Plays the animation to unpause the game
	get_tree().paused = false #Any process node set to inherit will get unpaused

func pause():
	animation.play("Pause") #Plays the animation to pause the game
	get_tree().paused = true #Any process node set to inherit will get unpaused
