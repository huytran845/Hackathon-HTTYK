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
var textFinished = false
var textBlock = []
var textIndex = 0
var toPlayer = false
var eNum = 0
var isPlayerVictorious = false

func battleSetup(enemyNum,plHealth,plEnergy,plAtk,plDef,plSpeed,plLuck,enHealth,enEnergy,enAtk,enDef,enSpeed,enLuck,enSkills,enSkillChance):
	print("Battle is setting up")
	eNum = enemyNum
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
	#Determines who is faster
	if pSpeed >= eSpeed:
		playerTurn()
		print("Player is faster")
	elif eSpeed > pSpeed:
		enemyTurn()
		print("enemy is faster")

func playerTurn():
	print("Player turn")
	#Prevent player from pressing on enemy> This feature was implemented in case we wanted to do battles with more than one monster involved...
	$playerUi/enemy.disabled = true
	$playerUi/enemy.set_process_input(false)
	#Turns = player or enemy turn
	turns += 1
	#Remove menu to let player choice menu take place
	$textBox/textBox.visible = false
	$textBox/textBox.set_process_input(false)
	$playerUi/PlayerMenu/playerMenu.visible = true
	$playerUi/PlayerMenu/playerMenu/cursor.visible = true
	$playerUi/PlayerMenu/playerMenu/cursor.isVisible = true
	$playerUi/PlayerMenu/playerMenu.set_process_input(true)
	$playerUi/PlayerMenu/playerMenu/GridContainer/Fight.grab_focus()

func enemyTurn():
	print("Enemy Turn")
	$playerUi/PlayerMenu/playerMenu.visible = false
	$playerUi/PlayerMenu/playerMenu/cursor.visible = false
	$textBox/textBox.visible = true
	$playerUi/enemy.disabled = true
	#As actions happen, textBlock takes note and display all of them at the end to the Player instead of displaying it when it's happening.
	textBlock.append("The Enemy readies for an attack!")
	turns += 1
	#Must determine the probablity of enemy using skill. Every enemy has a different likelihood of using a skill as opposed to attacking normally
	var useSkillChance = randf()
	var skillChoose = randi_range(0,eSkills.size()-1)
	var skillName = eSkills[skillChoose]
	var skillScript = load("res://objects/" + str(skillName) + ".gd")
	var skillActive = skillScript.new()
	if useSkillChance >= eSkillChance and skillActive.energyCost() <= eEnergy:
		#If here, then skill activated
		if skillActive.specialSkill():
			#Special skill = anything that isn't direct damage
			if skillActive.isDebuff() == true:
				#Debuffs the player
				if pBuffs > 0.4:
					pBuffs -= skillActive.useSkill(pHealth,pEnergy,pAtk,pDef,pSpeed,pLuck,eHealth,pBuffs,eEnergy,eAtk,eDef,eSpeed,eLuck,eBuffs)
					textBlock.append("The enemy uses " + skillName + "! Your attack went down!")
			elif skillActive.isBuff() == true:
				#Buff self
				eBuffs += skillActive.useSkill(pHealth,pEnergy,pAtk,pDef,pSpeed,pLuck,eHealth,pBuffs,eEnergy,eAtk,eDef,eSpeed,eLuck,eBuffs)
				textBlock.append("The enemy uses " + skillName + "! Their attack went up!")
		else:
			#Normal skill. Causes normal damage with no special effects
			var dmg = skillActive.useSkill(pHealth,pEnergy,pAtk,pDef,pSpeed,pLuck,eHealth,pBuffs,eEnergy,eAtk,eDef,eSpeed,eLuck,eBuffs)
			#roundtoTwo rounds to the nearest decimal point
			dmg = roundToTwo(dmg,2)
			pHealth -= dmg - pDef
			textBlock.append("The enemy uses " + skillName + "! You took " + str(dmg) + "!")
	else:
		#Enemy decided not to use a skill and attakcs normally
		var evadeChance = randf() + (pLuck/1000) - (eLuck/1000)
		if evadeChance <= 0.99:
			#1% chance to evade +- luck of player/enemy
			var critChance = randf() + (eLuck/1000) - (pLuck/1000)
			if critChance >= 0.95:
				#5% to crit +- luck
				var dmg = (((eAtk*eBuffs*eStatus)*1.5)*randf_range(0.8,1)-pDef)
				dmg = roundToTwo(dmg,2)
				pHealth -= dmg
			var dmg = ((eAtk*eBuffs*eStatus)*randf_range(0.8,1)-pDef)
			dmg = roundToTwo(dmg,2)
			pHealth -= dmg
			textBlock.append("The enemy attacks you directly! You took " + str(dmg) + "!")
		else:
			textBlock.append("You evaded the enemy's attack!")
	#removes the object called earilier 
	skillActive.queue_free()
	if pHealth <= 0:
		#Player dies
		var gameOverInstance = load("res://scenes/game_over.tscn")
		var gameOverScene = gameOverInstance.instiniate()
		add_child(gameOverScene)
		gameOverScene.appear()
	else:
		if turns == battlers:
			turns = 0
			rounds += 1
			#Both have moved and game calculate new turn order in case anything changed in speed
			calculateTurnOrder()
		else: 
			#Whenever playTextAnimation appears, it plays all the dialog stored in textBlock
			toPlayer = true
			playTextAnimation()


