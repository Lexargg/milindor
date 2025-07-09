extends Control

# Advanced Character Creator
# Sistema di creazione personaggi che supera PF:WotR in complessità e profondità

@onready var race_container = $VBoxContainer/RaceSection
@onready var subrace_container = $VBoxContainer/SubraceSection  
@onready var class_container = $VBoxContainer/ClassSection
@onready var archetype_container = $VBoxContainer/ArchetypeSection
@onready var background_container = $VBoxContainer/BackgroundSection
@onready var stats_container = $VBoxContainer/StatsSection
@onready var traits_container = $VBoxContainer/TraitsSection
@onready var moral_compass_container = $VBoxContainer/MoralCompassSection
@onready var destiny_container = $VBoxContainer/DestinySection

@onready var preview_panel = $HSplitContainer/PreviewPanel
@onready var create_button = $VBoxContainer/CreateButton

var character_data = {}
var available_races = {}
var available_classes = {} 
var available_archetypes = {}
var available_backgrounds = {}

# Sistemi avanzati
var stat_point_buy_system = {}
var racial_heritage_system = {}
var destiny_paths = {}
var personality_traits = {}

func _ready():
	_load_advanced_character_data()
	_setup_advanced_ui()
	_initialize_point_buy_system()

func _load_advanced_character_data():
	# Carica tutti i dati espansi
	available_races = _load_json_data("res://data/advanced_races.json")
	available_classes = _load_json_data("res://data/advanced_progression.json")
	
	# Sistemi di background più complessi di PF:WotR
	available_backgrounds = {
		"noble_heir": {
			"name": "Erede Nobile",
			"description": "Nato in una famiglia di alto lignaggio, con privilegi e responsabilità",
			"skill_bonuses": {"Diplomacy": 2, "Knowledge(Nobility)": 2, "Ride": 1},
			"starting_equipment": ["Signet Ring", "Noble Outfit", "Warhorse"],
			"social_connections": ["Royal Court", "Merchant Guilds"],
			"starting_wealth": 500,
			"reputation_modifiers": {"nobles": 20, "commoners": -5}
		},
		"street_orphan": {
			"name": "Orfano di Strada", 
			"description": "Cresciuto nelle strade più dure, hai imparato a sopravvivere",
			"skill_bonuses": {"Stealth": 2, "Sleight_of_Hand": 2, "Survival": 1},
			"starting_equipment": ["Lockpicks", "Hidden Dagger", "Beggar's Outfit"],
			"social_connections": ["Thieves Guild", "Street Network"],
			"starting_wealth": 25,
			"reputation_modifiers": {"criminals": 15, "law_enforcement": -10}
		},
		"kai_initiate": {
			"name": "Iniziato Kai",
			"description": "Addestrato nei monasteri dei Signori Kai prima della loro caduta",
			"skill_bonuses": {"Concentration": 2, "Sense_Motive": 2, "Knowledge(Religion)": 1},
			"special_abilities": ["Kai Sight", "Mental Shield", "Sixth Sense"],
			"starting_equipment": ["Kai Cloak", "Meditation Focus", "Ancient Scroll"],
			"destiny_path": "kai_lord_ascension",
			"reputation_modifiers": {"good_factions": 25, "evil_factions": -20}
		}
	}
	
	# Sentieri del destino unici
	destiny_paths = {
		"kai_lord_ascension": {
			"name": "Ascensione del Signore Kai",
			"description": "Il cammino per diventare uno dei leggendari Signori Kai",
			"requirements": ["Good alignment", "Kai background or training"],
			"milestones": [
				{"level": 5, "trial": "Master basic Kai disciplines"},
				{"level": 10, "trial": "Defeat a Darklord's lieutenant"},
				{"level": 15, "trial": "Restore a corrupted sacred site"},
				{"level": 20, "trial": "Face a Darklord in single combat"},
				{"level": 25, "trial": "Achieve perfect harmony of mind and body"}
			],
			"ultimate_reward": "Become a true Kai Lord with cosmic awareness"
		},
		"shadow_dancer": {
			"name": "Danzatore delle Ombre",
			"description": "Maestro delle tenebre che usa l'oscurità come alleata",
			"requirements": ["Chaotic alignment", "Rogue or related class"],
			"milestones": [
				{"level": 5, "trial": "Become one with shadows"},
				{"level": 10, "trial": "Steal from the impossible"},
				{"level": 15, "trial": "Escape from the plane of shadow"},
				{"level": 20, "trial": "Outsmart a demon lord"},
				{"level": 25, "trial": "Dance between reality and shadow"}
			],
			"ultimate_reward": "Become a living shadow with reality-bending powers"
		}
	}

func _setup_advanced_ui():
	_setup_race_selection()
	_setup_class_selection()  
	_setup_background_selection()
	_setup_moral_compass_system()
	_setup_destiny_selection()

func _setup_race_selection():
	# Sistema di selezione razza con sottotipi
	var race_selector = OptionButton.new()
	race_selector.name = "RaceSelector"
	
	if available_races and available_races.has("advanced_races"):
		var races = available_races.advanced_races
		
		# Razze core
		if races.has("core_races"):
			for race in races.core_races:
				race_selector.add_item(race.name)
		
		# Razze esotiche
		if races.has("exotic_races"):
			race_selector.add_separator()
			for race in races.exotic_races:
				race_selector.add_item(race.name + " (Esotica)")
		
		# Razze mostruose
		if races.has("monstrous_races"):
			race_selector.add_separator()
			for race in races.monstrous_races:
				race_selector.add_item(race.name + " (Mostruosa)")
	
	race_selector.connect("item_selected", _on_race_selected)
	race_container.add_child(race_selector)

