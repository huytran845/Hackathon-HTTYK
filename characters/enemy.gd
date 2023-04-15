extends CharacterBody2D

var isPlayer = false
@onready var spriteImage = $Sprite2D
@onready var stateTimer = $stateTimer
@onready var tomatoscene = load("res://tomato.gd")
@onready var battleInstance = load("res://scenes/battle_screen.tscn")
@export var skills = []
@export var eHealth = 0.0
@export var eEnergy = 0.0
@export var eAtk = 0.0
@export var eDef = 0.0
@export var eSpeed = 0.0
@export var eLuck = 0.0
@export var level = 0.0
@export var moveSpeed = 0.0
@export var skillsChance = 0.0
@export var character = ""
@export var timerWaitTime = 0.0
@export var enemyNum = 1
var player
var move_direction : Vector2 = Vector2.ZERO
enum enemyState {Idle,Walk,Chase,Freeze}
var currentState : enemyState = enemyState.Idle
var Enemy 

func setUp(character):
	spriteImage.texture = load("res://images/" + str(character) + "/.png")
	var enemyInstance = load("res://objects/" + character + ".gd")
	Enemy = enemyInstance.new()
	Enemy.load_stats()
	matchStats()

func matchStats():
	eHealth = Enemy.eHealth
	eEnergy = Enemy.eEnergy
	eAtk = Enemy.eAtk
	eDef = Enemy.eDef
	eSpeed = Enemy.eSpeed
	eLuck = Enemy.eLuck
	timerWaitTime = Enemy.timerWaitTime
	skillsChance = Enemy.skillsChance

func _physics_process(delta):
	if player and currentState == enemyState.Chase:
		velocity = position.direction_to(player.position)*(moveSpeed)*2
		move_and_slide()
	elif currentState == enemyState.Walk:
		velocity = move_direction*moveSpeed
		move_and_slide()
	elif currentState == enemyState.Freeze:
		velocity = Vector2(0,0)*0

func select_new_direction():
	randomize()
	move_direction = Vector2(
		randi_range(-1,1),
		randi_range(-1,1)
	)
	if (move_direction.x <0):
		spriteImage.flip_h = true
	elif move_direction.x > 0:
		spriteImage.flip_h = false

func pick_new_state():
	if currentState == enemyState.Idle:
		currentState = enemyState.Walk
		select_new_direction()
		stateTimer.wait_time = 5 
		stateTimer.start()
		stateTimer.one_shot = true
	elif currentState == enemyState.Walk:
		currentState = enemyState.Idle
		stateTimer.wait_time = 5 
		stateTimer.start()
		stateTimer.one_shot = true


func _on_chase_area_body_entered(body):
	if body.isPlayer == true:
		player = body
		currentState = enemyState.Chase


func _on_chase_area_body_exited(body):
	if body.isPlayer == true:
		player = null
		currentState = enemyState.Freeze
		velocity = Vector2(0,0)
		


func _on_state_timer_timeout():
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
	if body.isPlayer == true:
		get_parent().battleStart(enemyNum)

