extends Control

signal battleEnded
@onready var textBox = $textBox/textBox/MarginContainer/RichTextLabel
@onready var textAnimation = $textBox/textAnimation
var pHealth = 1.0
var pEnergy = 1.0
var pAtk = 1.0
var pDef = 1.0
var pSpeed = 1.0
var pLuck = 1.0
var eHealth = 1.0
var eEnergy = 1.0
var eAtk = 1.0
var eDef = 1.0
var eSpeed = 1.0
var eLuck = 1.0
var eSkillChance = 1.0
var eSkills = []
var turns = 0
var rounds = 0
var pBuffs = 1.0
var eBuffs = 1.0
var pAtkBuff = 1.0
var pDefBuff = 1.0
var pSpeedBuff = 1.0
var pLuckBuff = 1.0
var pEvasionBuff = 1.0
var pAccuracyBuff = 1.0
var eAtkBuff = 1.0
var eDefBuff = 1.0
var eSpeedBuff = 1.0
var eLuckBuff = 1.0
var eEvasionBuff = 1.0
var eAccuracyBuff = 1.0
var pStatus = 1.0
var eStatus = 1.0
var buttonPressed = "attack"
var battlers = 2
var textFinished = true
var textBlock = []
var textIndex = 0
var toPlayer = false

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
	$playerUi/enemy.disabled = true
	$playerUi/enemy.set_process_input(false)
	turns += 1
	$textBox/textBox.visible = false
	$textBox/textBox.set_process_input(false)
	$playerUi/PlayerMenu/playerMenu.visible = true
	$playerUi/PlayerMenu/playerMenu/cursor.visible = true
	$playerUi/PlayerMenu/playerMenu/cursor.isVisible = true
	$playerUi/PlayerMenu/playerMenu.set_process_input(true)
	$playerUi/PlayerMenu/playerMenu/GridContainer/Fight.grab_focus()

func enemyTurn():
	textBlock.append("The Enemy readies for an attack!")
	turns += 1
	var useSkillChance = randf()
	var skillChoose = randi_range(0,eSkills.size()-1)
	var skillName = eSkills[skillChoose]
	var skillScript = load("res://objects/" + str(skillName) + ".gd")
	var skillActive = skillScript.new()
	if useSkillChance >= eSkillChance and skillActive.energyCost() <= eEnergy:
		if skillActive.specialSkill():
			if skillActive.isDebuff() == true:
				if pBuffs > 0.4:
					pBuffs -= skillActive.useSkill(pHealth,pEnergy,pAtk,pDef,pSpeed,pLuck,eHealth,pBuffs,eEnergy,eAtk,eDef,eSpeed,eLuck,eBuffs)
					textBlock.append("The enemy uses " + skillName + "! Your attack went down!")
			elif skillActive.isBuff() == true:
				eBuffs += skillActive.useSkill(pHealth,pEnergy,pAtk,pDef,pSpeed,pLuck,eHealth,pBuffs,eEnergy,eAtk,eDef,eSpeed,eLuck,eBuffs)
				textBlock.append("The enemy uses " + skillName + "! Their attack went up!")
		else:
			var dmg = skillActive.useSkill(pHealth,pEnergy,pAtk,pDef,pSpeed,pLuck,eHealth,pBuffs,eEnergy,eAtk,eDef,eSpeed,eLuck,eBuffs)
			dmg = roundToTwo(dmg,2)
			pHealth -= dmg - pDef
			textBlock.append("The enemy uses " + skillName + "! You took " + str(dmg) + "!")
	else:
		var evadeChance = randf() + (pLuck/1000) - (eLuck/1000)
		if evadeChance <= 0.99:
			var critChance = randf() + (eLuck/1000) - (pLuck/1000)
			if critChance >= 0.95:
				var dmg = (((eAtk*eBuffs*eStatus)*1.5)*randf_range(0.8,1)-pDef)
				dmg = roundToTwo(dmg,2)
				pHealth -= dmg
			var dmg = ((eAtk*eBuffs*eStatus)*randf_range(0.8,1)-pDef)
			dmg = roundToTwo(dmg,2)
			pHealth -= dmg
			textBlock.append("The enemy attacks you directly! You took " + str(dmg) + "!")
		else:
			textBlock.append("You evaded the enemy's attack!")
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
			toPlayer = true
			playTextAnimation()


func _on_fight_pressed():
	buttonPressed = "attack"
	$playerUi/enemy.disabled = false
	$playerUi/enemy.set_process_input(true)
	$playerUi/enemy.grab_focus()

func _on_enemy_pressed():
	$playerUi/enemy.disabled = true
	$playerUi/PlayerMenu/playerMenu/cursor.isVisible = false
	$playerUi/PlayerMenu/playerMenu/cursor.visible = false
	$playerUi/PlayerMenu/playerMenu.visible = false
	$textBox/textBox.visible = true
	if buttonPressed == "attack":
		var evadeChance = randf() + (eLuck/1000) - (pLuck/1000)
		if evadeChance <= 0.99:
			var critChance = randf() + (pLuck/1000) - (eLuck/1000)
			if critChance >= 0.95:
				var dmg = (((pAtk*pBuffs*pStatus)*1.5)*randf_range(0.8,1)-eDef)
				dmg = roundToTwo(dmg,2)
				eHealth -= dmg
			var dmg = ((pAtk*pBuffs*pStatus)*randf_range(0.8,1)-eDef)
			dmg = roundToTwo(dmg,2)
			eHealth -= dmg
			textBlock.append("You bit the enemy! It took " + str(dmg) + " damage!")
	if eHealth <= 0:
		battleEnd()
	else:
		if turns == battlers:
			turns = 0
			rounds += 1
			calculateTurnOrder()
		else: 
			toPlayer = false
			playTextAnimation()

func roundToTwo(num, digit):
	return round(num * pow(10.0, digit)) / pow(10.0, digit)

func calculateTurnOrder():
	if pSpeed >= eSpeed:
		toPlayer = true
		playTextAnimation()
		
	elif eSpeed > pSpeed:
		toPlayer = false
		playTextAnimation()

func battleEnd():
	emit_signal("battleEnded")

func playTextAnimation():
	
	textBox.text = textBlock[textIndex]
	textFinished = false
	textAnimation.play("textAnimation")

func _input(event):
	if $textBox/textBox.visible == true and event is InputEventKey and event.keycode  == KEY_ENTER and event.pressed == true and textFinished == true:
		if textIndex < textBlock.size()-1:
			textIndex += 1
			textBox.text = textBlock[textIndex]
			textAnimation.play("textAnimation")
			textFinished = false
		else:
			textIndex = 0
			textBlock = []
			if toPlayer:
				$playerUi/PlayerMenu/playerMenu.visible = true
				$playerUi/PlayerMenu/playerMenu/cursor.visible = true
				$playerUi/PlayerMenu/playerMenu/cursor.isVisible = true
				playerTurn()
			else:
				$playerUi/PlayerMenu/playerMenu.visible = false
				$playerUi/PlayerMenu/playerMenu/cursor.visible = false
				$playerUi/PlayerMenu/playerMenu/cursor.isVisible = false
				enemyTurn()
#	for x in textBlock.size():
#		textBox.text = textBlock[x]
#		textFinished = false
#		textAnimation.play("textAnimation")
#		if $textBox/textBox.visible == true and event is InputEventKey and event.scancode == KEY_ENTER and event.pressed == true and textFinished == true:
#			pass

func _on_text_animation_animation_finished(anim_name):
	textFinished = true
