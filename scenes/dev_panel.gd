extends Control

var db;
var ui_root;

func _ready():
	ui_root = get_tree().get_root().get_child(0);
	db = ui_root.get_node("data_manager")
	
	print("dev panel ready called")

func _process(_delta):
	if Input.is_action_just_pressed("dev_button"):
		self.queue_free();

func _on_dog_button_pressed():
	db.summon_the_pups();
	ui_root.grab_me_from_below();

func _on_appointment_button_pressed():
	db.rain_down_appointments();
	ui_root.grab_me_from_below();

func _on_dog_delete_pressed():
	db.delete_all_dogs();
	ui_root.grab_me_from_below();

func _on_appointment_delete_pressed():
	db.delete_all_appointments();
	ui_root.grab_me_from_below();

func _on_location_2_button_pressed():
	print(db.get_locations())
	pass

func date_sort(a, b):
	var al = a.split("-"); var bl = b.split("-");
	if al[2] != bl[2]:
		return (al[2].to_int() < bl[2].to_int());
	elif al[0] != bl[0]:
		return (al[0].to_int() < bl[0].to_int());
	elif al[1] != al[1]:
		return (al[1].to_int() < bl[1].to_int());

func _on_test_pressed():
	var time_dict = Time.get_date_dict_from_system();
	var today_date = (str(time_dict["month"]) + "-" + str(time_dict["day"]) + "-" + str(time_dict["year"]).substr(2, 3));
	var dog_dates = db.get_dog_dates();
	var onboard_dates = {};
	var output = {};
	var inflection_point;
	var dates;
	
	for i in dog_dates:
		if i["date_boarded"] != "N/A":
			onboard_dates[i["dog_name"]] = i["date_boarded"];
	dates = onboard_dates.values();
	dates.append(today_date);
	dates.sort_custom(date_sort);
	inflection_point = dates.find(today_date);
	dates = dates.slice(inflection_point + 1, dates.size());
	for value in dates:
		output[onboard_dates.find_key(value)] = value;
		pass
	print(output);
