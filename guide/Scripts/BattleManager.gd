extends Node

var opponent_card_slots = []
var empty_opponent_card_slots = []
var opponent_deck
var player_cards_on_battlefield = []
var opponent_cards_on_battlefield = []
var player_cards_in_graveyard = []
var opponent_cards_in_graveyard = []

const PLAYER = "Player"
const OPPONENT = "Opponent"


func _ready() -> void:
	opponent_deck = $"../OpponentDeck"
	opponent_card_slots = [ 
		## Ordered by Godot's Sorting Idiotism
		# Line 1 for range 2..inf
		$"../OpponentCardSlots/CardSlot5",
		$"../OpponentCardSlots/CardSlot",
		$"../OpponentCardSlots/CardSlot4",
		$"../OpponentCardSlots/CardSlot2",
		$"../OpponentCardSlots/CardSlot3",
		# Line 2 for range = 0..1
		$"../OpponentCardSlots/CardSlot8",
		$"../OpponentCardSlots/CardSlot7",
		$"../OpponentCardSlots/CardSlot9",
		$"../OpponentCardSlots/CardSlot6",
		$"../OpponentCardSlots/CardSlot10",
	]
	# Show info for 5 sec
	$"RichTextLabel".visible = true
	await battle_timer(5000)
	$"RichTextLabel".visible = false


func _on_end_turn_button_pressed() -> void:
	opponent_turn()


func opponent_turn() -> void:
	$EndTurnButton.disabled = true
	$EndTurnButton.visible = false
	## Draw a card
	var opponent_hand = $"../OpponentHand".opponent_hand
	if (opponent_deck.opponent_deck.size() > 0 
			and opponent_hand.size() < $"../CardManager".MAX_CARD_IN_HAND):
		# Think
		battle_timer()
		opponent_deck.draw_card()
	if opponent_deck.opponent_deck.size() > 0:
		$EndTurnButton.disabled = false
		$EndTurnButton.visible = true
	# Think
	await battle_timer()
	# play
	try_play_card()
	# final
	end_opponent_turn()
	
	
func  try_play_card():
	## @DEBUG
	# print("try_play_card():")
	var opponent_hand = $"../OpponentHand".opponent_hand
	if opponent_hand.size() != 0:
		## Recalculate values in slots
		# iterate hand cards and recalculate weights with slots
		# 1. walls and waters (range 0) heve values only in slots 0..3
		# 2. close-range cards have less values in slots 4..7, but more in 0..3
		# 3. ranged cards have less in 0..5 and more 5..10
		## Init vars
		var last_drawn_card = opponent_hand[opponent_hand.size()-1]
		var card_with_max_value = last_drawn_card
		var card_calc_max_value = last_drawn_card.value
		var play_card_to_slot = null
		
		## Recalculate values in slots for Ranged cards
		for slot_number in range(0,5): 
			# check if slot is empty
			if not opponent_card_slots[slot_number].card_in_slot:
				## Iterate cards in hand
				for card in opponent_hand:
					var card_in_slot_value = card.value
					if card.ranged > 2:
						## Ranged
						card_in_slot_value = card.value * 2
					elif card.ranged > 1:
						## Pikas
						card_in_slot_value = card.value * 1.5
					elif card.ranged == 1:
						## Mellee
						card_in_slot_value = card.value * 0.5
					elif card.ranged == 0:
						## Walls
						card_in_slot_value = 0
						## Find maximum
					if card_in_slot_value >= card_calc_max_value:
						play_card_to_slot = opponent_card_slots[slot_number]
						card_calc_max_value = card_in_slot_value
						card_with_max_value = card

		## Recalculate values in slots for Close-Range cards
		for slot_number in range(5,10): 
			# check if slot is empty
			if not opponent_card_slots[slot_number].card_in_slot:
				## Iterate cards in hand
				for card in opponent_hand:
					var card_in_slot_value = card.value
					if card.ranged == 0:
						## Walls
						card_in_slot_value = card.value * 2.0
					elif card.ranged == 1:
						## Mellee
						card_in_slot_value = card.value * 1.5
					elif card.ranged > 1:
						## Pikas
						card_in_slot_value = card.value * 1.1
					elif card.ranged > 2:
						## Ranged
						card_in_slot_value = (card.value) / 3.0
						## Find maximum
					if card_in_slot_value > card_calc_max_value:
						play_card_to_slot = opponent_card_slots[slot_number]
						card_calc_max_value = card_in_slot_value
						card_with_max_value = card
				
		## Play the card if the slot is used
		if play_card_to_slot:
			# Put the card to the slot
			play_card_to_slot.card_in_slot = card_with_max_value
			opponent_cards_on_battlefield.append(card_with_max_value)
			card_with_max_value.card_slot_card_is_in = play_card_to_slot
			# Animate
			var tween = get_tree().create_tween()
			tween.tween_property(card_with_max_value, "position", play_card_to_slot.position, 
				$"../CardManager".DEFAULT_CARD_MOVE_SPEED)
			card_with_max_value.get_node("AnimationPlayer").play("Flip")
			$"../OpponentHand".remove_card_from_hand(card_with_max_value)
			## @DEBUG
			print("PLAY" 
				+ " name: " + str(card_with_max_value.name) 
				+ " range: " + str(card_with_max_value.ranged) 
				+ " value: " + str(card_calc_max_value)
				+ " slot: " + str(play_card_to_slot.name)  )
		## Can NOT play card:
		else:
			## @DEBUG
			print("CANT play: cards in the hand:")
			for card in opponent_hand:
				print("CARD" 
					+ " name: " + str(card.name) 
					+ " range: " + str(card.ranged) 
					+ " value: " + str(card.value) )

