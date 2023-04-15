class_name tomato
extends Node

var skills = []
var eHealth = 0.0
var eEnergy = 0.0
var eAtk = 0.0
var eDef = 0.0
var eSpeed = 0.0
var eLuck = 1
var level = 0.0
var moveSpeed = 0.0
var skillsChance = 0.0
var timerWaitTime = 10


func load_stats():
	randomize()
	eHealth = randi_range(round((100*level)*0.75),round((50*level)*.75))
	eEnergy = randi_range(round((100*level)*0.75),round((50*level)*.75))
	eAtk = randi_range(round((10*level)*0.75),round((1*level)*.75))
	eDef = randi_range(round((10*level)*0.75),round((1*level)*.75))
	eSpeed = randi_range(round((10*level)*0.75),round((1*level)*.75))
	eLuck = randi_range(round((10*level)*0.75),round((1*level)*.75))
	
