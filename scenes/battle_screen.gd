extends Control

signal battleEnded
@onready var textBox = $textBox/textBox/MarginContainer/RichTextLabel/Label
@onready var textAnimation = $textBox/textAnimation 
@onready var textButton = $textBox/textBox/MarginContainer/RichTextLabel
var eName = ""
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
var toPlayer = false
var eNum = 0
var isPlayerVictorious = false
var enterPressed = false
var foodItem = ""
@onready var textboxBackground = $textBox/textBox
var isPlayerTurn = false
var battleSituations = 0
var eChara
var isBurned = false

func battleSetup(enCharacter,enName,enemyNum,plHealth,plEnergy,plAtk,plDef,plSpeed,plLuck,enHealth,enEnergy,enAtk,enDef,enSpeed,enLuck,enSkills,enSkillChance):
	eName = enName
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
	eChara = enCharacter
	eSkillChance = enSkillChance
	$playerUi/PlayerMenu/Health.max_value = pHealth
	$playerUi/PlayerMenu/Health.value = pHealth
	$playerUi/eHealth.max_value = eHealth
	$playerUi/eHealth.value = eHealth
	$playerUi/PlayerMenu/Energy.max_value = pEnergy
	$playerUi/PlayerMenu/Energy.value = pEnergy
	$playerUi/eEnergy.max_value = eEnergy
	$playerUi/eEnergy.value = eEnergy
	$playerUi/PlayerMenu/eName.text = eName
	$playerUi/PlayerMenu/Health.value = pHealth
	if eChara == "onion":
		eName = "Dragonion"
	elif eChara == "tomato":
		eName = "Tomaturtle"
	elif eChara == "pepper":
		eName == "Ghost Pepper"
	$playerUi/PlayerMenu/eName.text = eName
	print("Food item = ", eChara, "eName = ", eName )
	$playerUi/enemy.texture = load("res://images/" + str(eChara) + "Battle.png")
	
	#Determines who is faster
	if pSpeed >= eSpeed:
		playerTurn()
		
	elif eSpeed > pSpeed:
		enemyTurn()
		



func playerTurn():
	isPlayerTurn = true
	textFinished = false 
	#Prevent player from pressing on enemy> This feature was implemented in case we wanted to do battles with more than one monster involved...
	#Turns = player or enemy turn
	turns += 1
	#Remove menu to let player choice menu take place
	$textBox/textBox.visible = false
	$textBox/textBox.set_process_input(false)
	$playerUi/PlayerMenu/playerMenu.visible = true
	$playerUi/PlayerMenu/playerMenu.set_process_input(true)
	$playerUi/PlayerMenu/playerMenu/GridContainer/Fight.disabled = false
	$playerUi/PlayerMenu/playerMenu/GridContainer/Fight.grab_focus()

func enemyTurn():
	textFinished = false
	$playerUi/PlayerMenu/playerMenu.visible = false
	textboxBackground.visible = true
	#As actions happen, textBlock takes note and display all of them at the end to the Player instead of displaying it when it's happening.
	randomize()
	var dialogChance = randi_range(3,1)
	if dialogChance == 1:
		var text = "The enemy is cooking something behind its back..."
		showText(text)
	elif dialogChance == 2:
		var text = "It's either eat or be eaten..."
	else:
		var text = "Let's dish up something special!"
	textButton.disabled = false
	textButton.grab_focus()
	battleSituations = 1
	turns += 1