func end_opponent_turn() -> void:
	pass
	
func attack(att_card: Node2D, def_card: Node2D, attacker) -> void:
	var att_card_z_index = att_card.z_index
	att_card.z_index = 50
	var new_pos = Vector2(def_card.position.x, def_card.position.y \
		+ $"../CardManager".DEFAULT_CARD_Y_OFFSET)
		
	var tween = get_tree().create_tween()
	tween.tween_property(att_card, "position", new_pos, \
		$"../CardManager".DEFAULT_CARD_MOVE_SPEED)
	await battle_timer()
	var tween2 = get_tree().create_tween()
	tween2.tween_property(att_card, "position", att_card.card_slot_card_is_in.position, \
		$"../CardManager".DEFAULT_CARD_MOVE_SPEED)
		
	## Deal damage to each other
	## @TODO use on-update trigger instead
	def_card.health = max(0, def_card.health - att_card.attack)
	var def_card_healt = def_card.get_node("Health")
	if def_card_healt.text != str(def_card.health):
		def_card_healt.text = str(def_card.health)
		def_card_healt.modulate = Color.FIREBRICK
	att_card.health = max(0, att_card.health - def_card.attack)
	var att_card_healt = att_card.get_node("Health")
	if att_card_healt.text != str(att_card.health):
		att_card_healt.text = str(att_card.health)
		att_card_healt.modulate = Color.FIREBRICK
		
	await battle_timer()
	att_card.z_index = att_card_z_index
	
	if att_card.health == 0:
		destroy_card(att_card)
	if def_card.health == 0:
		destroy_card(def_card)
	
	
func destroy_card(card: Node2D) -> void:
	## @DEBUG
	printt("KILL card", str(card.name))
	var new_pos
	var new_rot
	var hide_cards = []
	if card in player_cards_on_battlefield:
		## @DEBUG
		printt("IN Player's", card.card_slot_card_is_in.name)
		hide_cards = player_cards_in_graveyard
		player_cards_in_graveyard.append(card)
		player_cards_on_battlefield.erase(card)
		new_pos = $"../PlayerDiscard".position
		new_rot = $"../PlayerDiscard".rotation
	elif card in opponent_cards_on_battlefield:
		# @DEBUG
		printt("In Opponent's", card.card_slot_card_is_in.name)
		hide_cards = opponent_cards_in_graveyard
		opponent_cards_in_graveyard.append(card)
		opponent_cards_on_battlefield.erase(card)
		new_pos = $"../OpponentDiscard".position
		new_rot = $"../OpponentDiscard".rotation
	else: return
	
	if card.card_slot_card_is_in:
		card.card_slot_card_is_in.card_in_slot = false
		## Disable Player's Card collision
		if card in player_cards_on_battlefield:
			card.get_node("Area2D/CollisionShape2D").disabled = true
	card.card_slot_card_is_in = null
	card.z_index = 5
	
	var tween = get_tree().create_tween()
	tween.tween_property(card, "position", new_pos, \
		$"../CardManager".DEFAULT_CARD_MOVE_SPEED)
	tween.tween_property(card, "rotation", new_rot, \
		$"../CardManager".DEFAULT_CARD_ZOOM_SPEED)
	tween.tween_property(card, "scale", $"../CardManager".ZOOM_NORMAL,\
		$"../CardManager".DEFAULT_CARD_ZOOM_SPEED)
	
	await battle_timer()
	for hide_card in hide_cards:
		if card != hide_card:
			hide_card.visible = false


func battle_timer(delay = 200.0 + 200.0 * randf()):
	$BattleTimer.wait_time = delay / 1000
	$BattleTimer.start()
	return $BattleTimer.timeout
