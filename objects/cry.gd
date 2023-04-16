class_name cry
extends Node

func energyCost():
	return 10

func specialSkill():
	return true

func isDebuff():
	return true

func targetStat():
	return "attack"

func useSkill(_pHealth,_pEnergy,_pAtk,_pDef,_pSpeed,_pLuck,_pBuffs,_eHealth,_eEnergy,_eAtk,_eDef,_eSpeed,_eLuck,_eBuffs):
	return 0.2
