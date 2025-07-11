import json
import random

class AIGameManager:
    def __init__(self, game_data_path):
        # Carica i dati del gioco
        self.game_data_path = game_data_path
        self.game_data = self.load_game_data()

    def load_game_data(self):
        """Carica i dati del gioco da un file JSON."""
        try:
            with open(self.game_data_path, 'r') as file:
                data = json.load(file)
                print(f"Dati caricati correttamente: {data}")  # Messaggio di debug
                return data
        except FileNotFoundError:
            print(f"File {self.game_data_path} non trovato.")
            return {}

    def suggest_action(self, player_state):
        """Suggerisce un'azione basata sullo stato del giocatore."""
        # Esempio: suggerisce un'azione casuale tra quelle disponibili
        actions = self.game_data.get('progression', {}).get('actions', [])
        if actions:
            print(f"Azioni disponibili: {actions}")  # Messaggio di debug
            return random.choice(actions)
        print("Nessuna azione trovata nei dati.")  # Messaggio di debug
        return "Nessuna azione disponibile."

    def adapt_gameplay(self, player_state):
        """Adatta il gameplay in base allo stato del giocatore."""
        # Esempio: modifica la difficoltà in base al livello del giocatore
        difficulty = player_state.get('level', 1) * 1.5
        return f"Difficoltà impostata a {difficulty}"

# Esempio di utilizzo
if __name__ == "__main__":
    ai_manager = AIGameManager("data/gameplay/progression.json")
    player_state = {"level": 5, "health": 80}
    print(ai_manager.suggest_action(player_state))
    print(ai_manager.adapt_gameplay(player_state))
