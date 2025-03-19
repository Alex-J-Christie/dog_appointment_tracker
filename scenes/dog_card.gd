extends Control

var id: int
var dog_name: String
var breed: String
var sex: String
var age: int
var role: String
var note: String
var photo: String
var location: String
var onboard: bool
var date_on: String
var date_off: String
var owner_id: int
var data_collection = []

var apptmnt_data_collection = [];

var mouseEntered = false;
var db;
var ui_root;

func _ready():
	ui_root = get_tree().get_root().get_child(0);
	db = ui_root.get_node("data_manager");
	self.pivot_offset = Vector2(125, 138);
	#self.pivot_offset = Vector2(self.size.x/2, self.size.y/2);

func _process(_delta):
	if Input.is_action_just_pressed("leftClick") && mouseEntered:
		print("mouse clicked successfully")
		add_profile_to_tree();


func set_info(data_form: Dictionary):
	id = data_form["id"];
	dog_name = data_form["dog_name"];
	breed = data_form["dog_breed"];
	sex = data_form["dog_sex"];
	age = data_form["dog_age"];
	role = data_form["role"];
	note = data_form["note"];
	photo = data_form["photo"];
	if data_form["location"] != null:
		location = data_form["location"];
	else:
		location = "";
	onboard = data_form["currently_boarded"];
	date_on = data_form["date_boarded"];
	date_off = data_form["date_to_offload"];
	owner_id = data_form["owner_id"];
	data_collection = [id, dog_name, breed, sex, age, role, note, photo, location, onboard, date_on, date_off, owner_id]
	
	$card/dog_photo.texture = load(photo); 
	$card/info_background/info_container/name_container/nameValue.text = dog_name;
	$card/info_background/info_container/type_container/typeValue.text = breed;
	$card/info_background/info_container/entry_container/entryValue.text = date_on;
	$card/info_background/info_container/exit_container/exitValue.text = date_off;

func print_dog_names():
	var dog_folder = DirAccess.open("res://fonts/example_info/example_dog_photos/");
	#var dogs = dog_folder.get_files();
	for dog_names in dog_folder.get_files():
		if !dog_names.contains(".import"):
			print(dog_name);

func _on_mouse_entered():
	var tween = get_tree().create_tween();
	tween.tween_property(self, "scale", Vector2(1.1, 1.1), .08);
	tween.play();
	mouseEntered = true;

func _on_mouse_exited():
	var tween = get_tree().create_tween();
	tween.tween_property(self, "scale", Vector2(1, 1), .08);
	tween.play();
	mouseEntered = false;

func add_profile_to_tree():
	var profile = load("res://scenes/dog_profile.tscn");
	var dog_profile = profile.instantiate();
	dog_profile.new(self, data_collection, db)
	var sceneRoot = get_tree().get_current_scene();
	sceneRoot.add_child(dog_profile)

