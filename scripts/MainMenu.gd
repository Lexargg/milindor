extends Control

# Main menu scene per Milindor Book Game
# Gestisce navigazione tra Character Creation, Story Mode, Settings

@onready var character_button = $VBoxContainer/CharacterButton
@onready var story_button = $VBoxContainer/StoryButton
@onready var settings_button = $VBoxContainer/SettingsButton
@onready var quit_button = $VBoxContainer/QuitButton

func _ready():
	print("Milindor Book Game - Inizializzazione Main Menu")
	_setup_ui()
	_connect_signals()

func _setup_ui():
	# Setup del tema e stile
	pass

func _connect_signals():
	character_button.pressed.connect(_on_character_pressed)
	story_button.pressed.connect(_on_story_pressed)
	settings_button.pressed.connect(_on_settings_pressed)
	quit_button.pressed.connect(_on_quit_pressed)

func _on_character_pressed():
	print("Avvio Character Creator")
	get_tree().change_scene_to_file("res://scenes/CharacterCreator.tscn")

func _on_story_pressed():
	print("Avvio Story Mode")
	get_tree().change_scene_to_file("res://scenes/StoryScreen.tscn")

func _on_settings_pressed():
	print("Apertura Settings")
	# TODO: Implementare settings screen

func _on_quit_pressed():
	print("Uscita dal gioco")
	get_tree().quit()
