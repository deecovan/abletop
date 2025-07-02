extends Node

var empty_card_slots = []
var opponent_deck

func _ready() -> void:
	opponent_deck = $"../OpponentDeck"
	empty_card_slots = [
		$"../OpponentCardSlots/CardSlot", 
		$"../OpponentCardSlots/CardSlot2",
		$"../OpponentCardSlots/CardSlot3",
		$"../OpponentCardSlots/CardSlot4",
		$"../OpponentCardSlots/CardSlot5",
		$"../OpponentCardSlots/CardSlot6",
		$"../OpponentCardSlots/CardSlot7",
		$"../OpponentCardSlots/CardSlot8"
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
	await battle_timer()
	
	# Implement turn
	## Draw a card
	var opponent_hand = $"../OpponentHand".opponent_hand
	if (opponent_deck.opponent_deck.size() > 0 
			and opponent_hand.size() < $"../CardManager".MAX_CARD_IN_HAND):
		# twice
		opponent_deck.draw_card()
		await battle_timer()
		opponent_deck.draw_card()
		await battle_timer()
	
	if opponent_deck.opponent_deck.size() > 0:
		$EndTurnButton.disabled = false
		$EndTurnButton.visible = true
		
	if empty_card_slots.size() == 0:
		end_opponent_turn()
		return
	
	# twice
	await try_play_card()
	await try_play_card()
	# final
	end_opponent_turn()
	
func  try_play_card():
	var opponent_hand = $"../OpponentHand".opponent_hand
	if opponent_hand.size() != 0:
		# Find a card with highest Value
		var random_slot = empty_card_slots[randi_range(0, empty_card_slots.size()-1)]
		empty_card_slots.erase(random_slot)
		var card_with_highest_value = opponent_hand[0]
		for card in opponent_hand:
			if card.value > card_with_highest_value.value:
				card_with_highest_value = card
		# Put the card to the slot
		var tween = get_tree().create_tween()
		tween.tween_property(card_with_highest_value, "position", random_slot.position, 
			$"../CardManager".DEFAULT_CARD_MOVE_SPEED)
		card_with_highest_value.get_node("AnimationPlayer").play("Flip")
		$"../OpponentHand".remove_card_from_hand(card_with_highest_value)
		
	# return timeout
	return battle_timer()

func end_opponent_turn() -> void:
	pass
	


func battle_timer(delay = 500.0 * randf()):
	$BattleTimer.wait_time = delay / 1000
	$BattleTimer.start()
	return $BattleTimer.timeout
