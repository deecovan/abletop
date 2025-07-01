extends Node

const STARTING_HAND_SIZE = 4
var empty_monster_card_slots = []
var opponent_deck

func _ready() -> void:
	opponent_deck = $"../OpponentDeck"
	empty_monster_card_slots = [
		$"../OpponentCardSlots/CardSlot", 
		$"../OpponentCardSlots/CardSlot2",
		$"../OpponentCardSlots/CardSlot3",
		$"../OpponentCardSlots/CardSlot4",
		$"../OpponentCardSlots/CardSlot5",
		$"../OpponentCardSlots/CardSlot6",
		$"../OpponentCardSlots/CardSlot7",
		$"../OpponentCardSlots/CardSlot8"
	]

func _on_end_turn_button_pressed() -> void:
	opponent_turn()

func opponent_turn() -> void:
	$EndTurnButton.disabled = true
	$EndTurnButton.visible = false
	await battle_timer()
	
	# Implement turn
	## Draw a card
	if opponent_deck.opponent_deck.size() > 0:
		opponent_deck.draw_card()
		await battle_timer()
	
	if opponent_deck.opponent_deck.size() > 0:
		$EndTurnButton.disabled = false
		$EndTurnButton.visible = true
		
	if empty_monster_card_slots.size() == 0:
		end_opponent_turn()
		return
	
	await try_play_card()
	end_opponent_turn()
	
func  try_play_card():
	print("try_play_card()")
	return battle_timer()

func end_opponent_turn() -> void:
	print("end_opponent_turn()")
	


func battle_timer(delay = 500.0 * randf()):
	$BattleTimer.wait_time = delay / 1000
	$BattleTimer.start()
	return $BattleTimer.timeout
