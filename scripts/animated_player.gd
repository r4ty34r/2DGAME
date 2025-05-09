extends CharacterBody2D
@onready var bullet_scene = preload("res://scenes/bullet.tscn")
@onready var healthBar = $Camera2D/HUD/ProgressBar
@onready var healthLabel = $Camera2D/HUD/HealthLabel
@onready var HUD = $Camera2D/HUD
@onready var marker = $Marker2D
@export var rotation_speed: float = 5.0  # Radians per second
@export var movement_speed: float = 500.0  # Pixels per second
@export var acceleration: float = 5.0  # How quickly the character reaches full speed
@export var damageAmount = Settings.playerDamageSetting       #10
@export var health: float = 100
@export var maxHealth = 100
var canShoot: bool = true
var reloading: bool = false
@export var cooldown = 0.25
@export var reload_time: float = 1
var magSize = 10
var currentAmmo = 10

@onready var viewport_size = get_viewport().get_visible_rect().size


func _ready() -> void:
	$GunCooldown.wait_time = cooldown
	# Initialize the health bar
	healthBar.max_value = maxHealth
	healthBar.value = health
	healthBar.show()
	
	# Style the health bar for better visibility
	_setup_health_bar_style()
	#healthBar.position = Vector2(healthBar.size.x / 2, -60)  
	#healthBar.position = Vector2(0,0)  

func _physics_process(delta: float) -> void:
	
	if Input.is_key_label_pressed(KEY_SPACE):
		shoot()
	# Handle rotation
	var rotation_direction = 0
	if Input.is_action_pressed("rotateLeft"):
		rotation_direction -= 1
	if Input.is_action_pressed("rotateRight"):
		rotation_direction += 1
	
	if Input.is_key_label_pressed(KEY_R): # manual reload only if not full
		if currentAmmo < magSize:
			reloading = true
			start_reload() 
			$Body.play("reload")
	# Apply rotation
	rotation += rotation_direction * rotation_speed * delta
	
	# Handle movement
	var input_direction = 0
	
	#wrapped movement and animation logic in this reloading conditional to not avoid conflicting body animations
	if not reloading:
		if Input.is_action_pressed("forward"):
			$Body.play("move_forward")
			$Body/Feet.play("run_forward")
			input_direction += 1
	
		elif Input.is_action_pressed("back"):
			#$Body.play("move_back")
			$Body.play_backwards("move_forward")
			$Body/Feet.play_backwards("run_forward")
			input_direction -= 1
		else:
			$Body.play("idle")
			$Body/Feet.pause()
	else:
		#print("reloading body animation\n")
		$Body.play("reload")
		if Input.is_action_pressed("forward"):
			#$Body.play("move_forward")
			$Body/Feet.play("run_forward")
			input_direction += 1
	
		elif Input.is_action_pressed("back"):
			#$Body.play("move_back")
			#$Body.play_backwards("move_forward")
			$Body/Feet.play_backwards("run_forward")
			input_direction -= 1
		else:
			#$Body.play("idle")
			$Body/Feet.pause()
	
	# Calculate target velocity based on character's forward direction
	var forward_direction = Vector2.RIGHT.rotated(rotation)
	var target_velocity = forward_direction * input_direction * movement_speed
	
	# Smoothly apply acceleration
	velocity = velocity.lerp(target_velocity, acceleration * delta)
	#velocity += acceleration * forward_direction 
	# Move the character
	move_and_slide()
	


	
func shoot():
	if currentAmmo < 1:
		reloading = true
		start_reload()
		
		
	if canShoot and currentAmmo > 0:
		var bullet = bullet_scene.instantiate()
		$MuzzleFlash.visible = true 
		$GunSound.play()
		$Body.play("shoot")
		HUD.fire_weapon()
		bullet.global_position = marker.global_position
		bullet.direction = Vector2.RIGHT.rotated((rotation))
		get_parent().add_child(bullet)
		currentAmmo -=1
		$GunCooldown.start()
		canShoot = false
		
		#increment shots fired 
		PlayerData.shots_fired+= 1
		print("animated_player.gd: total shots fired: ", PlayerData.shots_fired)



