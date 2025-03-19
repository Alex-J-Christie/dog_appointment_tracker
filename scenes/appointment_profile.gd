extends Control

var id: int
var service_name: String
var date_boarded: String
var date_offloaded: String

var db;
var profile_owner;

func _ready():
	scale = Vector2(0, 0);
	pivot_offset = Vector2(size.x/2, size.y/2);
	tween_summon()


func _process(delta):
	pass

func new(dog_id, profile, database):
	id = dog_id;
	profile_owner = profile;
	db = database;

func tween_summon():
	var tween = get_tree().create_tween();
	tween.tween_property(self, "scale", Vector2(1, 1), .3);
	tween.play();

func grab_values():
	service_name = $profileContainer/partssPContainer/overViewContainer/serviceBox/serviceEdit.text;
	date_boarded = $profileContainer/partssPContainer/overViewContainer/onBox/onEdit.text;
	date_offloaded = $profileContainer/partssPContainer/overViewContainer/offBox/offEdit.text;

func _on_save_button_pressed():
	grab_values();
	db.add_appointment_to_table(id, service_name, date_boarded, date_offloaded, db.get_owner_id_by_dog(id)[0]["owner_id"]);
	profile_owner.appointment_refill();

func _on_cancel_button_pressed():
	var tween = get_tree().create_tween();
	tween.tween_property(self, "scale", Vector2(0, 0), .3);
	tween.play();
	await get_tree().create_timer(.3).timeout;
	self.queue_free()


func _on_exit_button_pressed():
	_on_cancel_button_pressed()
