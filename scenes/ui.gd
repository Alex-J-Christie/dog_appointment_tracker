extends Control

var db = null;
var found_me = "You got it!"
signal dogs_summoned;

func _ready():
	#grab_me_from_below()
	$side_panel/search_panel.ui_grab();
	$side_panel/info_panel.ui_grab();
	remember_grouping($side_panel/info_panel/ScrollContainer/HBoxContainer.get_child(0));
	print("ui ready called")

func grab_me_from_below():
	panel_grab()
	emit_signal("dogs_summoned");

func _process(_delta):
	if Input.is_action_just_pressed("dev_button") && get_node_or_null("dev_panel") == null:
		var dev_panel = load("res://scenes/dev_panel.tscn")
		var dev_child = dev_panel.instantiate();
		add_child(dev_child);
	pass

func panel_grab():
	if $side_panel/info_panel/table/mCon/sCon/grid.get_children().size() > 0:
		for child in $side_panel/info_panel/table/mCon/sCon/grid.get_children():
			child.queue_free()
	if $side_panel/info_panel/table/mCon/sCon/grid.get_children().size() > 0:
		for child in $side_panel/search_panel/table/mCon/sCon/grid.get_children():
			child.queue_free()
	$side_panel/search_panel.ui_grab();
	$side_panel/info_panel.ui_grab();
	for button in $side_panel/info_panel/ScrollContainer/HBoxContainer.get_children():
		if button.is_pressed():
			remember_grouping(button)

func remember_grouping(button):
	button.set_pressed(false);
	button.set_pressed(true);

func instance_db():
	var source = load("res://scenes/data_manager.tscn")
	db = source.instantiate();
	add_child(db);
