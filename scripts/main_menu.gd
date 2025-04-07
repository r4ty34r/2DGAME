extends Control

# Node references
@onready var username_input = $ButtonsContainer/HBoxContainer/UsernameInput
@onready var start_button = $ButtonsContainer/StartGameButton
@onready var options_button = $ButtonsContainer/OptionsButton
@onready var quit_button = $ButtonsContainer/QuitButton
@onready var error_label = $ButtonsContainer/HBoxContainer/ErrorLabel

# Configuration
@export var game_scene_path: String = "res://scenes/control_ui.tscn"
@export var min_username_length: int = 3
@export var max_username_length: int = 20


func _ready():
	# Connect button signals
	start_button.pressed.connect(_on_StartGame_pressed)
	if options_button:
		options_button.pressed.connect(_on_Options_pressed)
	quit_button.pressed.connect(_on_Quit_pressed)
	
	# Connect text input signals
	username_input.text_changed.connect(_on_UsernameInput_text_changed)
	
# Validate username and update UI accordingly
func _on_UsernameInput_text_changed(new_text):
	var valid = validate_username(new_text)
	start_button.disabled = !valid
	

# Username validation rules
func validate_username(username_text):
	# Check for empty username
	if username_text.is_empty():
		if error_label:
			error_label.text = "Username cannot be empty"
		return false
	
	# Check minimum length
	if username_text.length() < min_username_length:
		if error_label:
			error_label.text = "Username must be at least %d characters" % min_username_length
		return false
	
	# Check maximum length
	if username_text.length() > max_username_length:
		if error_label:
			error_label.text = "Username must be at most %d characters" % max_username_length
		return false
	
	# Check for invalid characters (optional)
	var regex = RegEx.new()
	regex.compile("^[a-zA-Z0-9_-]+$")
	if !regex.search(username_text):
		if error_label:
			error_label.text = "Username can only contain letters, numbers, underscores and hyphens"
		return false
	
	return true

# Button signal handlers
func _on_StartGame_pressed():
	#name is verified so set playerdata username 
	PlayerData.user_name = $ButtonsContainer/HBoxContainer/UsernameInput.text
	
	# Store username locally for now
	var username = username_input.text
	print("\nmain_menu.gd: Player data username is: ", PlayerData.user_name)
	print("\nmain_menu.gd Starting game with username: ", username)
	
	# Change to the game scene
	var error = get_tree().change_scene_to_file(game_scene_path)
	if error != OK:
		push_error("Failed to change to game scene: " + str(error))
		if error_label:
			error_label.text = "Failed to start game"
			error_label.visible = true

func _on_Options_pressed():
	# Implement options menu functionality
	# This could be a popup or a new scene
	print("Options button pressed")
	pass

func _on_Quit_pressed():
	print("Quitting game")
	get_tree().quit()