func _setup_moral_compass_system():
	# Sistema di allineamento più sfumato di PF:WotR
	var moral_compass = Control.new()
	moral_compass.name = "MoralCompass"
	
	# Asse Legge-Caos
	var law_chaos_slider = HSlider.new()
	law_chaos_slider.min_value = -100
	law_chaos_slider.max_value = 100
	law_chaos_slider.value = 0
	law_chaos_slider.step = 1
	
	var law_chaos_label = Label.new()
	law_chaos_label.text = "Legge ← → Caos"
	
	# Asse Bene-Male
	var good_evil_slider = HSlider.new()
	good_evil_slider.min_value = -100
	good_evil_slider.max_value = 100
	good_evil_slider.value = 0
	good_evil_slider.step = 1
	
	var good_evil_label = Label.new()
	good_evil_label.text = "Bene ← → Male"
	
	moral_compass.add_child(law_chaos_label)
	moral_compass.add_child(law_chaos_slider)
	moral_compass.add_child(good_evil_label)
	moral_compass.add_child(good_evil_slider)
	
	moral_compass_container.add_child(moral_compass)

func _initialize_point_buy_system():
	# Sistema point-buy più flessibile di PF:WotR
	stat_point_buy_system = {
		"total_points": 32,  # Più punti di D&D standard
		"min_stat": 8,
		"max_stat": 18,  # Prima dei modificatori razziali
		"costs": {
			8: 0, 9: 1, 10: 2, 11: 3, 12: 4, 13: 5,
			14: 7, 15: 9, 16: 12, 17: 16, 18: 21
		}
	}

func _on_race_selected(index: int):
	var race_selector = race_container.get_node("RaceSelector")
	var selected_race_name = race_selector.get_item_text(index)
	
	# Trova la razza selezionata nei dati
	var selected_race = _find_race_by_name(selected_race_name)
	if selected_race:
		character_data.race = selected_race
		_update_subrace_options(selected_race)
		_update_character_preview()

func _find_race_by_name(race_name: String) -> Dictionary:
	if not available_races or not available_races.has("advanced_races"):
		return {}
	
	var races = available_races.advanced_races
	
	# Cerca nelle razze core
	if races.has("core_races"):
		for race in races.core_races:
			if race.name == race_name:
				return race
	
	# Cerca nelle razze esotiche
	if races.has("exotic_races"):
		for race in races.exotic_races:
			if race_name.begins_with(race.name):
				return race
	
	return {}

func _update_subrace_options(race: Dictionary):
	# Pulisci opzioni precedenti
	for child in subrace_container.get_children():
		child.queue_free()
	
	if not race.has("subtypes"):
		return
	
	var subrace_selector = OptionButton.new()
	subrace_selector.name = "SubraceSelector"
	
	for subtype in race.subtypes:
		subrace_selector.add_item(subtype.name)
	
	subrace_selector.connect("item_selected", _on_subrace_selected)
	subrace_container.add_child(subrace_selector)

func _on_subrace_selected(index: int):
	if not character_data.has("race") or not character_data.race.has("subtypes"):
		return
	
	character_data.subrace = character_data.race.subtypes[index]
	_update_character_preview()

func _update_character_preview():
	# Aggiorna il pannello di anteprima con tutti i dettagli
	var preview_text = ""
	
	if character_data.has("race"):
		preview_text += "Razza: " + character_data.race.name + "\n"
		
		if character_data.has("subrace"):
			preview_text += "Sottorazza: " + character_data.subrace.name + "\n"
			preview_text += character_data.subrace.description + "\n\n"
			
			# Mostra bonus statistiche
			if character_data.subrace.has("bonuses"):
				preview_text += "Bonus: "
				for stat in character_data.subrace.bonuses:
					preview_text += stat + " +" + str(character_data.subrace.bonuses[stat]) + " "
				preview_text += "\n\n"
			
			# Mostra abilità speciali
			if character_data.subrace.has("special_abilities"):
				preview_text += "Abilità Speciali:\n"
				for ability in character_data.subrace.special_abilities:
					preview_text += "• " + ability + "\n"
	
	var preview_label = preview_panel.get_node_or_null("PreviewLabel")
	if not preview_label:
		preview_label = RichTextLabel.new()
		preview_label.name = "PreviewLabel"
		preview_panel.add_child(preview_label)
	
	preview_label.text = preview_text

func _load_json_data(file_path: String) -> Dictionary:
	var file = FileAccess.open(file_path, FileAccess.READ)
	if file:
		var json_string = file.get_as_text()
		file.close()
		
		var json = JSON.new()
		var parse_result = json.parse(json_string)
		if parse_result == OK:
			return json.data
		else:
			print("Errore nel parsing JSON: ", file_path)
	
	return {}

func create_advanced_character() -> Dictionary:
	# Crea un personaggio con tutti i sistemi avanzati
	var final_character = {
		"name": character_data.get("name", "Senza Nome"),
		"race": character_data.get("race", {}),
		"subrace": character_data.get("subrace", {}),
		"class": character_data.get("class", {}),
		"archetype": character_data.get("archetype", {}),
		"background": character_data.get("background", {}),
		"stats": character_data.get("stats", {}),
		"moral_alignment": character_data.get("moral_alignment", {"law_chaos": 0, "good_evil": 0}),
		"destiny_path": character_data.get("destiny_path", {}),
		"level": 1,
		"experience": 0,
		"creation_timestamp": Time.get_unix_time_from_system()
	}
	
	return final_character
