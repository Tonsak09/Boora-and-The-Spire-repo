extends Sprite2D

@export var Inventory : Area2D
@export var cauldron : Node2D
@export var rangeToPull : float

@export var shopLabel : Label
@export var castTexture : Texture
@export var hand : Node2D


@export var ShoppingLists : Array[Array]

var currList : int # Index for list in ShoppingLists
var currShoppingList : Array # Each index refers to num of item 
var typeToCharIndex : Array # What is the number character's index based on type 

var shopListTotal : int

func _ready():
	GenerateShoppingListInternal()

func _process(delta):
	if (global_position - Inventory.global_position).length_squared() / 1000 < rangeToPull && Inventory.items.size() > 0:
		for item in Inventory.items:
			item.StartAbsorb(cauldron) # Animate to cauldron 
			currShoppingList[item.itemType] = currShoppingList[item.itemType] - 1
			var index = typeToCharIndex[item.itemType]
			if index != -1:
				shopLabel.text[index] = str(int(shopLabel.text[index + 2]) - currShoppingList[item.itemType]) 
				shopListTotal -= 1
		Inventory.items = [] # Clear inventory 
		
		# Check if shopping list is complete 
		print_debug(shopListTotal)
		if(shopListTotal == 0):
			hand.visible = true;
			texture = castTexture;
			shopLabel.text = "Thanks"


func GenerateShoppingListInternal():
	var rawList = ShoppingLists[currList]
	var textArr = []
	typeToCharIndex = []
	
	shopListTotal = 0
	
	currShoppingList = []
	for n in 8: # Empty arrays 
		currShoppingList.append(0)
		typeToCharIndex.append(-1)
	
	for item in rawList: # Convert raw list into combine list 
		currShoppingList[item] = currShoppingList[item] + 1
		shopListTotal += 1
	
	shopLabel.text = "" # Clear Text
	var counter = 0
	for item in currShoppingList: # Add to list 
		if item == 0:
			continue
		typeToCharIndex[counter] = shopLabel.text.length()
		shopLabel.text += "0/" + str(item) + " " + str(Types.CollectType.find_key(counter)) + "\n"
		counter += 1
