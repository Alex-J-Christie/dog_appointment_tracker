extends Control

var db;
var ui_root;

var todays_date;
var dogs_currently_boarded;
var upcoming_onboarding;
var upcoming_offboarding;

var label_values = [];

func _ready():
	ui_root = get_tree().get_root().get_child(0);
	db = ui_root.get_node("data_manager");
	print(db.get_dog_dates())

func set_labels():
	set_up_variables();
	append_label_names();

func set_up_variables():
	todays_date = get_date();
	dogs_currently_boarded = return_dogs_currently_boarded();
	upcoming_onboarding = get_upcoming_onboard_dates();
	upcoming_offboarding = get_upcoming_offload_dates();
	label_values = [todays_date, dogs_currently_boarded[0], (dogs_currently_boarded[0] + dogs_currently_boarded[1]), format_dates(upcoming_offboarding), format_dates(upcoming_onboarding)]

func get_date():
	var time_dict = Time.get_date_dict_from_system();
	return str(time_dict["month"]) + "-" + str(time_dict["day"]) + "-" + str(time_dict["year"] - 2000);

func return_dogs_currently_boarded():
	var time_dict = Time.get_date_dict_from_system();
	var dog_dates = db.get_dog_dates();
	var currently_boarded = 0;
	var currently_offboarded = 0;
	
	var onboard_truth;
	var offload_truth;
	
	for date_value in dog_dates:
		var onboard_date = date_value["date_boarded"].split("-");
		var offload_date = date_value["date_boarded"].split("-");
		
		if date_value["date_boarded"] == "N/A" || date_value["date_to_offload"] == "N/A":
			currently_offboarded += 1;
		else:
			#if onboard truth or offload truth are true, the date of the given value is in the past, elsewise its the future
			onboard_truth = int(onboard_date[2]) <= int(time_dict["year"] - 2000) && int(onboard_date[0]) <= int(time_dict["month"]) && int(onboard_date[1]) <= int(time_dict["day"]);
			offload_truth = !(int(offload_date[2]) <= int(time_dict["year"] - 2000) && int(offload_date[0]) <= int(time_dict["month"]) && int(offload_date[1]) <= int(time_dict["day"]));
			print("dog name: " + date_value["dog_name"])
			print("boarding before today: " + str(onboard_truth) + ", offloading before today: " + str(offload_truth) + "\n")
			if !onboard_truth && !offload_truth:
				currently_offboarded += 1;
			elif onboard_truth:
				currently_offboarded += 1;
			elif !onboard_truth && offload_truth:
				currently_boarded += 1;
	return Vector2(currently_boarded, currently_offboarded);

func get_upcoming_onboard_dates():
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
	return output;

func get_upcoming_offload_dates():
	var time_dict = Time.get_date_dict_from_system();
	var today_date = (str(time_dict["month"]) + "-" + str(time_dict["day"]) + "-" + str(time_dict["year"]).substr(2, 3));
	var dog_dates = db.get_dog_dates();
	var offboard_dates = {};
	var output = {};
	var inflection_point;
	var dates;
	
	for i in dog_dates:
		if i["date_boarded"] != "N/A":
			offboard_dates[i["dog_name"]] = i["date_to_offload"];
	dates = offboard_dates.values();
	dates.append(today_date);
	dates.sort_custom(date_sort);
	inflection_point = dates.find(today_date);
	dates = dates.slice(inflection_point + 1, dates.size());
	for value in dates:
		output[offboard_dates.find_key(value)] = value;
		pass
	return output;

func date_sort(a, b):
	var al = a.split("-"); var bl = b.split("-");
	if al[2] != bl[2]:
		return (al[2].to_int() < bl[2].to_int());
	elif al[0] != bl[0]:
		return (al[0].to_int() < bl[0].to_int());
	elif al[1] != al[1]:
		return (al[1].to_int() < bl[1].to_int());

func format_dates(keypairs):
	var output = "";
	var val_list = keypairs.values();
	val_list.sort_custom(date_sort);
	for value in val_list:
		output += value + ": " + keypairs.find_key(value) + ", \n";
	return output

func append_label_names():
	var index = 0;
	for value in $stat_list.get_children():
		if value.name != "spacer" && value.name != "Date Board":
			value.text = value.name + ": " + str(label_values[index]);
			index += 1;
	pass