func enemyActionTurn():
	#Must determine the probablity of enemy using skill. Every enemy has a different likelihood of using a skill as opposed to attacking normally
	var useSkillChance = randf()
	battleSituations = 2
	print(eSkills)
	var skillChoose = randi_range(0,eSkills.size()-1)
	var skillName = eSkills[skillChoose]
	var skillScript = load("res://objects/" + str(skillName) + ".gd")
	var skillActive = skillScript.new()
	if useSkillChance >= eSkillChance and skillActive.energyCost() <= eEnergy:
		if skillName == "invisiblity":
			if pAccuracyBuff >= 0.4:
				pAccuracyBuff -= 0.2
			else:
				var text = "You can't can't see the Ghost Pepper any more (less?)!"
				showText(text)
		elif skillName == "intangible":
			if eEvasionBuff <= 1.6:
				eEvasionBuff += 0.2
			else:
				var text = "But the Ghost Pepper can't disappear anymore from life!"
				showText(text)
		elif skillName == "burn":
			if isBurned == false:
				burn()
			else:
				var text = "Ghost Pepper tried to burn you again, but you're already on fire!"
		#If here, then skill activated
		elif skillActive.specialSkill():
			#Special skill = anything that isn't direct damage
			if skillActive.isDebuff() == true:
				#Debuffs the player
				if pBuffs > 0.4:
					pBuffs -= skillActive.useSkill(pHealth,pEnergy,pAtk,pDef,pSpeed,pLuck,eHealth,pBuffs,eEnergy,eAtk,eDef,eSpeed,eLuck,eBuffs)
					
					var text = ("The enemy uses " + skillName + "! Your attack went down!")
					showText(text)
					
			elif skillActive.isBuff() == true:
				#Buff self
				eBuffs += skillActive.useSkill(pHealth,pEnergy,pAtk,pDef,pSpeed,pLuck,eHealth,pBuffs,eEnergy,eAtk,eDef,eSpeed,eLuck,eBuffs)
				
				var text = ("The enemy uses " + skillName + "! Their attack went up!")
				showText(text)
				
		else:
			#Normal skill. Causes normal damage with no special effects
			var dmg = skillActive.useSkill(pHealth,pEnergy,pAtk,pDef,pSpeed,pLuck,eHealth,pBuffs,eEnergy,eAtk,eDef,eSpeed,eLuck,eBuffs)
			#roundtoTwo rounds to the nearest decimal point
			dmg = roundToTwo(dmg,2)
			if dmg - pDef <= 0:
				dmg = 0
			pHealth -= dmg - pDef
			$playerUi/PlayerMenu/Health.value -= dmg - pDef
			textboxBackground.visible = true
			$playerUi/PlayerMenu/playerPortrait/portrait.texture = load("res://images/portrait2.png")
			var text = ("The enemy uses " + skillName + "! You took " + str(dmg) + "!")
			showText(text)
			
		skillActive.queue_free()
	else:
		#Enemy decided not to use a skill and attakcs normally
		var evadeChance = randf() + ((pLuck/1000)*pEvasionBuff) - ((eLuck/1000)*eAccuracyBuff)
		if evadeChance <= 0.99:
			#1% chance to evade +- luck of player/enemy
			var critChance = randf() + (eLuck/1000) - (pLuck/1000)
			if critChance >= 0.95:
				#5% to crit +- luck
				var dmg = (((eAtk*eAtkBuff*eStatus)*1.5)*randf_range(0.8,1)-(pDef*pDefBuff))
				dmg = roundToTwo(dmg,2)
				if dmg <= 0:
					dmg = 1
				pHealth -= dmg
				$playerUi/PlayerMenu/playerPortrait/portrait.texture = load("res://images/portrait2.png")
				$playerUi/PlayerMenu/Health.value -= dmg 
				textboxBackground.visible = true
				var text = ("The enemy attcks you directly! CRITICAL HIT! You took " + str(dmg) + " damage!")
				showText(text)
			var dmg = ((eAtk*eAtkBuff*eStatus)*randf_range(0.8,1)-(pDef*pDefBuff))
			if dmg <= 0:
				dmg = 1
			dmg = roundToTwo(dmg,2)
			pHealth -= dmg
			$playerUi/PlayerMenu/playerPortrait/portrait.texture = load("res://images/portrait2.png")
			$playerUi/PlayerMenu/Health.value -= dmg 
			textboxBackground.visible = true
			var text = ("The enemy attacks you directly! You took " + str(dmg) + "!")
			showText(text)
			
		else:
			textboxBackground.visible = true
			var text = ("You evaded the enemy's attack!")
			showText(text)
			
	#removes the object called earilier 

func enemyTurnEnds():
	if pHealth <= 0:
		battleSituations = 3
		#Player dies
		textboxBackground.visible = true
		var text = ("You have no more health left!")
		showText(text)
		
	else:
		if turns == battlers:
			turns = 0
			rounds += 1
			#Both have moved and game calculate new turn order in case anything changed in speed
			calculateTurnOrder()
		else: 
			#Whenever playTextAnimation appears, it plays all the dialog stored in textBlock
			playerTurn()

func burn():
	pass

func gameOver():
	var gameOverInstance = load("res://scenes/game_over.tscn")
	var gameOverScene = gameOverInstance.instantiate()
	add_child(gameOverScene)
	gameOverScene.appear()

