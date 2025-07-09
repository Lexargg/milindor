extends Node

# Dark Fantasy Atmosphere Controller
# Ispirato a Lone Wolf, Dark Souls, Diablo, Warhammer Fantasy

class_name AtmosphereController

signal atmosphere_changed(new_mood)
signal horror_event_triggered(event_type)
signal mythic_moment_activated(moment_data)

# Atmospheric systems
var current_mood = "neutral"
var horror_intensity = 0.0
var mythic_presence = 0.0
var environmental_storytelling = {}

# Dark Fantasy elements inspired by Lone Wolf and dark fantasy literature
var atmosphere_presets = {
	"kai_monastery_ruins": {
		"description": "Le rovine del Monastero Kai giacciono in silenzio, testimoni di una gloria perduta",
		"mood": "melancholic_dread",
		"horror_level": 0.3,
		"color_palette": ["muted_grays", "blood_red", "shadow_black"],
		"ambient_sounds": ["distant_wind", "crumbling_stone", "whispered_prayers"]
	},
	"darklands_journey": {
		"description": "La terra desolata si estende all'infinito, punteggiata da rovine di civiltà perdute",
		"mood": "hopeless_determination", 
		"horror_level": 0.7,
		"color_palette": ["ash_gray", "rust_red", "void_black"],
		"ambient_sounds": ["howling_wind", "distant_screams", "metal_grinding"]
	},
	"sommerlund_under_siege": {
		"description": "Il regno brucia mentre le armate delle tenebre avanzano inesorabili",
		"mood": "desperate_heroism",
		"horror_level": 0.5,
		"color_palette": ["fire_orange", "smoke_gray", "blood_crimson"],
		"ambient_sounds": ["battle_cries", "burning_buildings", "dying_screams"]
	},
	"magnamund_deep_lore": {
		"description": "Antichi segreti susurrano dalle profondità del tempo, troppo terribili per essere compresi",
		"mood": "cosmic_dread",
		"horror_level": 0.9,
		"mythic_presence": 0.8,
		"color_palette": ["eldritch_purple", "void_black", "sickly_green"],
		"ambient_sounds": ["otherworldly_whispers", "reality_tearing", "madness_induced_laughter"]
	}
}

# Horror and dread mechanics
var horror_elements = {
	"body_horror": {
		"descriptions": [
			"La carne si contorce in forme innaturali",
			"Ossa sporgono attraverso la pelle in angoli impossibili",
			"Gli occhi si moltiplicano lungo il volto deformato"
		],
		"psychological_impact": 0.8,
		"visual_distortion": true
	},
	"cosmic_horror": {
		"descriptions": [
			"La realtà stessa sembra piegarsi e deformarsi",
			"Geometrie impossibili offendono la mente mortale",
			"Il tempo scorre in direzioni che non dovrebbero esistere"
		],
		"psychological_impact": 0.9,
		"sanity_damage": true
	},
	"existential_dread": {
		"descriptions": [
			"Il peso dell'infinita solitudine cosmica ti schiaccia",
			"Realizzi l'insignificanza della tua esistenza nell'universo",
			"La morte non è una fine, ma un inizio di qualcosa di peggiore"
		],
		"psychological_impact": 0.7,
		"long_term_effects": true
	}
}

# Mythic and legendary moments
var mythic_moments = {
	"ascension_trial": {
		"trigger_conditions": ["level_20_plus", "divine_quest_completed", "moral_alignment_extreme"],
		"description": "Il potere divino ti chiama a trascendere i limiti mortali",
		"visual_effects": ["golden_aura", "reality_ripples", "celestial_music"],
		"permanent_changes": true
	},
	"dark_apotheosis": {
		"trigger_conditions": ["evil_alignment", "demon_pact", "innocents_sacrificed"],
		"description": "Le tenebre ti abbracciano, offrendoti potere oltre ogni immaginazione",
		"visual_effects": ["shadow_tendrils", "blood_rain", "screaming_winds"],
		"corruption_level": 1.0
	},
	"kai_lord_awakening": {
		"trigger_conditions": ["kai_disciplines_mastered", "evil_defeated", "sacrifice_made"],
		"description": "L'antica saggezza dei Signori Kai si risveglia in te",
		"visual_effects": ["golden_light", "ancient_symbols", "peaceful_silence"],
		"special_abilities": ["kai_sight", "mindshield", "healing_touch"]
	}
}

func _ready():
	_initialize_atmosphere_systems()

func set_atmospheric_preset(preset_name: String):
	if not atmosphere_presets.has(preset_name):
		push_error("Atmospheric preset not found: " + preset_name)
		return
	
	var preset = atmosphere_presets[preset_name]
	current_mood = preset.mood
	horror_intensity = preset.get("horror_level", 0.0)
	mythic_presence = preset.get("mythic_presence", 0.0)
	
	_apply_visual_atmosphere(preset)
	_start_ambient_audio(preset.ambient_sounds)
	
	emit_signal("atmosphere_changed", current_mood)

