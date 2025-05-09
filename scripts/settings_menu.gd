extends Control

@onready var easy_button = $Panel/VBoxContainer/HBoxContainer/Easy
@onready var regular_button = $Panel/VBoxContainer/HBoxContainer/Regular
@onready var impossible_button = $Panel/VBoxContainer/HBoxContainer/Impossible
@onready var panel = $Panel
@onready var label = $Panel/VBoxContainer/Label
@onready var menuContainer = $"."


func _ready():
	set_process_input(true)
	#var parent_size = get_viewport_rect().size
	#label.position = (parent_size - label.size)/2
	#var panel_size = panel.size * .7
	#panel.size = panel_size
	#panel.position = (parent_size - panel.size) / 3
	#panel.position = get_viewport_rect().size / 2
	# Pre-select current difficulty
	match Settings.difficulty:
		Settings.Difficulty.EASY:
			highlight_button(easy_button)
		Settings.Difficulty.REGULAR:
			highlight_button(regular_button)
		Settings.Difficulty.IMPOSSIBLE:
			highlight_button(impossible_button)

	# Connect button signals
	easy_button.pressed.connect(_on_easy_pressed)
	regular_button.pressed.connect(_on_regular_pressed)
	impossible_button.pressed.connect(_on_impossible_pressed)

func _on_easy_pressed():
	Settings.set_difficulty(Settings.Difficulty.EASY)
	#Settings.difficulty = Settings.Difficulty.EASY
	highlight_button(easy_button)

func _on_regular_pressed():
	Settings.set_difficulty(Settings.Difficulty.REGULAR)
	#Settings.difficulty = Settings.Difficulty.REGULAR
	highlight_button(regular_button)

func _on_impossible_pressed():
	Settings.set_difficulty(Settings.Difficulty.IMPOSSIBLE)
	#Settings.difficulty = Settings.Difficulty.IMPOSSIBLE
	highlight_button(impossible_button)

func highlight_button(active_button: Button):
	for b in [easy_button, regular_button, impossible_button]:
		b.modulate = Color.WHITE
	active_button.modulate = Color.LIGHT_BLUE


func _input(event):
	if event is InputEventMouseButton:
		#print("\n mouse input detected")
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			#print("\nleft mouse click detected at ", event.global_position)
			var panel_rect = panel.get_global_rect()
			if not panel_rect.has_point(event.global_position):
				#print("\n click outside menu")
				queue_free()
