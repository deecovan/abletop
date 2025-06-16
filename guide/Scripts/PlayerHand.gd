extends Node2D

const CARD_WIDTH = 150
const HAND_X_POSITION = 150
const HAND_Y_POSITION = 575
const DEFAULT_CARD_MOVE_SPEED = 0.2

var card_scene = preload("res://Scenes/Card.tscn")
var player_hand = []
var center_screen_x = 0

func _ready() -> void:
	center_screen_x = get_viewport().size.x / 2

func add_card_to_hand(card) -> void:
	if card not in player_hand:
		player_hand.insert(0, card)
		update_hand_positions(DEFAULT_CARD_MOVE_SPEED)
	else:
		animate_card_to_position(card, card.starting_position, DEFAULT_CARD_MOVE_SPEED)
		pass

func update_hand_positions(speed) -> void:
	for i in range(player_hand.size()):
		var new_position = Vector2(calculate_card_position(i), HAND_Y_POSITION)
		var card = player_hand[i]
		animate_card_to_position(card, new_position, speed)
	
func calculate_card_position(index) -> float:
	var total_width = player_hand.size() * CARD_WIDTH
	@warning_ignore("integer_division")
	var x_offset = HAND_X_POSITION + center_screen_x + index * CARD_WIDTH - total_width / 2
	return x_offset
	
func animate_card_to_position(card, new_position, speed) -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(card, "position", new_position, speed)
	
func remove_card_from_hand(card) -> void:
		if card in player_hand:
			player_hand.erase(card)
			update_hand_positions(DEFAULT_CARD_MOVE_SPEED)
			
