extends Node

const SAVE_FILE = "user://KTSaveFile.save" #Chooses the place where the save file is saved
var gameData = {} #Dictionary for the game data

func _ready():
	loadData()

func saveData():
	var file = FileAccess.open(SAVE_FILE, FileAccess.WRITE) #Opens the file for writing
	file.store_var(gameData)
	file.close()

func loadData():
	if not FileAccess.file_exists(SAVE_FILE): #If the file doesn't exist, then we'll write new variables for the dictionary
		gameData = {
			"pHealth" : 100,
			"pEnergy" : 100,
			"pAtk" : 50,
			"pDef" : 10,
			"pLuck" : 4,
			"pSpeed" : 4,
		}
		
		saveData()

	var file = FileAccess.open(SAVE_FILE, FileAccess.READ) #Opens the file for reading
	gameData = file.get_var()
	file.close()
