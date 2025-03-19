extends VBoxContainer

var db;
var ui_root;
#search panel
func _ready():
	ui_root = get_tree().get_root().get_child(0);
	db = ui_root.get_node("data_manager");
	print("search panel ready called")

func ui_grab():
	$table.panel_grab("search");


func _process(_delta):
	pass

func all_visible_dogs():
	for element in $table/mCon/sCon/grid.get_children():
		element.visible = true;

func get_started():
	print("getting started")
	var dogs = db.get_all_dog_records();
	for dog in dogs:
		$table.add_dog_card(dog);

func _on_search_bar_text_changed(new_text):
	#var data_collection;
	if new_text == "":
		all_visible_dogs();
	else:
		for dog in $table/mCon/sCon/grid.get_children():
			var el = dog.data_collection;
			var a = str(el[0]) == (new_text)
			var b = el[1].to_lower().contains(new_text.to_lower())
			var c = el[2].to_lower().contains(new_text.to_lower())
			var d = el[3].to_lower().contains(new_text.to_lower())
			var e = str(el[4]) == (new_text)
			var f = el[5].to_lower().contains(new_text.to_lower())
			var g = el[6].to_lower().contains(new_text.to_lower())
			var h = el[7].to_lower().contains(new_text.to_lower())
			var i = el[8].to_lower().contains(new_text.to_lower())
			#var j = el[9].contains(new_text)
			var k = el[10].to_lower().contains(new_text.to_lower())
			var l = el[11].to_lower().contains(new_text.to_lower())
			var m = str(el[12]) == (new_text)
			
			if a || b || c || d || e || f || g || h || i|| k || l || m:
				dog.visible = true
			else:
				dog.visible = false

