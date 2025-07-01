extends Node2D

var card_scene = preload("res://Scenes/OpponentCard.tscn")
var card_database_reference = preload("res://Scripts/CardDatabase.gd")
var opponent_deck = [
	"Knight", "Archer", "Mage", "Knight",
	"Knight", "Archer", "Mage", "Knight",
]

func _ready() -> void:
	opponent_deck.shuffle()
	$RichTextLabel.text = str(opponent_deck.size())
	
	for i in range($"../BattleManager".STARTING_HAND_SIZE):
		draw_card()
	
func draw_card() -> void:
	# Safe check deck size
	if opponent_deck.size() < 1: return
	
	var card_drawn_name = opponent_deck[0]
	opponent_deck.erase(card_drawn_name)
	
	if opponent_deck.size() == 0:
		$Sprite2D.visible = false
		$RichTextLabel.visible = false
		
	$RichTextLabel.text = str(opponent_deck.size())
	var new_card = card_scene.instantiate()
	new_card.name = "Card"
	new_card.position = Vector2(position.x, position.y)
	new_card.get_node("CardImage").texture = load("res://Assets/" + card_drawn_name + ".png")
	new_card.get_node("Attack").text = str(card_database_reference.CARDS[card_drawn_name][0])
	new_card.get_node("Health").text = str(card_database_reference.CARDS[card_drawn_name][1])
	$"../CardManager".add_child(new_card)
	$"../OpponentHand".add_card_to_hand(new_card)
