extends Node2D

var card_scene = preload("res://Scenes/OpponentCard.tscn")
var card_database_reference = preload("res://Scripts/CardDatabase.gd")
var opponent_deck = [
	"Wall",
	"Wall",
	"Water",
	"Water",
	"Peasant",
	"Peasant",
	"Peasant",
	"Peasant",
	"Sergant",
	"Sergant",
	"Knight",
	"Tank",
	"Pikiner",
	"Pikiner",
	"Pikiner",
	"Pikiner",
	"Ranger",
	"Ranger",
	"Archer",
	"Mage",
]

func _ready() -> void:
	## Double deck
	opponent_deck += opponent_deck
	opponent_deck.shuffle()
	$RichTextLabel.text = str(opponent_deck.size())
	for i in range($"../CardManager".STARTING_HAND_SIZE):
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
	new_card.position = Vector2(position.x, position.y)
	# Init card nnodes
	new_card.get_node("CardImage").texture = load("res://Assets/" + card_drawn_name + ".png")
	new_card.get_node("Name").text = card_drawn_name
	new_card.get_node("Attack").text = str(card_database_reference.CARDS[card_drawn_name][0])
	new_card.get_node("Health").text = str(card_database_reference.CARDS[card_drawn_name][1])
	# Init card values
	new_card.attack = card_database_reference.CARDS[card_drawn_name][0]
	new_card.health = card_database_reference.CARDS[card_drawn_name][1]
	new_card.ranged = card_database_reference.CARDS[card_drawn_name][2]
	new_card.value = card_database_reference.CARDS[card_drawn_name][3]
	$"../CardManager".add_child(new_card)
	new_card.name = card_drawn_name + "_" + str(new_card.get_parent().get_index())
	## @DEBUG
	print("DRAW" 
		+ " card: " + str(new_card.name) 
		+ " range: " + str(new_card.ranged) 
		+ " value: " + str(new_card.value) )
	$"../OpponentHand".add_card_to_hand(new_card)
