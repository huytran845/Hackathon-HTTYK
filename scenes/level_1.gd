extends Node2D

signal battleEntered
@onready var battleInstance = load("res://scenes/battle_screen.tscn")
@onready var Enemy1 = $CanvasLayer/TileMap/Enemy
@onready var Enemy2 = $CanvasLayer/TileMap/Enemy2
@onready var Enemy3 = $CanvasLayer/TileMap/Enemy3
@onready var Player = $CanvasLayer/Culinara
var eNum

var canMove = true
#0 - not battling, 1 battling, 2 victory, 3 is ran away
var playerVictory = 0

#func _ready():
#	print("Enemy 1 = ", $CanvasLayer/TileMap/Enemy.character, $CanvasLayer/TileMap/Enemy.enemyNum)
#	print("Enemy 2 = ", $CanvasLayer/TileMap/Enemy2.character, $CanvasLayer/TileMap/Enemy2.enemyNum)
#

func battleEnter(enemyNum):
	$AudioStreamPlayer2D.stop()
	#Stop all other enemies from moving. Not sure if it actually works tho
	eNum = enemyNum
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



func battleStart(): #Sends the stats to the battleScene. I don't know how to do this in a better way
	var battleScene = battleInstance.instantiate()
	$CanvasLayer/TileMap.add_child(battleScene)
	var plHealth = Player.pHealth
	var plEnergy = Player.pEnergy
	var plAtk = Player.pAtk
	var plDef = Player.pDef
	var plSpeed = Player.pSpeed
	var plLuck = Player.pLuck 
	if eNum == 1: 
		print("E = 1")
		var enName = Enemy1.eName
		var enHealth = Enemy1.eHealth
		var enEnergy = Enemy1.eEnergy
		var enAtk = Enemy1.eAtk
		var enDef = Enemy1.eDef
		var enSpeed = Enemy1.eSpeed
		var enLuck = Enemy1.eLuck
		var enSkills = Enemy1.skills
		var enSkillChance = Enemy1.skillsChance
		var enCharacter = Enemy1.character
		battleScene.battleSetup(enCharacter,enName,eNum,plHealth,plEnergy,plAtk,plDef,plSpeed,plLuck,enHealth,enEnergy,enAtk,enDef,enSpeed,enLuck,enSkills,enSkillChance)
	elif eNum == 2:
		print("E = 2")
		var enCharacter = Enemy2.character
		var enName = Enemy2.eName
		var enHealth = Enemy2.eHealth
		var enEnergy = Enemy2.eEnergy
		var enAtk = Enemy2.eAtk
		var enDef = Enemy2.eDef
		var enSpeed = Enemy2.eSpeed
		var enLuck = Enemy2.eLuck
		var enSkills = Enemy2.skills
		var enSkillChance = Enemy2.skillsChance
		battleScene.battleSetup(enCharacter,enName,eNum,plHealth,plEnergy,plAtk,plDef,plSpeed,plLuck,enHealth,enEnergy,enAtk,enDef,enSpeed,enLuck,enSkills,enSkillChance)
	else:
		print("E = 3")
		var enCharacter = Enemy3.character
		var enName = Enemy3.eName
		var enHealth = Enemy3.eHealth
		var enEnergy = Enemy3.eEnergy
		var enAtk = Enemy3.eAtk
		var enDef = Enemy3.eDef
		var enSpeed = Enemy3.eSpeed
		var enLuck = Enemy3.eLuck
		var enSkills = Enemy3.skills
		var enSkillChance = Enemy3.skillsChance
		battleScene.battleSetup(enCharacter,enName,eNum,plHealth,plEnergy,plAtk,plDef,plSpeed,plLuck,enHealth,enEnergy,enAtk,enDef,enSpeed,enLuck,enSkills,enSkillChance)


func battleEnded(enemyNum): #EnemyNum is a unqiue exported variable which should identify which enemy to delete after a battle finishes assuming player victory
	Player.canMove = true
	$AudioStreamPlayer2D.stream = load("res://images/Another_Face.mp3")
	$AudioStreamPlayer2D.play()
	
	Player.set_process_input(true)
	if enemyNum == 1 and playerVictory == 2:
		$CanvasLayer/TileMap/Enemy.queue_free()
	elif enemyNum == 2 and playerVictory == 2:
		$CanvasLayer/TileMap/Enemy2.queue_free()
	elif enemyNum == 3 and playerVictory == 2:
		$CanvasLayer/TileMap/Enemy3.queue_free()


func _on_animation_player_animation_finished(_anim_name):
	battleStart()

signal toggle_inventory()

#leaving it for a bit later
func _on_button_pressed():
	$inventory.visible = !$inventory.visible
	
#trying to test the toggle for inventory
#func _ready() -> void:
	#player.toggle_inventory.connect(toggle_inventory_interface)
	#inventory_interface.set_player_inventory_data(culinara.inventory)


func _on_audio_stream_player_2d_finished():
	$AudioStreamPlayer2D.stream = load("res://images/Another_Face.mp3")
	$AudioStreamPlayer2D.play()