var takingDamage = false
func damage():
	if not takingDamage:
		healthFeedback()
		$Camera2D.big_shake()
	var beforeHealth = health
	health -= damageAmount
	# Update health bar
	healthBar.value = health
	
	# Animate the health bar decreasing
	_animate_health_bar(beforeHealth, health)
	
	# Update health bar color based on current health percentage
	_update_health_bar_color()

	if health <= 0:
		die()
	#print("\nplayer damage: (current health)", health)

func die():
	#print("inside animated player script: die()\n")
	#print("username: ", PlayerData.user_name, " has died\n")
	var scene_root = get_tree().current_scene
	if scene_root:
		queue_free()
		scene_root.game_over()
	


func _on_gun_cooldown_timeout() -> void:
	canShoot = true
	$MuzzleFlash.visible = false

# implementing new reload  mechanics 
func start_reload():
	$ReloadSound.play()
	#print("reloading\n")
	HUD.start_reload()
	#$Body.stop()
	#$Body.play("reload")
	canShoot = false
	emit_signal("reload_started", reload_time)  # For UI updates
	await get_tree().create_timer(reload_time).timeout
	currentAmmo = magSize  # Refill ammo
	canShoot = true
	emit_signal("reload_completed")
	reloading = false
	#$Body.stop()

func damage_done():
	takingDamage = false

#implementing health feedback 
func healthFeedback():
	var original_color = modulate
	takingDamage = true
	#modulate = Color(0,0,0)
	var tween =get_tree().create_tween()
	tween.tween_property(self, "modulate", Color.BLACK, 0.5)
	tween.tween_property(self, "modulate", original_color, 0.5)
	#await get_tree().create_timer(1).timeout
	tween.tween_callback(damage_done)
	modulate = original_color


func _animate_health_bar(from_value: float, to_value: float) -> void:
	var tween = get_tree().create_tween()
	# Cancel any existing animation
	if tween and tween.is_valid():
		tween.kill()
	
	# Create new tween for smooth health bar animation
	tween = create_tween()
	tween.tween_property(healthBar, "value", to_value, 0.3)

func _update_health_bar_color() -> void:
	# Calculate health percentage
	var health_percent = health / maxHealth
	var PulseTimer = get_node("PulseTimer")
	
	# Change color based on health level
	#if health_percent <= 0.25:
		#healthBar.modulate = Color(1, 0, 0)  # Red when health is critical
	#elif health_percent <= 0.5:
		#healthBar.modulate = Color(1, 0.5, 0)  # Orange when health is low
	#else:
		#healthBar.modulate = Color(0, 1, 0)  # Green when health is good
	
	# Change color based on health percent with a smooth gradient
	var fill_style = healthBar.get_theme_stylebox("fill")
	if fill_style is StyleBoxFlat:
		# Create a smooth transition from green (100%) to yellow (50%) to red (0%)
		var r = lerp(0.0, 1.0, 1.0 - health_percent)	# Red increases as health decreases
		var g = lerp(0.0, 1.0, health_percent)		# Green decreases as health decreases
		var b = 0.0					# Blue stays at 0
		
		# Apply the new color
		fill_style.bg_color = Color(r, g, b)
		
		# Optional: Add a subtle pulsing effect when health is critical
		if health_percent <= 20:
			if PulseTimer != null:
				if PulseTimer.is_stopped():
						# Start a pulsing effect if not already pulsing
					start_pulse_effect()
		else:
			# Stop pulsing if health is above critical
			if has_node("PulseTimer"):
				stop_pulse_effect()


