extends CharacterBody2D

var isPlayer = false
@onready var spriteImage = $Sprite2D
@onready var stateTimer = $stateTimer
@onready var battleInstance = load("res://scenes/battle_screen.tscn")
@export var skills = []
@export var eName = "Dragonion"
@export var eHealth = 0.0
@export var eEnergy = 0.0
@export var eAtk = 0.0
@export var eDef = 0.0
@export var eSpeed = 0.0
@export var eLuck = 0.0
@export var level = 0.0
@export var moveSpeed = 0.0
@export var skillsChance = 0.0
@export var character = "onion"
@export var timerWaitTime = 0.0
@export var enemyNum : int
var canMove = true
var eNums = 2
var player
var move_direction : Vector2 = Vector2.ZERO
enum enemyState {Idle,Walk,Chase,Freeze}
var currentState : enemyState = enemyState.Idle
var Enemy 
var battlingPlayer = false

func _ready():
	
	if character == "onion":
		eName = "Dragonion"
	elif character == "tomato":
		eName = "Tomaturtle"
	elif character == "pepper":
		eName == "Ghost Pepper"
	#The character is exported and then loads the proper sprite 
	#This should load the file == to res://images/onionBatte.png if the character set was onion
	
	spriteImage.texture = load("res://images/" + str(character) + "Battle.png")
	#This calls on the class which contains all the enemy's stats and skills, as well as special behavior like skill use frequency
	var enemyInstance = load("res://objects/" + character + ".gd")
	Enemy = enemyInstance.new()
	#Depending on the enemy, different stats will load depending on their difficulty
	Enemy.load_stats()
	#Matches stats to this script's equvalent
	matchStats()
	#Choose whether to idle or walk
	pick_new_state()

func matchStats():
	#Matches the stats from this script to the one loaded above in the enemy class
	eName = Enemy.eName
	eHealth = Enemy.eHealth
	eEnergy = Enemy.eEnergy
	eAtk = Enemy.eAtk
	eDef = Enemy.eDef
	eSpeed = Enemy.eSpeed
	eLuck = Enemy.eLuck
	skills = Enemy.skills
	print(skills)
	timerWaitTime = Enemy.timerWaitTime
	skillsChance = Enemy.skillsChance

func _physics_process(_delta):
	#Freeze takes priority over everything. Happens when player enters battle or 3 seconds after a battle ended
	if currentState == enemyState.Freeze or get_parent().get_parent().get_parent().canMove == false:
		velocity = Vector2(0,0)*0
		$enterBattle/CollisionShape2D.disabled = true
		#Otherwise, if enemy sees player, give chase
		if battlingPlayer and get_parent().get_parent().get_parent().playerVictory == 2:
			self.queue_free()
	elif player and currentState == enemyState.Chase:
		velocity = position.direction_to(player.position)*(moveSpeed)*2
		move_and_slide()
		$enterBattle/CollisionShape2D.disabled = false
	elif currentState == enemyState.Walk:
		velocity = move_direction*moveSpeed
		move_and_slide()
		$enterBattle/CollisionShape2D.disabled = false
	else: #Idle animation
		pass
		

#Selects a new direction to walk in
func select_new_direction():
	randomize()
	#Select new direction
	move_direction = Vector2(
		randi_range(-1,1),
		randi_range(-1,1)
	)
	if (move_direction.x <0):
		spriteImage.flip_h = true
	elif move_direction.x > 0:
		spriteImage.flip_h = false

func pick_new_state():
	#Select new state
	if currentState == enemyState.Idle:
		currentState = enemyState.Walk
		select_new_direction()
		stateTimer.wait_time = timerWaitTime
		stateTimer.start()
		stateTimer.one_shot = true
	elif currentState == enemyState.Walk:
		currentState = enemyState.Idle
		stateTimer.wait_time = 5 
		stateTimer.start()
		stateTimer.one_shot = true


func _on_chase_area_body_entered(body):
	#If player enter radius to give chase, enemy gives chase.
	
	if body.isPlayer:
		player = body
		currentState = enemyState.Chase


func _on_chase_area_body_exited(body):
	#Stop giving chase as player exited chase radius
	if body.isPlayer:
		player = null
		currentState = enemyState.Freeze
		velocity = Vector2(0,0)
		


func _on_state_timer_timeout():
	#Determines how often enemy enters new state
	if currentState == enemyState.Walk:
		currentState = enemyState.Idle
		stateTimer.wait_time = timerWaitTime
		stateTimer.start()
		stateTimer.one_shot = true
	elif currentState == enemyState.Idle:
		currentState = enemyState.Walk
		select_new_direction()
		stateTimer.wait_time = timerWaitTime 
		stateTimer.start()
		stateTimer.one_shot = true


func _on_enter_battle_body_entered(body):
	#Player touched enemy and will battle
	if body.isPlayer == true:
		get_parent().get_parent().get_parent().playerVictory = 1
		battlingPlayer = true
		print("character = ", character, "skills = ", skills, " Enemy Number = ", enemyNum)
		get_parent().get_parent().get_parent().battleEnter(enemyNum)
		#Freezes all the other enemies
		

func _on_battle_screen_battle_ended():
	var unfreezeTimer = Timer.new()
	unfreezeTimer.wait_time = 1
	unfreezeTimer.autostart = false
	unfreezeTimer.start()
	unfreezeTimer.timeout.connect("unfreezeTimer",[unfreezeTimer])
	currentState = enemyState.Idle

func unfreeze(unfreezeTimer):
	#Removes the timer that was created. Happens after a battle finished and turn enemies to idle after being frozen
	unfreezeTimer.queue_free()
	currentState = enemyState.Idle
	$stateTimer.start()


func _on_level_1_battle_entered():
	#Battle enters. Should freeze enemy player came in contact with in place while battle takes place
	$stateTimer.stop()
	currentState = enemyState.Freeze
