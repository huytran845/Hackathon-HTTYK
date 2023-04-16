extends Camera2D

@onready var Player = get_parent()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.x = Player.position.x
	position.y = Player.position.x
