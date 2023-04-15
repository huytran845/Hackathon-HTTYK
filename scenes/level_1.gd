extends Control

signal battleEntered
@onready var battleInstance = load("res://scenes/battle_screen.tscn")
@onready var Enemy1 = $CanvasLayer/TileMap/Enemy
@onready var Enemy2 = $CanvasLayer/TileMap/Enemy2
@onready var Enemy3 = $CanvasLayer/TileMap/Enemy3
@onready var Player = $CanvasLayer/TileMap/Culinara
var canMove = true
#0 - not battling, 1 battling, 2 victory, 3 is ran away
var playerVictory = 0

func _ready():
	pass

func battleEnter(eNums):
	#Stop all other enemies from moving. Not sure if it actually works tho
	canMove = false
	$CanvasLayer/AnimationPlayer.play("battleTransition") 
	emit_signal("battleEntered") #Emits to all other enemies to stop moving
	$CanvasLayer.layer = -2
	#In case the signal doesn't work, backup to prevent them from moving.
	if is_instance_valid(Enemy1):
		Enemy1.currentState = Enemy1.enemyState.Freeze
	#I don't know why, but the player can still move even after I set their process_input to false
	Player.set_process_input(false)
	if is_instance_valid(Enemy2):
		Enemy2.currentState = Enemy2.enemyState.Freeze
	if is_instance_valid(Enemy3):
		Enemy3.currentState = Enemy3.enemyState.Freeze



func battleStart(enemyNum): #Sends the stats to the battleScene. I don't know how to do this in a better way
	var battleScene = battleInstance.instantiate()
	$CanvasLayer/TileMap.add_child(battleScene)
	if enemyNum == 1: 
		print("E = 1")
		var enHealth = Enemy1.eHealth
		var enEnergy = Enemy1.eEnergy
		var enAtk = Enemy1.eAtk
		var enDef = Enemy1.eDef
		var enSpeed = Enemy1.eSpeed
		var enLuck = Enemy1.eLuck
		var enSkills = Enemy1.skills
		var enSkillChance = Enemy1.skillsChance
		var plHealth = Player.pHealth
		var plEnergy = Player.pEnergy
		var plAtk = Player.pAtk
		var plDef = Player.pDef
		var plSpeed = Player.pSpeed
		var plLuck = Player.pLuck 
		battleScene.battleSetup(enemyNum,plHealth,plEnergy,plAtk,plDef,plSpeed,plLuck,enHealth,enEnergy,enAtk,enDef,enSpeed,enLuck,enSkills,enSkillChance)
	elif enemyNum == 2:
		print("E = 2")
		var enHealth = Enemy2.eHealth
		var enEnergy = Enemy2.eEnergy
		var enAtk = Enemy2.eAtk
		var enDef = Enemy2.eDef
		var enSpeed = Enemy2.eSpeed
		var enLuck = Enemy2.eLuck
		var enSkills = Enemy2.skills
		var enSkillChance = Enemy2.skillsChance
		var plHealth = Player.pHealth
		var plEnergy = Player.pEnergy
		var plAtk = Player.pAtk
		var plDef = Player.pDef
		var plSpeed = Player.pSpeed
		var plLuck = Player.pLuck 
		battleScene.battleSetup(enemyNum,plHealth,plEnergy,plAtk,plDef,plSpeed,plLuck,enHealth,enEnergy,enAtk,enDef,enSpeed,enLuck,enSkills,enSkillChance)
	else:
		print("E = 3")
		var enHealth = Enemy3.eHealth
		var enEnergy = Enemy3.eEnergy
		var enAtk = Enemy3.eAtk
		var enDef = Enemy3.eDef
		var enSpeed = Enemy3.eSpeed
		var enLuck = Enemy3.eLuck
		var enSkills = Enemy3.skills
		var enSkillChance = Enemy3.skillsChance
		var plHealth = Player.pHealth
		var plEnergy = Player.pEnergy
		var plAtk = Player.pAtk
		var plDef = Player.pDef
		var plSpeed = Player.pSpeed
		var plLuck = Player.pLuck 
		battleScene.battleSetup(enemyNum,plHealth,plEnergy,plAtk,plDef,plSpeed,plLuck,enHealth,enEnergy,enAtk,enDef,enSpeed,enLuck,enSkills,enSkillChance)


func battleEnded(enemyNum): #EnemyNum is a unqiue exported variable which should identify which enemy to delete after a battle finishes assuming player victory
	canMove = true
	playerVictory = 2
	Player.set_process_input(true)
	if enemyNum == 1:
		$CanvasLayer/TileMap/Enemy.queue_free()
	elif enemyNum == 2:
		$CanvasLayer/TileMap/Enemy2.queue_free()
	elif enemyNum == 3:
		$CanvasLayer/TileMap/Enemy3.queue_free()
	$CanvasLayer.layer = 1
	


func _on_animation_player_animation_finished(anim_name):
	var enemyNum
	battleStart(enemyNum)
