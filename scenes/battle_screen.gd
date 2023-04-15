extends Control

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
	turns += 1
	$textBox/textBox.visible = false
	$textBox/textBox.set_process_input(false)
	$playerUi/PlayerMenu/playerMenu.visible = true
	$playerUi/PlayerMenu/playerMenu.set_process_input(true)
	$fight.grab_focus()

func enemyTurn():
	pass
