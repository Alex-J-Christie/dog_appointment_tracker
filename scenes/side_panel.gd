extends HBoxContainer


func _ready():
	$panel_list/buttonContainer/location_button.emit_signal("pressed")
	print("side panel ready called")
	$search_panel.ui_grab();

func _process(_delta):
	pass

func _on_location_button_pressed():
	$info_panel.visible = true;
	$search_panel.visible = false;
	$new_panel.visible = false;
	$stats_panel.visible = false;

func _on_search_button_pressed():
	$info_panel.visible = false;
	$search_panel.visible = true;
	$new_panel.visible = false;
	$stats_panel.visible = false;

func _on_add_button_pressed():
	$info_panel.visible = false;
	$search_panel.visible = false;
	$new_panel.visible = true;
	$stats_panel.visible = false;
	$new_panel.location_fill();

func _on_tba_button_pressed():
	$info_panel.visible = false;
	$search_panel.visible = false;
	$new_panel.visible = false;
	$stats_panel.visible = true;
	$stats_panel.set_labels();
