extends TextureRect

@export var menu_parent_path : NodePath
@export var cursorOffSet : Vector2
@onready var menuParent := get_node(menu_parent_path)
var isVisible = false
var cursorIndex = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var input := Vector2.ZERO
	if Input.is_action_just_pressed("ui_up"):
		input.y -= 1
	if Input.is_action_just_pressed("ui_down"):
		input.y += 1
	if Input.is_action_just_pressed("ui_left"):
		input.x -= 1
	if Input.is_action_just_pressed("ui_right"):
		input.x += 1
	if isVisible:
		set_cursor_from_index(cursorIndex + input.x + input.y * menuParent.columns)

func set_cursor_from_index(index : int):
	var menuItem := get_menu_item_at_index(index)
	if menuItem == null:
		return
	
	var position = menuItem.global_position
	
	global_position = Vector2(position.x,position.y)

func get_menu_item_at_index(index : int) -> Control:
	if menuParent == null:
		return null
	
	if index >= menuParent.get_child_count() or index < 0:
		return null
	return menuParent.get_child(index) as Control
