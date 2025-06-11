extends Node2D

const CARD_SCENE_PATH = "res://Scenes/Card.tscn"
const CARD_DRAW_SPEED = 0.2

var player_deck = ["Knight", "Knight", "Knight"]

func _ready() -> void:
	$RichTextLabel.text = str(player_deck.size())
	
func draw_card() -> void:
	var card_drawn = player_deck[0]
	player_deck.erase(card_drawn)
	if player_deck.size() == 0:
		pass
