extends VBoxContainer

var dog_name: String
var breed: String
var sex: String
var age: int
var role: String
var note: String
var photo: String = "N/A"
var location: String
var onboard: bool
var services: String
var date_on: String
var date_off: String
var owner_id: int

var dialog
var db;
var ui_root;

func _ready():
	ui_root = get_tree().get_root().get_child(0);
	db = ui_root.get_child(-1)
	
	dialog = FileDialog.new();
	dialog.size = Vector2(1135, 609);
	dialog.position = Vector2(7, 32);
	dialog.min_size = dialog.size
	add_child(dialog);
	dialog.file_selected.connect(_on_file_selected);
	print("new panel ready called")

func _process(_delta):
	pass

func add_record():
	dog_name = $topCon/firstQuestions/fQuestions/editable_labels/labels/name.text
	breed = $topCon/firstQuestions/fQuestions/editable_labels/labels/breed.text
	sex = $topCon/firstQuestions/fQuestions/editable_labels/labels/sex.text
	age = int($topCon/firstQuestions/fQuestions/editable_labels/labels/age.text)
	role = $topCon/firstQuestions/fQuestions/editable_labels/labels/role.text
	note = $topCon/firstQuestions/fQuestions/editable_labels/labels/notes.text
	location = $topCon/firstQuestions/fQuestions/editable_labels/labels/locations.text
	services = $bottomCon/options/services.text
	date_on = $bottomCon/options/date_on_edit.text
	date_off = $bottomCon/options/date_off_edit.text
	
	if date_on != null:
		onboard = true;
	
	#photo stored by photo button
	
	print(dog_name, breed, sex, age, role, note, location, services, onboard, date_on, date_off)
	#name, breed, sex, age, role, note, photo, location, onboard, date_on, date_off, owner_id, service_name
	db.make_full_entry(dog_name, breed, sex, age, role, note, photo, location, onboard, date_on, date_off, services)
	pass

func _on_texture_button_mouse_entered():
	$topCon/Photo/photo_button.self_modulate = Color("a2a2a2")

func _on_photo_button_mouse_exited():
	$topCon/Photo/photo_button.self_modulate = Color("ffffff")

func _on_click_here_to_replace_photo_mouse_entered():
	_on_texture_button_mouse_entered()

func _on_click_here_to_replace_photo_mouse_exited():
	_on_photo_button_mouse_exited()

func _on_photo_button_pressed():
	dialog.access = FileDialog.ACCESS_FILESYSTEM
	dialog.set_file_mode(FileDialog.FILE_MODE_OPEN_FILE)
	dialog.extend_to_title = true
	dialog.popup_window = true;
	dialog.show()

func _on_file_selected(path: String):
	print("Selected file path: " + path)
	#var file = path.get_file();
	#var dir_for_copying = DirAccess.open(path.get_base_dir());
	#dir_for_copying.copy(path, "res://dog_photos/" + file)
	#print(file)
	var image = Image.new();
	var err = image.load(path);
	if err != OK:
		print("failed")
	var texture = ImageTexture.new()
	texture = ImageTexture.create_from_image(image);
	
	photo = path;
	$topCon/Photo/photo_button.texture_normal = texture
	$"topCon/Photo/photo_button/textMargin/click here to replace photo".text = ""

func location_fill():
	var drop = $topCon/firstQuestions/fQuestions/editable_labels/labels/locations;
	drop.clear();
	for m in db.get_locations():
		drop.add_item(m["location_name"]);
	drop.selected = -1;

func reset_fields():
	$topCon/firstQuestions/fQuestions/editable_labels/labels/name.text = "";
	$topCon/firstQuestions/fQuestions/editable_labels/labels/breed.text = "";
	
	$topCon/firstQuestions/fQuestions/editable_labels/labels/sex.text = "";
	$topCon/firstQuestions/fQuestions/editable_labels/labels/sex.select(-1);
	
	$topCon/firstQuestions/fQuestions/editable_labels/labels/age.text = "";
	$topCon/firstQuestions/fQuestions/editable_labels/labels/role.text = "";
	$topCon/firstQuestions/fQuestions/editable_labels/labels/notes.text = "";
	
	$topCon/firstQuestions/fQuestions/editable_labels/labels/locations.text = "";
	$topCon/firstQuestions/fQuestions/editable_labels/labels/locations.select(-1);
	
	$bottomCon/options/services.text = "";
	$bottomCon/options/services.select(-1);
	
	$bottomCon/options/date_on_edit.text = "";
	$bottomCon/options/date_off_edit.text = "";
	
	$topCon/firstQuestions/fQuestions/editable_labels/labels/locations.selected = -1;
	
	$topCon/Photo/photo_button.texture_normal = load("res://white.png");
	$"topCon/Photo/photo_button/textMargin/click here to replace photo".text = "Click Here to Add Photo";

func _on_save_button_pressed():
	add_record();
	reset_fields();
	get_parent().get_parent().grab_me_from_below();

func _on_reset_button_pressed():
	reset_fields();
