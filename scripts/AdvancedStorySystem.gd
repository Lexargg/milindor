extends Node

# Advanced Story System - AI-Powered Dynamic Narrative
# Supera il sistema di Pathfinder: WotR con storie procedurali e reactive

class_name AdvancedStorySystem

signal story_choice_made(choice_data)
signal character_reputation_changed(faction, value)
signal mythic_moment_triggered(moment_type)

# Core story components
var story_database = {}
var character_profile = {}
var world_state = {}
var faction_relationships = {}
var moral_alignment_tracker = {}

# AI Story Generation
var story_ai_prompts = {}
var procedural_quest_generator = {}
var dynamic_npc_personalities = {}

# Dark Fantasy atmosphere elements
var atmosphere_controller = {}
var moral_choice_consequences = {}

func _ready():
	_initialize_story_systems()
	_load_story_database()
	_setup_ai_components()

func _initialize_story_systems():
	# Sistema di reputazione complesso
	faction_relationships = {
		"order_of_light": {"reputation": 0, "trust_level": "neutral"},
		"shadow_covenant": {"reputation": 0, "trust_level": "neutral"},
		"merchants_guild": {"reputation": 0, "trust_level": "neutral"},
		"arcane_circle": {"reputation": 0, "trust_level": "neutral"},
		"nature_wardens": {"reputation": 0, "trust_level": "neutral"},
		"undead_lords": {"reputation": 0, "trust_level": "hostile"},
		"demon_cults": {"reputation": 0, "trust_level": "hostile"}
	}
	
	# Sistema di allineamento morale dinamico
	moral_alignment_tracker = {
		"law_chaos_axis": 0,  # -100 (Chaos) to +100 (Law)
		"good_evil_axis": 0,  # -100 (Evil) to +100 (Good)
		"actions_history": [],
		"major_moral_choices": []
	}

func generate_dynamic_story(context: Dictionary) -> Dictionary:
	# AI-powered story generation based on:
	# - Character background and choices
	# - Current world state
	# - Faction relationships
	# - Moral alignment
	
	var story_parameters = {
		"character_level": character_profile.get("level", 1),
		"dominant_alignment": _calculate_alignment(),
		"primary_faction": _get_primary_faction(),
		"recent_actions": _get_recent_actions(5),
		"world_threats": _get_active_world_threats(),
		"atmospheric_tone": _determine_current_atmosphere()
	}
	
	return _ai_generate_story_node(story_parameters)

func _ai_generate_story_node(parameters: Dictionary) -> Dictionary:
	# Simulated AI story generation
	# In produzione, questo si connetterebbe a un LLM locale
	
	var base_scenarios = _get_appropriate_scenarios(parameters)
	var selected_scenario = _weight_scenario_selection(base_scenarios, parameters)
	
	var story_node = {
		"id": generate_unique_id(),
		"title": selected_scenario.title,
		"description": _enhance_description_with_character_context(selected_scenario.description),
		"atmosphere": _generate_atmospheric_elements(),
		"choices": _generate_contextual_choices(selected_scenario, parameters),
		"consequences": _predict_choice_consequences(selected_scenario),
		"skill_checks": _generate_dynamic_skill_checks(parameters),
		"combat_encounters": _generate_appropriate_encounters(parameters)
	}
	
	return story_node

func _generate_contextual_choices(scenario: Dictionary, params: Dictionary) -> Array:
	var choices = []
	
	# Scelte basate sulla classe del personaggio
	if character_profile.get("class") == "wizard":
		choices.append({
			"text": "Analizza la situazione con la magia",
			"type": "class_specific",
			"skill_required": "Spellcraft",
			"dc": 15,
			"success_outcome": "magical_insight",
			"failure_outcome": "magical_backlash"
		})
	
	# Scelte basate sulla razza
	if character_profile.get("race") == "elf":
		choices.append({
			"text": "Usa i tuoi sensi elfici per percepire dettagli nascosti",
			"type": "racial_specific", 
			"skill_required": "Perception",
			"dc": 12,
			"racial_bonus": 2
		})
	
	# Scelte morali complesse con conseguenze a lungo termine
	choices.append({
		"text": "Salva i civili innocenti a rischio della tua vita",
		"type": "moral_choice",
		"alignment_shift": {"good_evil_axis": 10, "law_chaos_axis": 5},
		"faction_effects": {"order_of_light": 20, "demon_cults": -30},
		"long_term_consequences": ["civilians_remember_heroism", "demons_mark_as_enemy"]
	})
	
	choices.append({
		"text": "Sfrutta la situazione per il tuo vantaggio personale",
		"type": "moral_choice",
		"alignment_shift": {"good_evil_axis": -15, "law_chaos_axis": -5},
		"faction_effects": {"merchants_guild": 15, "order_of_light": -10},
		"long_term_consequences": ["reputation_as_opportunist", "wealth_increase"]
	})
	
	return choices

