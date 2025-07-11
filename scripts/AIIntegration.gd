extends Node

# Path to the Python AI module
const AI_MODULE_PATH = "ai/ai_game_manager.py"

func _ready():
	# Esempio di utilizzo: invia dati al modulo AI e riceve una risposta
	var player_state = {"level": 5, "health": 80}
	var ai_response = call_ai_module(player_state)
	print("AI Response: " + ai_response)  # Sostituito push_error con print

func call_ai_module(player_state: Dictionary) -> String:
	# Chiama il modulo AI Python e restituisce la risposta
	var json_data = JSON.stringify(player_state)
	var output = []
	var error = OS.execute("python", [AI_MODULE_PATH, json_data], output, true)

	if error == OK:
		return "\n".join(output)  # Usa il metodo `join` della stringa per concatenare gli elementi dell'array
	else:
		return "Errore nella comunicazione con il modulo AI."