func _apply_visual_atmosphere(preset: Dictionary):
	# Sistema di illuminazione dinamica per Dark Fantasy
	var lighting_controller = get_node_or_null("/root/LightingController")
	if lighting_controller:
		lighting_controller.set_color_palette(preset.color_palette)
		lighting_controller.adjust_contrast_for_mood(current_mood)
		lighting_controller.add_dramatic_shadows()

func trigger_horror_event(event_type: String, intensity: float = 0.5):
	if not horror_elements.has(event_type):
		return
	
	var horror_data = horror_elements[event_type]
	var description = horror_data.descriptions[randi() % horror_data.descriptions.size()]
	
	# Applica effetti psicologici
	if horror_data.has("sanity_damage"):
		_apply_sanity_damage(intensity)
	
	if horror_data.has("visual_distortion"):
		_apply_visual_distortion(intensity)
	
	# Notifica il sistema di storia
	var event_data = {
		"type": event_type,
		"description": description,
		"intensity": intensity,
		"psychological_impact": horror_data.psychological_impact
	}
	
	emit_signal("horror_event_triggered", event_data)

func check_for_mythic_moment(character_data: Dictionary, story_context: Dictionary):
	for moment_id in mythic_moments:
		var moment = mythic_moments[moment_id]
		if _conditions_met(moment.trigger_conditions, character_data, story_context):
			_trigger_mythic_moment(moment_id, moment)
			break

func _trigger_mythic_moment(moment_id: String, moment_data: Dictionary):
	# Momento epico che cambia permanentemente il personaggio
	mythic_presence = 1.0
	
	var moment_info = {
		"id": moment_id,
		"description": moment_data.description,
		"visual_effects": moment_data.visual_effects,
		"permanent_changes": moment_data.get("permanent_changes", false)
	}
	
	_apply_mythic_visual_effects(moment_data.visual_effects)
	
	emit_signal("mythic_moment_activated", moment_info)

func _apply_mythic_visual_effects(effects: Array):
	# Effetti visivi epici per momenti mitici
	for effect in effects:
		match effect:
			"golden_aura":
				_create_golden_particle_system()
			"reality_ripples":
				_distort_screen_reality()
			"shadow_tendrils":
				_spawn_dark_tentacles()
			"blood_rain":
				_start_crimson_precipitation()

func create_environmental_storytelling(location: String, history: Dictionary) -> Dictionary:
	# Sistema di storytelling ambientale come in Dark Souls
	var environmental_elements = {
		"visual_clues": [],
		"interactive_objects": [],
		"hidden_lore": [],
		"atmospheric_details": []
	}
	
	# Esempio per rovine di un monastero
	if location == "ruined_monastery":
		environmental_elements.visual_clues = [
			"Statue decapitate di antichi eroi",
			"Libri sacri bruciati sparsi per terra",
			"Macchie di sangue ancora fresche sui muri"
		]
		
		environmental_elements.interactive_objects = [
			{
				"name": "Altare profanato",
				"interaction": "Esamina le rune demoniache incise",
				"lore_revealed": "I demoni hanno compiuto un rituale di corruzione qui"
			},
			{
				"name": "Diario di un monaco",
				"interaction": "Leggi le ultime parole scritte",
				"lore_revealed": "Gli ultimi giorni prima dell'attacco erano pieni di presagi funesti"
			}
		]
	
	return environmental_elements

# Sistema di progressione atmosferica
func evolve_atmosphere_based_on_choices(moral_choices: Array):
	var alignment_trend = _calculate_alignment_trend(moral_choices)
	
	if alignment_trend < -0.5:  # Tendenza malvagia
		_shift_to_darker_atmosphere()
	elif alignment_trend > 0.5:  # Tendenza buona  
		_shift_to_hopeful_atmosphere()
	else:  # Neutrale
		_maintain_gritty_realism()

func _shift_to_darker_atmosphere():
	# Il mondo diventa più corrotto e minaccioso
	horror_intensity = min(horror_intensity + 0.1, 1.0)
	_increase_environmental_decay()
	_spawn_more_undead_encounters()

func _shift_to_hopeful_atmosphere():
	# Piccoli segni di speranza iniziano a manifestarsi
	horror_intensity = max(horror_intensity - 0.05, 0.1)
	_add_signs_of_renewal()
	_increase_helpful_npc_encounters()

func get_current_atmosphere_description() -> String:
	var base_description = ""
	
	match current_mood:
		"melancholic_dread":
			base_description = "Un senso di perdita permea l'aria, come se il mondo stesso piangesse per ciò che è andato perduto."
		"hopeless_determination":
			base_description = "Nonostante tutto sembri perduto, una fiamma di determinazione arde ancora nel tuo cuore."
		"cosmic_dread":
			base_description = "La realtà stessa sembra fragile, come se forze incomprensibili premessero ai confini dell'esistenza."
		"desperate_heroism":
			base_description = "In questo momento buio, solo il coraggio può fare la differenza tra salvezza e dannazione."
	
	# Modifica basata su intensità horror
	if horror_intensity > 0.7:
		base_description += " Un terrore primordiale ti attanaglia, sussurrando che alcuni segreti non dovrebbero mai essere svelati."
	elif horror_intensity > 0.4:
		base_description += " Un disagio sottile ma persistente ti accompagna, come se fossi osservato da occhi invisibili."
	
	return base_description
