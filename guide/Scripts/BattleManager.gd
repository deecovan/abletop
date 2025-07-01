extends Node

const STARTING_HAND_SIZE = 4
var empty_monster_card_slots = []
var opponent_deck

func _ready() -> void:
	opponent_deck = $"../OpponentDeck"

func _on_end_turn_button_pressed() -> void:
	opponent_turn()

func opponent_turn() -> void:
	$EndTurnButton.disabled = true
	$EndTurnButton.visible = false
	await battle_timer(500.0 * randf())
	
	# Implement turn
	## Draw a card
	if opponent_deck.opponent_deck.size() > 0:
		opponent_deck.draw_card()
		await battle_timer(500.0 * randf())
	
	if opponent_deck.opponent_deck.size() > 0:
		$EndTurnButton.disabled = false
		$EndTurnButton.visible = true

func battle_timer(delay = 1000.0):
	$BattleTimer.wait_time = delay / 1000
	$BattleTimer.start()
	return $BattleTimer.timeout
