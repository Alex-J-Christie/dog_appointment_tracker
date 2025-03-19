extends Node

var db = SQLite.new()
var names = ["MACK (FOSTER)","REMY (FOSTER)","HENNESSY (FOSTER)","LOVELY (FOSTER)","GREGGY (FOSTER)","DOZER (FOSTER)","MEGAN (FOSTER)","GONZO (FOSTER)","HARLIE","BRENDA","KIPPER","KASH","OAKLEY","JACK","DEVO","SNOWBALL","RAMBO","ARIES","BROOKLYN","HEAVEN","COCCO","BIANCA","CHICA","RYDER"];
var breeds = ["Terrier, Pit Bull/Mix","Boxer/Terrier, Pit Bull","Terrier, Pit Bull/Mix","Terrier, Pit Bull/Hound","Terrier, Pit Bull/Mix","Retriever, Labrador/Mix","Terrier, Pit Bull/Mix","Bulldog/Mix","Hound/Retriever, Labrador","Terrier, Pit Bull/Mix","Terrier, Pit Bull/Mix","Terrier, Pit Bull/Mix","Terrier/Mix","Terrier, Pit Bull/Mix","Chihuahua, Short Coat","Poodle, Miniature","Shepherd/Terrier, Pit Bull","Terrier, Pit Bull/Mix","Terrier, Pit Bull/Mix","Chihuahua, Short Coat/Mix","Chihuahua, Short Coat/Mix","Chihuahua, Short Coat/Mix","Retriever, Labrador/Terrier, Pit Bull","Hound/Mix"];;
var sexes = ["Male/Neutered","Male/Neutered","Female/Spayed","Female/Spayed","Male/Neutered","Male/Neutered","Female/Spayed","Male/Neutered","Female","Female","Female","Male","Male","Male","Male","Female","Male","Female","Female","Male","Female","Female","Female","Male/Neutered"]
var notes = ["Agressive and Stupid","Unwanted and Ugly","Weird Mole: Cancer?","Doesn't like men, doesn't like women","Supposedly vegan","Susan says this dog can speak","The sound of soda cans opening causes rage","No notes, perfect dog","Tries their best","N/A","Boring","Can't read","Can open doors - Be Careful","N/A","N/A","N/A","N/A","N/A","N/A","N/A","N/A","N/A","N/A","N/A"];;
var roles = ["Service", "Detection", "S&R", "Police", "Military", "Personal Protection"];;
var locations = ["Kennel", "Play Area", "Outdoor Field", "Training Room", "Pool", "Perimeter"];
var services = ["Private Obedience Lessons", "Training Camp", "Board and Train Camp", "Puppy 101 Lessons", "John K9 Junior Camp", "Specialty or Trick Training", "Doggy Daycare", "Alumni ​Overnight Boarding", "Non-Alumni Overnight Boarding"];

var photos = clean_dog_list();

func _ready():
	db.path = "res://dog_data.db";
	db.open_db();
	if get_all_dog_records().size() == 0:
		add_it_all();
	print("data manager ready called")

func _process(_delta):
	pass

func add_it_all():
	initiate_tables();
	establish_locations();
	summon_the_pups();
	rain_down_appointments();

func establish_locations():
	for value in locations:
		add_location_to_table(value);

#getters

func get_db():
	return db;

func get_dogs_by_owner_id():
	return db.select_rows("Dogs", "", ["owner_id", "id"]);

func get_all_dog_records():
	return db.select_rows("Dogs", "", ["*"]);

func get_dog_location(local):
	return db.select_rows("Dogs", "location = '" + local + "'", ["*"]);

func appt_select_rows(value_id):
	return db.select_rows("Appointments", str(value_id) + " = dog_id", ["*"]);

func get_owner_id_by_dog(dog_name):
	return db.select_rows("Dogs", "id == " + str(dog_name), ["owner_id"]);

func get_current_dog_amount(location_name):
	return db.select_rows("Locations", "location_name == '" + location_name + "'", ["number_of_dogs"])

func get_dog_dates():
	return db.select_rows("Dogs", "", ["dog_name", "date_boarded", "date_to_offload"])

func get_locations():
	return db.select_rows("Locations", "", ["location_name"])#[0]["location_name"]


#deleters

func delete_dog(id):
	return db.delete_rows("Dogs", "id == " + str(id))

func delete_all_dogs():
	for dog in get_all_dog_records():
		delete_dog(dog["id"])

func delete_appointment(id):
	return db.delete_rows("Appointments", "id == " + str(id));

func delete_all_appointments():
	for appt in db.select_rows("Appointments", "", ["*"]):
		delete_appointment(appt["id"])
	pass

#setters

func update_dog_data_basic(idU, breedU, sexU, ageU, roleU, notesU, locationU):
	db.update_rows("Dogs", "id = " + str(idU), {"dog_breed": breedU, "dog_sex": sexU, "dog_age": ageU, "role": roleU, "note": notesU, "location": locationU})

func add_dog_to_table(dog_name, breed, sex, age, role, note, photo, location, onboard, date_on, date_off, owner_id):
	var data = {
		"dog_name": dog_name,
		"dog_breed": breed,
		"dog_sex": sex,
		"dog_age": age,
		"role": role,
		"note": note,
		"photo": photo,
		"location": location,
		"currently_boarded": onboard,
		"date_boarded": date_on,
		"date_to_offload": date_off,
		"owner_id": owner_id,
	}
	db.insert_row("Dogs", data);

