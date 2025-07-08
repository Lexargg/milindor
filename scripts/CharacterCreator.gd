extends Control

# Character Creator per Milindor
# Permette di creare personaggi fantasy con razze, classi, etc.

@onready var race_option = $VBoxContainer/RaceContainer/RaceOption
@onready var class_option = $VBoxContainer/ClassContainer/ClassOption
@onready var name_input = $VBoxContainer/NameContainer/NameInput
@onready var description_label = $VBoxContainer/DescriptionLabel
@onready var create_button = $VBoxContainer/CreateButton
@onready var back_button = $VBoxContainer/BackButton

var character_data = {}
var races = []
var classes = []

func _ready():
	print("Character Creator - Inizializzazione")
	_load_game_data()
	_setup_ui()
	_connect_signals()

func _load_game_data():
	# Carica dati dalle JSON (simile al Flutter)
	races = [
		{"name": "Umano", "description": "Versatili e adattabili"},
		{"name": "Elfo", "description": "Aggraziati e magici"},
		{"name": "Nano", "description": "Robusti e coraggiosi"},
		{"name": "Halfling", "description": "Piccoli ma astuti"},
		{"name": "Dragonide", "description": "Discendenti dei draghi"}
	]
	
	classes = [
		{"name": "Guerriero", "description": "Maestro delle armi"},
		{"name": "Mago", "description": "Tessitore di magie"},
		{"name": "Ladro", "description": "Ombra silenziosa"},
		{"name": "Chierico", "description": "Servitore del divino"},
		{"name": "Ranger", "description": "Guardiano della natura"}
	]

func _setup_ui():
	# Popola le opzioni
	for race in races:
		race_option.add_item(race.name)
	
	for character_class in classes:
		class_option.add_item(character_class.name)
	
	_update_description()

func _connect_signals():
	race_option.item_selected.connect(_on_race_selected)
	class_option.item_selected.connect(_on_class_selected)
	name_input.text_changed.connect(_on_name_changed)
	create_button.pressed.connect(_on_create_pressed)
	back_button.pressed.connect(_on_back_pressed)

func _on_race_selected(index: int):
	character_data["race"] = races[index]
	_update_description()

func _on_class_selected(index: int):
	character_data["class"] = classes[index]
	_update_description()

func _on_name_changed(new_text: String):
	character_data["name"] = new_text

func _update_description():
	var desc = "Crea il tuo eroe di Milindor:\n\n"
	
	if character_data.has("race"):
		desc += "Razza: " + character_data.race.name + "\n"
		desc += character_data.race.description + "\n\n"
	
	if character_data.has("class"):
		desc += "Classe: " + character_data.class.name + "\n"
		desc += character_data.class.description + "\n\n"
	
	description_label.text = desc

func _on_create_pressed():
	if character_data.has("name") and character_data.has("race") and character_data.has("class"):
		print("Personaggio creato: ", character_data)
		# Salva il personaggio e vai alla storia
		GameManager.set_current_character(character_data)
		get_tree().change_scene_to_file("res://scenes/StoryScreen.tscn")
	else:
		print("Completa tutti i campi!")

func _on_back_pressed():
	get_tree().change_scene_to_file("res://scenes/Main.tscn")
