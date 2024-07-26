extends Sprite2D

@export var Inventory : Area2D
@export var continueCircle : Node2D
@export var cauldron : Node2D
@export var rangeToPull : float

@export var shopLabel : Label
@export var castTexture : Texture
@export var hand : Node2D

@export var dialogueAudio : AudioStreamPlayer2D
@export var introDialogue : Array[String]
@export var ShoppingLists : Array[Array]

var currList : int # Index for list in ShoppingLists
var currShoppingList : Array # Each index refers to num of item 
var typeToCharIndex : Array # What is the number character's index based on type 

var shopListTotal : int

var introIndex : int;

var state : WizardState;
enum WizardState {INTRO, TUTORIAL_SHOPPING}

func _init():
	state = WizardState.INTRO
	introIndex = 0

func _ready():
	#GenerateShoppingListInternal()
	shopLabel.text = introDialogue[introIndex]
	
	pass

func _process(delta):
	pass

func OnInvetoryCollection(area):
	if state == WizardState.INTRO:
		return;
	
	for item in Inventory.items:
		item.StartAbsorb(cauldron) # Animate to cauldron 
		currShoppingList[item.itemType] = currShoppingList[item.itemType] - 1
		var index = typeToCharIndex[item.itemType]
		print_debug(currShoppingList[item.itemType])
		if index != -1 && currShoppingList[item.itemType] + 1 > 0: # Does item exist on shpping list 
			shopLabel.text[index] = str(int(shopLabel.text[index + 2]) - currShoppingList[item.itemType]) 
			shopListTotal = max(shopListTotal - 1, 0)
		else:
			item.Reset()
		Inventory.items = [] # Clear inventory 
			
		# Check if shopping list is complete 
		if(shopListTotal == 0):
			currList += 1
			
			if currList >= ShoppingLists.size(): # End game? 
				hand.visible = true;
				texture = castTexture;
				shopLabel.text = "Thank you! Now feel free to find the secrets!"
			else: # Next list 
				GenerateShoppingListInternal()

func OnContinueDialogue(area):
	introIndex += 1
	
	if introIndex >= introDialogue.size():
		GenerateShoppingListInternal()
		Inventory.canCollect = true
		state = WizardState.TUTORIAL_SHOPPING
		continueCircle.queue_free()
	else:
		shopLabel.text = introDialogue[introIndex]
		dialogueAudio.play()

func GenerateShoppingListInternal():
	var rawList = ShoppingLists[currList]
	var textArr = []
	typeToCharIndex = []
	shopLabel.text = "" # Clear Text
	
	shopListTotal = 0
	
	currShoppingList = []
	for n in 8: # Empty arrays 
		currShoppingList.append(0)
		typeToCharIndex.append(-1)
	
	for item in rawList: # Convert raw list into combine list 
		currShoppingList[item] = currShoppingList[item] + 1
		shopListTotal += 1
	
	
	var counter = 0
	for item in currShoppingList: # Add to list 
		if item == 0:
			counter += 1
			continue
		typeToCharIndex[counter] = shopLabel.text.length()
		shopLabel.text += "0/" + str(item) + " " + str(Types.CollectType.find_key(counter)) + "\n"
		counter += 1
