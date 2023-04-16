class_name pepper
extends Node

var skills = ["invisibility","intangible","burn"]
var eHealth = 0.0
var eEnergy = 0.0
var eAtk = 0.0
var eDef = 0.0
var eSpeed = 0.0
var eLuck = 10
var level = 1.0
var eName = "Ghost Pepper"
var moveSpeed = 10.0
var skillsChance = 0.95
var timerWaitTime = 4
var statsCalc = 0.25
var baseHighHealth = 100
var baseLowHealth = 25
var baseHigh = 5
var baseLow = 5

func load_stats():
	randomize()
	eHealth = randi_range(round((baseHighHealth*level)*statsCalc),round((baseLowHealth*level)*statsCalc))
	eEnergy = randi_range(round((baseHighHealth*level)*statsCalc),round((baseLowHealth*level)*statsCalc))
	eAtk = randi_range(round((baseHigh*level)*statsCalc),round((baseLow*level)*statsCalc))
	eDef = randi_range(round((baseHigh*level)*statsCalc),round((baseLow*level)*statsCalc))
	eSpeed = randi_range(round((baseHigh*level)*statsCalc),round((baseLow*level)*statsCalc))
	eLuck = randi_range(round((baseHigh*level)*statsCalc),round((baseLow*level)*statsCalc))
	
