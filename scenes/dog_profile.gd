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
var dog_card
var dog_data_collection = [];
var edit_objects = [];

var db;
var dog_appointments;

func new(card, data:Array, database):
	dog_card = card;
	db = database
	organize_edit_objects();
	set_values(data);
	toggle_uneditable();
	set_overview_text();

func _ready():
	pivot_offset = Vector2(size.x/2, size.y/2);
	scale = Vector2(0, 0);
	dog_appointments = get_dog_appointments();
	appointment_fill();
	location_fill();
	tween_summon();
	await get_tree().create_timer(.3).timeout;
	print("dog profile ready called")

func location_fill():
	for m in db.get_locations():
		$profileContainer/partssPContainer/overViewContainer/locationBox/locationButton.add_item(m["location_name"]);
	$profileContainer/partssPContainer/overViewContainer/locationBox/locationButton.text = dog_card.location;

func get_dog_appointments():
	return db.appt_select_rows(id);

func _process(_delta):
	pass

func tween_summon():
	var tween = get_tree().create_tween();
	tween.tween_property(self, "scale", Vector2(1, 1), .3);
	tween.play();

func set_local_options():
	
	pass

func appointment_fill():
	for i in dog_appointments.size():
		var dog_id = dog_appointments[i]["id"];
		var service_name = dog_appointments[i]["service_name"];
		var on = dog_appointments[i]["date_boarded"];
		var off = dog_appointments[i]["date_offloaded"];
		var scene = load("res://scenes/appointment_card.tscn");
		var appt_card = scene.instantiate();
		appt_card.new(dog_id, service_name, on, off, self, db);
		$profileContainer/appointment_chooser/MarginContainer/ScrollContainer/scrolling_appointment_list.add_child(appt_card);
	pass

func set_values(dog_data: Array):
	id = dog_data[0]
	dog_name = dog_data[1]
	breed = dog_data[2]
	sex = dog_data[3]
	age = dog_data[4]
	role = dog_data[5]
	note = dog_data[6]
	photo = dog_data[7]
	location = dog_data[8]
	onboard = dog_data[9]
	date_on = dog_data[10]
	date_off = dog_data[11]
	owner_id = dog_data[12]
	dog_data_collection = [id, dog_name, breed, sex, age, role, note, photo, location, onboard, date_on, date_off, owner_id]

func set_overview_text():
	$profileContainer/partssPContainer/pictureContainer/bone/name.text = dog_name;
	$profileContainer/partssPContainer/pictureContainer/profilePicture/profilePicture.texture = load(photo);
	var index = 1;
	for label in $profileContainer/partssPContainer/overViewContainer.get_children():
		if label.get_child(0).name != "m" && label.get_child(0).name != "spacer1" && label.name != "buttonBox" && !label.name.contains("hSpacer"):
			label.get_child(0).text = label.get_child(0).name + ": ";
			edit_objects[index - 1].text = str(dog_data_collection[index + 1]);
			index += 1;

func toggle_uneditable():
	$profileContainer/partssPContainer/overViewContainer/buttonBox/edit_info_button.visible = !$profileContainer/partssPContainer/overViewContainer/buttonBox/edit_info_button.visible
	$profileContainer/partssPContainer/overViewContainer/buttonBox/cancel_button.visible = !$profileContainer/partssPContainer/overViewContainer/buttonBox/cancel_button.visible;
	$profileContainer/partssPContainer/overViewContainer/buttonBox/save_button.visible = !$profileContainer/partssPContainer/overViewContainer/buttonBox/save_button.visible;
	$profileContainer/partssPContainer/overViewContainer/buttonBox/delete_button.visible = !$profileContainer/partssPContainer/overViewContainer/buttonBox/delete_button.visible;

	for item in edit_objects:
		if item.name != "locationButton":
			item.editable = !item.editable;
			if item.alignment == 2:
				item.alignment = 0
			elif item.alignment == 0:
				item.alignment = 2
		else:
			$profileContainer/partssPContainer/overViewContainer/locationBox/locationButton.disabled = !$profileContainer/partssPContainer/overViewContainer/locationBox/locationButton.disabled

