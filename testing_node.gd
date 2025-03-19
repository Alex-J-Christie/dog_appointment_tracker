extends Control

var dialog = FileDialog.new()

func _ready():
	test_string_comp();

func dolphin_get():
	var result = OS.execute("dolphin", [])
	if result != OK:
		print("Failed to launch file explorer:", result)


func test_string_comp():
	var list_services = ["Puppy 101 Lessons", "Training Camp", "John K9 Junior Camp", "Alumni ​Overnight Boarding"];
	
	#var alphabet = Array("A B C D E F G H I J K L M N O P Q R S T U V W X Y Z".split(" "));
	#alphabet.shuffle()
	#print(alphabet)
	#alphabet.sort_custom(func(a, b): return a < b);
	#print(alphabet)
	
	print(list_services)
	print(list_services[0][0])
	list_services.sort_custom(func(a, b): return a[0] < b[0]);
	#list_services.sort_custom(service_sort)
	print(list_services);
	
	#print(str("B" < "A"))
	#print(str("A" < "B"))

func _process(delta):
	if dialog.visible && dialog.current_file != "":
		print("Selected file:", dialog.current_file)
		process_selected_file(dialog.current_file)
		dialog.visible = false  

func process_selected_file(path):
	var image = load(path)
	another_method(image)

func another_method(image):
	pass
