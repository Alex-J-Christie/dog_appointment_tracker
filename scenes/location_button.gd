extends Button

var parent;
var title;
var db;

func _ready():
	pass

func new(parent_value, db_value, title_value):
	parent = parent_value;
	db = db_value;
	title = title_value;
	self.text = title;

func _on_toggled(toggled_on):
	if title != "+":
		if !toggled_on:
			parent.hide_dogs(title);
		if toggled_on:
			parent.unhide_dogs(title);

func _on_pressed():
	if title == "+":
		var local_profile = load("res://scenes/location_add.tscn");
		var local = local_profile.instantiate();
		var sceneRoot = get_tree().get_current_scene();
		local.new(parent, db);
		sceneRoot.add_child(local);
