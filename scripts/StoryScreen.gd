extends Control

# Story Screen - Gestisce le storie interattive di Milindor
# Sistema di scelte multiple che influenzano la narrativa

@onready var story_text = $VBoxContainer/StoryText
@onready var choices_container = $VBoxContainer/ChoicesContainer
@onready var character_info = $VBoxContainer/CharacterInfo
@onready var back_button = $VBoxContainer/BackButton

var current_story_node = 0
var story_data = []
var character_data = {}

# Scenari disponibili (importati da Milindor Flutter)
var available_scenarios = [
	{
		"name": "La Storiella",
		"description": "Introduzione breve alla storia di Milindor (Livelli 1–10). Ideale per nuovi giocatori.",
		"choices": [
			{"text": "Inizia l'avventura", "next": 1},
			{"text": "Esplora il villaggio", "next": 2}
		]
	},
	{
		"name": "Il Racconto",
		"description": "Campagna estesa che copre i livelli 1–20 con Classi di Prestigio e scelte ramificate.",
		"choices": [
			{"text": "Accetta la missione", "next": 3},
			{"text": "Rifiuta e cerca risposte", "next": 4}
		]
	},
	{
		"name": "L'Epopea",
		"description": "Esperienza completa 1–30 con Percorsi di Ascensione e minacce di portata cosmica.",
		"choices": [
			{"text": "Sfida il destino", "next": 5},
			{"text": "Cerca alleati", "next": 6}
		]
	},
]

func _ready():
	print("Story Screen - Inizializzazione")
	character_data = GameManager.get_current_character()
	_load_story_data()
	_setup_ui()
	_show_current_node()

func _load_story_data():
	# Carica scenari disponibili
	story_data = available_scenarios

func _setup_ui():
	if character_data.size() > 0:
		character_info.text = "Eroe: " + character_data.get("name", "Sconosciuto") + 
						     " (" + character_data.get("race", {}).get("name", "") + 
						     " " + character_data.get("class", {}).get("name", "") + ")"
	else:
		character_info.text = "Nessun personaggio selezionato"
	
	back_button.pressed.connect(_on_back_pressed)

func _show_current_node():
	var node = _get_story_node(current_story_node)
	if node == null:
		story_text.text = "Fine della storia!"
		_clear_choices()
		return
	
	story_text.text = node.text
	_show_choices(node.choices)

func _get_story_node(id: int):
	for node in story_data:
		if node.id == id:
			return node
	return null

func _show_choices(choices: Array):
	_clear_choices()
	
	for i in range(choices.size()):
		var choice = choices[i]
		var button = Button.new()
		button.text = choice.text
		button.pressed.connect(_on_choice_selected.bind(choice.next))
		choices_container.add_child(button)

func _clear_choices():
	for child in choices_container.get_children():
		child.queue_free()

func _on_choice_selected(next_node: int):
	print("Scelta selezionata, prossimo nodo: ", next_node)
	current_story_node = next_node
	_show_current_node()

func _on_back_pressed():
	_transition_to_scene("res://scenes/Main.tscn")

func _transition_to_scene(scene_path: String):
	var fade_out = AnimationPlayer.new()
	add_child(fade_out)
	fade_out.play("fade_out")
	fade_out.connect("animation_finished", self, "_on_animation_finished", [scene_path])

func _on_animation_finished(scene_path: String):
	get_tree().change_scene(scene_path)
