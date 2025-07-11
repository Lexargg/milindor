import random

class AISystem:
    def __init__(self, lore, npc, missions):
        self.lore = lore
        self.npc = npc
        self.missions = missions

    def guide_player(self, player_action):
        """Suggerisce azioni basate sul comportamento del giocatore."""
        if player_action == "explore":
            return random.choice(self.lore)
        elif player_action == "interact_npc":
            return random.choice(self.npc)
        elif player_action == "start_mission":
            return random.choice(self.missions)
        else:
            return "Non ho suggerimenti per questa azione."

    def adapt_gameplay(self, difficulty):
        """Adatta la difficoltà del gioco."""
        if difficulty == "easy":
            return "Missioni semplificate e nemici meno aggressivi."
        elif difficulty == "hard":
            return "Missioni complesse e nemici più forti."
        else:
            return "Difficoltà standard."

# Esempio di utilizzo
lore = ["Scopri i segreti della Forgia Celeste.", "Esplora la Foresta di Sylvarion."]
npc = ["Aurion il Saggio", "Sylvaris l'Incantatore"]
missions = ["Difendi le Pianure Dorate.", "Ripristina l'equilibrio magico a Sylvaria."]

ai = AISystem(lore, npc, missions)
print(ai.guide_player("explore"))
print(ai.adapt_gameplay("easy"))
