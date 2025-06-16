extends Node2D

const HAND_COUNT = 2
const CARD_WIDTH = 150
const HAND_Y_POSITION = 575
const DEFAULT_CARD_MOVE_SPEED = 0.2

var card_scene = preload("res://Scenes/Card.tscn")
var card_database_reference = preload("res://Scripts/CardDatabase.gd")
var player_deck = ["Knight", "Archer", "Daemon", "Knight"]

func _ready() -> void:
	player_deck.shuffle()
	$RichTextLabel.text = str(player_deck.size())
	
func draw_card() -> void:
	var card_drawn_name = player_deck[0]
	player_deck.erase(card_drawn_name)
	
	if player_deck.size() == 0:
		$Area2D/CollisionShape2D.disabled = true
		$Sprite2D.visible = false
		$RichTextLabel.visible = false
		
	$RichTextLabel.text = str(player_deck.size())
	var new_card = card_scene.instantiate()
	new_card.name = "Card"
	new_card.position = Vector2(position.x + CARD_WIDTH, position.y)
	new_card.get_node("CardImage").texture = load("res://Assets/" + card_drawn_name + ".png")
	new_card.get_node("Attack").text = str(card_database_reference.CARDS[card_drawn_name][0])
	new_card.get_node("Health").text = str(card_database_reference.CARDS[card_drawn_name][1])
	$"../CardManager".add_child(new_card)
	$"../PlayerHand".add_card_to_hand(new_card)
