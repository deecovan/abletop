extends Node2D

const CARD_DRAW_SPEED = 0.2

var card_scene = preload("res://Scenes/Card.tscn")
var player_deck = ["Knight", "Knight", "Knight"]

func _ready() -> void:
	$RichTextLabel.text = str(player_deck.size())
	draw_card()
	
func draw_card() -> void:
	var card_drawn = player_deck[0]
	player_deck.erase(card_drawn)
	if player_deck.size() == 0:
		$Area2D/CollisionShape2D.disabled = true
		$Sprite2D.visible = false
		$RichTextLabel.visible = false
		
	$RichTextLabel.text = str(player_deck.size())
	var new_card = card_scene.instantiate()
	$"../CardManager".add_child(new_card)
	new_card.name = "Card"
	$"../PlayerHand".add_card_to_hand(new_card, CARD_DRAW_SPEED)