func _setup_health_bar_style() -> void:
	# Set up background style
	var bg_style = StyleBoxFlat.new()
	bg_style.bg_color = Color(0.2, 0.2, 0.2, 0.8)
	bg_style.corner_radius_top_left = 6 # og is 2
	bg_style.corner_radius_top_right = 6 # og is 2
	bg_style.corner_radius_bottom_left = 6 # og is 2
	bg_style.corner_radius_bottom_right = 6 # og is 2
	healthBar.add_theme_stylebox_override("background", bg_style)
	
	# Set up fill style
	var fill_style = StyleBoxFlat.new()
	fill_style.bg_color = Color(0, 1, 0)  # Start with green
	fill_style.corner_radius_top_left = 2  # og is 2
	fill_style.corner_radius_top_right = 2  # og is 2
	fill_style.corner_radius_bottom_left = 2  # og is 2
	fill_style.corner_radius_bottom_right = 2  # og is 2
	healthBar.add_theme_stylebox_override("fill", fill_style)
	
	# Make health bar a good size
	healthBar.custom_minimum_size = Vector2(50, 8)

func start_pulse_effect():
	var pulse_timer = Timer.new()
	pulse_timer.name = "PulseTimer"
	pulse_timer.wait_time = 0.5	# Pulse every half second
	pulse_timer.autostart = true
	add_child(pulse_timer)
	pulse_timer.connect("timeout", Callable(self, "pulse_health_bar"))
	
func pulse_health_bar():
	var current_alpha = healthBar.modulate.a
	# Toggle between normal and slightly transparent
	healthBar.modulate.a = 1.0 if current_alpha < 1.0 else 0.7
	
func stop_pulse_effect():
	if has_node("PulseTimer"):
		var pulse_timer = get_node("PulseTimer")
		pulse_timer.stop()
		pulse_timer.queue_free()
		healthBar.modulate.a = 1.0	# Reset to full visibility

func add_health(amount):
	health+= amount



# health label styling 
# Apply styling to the existing healthLabel
func stylize_health_label():
	# Set basic properties
	healthLabel.text = "HEALTH"
	
	# Apply font styling
	healthLabel.add_theme_font_size_override("font_size", 16)
	healthLabel.add_theme_color_override("font_color", Color(0.9, 0.9, 0.9))
	healthLabel.add_theme_constant_override("shadow_offset_x", 2)
	healthLabel.add_theme_constant_override("shadow_offset_y", 2)
	healthLabel.add_theme_color_override("font_shadow_color", Color(0, 0, 0, 0.5))
	
	# Make the label bold
	healthLabel.add_theme_font_override("font_bold", true)
	
	# Position the label to the left of the health bar
	# Assuming health bar is at position (0,0) relative to parent
	healthLabel.position = Vector2(-70, 0)  # Adjust based on your layout
	
	# Optional: Add a custom background
	var style_box = StyleBoxFlat.new()
	style_box.bg_color = Color(0.1, 0.1, 0.1, 0.7)
	style_box.corner_radius_top_left = 4
	style_box.corner_radius_top_right = 4
	style_box.corner_radius_bottom_left = 4
	style_box.corner_radius_bottom_right = 4
	style_box.content_margin_left = 5
	style_box.content_margin_right = 5
	style_box.content_margin_top = 2
	style_box.content_margin_bottom = 2
	healthLabel.add_theme_stylebox_override("normal", style_box)
	
	
	# Add this function to create a pulsing effect
func pulse_health_label():
	var tween = create_tween().set_loops()
	tween.tween_property(healthLabel, "modulate", Color(1, 0, 0, 1), 0.5)
	tween.tween_property(healthLabel, "modulate", Color(1, 0.5, 0.5, 1), 0.5)

# Call this function when health is low
# For example in your health update function:
func update_health(new_health_value):
	# Your existing health update code
	
	# Add pulsing effect when health is critical
	if new_health_value <= 25:
		pulse_health_label()
	else:
		# Reset to normal if health recovers
		var reset_tween = create_tween()
		reset_tween.tween_property(healthLabel, "modulate", Color(1, 1, 1, 1), 0.3)
