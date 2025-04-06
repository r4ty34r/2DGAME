#extends CanvasLayer
#
#@export var control_text: String = "Use WS to move, JL to rotate and D to shoot\nPress any key to start playing"
#@onready var label: Label = $Label
#@onready var mainscene = preload("res://main.tscn")
#func _ready():
	## Show the control text
	#label.text = control_text
	##label.rect_min_size = Vector2(400, 200)  # Optional: Adjust size for text
#
	## Set up the canvas layer to wait for input
	#label.visible = true
#
	## Hide the UI and start the game when input is detected
	#set_process_input(true)  # Start processing input to detect any key press
	#
#
#func _input(event):
	## If any input is detected, start the game
	#if event is InputEventKey:
		## Hide the control UI and start the game
		##label.visible = false
		#_start_game()
		## Optionally, fade out or transition to gameplay scene
		#
#
#func _start_game():
	## Your code to start the game goes here (e.g., load the game scene or activate player)
	#print("Game is starting...")
	##get_tree().unload_current_scene()
	#get_tree().change_scene_to_file("res://main.tscn")
	##mainscene.instantiate()
#
	## You can add a scene change here or other logic to start the gameplay
	##get_tree().current_scene = mainscene
	##get_parent().add_child(mainscene)
	#
	#

### NEW VERSION BELOW 
extends CanvasLayer

@export_multiline var control_text: String = "Use [W][S] to move\n[J][L] to rotate\n[SPACE] to shoot\n\nPress any key to start"
@export var fade_duration: float = 0.5
@onready var label: Label = $Label

# Solana cyberpunk colors
var purple_color = Color("#9945FF")  # Solana purple
var green_color = Color("#14F195")   # Solana green

func _ready():
	 # Make sure this is the only active instance
	print("Control UI ready at: ", get_path())
	
	for node in get_tree().get_nodes_in_group("*"):
		if node != self and "control" in node.name.to_lower():
			print("Found duplicate control node: ", node.name)
			node.queue_free()
	# Configure label text and formatting
	label.text = control_text
	
	# Set label to fill the screen and be properly centered
	label.anchors_preset = Control.PRESET_FULL_RECT
	label.horizontal_alignment = HorizontalAlignment.HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VerticalAlignment.VERTICAL_ALIGNMENT_CENTER
	
	# Apply Solana cyberpunk styling
	label.add_theme_color_override("font_color", green_color)
	label.add_theme_font_size_override("font_size", 24)
	
	# Add an outline for better visibility against dark backgrounds
	label.add_theme_color_override("font_outline_color", purple_color)
	label.add_theme_constant_override("outline_size", 2)
	
	# Make sure the label is visible when scene starts
	label.visible = true
	
	# Add a cyberpunk glow effect
	_add_glow_effect()
	
	# Set up input processing
	set_process_input(true)
	
func _add_glow_effect():
	# Create a subtle pulsing glow effect with tweens
	var glow_tween = create_tween()
	glow_tween.set_loops()  # Make it loop infinitely
	
	# Pulse between normal and slightly brighter
	glow_tween.tween_property(label, "modulate", Color(1.2, 1.2, 1.2, 1), 1.5)
	glow_tween.tween_property(label, "modulate", Color(1, 1, 1, 1), 1.5)
	
func _input(event):
	print("\nINPUT FROM CONTROLUI DETETCED: ", event)
	# If any input is detected, start the game
	if event is InputEventKey and event.pressed:
		set_process_input(false)  # Stop processing input
		_fade_out_and_start_game()

func _fade_out_and_start_game():
	# Create a tween for fading out with a cyberpunk flash effect
	var tween = create_tween()
	
	# First flash bright before fading
	tween.tween_property(label, "modulate", Color(1.5, 1.5, 1.5, 1), 0.2)
	tween.tween_property(label, "modulate", Color(1, 1, 1, 0), fade_duration)
	tween.tween_callback(start_game)

func start_game():
	print("Game is starting...")
	get_tree().change_scene_to_file("res://scenes/main.tscn")