func _on_fight_pressed():
	buttonPressed = "attack"
	$playerUi/enemy.disabled = false
	$playerUi/enemy.set_process_input(true)
	$playerUi/enemy.grab_focus()
	#On fight pressed, player is suppsoed to select an enemy in case there are multiples... currently, I'm not sure if it works.

func _on_enemy_pressed():
	#Player attacks chosen enemy. Normal attack
	$playerUi/enemy.disabled = true
	$playerUi/PlayerMenu/playerMenu/cursor.isVisible = false
	$playerUi/PlayerMenu/playerMenu/cursor.visible = false
	$playerUi/PlayerMenu/playerMenu.visible = false
	$textBox/textBox.visible = true
	if buttonPressed == "attack": #Checks if normal attack is used or skill is used on enemy
		var evadeChance = randf() + (eLuck/1000) - (pLuck/1000)
		if evadeChance <= 0.99:
			var critChance = randf() + (pLuck/1000) - (eLuck/1000)
			if critChance >= 0.95:
				var dmg = (((pAtk*pBuffs*pStatus)*1.5)*randf_range(0.8,1)-eDef)
				dmg = roundToTwo(dmg,2)
				eHealth -= dmg
				textBlock.append("You bit the enemy! CRITICAL HIT! It took " + str(dmg) + " damage!")
			var dmg = ((pAtk*pBuffs*pStatus)*randf_range(0.8,1)-eDef)
			dmg = roundToTwo(dmg,2)
			eHealth -= dmg
			textBlock.append("You bit the enemy! It took " + str(dmg) + " damage!")
			#Check Enemy Turn
		else:
			textBlock.append("The enemy evaded your attack!")
	if eHealth <= 0:
		battleEnd()
		#enemy defeated
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
	
	get_parent().get_parent().get_parent().battleEnded(eNum)
	textBlock = ["The enemy has died! You have won!"]
	textIndex = 0
	isPlayerVictorious = true
	$playerUi/PlayerMenu/playerMenu.visible = false
	$textBox/textBox.visible = true
	playTextAnimation()

func endingDialog():
	pass

func playTextAnimation():
	#Plays animation of textBlock which the game stores overtime with every action that took place and plays them all at the same time. 
	textBox.text = textBlock[textIndex]
	textFinished = false
	textAnimation.play("textAnimation")

func _input(event):
	#On Enter, if text animation is finished, move on to the next dialog or end and continue turns
	if $textBox/textBox.visible == true and event is InputEventKey and event.keycode  == KEY_ENTER and event.pressed == true and textFinished == true:
		
		if textIndex < textBlock.size()-1:
			#play next dialog
			
			textIndex += 1
			textBox.text = textBlock[textIndex]
			textAnimation.play("textAnimation")
			textFinished = false
		else:
			#Resets dialog system
			if isPlayerVictorious:#PLayer won, plays vicotry dialog
				self.queue_free() 
			else:
				textIndex = 0
				textBlock = []
			#toPlayer == Player turn next if true
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
