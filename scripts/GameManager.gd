extends Node

# GameManager - Singleton per gestire stato globale del gioco
# Mantiene dati personaggio, progressione storia, salvataggi

var current_character = {}
var story_progress = {}
var game_settings = {}

func _ready():
	print("GameManager inizializzato")
	_load_settings()

func set_current_character(character_data: Dictionary):
	current_character = character_data
	print("Personaggio impostato: ", character_data.get("name", "Sconosciuto"))

func get_current_character() -> Dictionary:
	return current_character

func save_story_progress(node_id: int, choices_made: Array):
	story_progress["current_node"] = node_id
	story_progress["choices"] = choices_made
	_save_game_data()

func load_story_progress() -> Dictionary:
	return story_progress

func _load_settings():
	# Carica impostazioni di gioco
	game_settings = {
		"volume_master": 1.0,
		"volume_music": 0.8,
		"volume_sfx": 1.0,
		"fullscreen": false,
		"language": "it"
	}

func _save_game_data():
	# TODO: Implementare salvataggio su file
	print("Salvataggio dati di gioco...")

func _load_game_data():
	# TODO: Implementare caricamento da file
	print("Caricamento dati di gioco...")

func get_save_path() -> String:
	return OS.get_user_data_dir() + "/milindor_save.dat"