func process_choice_consequences(choice: Dictionary, outcome: String):
	# Gestisce le conseguenze delle scelte in modo più profondo di PF:WotR
	
	# Aggiorna allineamento morale
	if choice.has("alignment_shift"):
		_apply_alignment_shift(choice.alignment_shift)
	
	# Aggiorna relazioni fazioni
	if choice.has("faction_effects"):
		_apply_faction_changes(choice.faction_effects)
	
	# Conseguenze a lungo termine
	if choice.has("long_term_consequences"):
		_register_long_term_consequences(choice.long_term_consequences)
	
	# Trigger eventi speciali
	_check_for_special_story_triggers()
	
	# Aggiorna stato del mondo
	_update_world_state_from_choice(choice, outcome)

func _generate_atmospheric_elements() -> Dictionary:
	# Sistema atmosferico per Dark Fantasy
	var atmosphere_elements = {
		"weather": _generate_ominous_weather(),
		"ambient_sounds": _select_dark_ambient(),
		"lighting": _determine_dramatic_lighting(),
		"npc_moods": _generate_npc_emotional_states(),
		"environmental_storytelling": _create_environmental_narrative()
	}
	
	return atmosphere_elements

func _generate_ominous_weather() -> Dictionary:
	var weather_options = [
		{"type": "storm", "description": "Tuoni minacciosi rimbombano in lontananza", "mood_modifier": -2},
		{"type": "fog", "description": "Una nebbia innaturale avvolge il paesaggio", "visibility_penalty": -4},
		{"type": "blood_rain", "description": "Gocce rossastre cadono dal cielo plumbeo", "supernatural": true},
		{"type": "perpetual_twilight", "description": "Il sole sembra non voler tramontare mai", "time_distortion": true}
	]
	
	return weather_options[randi() % weather_options.size()]

# Sistema di quest procedurali
func generate_procedural_quest(difficulty_level: int, theme: String) -> Dictionary:
	var quest_templates = {
		"investigation": {
			"base_structure": "mystery_to_solve",
			"complications": ["false_leads", "corrupt_officials", "supernatural_interference"],
			"resolution_types": ["combat", "negotiation", "puzzle_solving"]
		},
		"moral_dilemma": {
			"base_structure": "conflicting_interests", 
			"stakeholders": ["innocent_victims", "corrupt_authority", "desperate_family"],
			"no_perfect_solution": true
		},
		"survival_horror": {
			"base_structure": "escalating_threat",
			"horror_elements": ["body_horror", "psychological_tension", "cosmic_dread"],
			"escape_rather_than_victory": true
		}
	}
	
	return _build_quest_from_template(quest_templates[theme], difficulty_level)

func _setup_ai_components():
	# Setup per AI locale (futuro)
	story_ai_prompts = {
		"character_development": "Create a personal character moment that challenges their beliefs...",
		"faction_conflict": "Generate a conflict between two factions that forces difficult choices...",
		"mythic_ascension": "Design a trial worthy of mythic ascension that tests both power and wisdom...",
		"dark_revelation": "Reveal a terrible truth about the world that changes everything..."
	}

# Sistema di reputation più complesso di PF:WotR
func _calculate_reputation_effects() -> Dictionary:
	var effects = {}
	
	for faction in faction_relationships:
		var rep_value = faction_relationships[faction].reputation
		var trust_level = faction_relationships[faction].trust_level
		
		# Effetti basati su reputazione
		if rep_value > 50:
			effects[faction + "_benefits"] = ["discounted_services", "exclusive_information", "backup_in_crisis"]
		elif rep_value < -50:
			effects[faction + "_penalties"] = ["hostile_encounters", "sabotage_attempts", "bounty_on_head"]
	
	return effects

func save_story_state() -> Dictionary:
	return {
		"character_profile": character_profile,
		"world_state": world_state,
		"faction_relationships": faction_relationships,
		"moral_alignment": moral_alignment_tracker,
		"atmospheric_state": atmosphere_controller
	}

func load_story_state(save_data: Dictionary):
	character_profile = save_data.get("character_profile", {})
	world_state = save_data.get("world_state", {})
	faction_relationships = save_data.get("faction_relationships", {})
	moral_alignment_tracker = save_data.get("moral_alignment", {})
	atmosphere_controller = save_data.get("atmospheric_state", {})
