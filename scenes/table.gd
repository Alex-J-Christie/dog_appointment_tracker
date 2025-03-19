extends Control

@export var type: String;

var test_names = ["MACK (FOSTER)","REMY (FOSTER)","HENNESSY (FOSTER)","LOVELY (FOSTER)","GREGGY (FOSTER)","DOZER (FOSTER)","MEGAN (FOSTER)","GONZO (FOSTER)","HARLIE","BRENDA","KIPPER","KASH","OAKLEY","JACK","DEVO","SNOWBALL","RAMBO","ARIES","BROOKLYN","HEAVEN","COCCO","BIANCA","CHICA","RYDER"];
var test_breeds = ["Terrier, Pit Bull/Mix","Boxer/Terrier, Pit Bull","Terrier, Pit Bull/Mix","Terrier, Pit Bull/Hound","Terrier, Pit Bull/Mix","Retriever, Labrador/Mix","Terrier, Pit Bull/Mix","Bulldog/Mix","Hound/Retriever, Labrador","Terrier, Pit Bull/Mix","Terrier, Pit Bull/Mix","Terrier, Pit Bull/Mix","Terrier/Mix","Terrier, Pit Bull/Mix","Chihuahua, Short Coat","Poodle, Miniature","Shepherd/Terrier, Pit Bull","Terrier, Pit Bull/Mix","Terrier, Pit Bull/Mix","Chihuahua, Short Coat/Mix","Chihuahua, Short Coat/Mix","Chihuahua, Short Coat/Mix","Retriever, Labrador/Terrier, Pit Bull","Hound/Mix"];
var test_ages = ["Male/Neutered","Male/Neutered","Female/Spayed","Female/Spayed","Male/Neutered","Male/Neutered","Female/Spayed","Male/Neutered","Female","Female","Female","Male","Male","Male","Male","Female","Male","Female","Female","Male","Female","Female","Female","Male/Neutered"];
var dog_photos = DirAccess.open("res://dog_photos/").get_files();

var db;
var ui_root;

func _ready():
	ui_root = get_tree().get_root().get_child(0);
	db = ui_root.get_node("data_manager");
	panel_grab(type);
	print("table ready called")

func _process(_delta):
	pass

func make_dogs():
	var dogs = db.get_all_dog_records();
	for dog in dogs:
		add_dog_card(dog);

func panel_grab(panel_type: String):
	var should_be_seen = true
	make_dogs();
	match panel_type:
		"search":
			print("\nsearching...\n")
		"location":
			print("\nfinding location...\n")
			should_be_seen = false;
	for element in $mCon/sCon/grid.get_children():
		element.visible = should_be_seen;

#redundant
#actually not redundant because you can add dogs that don't have a location
func summon_every_dog_exclamation_point():
	var dogs = db.get_all_dog_records();
	for dog in dogs:
		add_dog_card(dog);

func hide_dog_card_by_location(local):
	for child in $mCon/sCon/grid.get_children():
		if child.location == local:
			child.visible = false;

func unhide_dog_card_by_location(local):
	for child in $mCon/sCon/grid.get_children():
		if child.location == local:
			child.visible = true;

func dog_card_test():
	var dog_data = [];
	for i in range(db.locations.size()):
		var loc = db.locations[i];
		dog_data.append(db.get_dog_location(loc));
	for dog_location in dog_data:
		for dogs in dog_location:
			add_dog_card(dogs);

func add_dog_card(dog_data: Dictionary):
	var dog_card_resource: Resource = load("res://scenes/dog_card.tscn");
	var dog_card_instance = dog_card_resource.instantiate();
	dog_card_instance.set_info(dog_data);
	$mCon/sCon/grid.add_child(dog_card_instance);

func clean_dog_list(): 
	var output = [];
	for j in range(dog_photos.size()):
		if !dog_photos[j].contains(".import"):
			output.append(dog_photos[j]);
	return output;
