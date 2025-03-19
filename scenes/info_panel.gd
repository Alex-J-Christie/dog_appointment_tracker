extends VBoxContainer

var db;
var ui_root;

signal toggled

#info panel
func _ready():
	ui_root = get_tree().get_root().get_child(0);
	db = ui_root.get_node("data_manager");
	print("table ready called")
	#append_button_names();

func ui_grab():
	$table.panel_grab("location");
	location_refill();

func append_button_names():
	var _index = 0;
	for button in $ScrollContainer/HBoxContainer.get_children():
		var local = button.text
		if local != "+":
			button.text = local + " (" + str(db.get_dog_location(local).size()) + ")";
			_index += 1;

func unhide_dogs(location_name):
	$table.unhide_dog_card_by_location(location_name);

func hide_dogs(location_name):
	$table.hide_dog_card_by_location(location_name)

func location_refill():
	for button in $ScrollContainer/HBoxContainer.get_children():
		button.queue_free();
	location_fill();
	append_button_names();

func location_fill():
	var loc_source;
	var loc_button;
	
	for value in db.get_locations():
		var text_value = value["location_name"];
		loc_source = load("res://scenes/location_button.tscn");
		loc_button = loc_source.instantiate();
		loc_button.new(self, db, text_value);
		$ScrollContainer/HBoxContainer.add_child(loc_button)
	
	loc_source = load("res://scenes/location_button.tscn");
	loc_button = loc_source.instantiate();
	loc_button.new(self, db, "+");
	loc_button.toggle_mode = false;
	$ScrollContainer/HBoxContainer.add_child(loc_button)


