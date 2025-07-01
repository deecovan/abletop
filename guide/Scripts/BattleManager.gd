extends Node

var battle_timer

const STARTING_HAND_SIZE = 4


func _on_end_turn_button_pressed() -> void:
	opponent_turn()


func opponent_turn() -> void:
	$EndTurnButton.disabled = true
	$EndTurnButton.visible = false
	
	$"../OpponentDeck".draw_card()
	
	$BattleTimer.start()
	await $BattleTimer.timeout
	
	# Implement turn
	
	$EndTurnButton.disabled = false
	$EndTurnButton.visible = true
