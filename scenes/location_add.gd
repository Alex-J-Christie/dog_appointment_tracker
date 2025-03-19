extends Control

var parent;
var db;

func _ready():
	self.scale = Vector2(0, 0);
	self.pivot_offset = Vector2(size.x / 2, size.y / 2);
	tween_summon()

func new(source, database):
	parent = source;
	db = database;


func tween_summon():
	var tween = get_tree().create_tween();
	var size;
	if (self.scale == Vector2(1, 1)):
		size = Vector2(0, 0);
	else:
		size = Vector2(1, 1);
	tween.tween_property(self, "scale", size, .3);
	tween.play();


func _on_exit_button_pressed():
	tween_summon();
	await get_tree().create_timer(.3).timeout;
	self.queue_free();

func db_search(value):
	for item in db.get_locations():
		if item["location_name"] == value:
			return true;
	return false;

func _on_save_button_pressed():
	print(db_search($backgroundPane/CenterContainer/VBoxContainer/locationEdit.text));
	if !db_search($backgroundPane/CenterContainer/VBoxContainer/locationEdit.text):
		db.add_location_to_table($backgroundPane/CenterContainer/VBoxContainer/locationEdit.text);
		print(db.get_locations());
		parent.location_refill();
		_on_exit_button_pressed();
