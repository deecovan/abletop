extends Node2D

const CARD_DRAW_SPEED = 0.2

var card_scene = preload("res://Scenes/Card.tscn")
var card_database_reference = preload("res://Scripts/CardDatabase.gd")
var player_deck = ["Knight", "Archer", "Daemon", "Knight"]

func _ready() -> void:
	draw_card()
	$RichTextLabel.text = str(player_deck.size())
	
func draw_card() -> void:
	player_deck.shuffle()
	var card_drawn = player_deck[0]
	player_deck.erase(card_drawn)
	if player_deck.size() == 0:
		$Area2D/CollisionShape2D.disabled = true
		$Sprite2D.visible = false
		$RichTextLabel.visible = false
		
	$RichTextLabel.text = str(player_deck.size())
	var new_card = card_scene.instantiate()
	new_card.name = "Card"
	new_card.get_node("Attack").text = str(card_database_reference.CARDS[card_drawn][0])
	new_card.get_node("Health").text = str(card_database_reference.CARDS[card_drawn][1])
	$"../CardManager".add_child(new_card)
	$"../PlayerHand".add_card_to_hand(new_card, CARD_DRAW_SPEED)
