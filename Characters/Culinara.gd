extends CharacterBody2D

# @export lets you see it in the inspector
@export var moveSpeed : float = 300
@export var startingDirection : Vector2 = Vector2(0,1)
@export var pHealth : float = 100
@export var pEnergy : float = 100
@export var pAtk : float = 50
@export var pDef : float = 10
@export var pLuck : float = 4
@export var pSpeed : float = 4
var isPlayer = true
var canMove = true

# When script starts we'll get access to this node in scene
@onready var animationTree = $AnimationTree #Stores reference to animation tree object
@onready var stateMachine = animationTree.get("parameters/playback") # Initializing thing that will let use change between states

func _ready():
	updateCharacterAnimation(startingDirection)

# Runs a certain number of times per second (Useful for objects that need physics)
func _physics_process(_delta): # Underscore on the variable means it's unused
	#Delta is the physics processing value of the main loop
	if canMove == true:
		var inputDirection = Vector2(
			#Positive value means that right is being inputted, and negative value means left is inputted
			Input.get_action_strength("right") - Input.get_action_strength("left"), # For x axis movement
			
			#Positive value is for downwards movement, and negative value is for upwards movement
			Input.get_action_strength("down") - Input.get_action_strength("up") # For y axis movement
		)
		
		updateCharacterAnimation(inputDirection)
	
	#Updating Velocity
		velocity = inputDirection * moveSpeed
	
	#Uses velocity to move the character around
		move_and_slide()
	
		#After movement is starts, we change their animation
		pickNewState()
	
	
func updateCharacterAnimation(moveInput : Vector2):
	#Won't change animation if there's no move input
	if (moveInput != Vector2.ZERO):
		animationTree.set("parameters/Walk/blend_position", moveInput)
		animationTree.set("parameters/Idle/blend_position", moveInput)


#Choose state based on what the player is doing
func pickNewState():
	#Animation won't change if no input is detected
	if (velocity != Vector2.ZERO): #If input found, start walk animation
		stateMachine.travel("Walk")
	else:
		stateMachine.travel("Idle")

func _unhandled_input(event: InputEvent):
	if event.is_action_pressed("ui_cancel"):
		$PauseMenu.pause()