func _on_fight_pressed():
	$playerUi/PlayerMenu/playerMenu/GridContainer/Fight.disabled = true
	$playerUi/PlayerMenu/playerMenu.visible = false
	var evadeChance = randf() + (eLuck/1000) - (pLuck/1000)
	if evadeChance <= 0.99:
		var critChance = randf() + (pLuck/1000) - (eLuck/1000)
		if critChance >= 0.95:
			var dmg = (((pAtk*pAtkBuff*pStatus)*1.5)*randf_range(0.8,1)-(eDef*eDefBuff))
			dmg = roundToTwo(dmg,2)
			eHealth -= dmg
			$playerUi/eHealth.value -= dmg
			textboxBackground.visible = true
			battleSituations = 4
			var text = ("You bit the enemy! CRITICAL HIT! It took " + str(dmg) + " damage!")
			showText(text)
			
		battleSituations = 4
		var dmg = ((pAtk*pAtkBuff*pStatus)*randf_range(0.8,1)-(eDef*eDefBuff))
		dmg = roundToTwo(dmg,2)
		eHealth -= dmg
		$playerUi/eHealth.value -= dmg
		var text = "You dealt " + str(dmg) + " damage to your opponent!"
		showText(text)
		textboxBackground.visible = true
		#Check Enemy Turn
	else:
		battleSituations = 4
		var text = "The enemy evaded your attack!"
		showText(text)
	battleSituations = 4

func playerTurnEnds():
	if eHealth <= 0:
		battleEnd()
		#enemy defeated
	else:
		battleSituations = 8
		if isBurned:
			$playerUi/PlayerMenu/playerPortrait/portrait.texture = load("res://images/portrait2.png")
			
			var dmg = ($playerUi/PlayerMenu/Health.max_value*0.1)
			pHealth -= dmg
			var text = "Ouch! You took " + str(dmg) + " damage from the spicy flavors!"
		else:
			randomize()
			var dialogChance = randi_range(3,1)
			if dialogChance == 1:
				var text = "Now's not the time to let up!"
				showText(text)
			elif dialogChance == 2:
				var text = "It's getting hotter, but you can stand it."
				showText(text)
			else:
				var text = "Take a deep breath... of garlic cloves and remember the good things in life!"
				showText(text)

func determineNextActions():
	if turns == battlers:
		turns = 0
		rounds += 1
		isPlayerTurn = false
		textboxBackground.visible = true
		calculateTurnOrder()
	else: 
		toPlayer = false
		isPlayerTurn = false
		$playerUi/PlayerMenu/playerMenu.visible = false
		textboxBackground.visible = true
		battleSituations = 6
		var text = "It is now the enemy's turn"
		showText(text)
		enemyTurn()
	#On fight pressed, player is suppsoed to select an enemy in case there are multiples... currently, I'm not sure if it works.


func showText(text):
	textboxBackground.visible = true
	textButton.visible = true
	textBox.text = text
	textAnimation.play("textAnimation")
	$playerUi/PlayerMenu/playerPortrait/portrait.texture = load("res://images/portrait1.png")

func roundToTwo(num, digit):
	return round(num * pow(10.0, digit)) / pow(10.0, digit)

func calculateTurnOrder():
	if pSpeed >= eSpeed:
		var text = "You are faster than your enemy!"
		showText(text)
		battleSituations = 5
		
	elif eSpeed > pSpeed:
		toPlayer = false
		var text = "Your enemy is faster than you!"
		showText(text)
		battleSituations = 6

func battleEnd():
	get_parent().get_parent().get_parent().battleEnded(eNum)
	battleSituations = 7
	var text = "The enemy has died! You have won!"
	showText(text)
	isPlayerVictorious = true


func endingDialog():
	pass 

func playTextAnimation():
	textAnimation.play("textAnimation")

#	for x in textBlock.size():
#		textBox.text = textBlock[x]
#		textFinished = false
#		textAnimation.play("textAnimation")
#		if $textBox/textBox.visible == true and event is InputEventKey and event.scancode == KEY_ENTER and event.pressed == true and textFinished == true:
#			pass

func _on_text_animation_animation_finished(anim_name):
	$textBox/textBox/MarginContainer/RichTextLabel.disabled = false
	$textBox/textBox/MarginContainer/RichTextLabel.grab_focus()




func _on_rich_text_label_pressed():
	$textBox/textBox/MarginContainer/RichTextLabel.disabled = true
	textboxBackground.visible = false
	$textBox/textBox/MarginContainer/RichTextLabel.visible = false
	textButton.disabled = true
	if battleSituations == 1:
		enemyActionTurn()
		
	elif battleSituations == 2:
		enemyTurnEnds()
		
	elif battleSituations == 3:
		
		gameOver()
	elif battleSituations == 4:
		playerTurnEnds()
		
	elif battleSituations == 5:
		playerTurn()
	elif battleSituations == 6:
		enemyTurn()
	elif battleSituations == 7:
		self.queue_free()
	elif battleSituations == 8:
		determineNextActions()
