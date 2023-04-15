extends Control

signal battleEntered
@onready var battleInstance = load("res://scenes/battle_screen.tscn")
@onready var Enemy1 = $CanvasLayer/TileMap/Enemy
@onready var Enemy2 = $CanvasLayer/TileMap/Enemy2
@onready var Enemy3 = $CanvasLayer/TileMap/Enemy3
@onready var Player = $CanvasLayer/TileMap/Culinara


func _ready():
	pass

func battleEnter(eNums):
	emit_signal("battleEntered")
	Enemy1.currentState = Enemy1.enemyState.Freeze
	
	Enemy2.currentState = Enemy2.enemyState.Freeze
	Enemy3.currentState = Enemy3.enemyState.Freeze

func battleStart(enemyNum):
	var battleScene = battleInstance.instantiate()
	$CanvasLayer/TileMap.add_child(battleScene)
	if enemyNum == 1: 
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
		battleScene.battleSetup(plHealth,plEnergy,plAtk,plDef,plSpeed,plLuck,enHealth,enEnergy,enAtk,enDef,enSpeed,enLuck,enSkills,enSkillChance)

func battleEnd(enemyNum):
	if enemyNum == 1:
		$CanvasLayer/TileMap/Enemy.queue_free()
	elif enemyNum == 2:
		$CanvasLayer/TileMap/Enemy2.queue_free()
	elif enemyNum == 3:
		$CanvasLayer/TileMap/Enemy3.queue_free()
	emit_signal("battleEnded")