func add_appointment_to_table(dog_id, service_name, date_boarded, date_offloaded, owner_id):
	var data = {
		"dog_id": dog_id,
		"service_name": service_name,
		"date_boarded": date_boarded,
		"date_offloaded": date_offloaded,
		"owner_id": owner_id,
	}
	db.insert_row("Appointments", data);

func make_full_entry(dog_name, breed, sex, age, role, note, photo, location, onboard, date_on, date_off, service_name):
	var owner_id = randi_range(0, 99999999);
	add_dog_to_table(dog_name, breed, sex, age, role, note, photo, location, onboard, date_on, date_off, owner_id)
	var id_by_dog = db.select_rows("Dogs", "dog_name == " + name, ["id"]);
	add_appointment_to_table(id_by_dog, service_name, date_on, date_off, owner_id)

func add_dog_to_location(location_name):
	db.update_rows("Locations", "location_name == '" + location_name + "'", {"number_of_dogs": int(get_current_dog_amount(location_name))})

func add_location_to_table(location_name):
	var data = {
		"location_name": location_name,
		"number_of_dogs": 0,
	}
	db.insert_row("Locations", data);

#helper function
func clean_dog_list(): 
	var output = [];
	for j in range(DirAccess.open("res://dog_photos/").get_files().size()):
		if !DirAccess.open("res://dog_photos/").get_files()[j].contains(".import") && !DirAccess.open("res://dog_photos/").get_files()[j].contains("johnK9_logo.png"):
			output.append("res://dog_photos/" + DirAccess.open("res://dog_photos/").get_files()[j]);
	return output;

func summon_the_pups():
	var random = RandomNumberGenerator.new()
	var dog_name 
	var breed
	var sex
	var age
	var note
	var role
	var photo
	var location
	var onboard
	var date_on
	var date_off
	var owner_id
	
	for i in range(names.size()):
		random.randomize()
		dog_name = names[i];
		breed = breeds[i];
		sex = sexes[i];
		age = randf() * 18;
		role = roles[randi_range(0, roles.size() - 1)];
		photo = photos[i];
		note = notes[randi_range(0, notes.size()-1)];
		onboard = (randi() % 2 == 0)
		if onboard == true:
			var on_date = [randi_range(1, 12), str(randi_range(1, 28)), randi_range(21, 26)]
			var off_date = [randi_range(1, 12), str(randi_range(1, 28)), on_date[2] + randi_range(1, 3)]
			location = locations[randi_range(0, locations.size() - 1)];
			date_on = str(on_date[0]) + "-" + str(on_date[1]) + "-" + str(on_date[2]);
			date_off = str(off_date[0]) + "-" + str(off_date[1]) + "-" + str(off_date[2]);
		else:
			date_on = "N/A";
			date_off = "N/A";
		owner_id = randi_range(0, 99999999);
		add_dog_to_table(dog_name, breed, sex, age, role, note, photo, location, onboard, date_on, date_off, owner_id)

func rain_down_appointments():
	var owners_with_id = get_dogs_by_owner_id();
	for i in range(100):
		randomize()
		var owners = owners_with_id[randi_range(0, owners_with_id.size() - 1)];
		add_appointment_to_table(owners["id"], services[randi_range(0, services.size() - 1)], str(randi_range(1, 12)) + "-" + str(randi_range(1, 29)) + "-" + str(randi_range(22, 24)), str(randi_range(1, 12)) + "-" + str(randi_range(1, 29)) + "-" + str(randi_range(24, 25)), owners["owner_id"]);

func initiate_tables():
	db.create_table("Locations", {
		"id": {"data_type": "int", "primary_key": true, "not_null": true, "auto_increment": true},
		"location_name": {"data_type": "text", "not_null": true},
		"number_of_dogs": {"data_type": "int", "not_null": true}
	})
	db.create_table("Dogs", {
		"id": {"data_type": "int", "primary_key": true, "not_null": true, "auto_increment": true},
		"dog_name": {"data_type": "text", "not_null": true,},
		"dog_breed": {"data_type": "text"},
		"dog_sex": {"data_type": "text"},
		"dog_age": {"data_type": "int"},
		"role": {"data_type": "text"},
		"note": {"data_type": "text"},
		"photo": {"data_type": "photo"},
		"location": {"data_type": "text"},
		"currently_boarded": {"data_type": "bool", "not_null": true,},
		"date_boarded": {"data_type": "Date"},
		"date_to_offload": {"data_type": "Date"},
		"owner_id": {"data_type": "int", "foreign_key": true, "not_null": true},
	})
	db.create_table("Appointments", {
		"id": {"data_type": "int", "primary_key": true, "not_null": true, "auto_increment": true},
		"dog_id": {"data_type": "int", "foreign_key": true, "not_null": true,},
		"service_name": {"data_type": "text", "not_null": true},
		"date_boarded": {"data_type": "Date"},
		"date_offloaded": {"data_type": "Date"},
		"owner_id": {"data_type": "int", "foreign_key": true, "not_null": true},
	})
