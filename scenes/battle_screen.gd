extends Control

signal battleEnded
var pHealth
var pEnergy
var pAtk
var pDef
var pSpeed
var pLuck
var eHealth
var eEnergy
var eAtk
var eDef
var eSpeed
var eLuck
var eSkillChance
var eSkills
var turns = 0
var rounds = 0
var pBuffs = 1
var eBuffs = 1
var pAtkBuff = 1
var pDefBuff = 1
var pSpeedBuff = 1
var pLuckBuff = 1
var pEvasionBuff = 1
var pAccuracyBuff = 1
var eAtkBuff = 1
var eDefBuff = 1
var eSpeedBuff = 1
var eLuckBuff = 1
var eEvasionBuff = 1
var eAccuracyBuff = 1
var pStatus = 1
var eStatus = 1
var buttonPressed = "attack"
var battlers = 2

func battleSetup(plHealth,plEnergy,plAtk,plDef,plSpeed,plLuck,enHealth,enEnergy,enAtk,enDef,enSpeed,enLuck,enSkills,enSkillChance):
	pHealth = plHealth
	pEnergy = plEnergy
	pAtk = plAtk
	pDef = plDef
	pSpeed = plSpeed
	pLuck = plLuck
	eHealth = enHealth
	eEnergy = enEnergy
	eAtk = enAtk
	eDef = enDef
	eSpeed = enSpeed
	eLuck = enLuck
	eSkills = enSkills
	eSkillChance = enSkillChance
	if pSpeed >= eSpeed:
		playerTurn()
	elif eSpeed > pSpeed:
		enemyTurn()

func playerTurn():
	$playerUi/GridContainer/enemy.disabled = true
	$playerUi/GridContainer/enemy.set_process_input(false)
	turns += 1
	$textBox/textBox.visible = false
	$textBox/textBox.set_process_input(false)
	$playerUi/PlayerMenu/playerMenu.visible = true
	$playerUi/PlayerMenu/playerMenu.set_process_input(true)
	$fight.grab_focus()

func enemyTurn():
	turns += 1
	var useSkillChance = randf()
	var skillChoose = randi_range(0,eSkills.size())
	var skillName = eSkills[skillChoose]
	var skillScript = load("res://objects/" + str(skillName) + ".gd")
	var skillActive = skillScript.new()
	if useSkillChance >= eSkillChance and skillActive.energyCost() <= eEnergy:
		if skillActive.specialSkill():
			if skillActive.isDebuff() == true:
				if pBuffs > 0.4:
					
					pBuffs -= skillActive.useSkill(pHealth,pEnergy,pAtk,pDef,pSpeed,pLuck,eHealth,pBuffs,eEnergy,eAtk,eDef,eSpeed,eLuck,eBuffs)
			elif skillActive.isBuff() == true:
				eBuffs += skillActive.useSkill(pHealth,pEnergy,pAtk,pDef,pSpeed,pLuck,eHealth,pBuffs,eEnergy,eAtk,eDef,eSpeed,eLuck,eBuffs)
		else:
			var dmg = skillActive.useSkill(pHealth,pEnergy,pAtk,pDef,pSpeed,pLuck,eHealth,pBuffs,eEnergy,eAtk,eDef,eSpeed,eLuck,eBuffs)
			pHealth -= dmg - pDef
	else:
		var evadeChance = randf() + (pLuck/1000) - (eLuck/1000)
		if evadeChance >= 0.99:
			var critChance = randf() + (eLuck/1000) - (pLuck/1000)
			if critChance >= 0.95:
				var dmg = (((eAtk*eBuffs*eStatus)*1.5)*randf_range(0.8,1)-pDef)
				pHealth -= dmg
			var dmg = ((eAtk*eBuffs*eStatus)*randf_range(0.8,1)-pDef)
			pHealth -= dmg
	skillActive.queue_free()
	if pHealth <= 0:
		var gameOverInstance = load("res://scenes/game_over.tscn")
		var gameOverScene = gameOverInstance.instiniate()
		add_child(gameOverScene)
		gameOverScene.appear()
	else:
		if turns == battlers:
			turns = 0
			rounds += 1
			calculateTurnOrder()
		else: 
			playerTurn()


func _on_fight_pressed():
	buttonPressed = "attack"
	$playerUi/GridContainer/enemy.disabled = false
	$playerUi/GridContainer/enemy.set_process_input(true)
	$playerUi/GridContainer/enemy.grab_focus()

func _on_enemy_pressed():
	if buttonPressed == "attack":
		var evadeChance = randf() + (eLuck/1000) - (pLuck/1000)
		if evadeChance >= 0.99:
			var critChance = randf() + (pLuck/1000) - (eLuck/1000)
			if critChance >= 0.95:
				var dmg = (((pAtk*pBuffs*pStatus)*1.5)*randf_range(0.8,1)-eDef)
				eHealth -= dmg
			var dmg = ((pAtk*pBuffs*pStatus)*randf_range(0.8,1)-eDef)
			eHealth -= dmg
	if eHealth <= 0:
		battleEnd()
	else:
		if turns == battlers:
			turns = 0
			rounds += 1
			calculateTurnOrder()
		else: 
			enemyTurn()

func calculateTurnOrder():
	if pSpeed >= eSpeed:
		playerTurn()
	elif eSpeed > pSpeed:
		enemyTurn()

func battleEnd():
	emit_signal("battleEnded")
