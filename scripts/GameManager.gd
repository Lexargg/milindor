extends Node

# GameManager - Singleton per gestire stato globale del gioco
# Mantiene dati personaggio, progressione storia, salvataggi
# Sistema espanso che supera Pathfinder: WotR

var current_character = {}
var story_progress = {}
var game_settings = {}

# Sistemi avanzati
var advanced_story_system: AdvancedStorySystem
var atmosphere_controller: AtmosphereController
var character_progression = {}
var faction_relationships = {}
var world_events = {}
var mythic_progression = {}

func _ready():
	print("GameManager inizializzato - Sistema Avanzato Milindor")
	_initialize_advanced_systems()
	_load_settings()
	_load_game_data() # Carica i dati di gioco all'avvio

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
	var save_data = {
		"character": current_character,
		"progress": story_progress,
		"advanced_progression": _get_advanced_progression_data(),
		"faction_relationships": _get_faction_data(),
		"moral_alignment": _get_moral_alignment_data(),
		"world_state": _get_world_state_data(),
		"atmosphere_state": _get_atmosphere_data()
	}
	var save_path = get_save_path()
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(save_data))
		file.close()
		print("Dati di gioco salvati in: ", save_path)
	else:
		print("Errore durante il salvataggio dei dati di gioco.")

func _load_game_data():
	var save_path = get_save_path()
	var file = File.new()
	if file.open(save_path, File.READ) == OK:
		var save_data = parse_json(file.get_as_text())
		current_character = save_data.get("character", {})
		story_progress = save_data.get("progress", {})
		file.close()
		print("Dati di gioco caricati da: ", save_path)
	else:
		print("Nessun file di salvataggio trovato.")

func get_save_path() -> String:
	return OS.get_user_data_dir() + "/milindor_save.dat"

func _initialize_advanced_systems():
	# Inizializza i sistemi avanzati
	advanced_story_system = AdvancedStorySystem.new()
	add_child(advanced_story_system)
	
	atmosphere_controller = AtmosphereController.new()
	add_child(atmosphere_controller)
	
	# Connetti i segnali
	advanced_story_system.connect("character_reputation_changed", _on_reputation_changed)
	advanced_story_system.connect("mythic_moment_triggered", _on_mythic_moment)
	atmosphere_controller.connect("atmosphere_changed", _on_atmosphere_changed)
