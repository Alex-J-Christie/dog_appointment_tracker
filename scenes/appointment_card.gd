extends Control

var id: int
var service_name: String
var date_boarded: String
var date_offloaded: String

var profile_owner
var db

func _ready():
	apply_text();

func _process(_delta):
	pass

func new(id_new, service_name_new, date_boarded_new, date_offloaded_new, owner, database):
	id = id_new;
	service_name = service_name_new;
	date_boarded = date_boarded_new;
	date_offloaded = date_offloaded_new;
	profile_owner = owner;
	db = database;

func apply_text():
	$bgPanel/vcon/service_name.text = "Service: " + service_name;
	$bgPanel/vcon/date_boarded.text = "Date Boarded: " + date_boarded;
	$bgPanel/vcon/date_offloaded.text = "Date Offloaded: " + date_offloaded;


func _on_delete_button_pressed():
	db.delete_appointment(id);
	profile_owner.appointment_refill();