func organize_edit_objects():
	var con = $profileContainer/partssPContainer/overViewContainer.get_children();
	for box in con:
		if box.name.contains("Box") && !box.name.contains("overview") && !box.name.contains("button"):
			for item in box.get_children():
				if item.name.contains("Edit"):
					edit_objects.append(item);
	edit_objects.append($profileContainer/partssPContainer/overViewContainer/locationBox/locationButton)

func _on_edit_info_button_pressed():
	toggle_uneditable()

func _on_cancel_button_pressed():
	toggle_uneditable()

func _on_exit_button_pressed():
	var tween = get_tree().create_tween();
	tween.tween_property(self, "scale", Vector2(0, 0), .3);
	tween.play();
	await get_tree().create_timer(.3).timeout;
	self.queue_free()

func _on_save_button_pressed():
	var items = []; #breed, sex, age, role, notes, location
	for line in edit_objects:
		items.append(line.text)
	disable_buttons()
	db.update_dog_data_basic(id, items[0], items[1], items[2], items[3], items[4], items[5])
	get_parent().grab_me_from_below();
	await get_tree().create_timer(.3).timeout;
	_on_exit_button_pressed()

func _on_delete_button_pressed():
	disable_buttons()
	db.delete_dog(dog_card.id)
	get_parent().grab_me_from_below()
	await get_tree().create_timer(.3).timeout;
	_on_exit_button_pressed()

func appointment_refill():
	for apptmnt in $profileContainer/appointment_chooser/MarginContainer/ScrollContainer/scrolling_appointment_list.get_children():
		apptmnt.queue_free();
	appointment_fill();

func _on_option_button_item_selected(index):
	var sort_type = $profileContainer/appointment_chooser/filterBox/visitContainer/OptionButton.get_item_text(index)
	var appmnts = $profileContainer/appointment_chooser/MarginContainer/ScrollContainer/scrolling_appointment_list.get_children();
	
	match sort_type:
		"Service":
			print("Sorting by service");
			dog_appointments.sort_custom(func(a, b): return a.service_name[0] < b.service_name[0]);
			appointment_refill();
		"Date Boarded":
			print("Sorting by date boarded");
			dog_appointments.sort_custom(func(a, b): return (a.date_boarded.split("-")[2] < b.date_boarded.split("-")[2]) || (a.date_boarded.split("-")[1] < b.date_boarded.split("-")[1]) || (a.date_boarded.split("-")[0] < b.date_boarded.split("-")[0]))
			appointment_refill();
		"Date Offloaded":
			print("Sorting by date offloaded");
			dog_appointments.sort_custom(func(a, b): return (a.date_offloaded.split("-")[2] < b.date_offloaded.split("-")[2]) || (a.date_offloaded.split("-")[1] < b.date_offloaded.split("-")[1]) || (a.date_offloaded.split("-")[0] < b.date_offloaded.split("-")[0]))
			appointment_refill();

func _on_add_appointment_button_pressed():
	var appointment_profile = load("res://scenes/appointment_profile.tscn");
	var profile = appointment_profile.instantiate();
	profile.new(id, self, db);
	var sceneRoot = get_tree().get_current_scene();
	get_tree().paused = false;
	sceneRoot.add_child(profile)

func disable_buttons():
	$exit_button.disabled = true;
	$profileContainer/partssPContainer/overViewContainer/buttonBox/delete_button.disabled = true
	$profileContainer/partssPContainer/overViewContainer/buttonBox/edit_info_button.disabled = true
	$profileContainer/partssPContainer/overViewContainer/buttonBox/save_button.disabled = true
	$profileContainer/appointment_chooser/filterBox/visitContainer/add_appointment_button.disabled = true
	$profileContainer/partssPContainer/overViewContainer/buttonBox/cancel_button.disabled = true
	var appointments = $profileContainer/appointment_chooser/MarginContainer/ScrollContainer/scrolling_appointment_list.get_children()
	for appntmnt in appointments:
		appntmnt.get_node("delete_button").disabled = true;

func _on_location_button_item_selected(index):
	pass # Replace with function body.
