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

func _ready():
	print("Story Screen - Inizializzazione")
	character_data = GameManager.get_current_character()
	_load_story_data()
	_setup_ui()
	_show_current_node()

func _load_story_data():
	# Storia di esempio per Milindor
	story_data = [
		{
			"id": 0,
			"text": "Ti risvegli in una taverna affollata di Milindor. La tua ultima memoria è di un lampo di luce magica. Un misterioso incappucciato si avvicina al tuo tavolo...",
			"choices": [
				{"text": "Ascolti quello che ha da dire", "next": 1},
				{"text": "Ti alzi e te ne vai", "next": 2},
				{"text": "Lo affronti direttamente", "next": 3}
			]
		},
		{
			"id": 1,
			"text": "L'incappucciato sussurra: 'Il regno è in pericolo. Solo tu puoi fermare l'Ombra che avanza dal Nord.' Ti porge un antico medaglione...",
			"choices": [
				{"text": "Accetti la missione", "next": 4},
				{"text": "Rifiuti e chiedi spiegazioni", "next": 5}
			]
		},
		{
			"id": 2,
			"text": "Mentre esci dalla taverna, noti che le strade sono stranamente deserte. Un urlo echeggia nella notte...",
			"choices": [
				{"text": "Corri verso l'urlo", "next": 6},
				{"text": "Ti nascondi nell'ombra", "next": 7}
			]
		},
		{
			"id": 3,
			"text": "L'incappucciato sorride: 'Coraggio! Proprio quello che cercavo. Sei tu l'eroe di cui parlano le profezie.'",
			"choices": [
				{"text": "Chiedi delle profezie", "next": 8},
				{"text": "Rimani scettico", "next": 9}
			]
		}
		# Altri nodi della storia...
	]

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
	get_tree().change_scene_to_file("res://scenes/Main.tscn")
