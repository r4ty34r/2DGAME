#extends CanvasLayer
#
## UI Components
#@onready var ammo_label = $AmmoCounter/AmmoLabel
#@onready var reload_progress_bar = $ReloadTimer/ProgressBar
#@onready var reload_timer_circle = $ReloadTimer/CircleProgress
#@onready var reload_time_label = $ReloadTimer/TimeLabel
#@onready var bullet_container = $BulletVisual/Container
#@onready var bullet_icon = preload("res://assets/bulletpng.png")
#
## Configuration
#var max_ammo = 10
#var current_ammo = 10
#var reload_time = 1
#var reload_timer = 0
#var is_reloading = false
#
#
## Bullet icon scene for visual representation
##var bullet_icon_scene = preload("res://scenes/ui/bullet_icon.tscn")
#
#func _ready():
	## Initialize HUD elements
	#update_ammo_display()
	##reload_progress_bar.max_value = reload_time
	##reload_progress_bar.value = 0
	##reload_progress_bar.visible = false
	##reload_timer_circle.value = 0
	##reload_timer_circle.visible = false
	##reload_time_label.visible = false
	 ## Set up a cleaner reload indicator
	#reload_progress_bar.max_value = 100
	#reload_progress_bar.value = 0
	## Style the progress bar
	#reload_progress_bar.modulate = Color(0.9, 0.7, 0.2)  # A gold/amber color
	## Make the bar thicker and more visible
	#reload_progress_bar.custom_minimum_size.y = 4
	#
	#reload_timer_circle.visible = false
	#reload_time_label.visible = false
	#
	#_setup_bullet_icons()
	#
	## Create a stylized HUD frame
	#var hud_frame = ColorRect.new()
	#hud_frame.color = Color(0.1, 0.1, 0.1, 0.5)  # Semi-transparent dark background
	#hud_frame.size = Vector2(250, 60)
	#hud_frame.position = Vector2(10, get_viewport().size.y - 70)
	#
	## Add rounded corners with a shader
	#var border = ColorRect.new()
	#border.color = Color(0.7, 0.7, 0.7, 0.3)
	#border.size = Vector2(254, 64)
	#border.position = Vector2(8, get_viewport().size.y - 72)
	#
	## Insert the frame at the beginning of the HUD children
	#$HUDPanel.add_child(border)
	#$HUDPanel.add_child(hud_frame)
	#$HUDPanel.move_child(border, 0)
	#$HUDPanel.move_child(hud_frame, 1)
	#
	#
	#
	 ## Replace text label with icon
	#var ammo_icon = TextureRect.new()
	#ammo_icon.texture = preload("res://assets/bulletpng.png")  # Your ammo icon
	#ammo_icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	#ammo_icon.custom_minimum_size = Vector2(24, 24)
	#ammo_icon.position = Vector2(20, get_viewport().size.y - 50)
	#
	## Replace or position next to existing AMMO text
	#$AmmoCounter.add_child(ammo_icon)
	#
	 ## Style the ammo counter text
	#ammo_label.add_theme_font_size_override("font_size", 18)
	#ammo_label.position = Vector2(ammo_label.position.x + 30, ammo_label.position.y)  # Move to make room for icon
	## Create bullet icons
	##_setup_bullet_icons()
	#
	#
#
#func _process(delta):
	#if is_reloading:
		## Update reload timer
		#reload_timer += delta
		#
		## Update progress displays
		#var progress = reload_timer / reload_time * 100
		##reload_progress_bar.value = reload_timer
		#reload_progress_bar.value = progress
		##reload_timer_circle.value = progress * 100
		#
		## Adding pulse visual 
		#var pulse = (sin(reload_timer * 10) * 0.2) + 0.8
		#reload_progress_bar.modulate = Color(
			#reload_progress_bar.modulate.r,
			#reload_progress_bar.modulate.g,
			#reload_progress_bar.modulate.b,
			#pulse
		#)
		#
		## Update time remaining text
		#var time_left = max(0, reload_time - reload_timer)
		#reload_time_label.text = "%.1fs" % time_left
		#
		## Check if reload is complete
		#if reload_timer >= reload_time:
			#_complete_reload()
#
## Updates the ammo counter display
#func update_ammo_display():
	## Update numerical display
	#ammo_label.text = str(current_ammo) + " / " + str(max_ammo)
	#
	## Add color warning for low ammo
	#if current_ammo <= max_ammo/2:
		#ammo_label.modulate = Color(1.0, 0.3, 0.3) # Red for low ammo
	#else:
		#ammo_label.modulate = Color.WHITE
	#
	## Update bullet visualization
	#for i in bullet_container.get_child_count():
		#var bullet = bullet_container.get_child(i)
		#bullet.modulate = Color.WHITE if i < current_ammo else Color(1, 1, 1, 0.3)
	#
#
## Initializes the bullet icon visualization
#func _setup_bullet_icons():
	 ## Clear existing icons
	#for child in bullet_container.get_children():
		#child.queue_free()
	#
	## Create new icons (limit to a reasonable number)
	#var display_count = min(max_ammo, 10)
	##var spacing = 20  # Spacing between icons
	#
	#for i in display_count:
		#var texture_rect = TextureRect.new()
		#texture_rect.texture = bullet_icon
		#texture_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		#texture_rect.custom_minimum_size = Vector2(16, 16)  # Set size as needed
		#texture_rect.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
		#bullet_container.add_child(texture_rect)
#
## Called when player fires weapon
#func fire_weapon():
	#if is_reloading or current_ammo <= 0:
		#return false
	#
	#current_ammo -= 1
	#update_ammo_display()
	#
	## Auto-reload when empty
	#if current_ammo <= 0:
		#start_reload()
	#
	#return true
#
## Starts the reload process
#func start_reload():
	#if is_reloading or current_ammo == max_ammo:
		#return
	#
	#is_reloading = true
	#reload_timer = 0
	#
	### Show reload indicators
	##reload_progress_bar.visible = true
	##reload_timer_circle.visible = true
	##reload_time_label.visible = false
	##
	  ## Hide standard indicators
	#reload_progress_bar.visible = false
	#reload_timer_circle.visible = false
	#reload_time_label.visible = false
	#
	## Show a single "RELOADING" indicator
	#ammo_label.text = "RELOADING..."
	#
	## Start animation for bullet icons
	#for i in range(max_ammo):
		#if i < bullet_container.get_child_count():
			#var bullet = bullet_container.get_child(i)
			#var tween = create_tween()
			## Start with dim bullets
			#bullet.modulate = Color(0.5, 0.5, 0.5, 0.7)
			## Schedule their appearance based on reload progress
			#var delay = reload_time * (i / float(max_ammo))
			#tween.tween_interval(delay)
			#tween.tween_property(bullet, "modulate", Color.WHITE, 0.2)
#
## Completes the reload process
#func _complete_reload():
	#current_ammo = max_ammo
	#is_reloading = false
	#
	## Hide reload indicators
	#reload_progress_bar.visible = false
	#reload_timer_circle.visible = false
	#reload_time_label.visible = false
	#
	## Update ammo display
	#update_ammo_display()
#
## Can be called from outside to cancel reload (e.g., when switching weapons)
#func cancel_reload():
	#if is_reloading:
		#is_reloading = false
		#reload_progress_bar.visible = false
		#reload_timer_circle.visible = false
		#reload_time_label.visible = false
#
#
## Add this new function to create the health bar
#func create_health_bar():
	## Get viewport size for positioning
	#var viewport_size = get_viewport().get_visible_rect().size
	#
	## Create a container node
	#var health_container = Control.new()
	#health_container.name = "HealthContainer"
	#health_container.position = Vector2(viewport_size.x - 180, 20)
	#
	## Create background
	#var health_bg = ColorRect.new()
	#health_bg.name = "HealthBG"
	#health_bg.color = Color(0.2, 0.2, 0.2, 0.8)
	#health_bg.size = Vector2(150, 12)
	#
	## Create foreground fill
	#var health_fill = ColorRect.new()
	#health_fill.name = "HealthFill"
	#health_fill.color = Color(0.2, 0.8, 0.3)
	#health_fill.size = Vector2(150, 12)
	#
	## Create label
	#var health_label = Label.new()
	#health_label.name = "HealthLabel"
	#health_label.text = "HEALTH"
	#health_label.position = Vector2(55, -18)
	#health_label.add_theme_font_size_override("font_size", 12)
	#
	## Add nodes to hierarchy
	#health_container.add_child(health_bg)
	#health_container.add_child(health_fill)
	#health_container.add_child(health_label)
	#
	## Add container to the scene
	#add_child(health_container)
	#
	## Animate it in
	#health_container.modulate.a = 0
	#var tween = create_tween()
	#tween.tween_property(health_container, "modulate:a", 1.0, 0.5)
#
## Call this whenever player health changes
#func update_health_bar(current_health, max_health):
	## Find the health fill bar
	#var health_fill = get_node_or_null("HealthContainer/HealthFill")
	#if health_fill:
		## Calculate percentage and update width
		#var health_percent = float(current_health) / max_health
		#health_fill.size.x = 150 * health_percent
		#
		## Change color based on health
		#if health_percent < 0.3:
			#health_fill.color = Color(0.9, 0.2, 0.2)  # Red when low
		#elif health_percent < 0.6:
			#health_fill.color = Color(0.9, 0.6, 0.2)  # Orange when medium
		#else:
			#health_fill.color = Color(0.2, 0.8, 0.3)  # Green when high
			#
		## Add a little flash effect when health changes
		#var tween = create_tween()
		#tween.tween_property(health_fill, "modulate", Color(1.5, 1.5, 1.5), 0.1)
		#tween.tween_property(health_fill, "modulate", Color(1, 1, 1), 0.2)



## new version 

extends CanvasLayer

# UI Components
@onready var ammo_label = $AmmoCounter/AmmoLabel
@onready var reload_progress_bar = $ReloadTimer/ProgressBar
@onready var reload_timer_circle = $ReloadTimer/CircleProgress
@onready var reload_time_label = $ReloadTimer/TimeLabel
@onready var bullet_container = $BulletVisual/Container
@onready var healthBar = $ProgressBar
@onready var HealthLabel = $ProgressBar/HealthLabel
# Assets
@onready var bullet_icon = preload("res://assets/bulletpng.png")

# grab player health bar node and modify it 

# Constants
const MAX_AMMO := 10
const HUD_FRAME_SIZE := Vector2(250, 60)
const BULLET_ICON_SIZE := Vector2(16, 16)
const AMMO_ICON_SIZE := Vector2(24, 24)
const HEALTH_BAR_WIDTH := 150
const RELOAD_BAR_COLOR := Color(0.9, 0.7, 0.2)

# State
var current_ammo = MAX_AMMO
var reload_time = 1.0
var reload_timer = 0.0
var is_reloading = false

func _ready():
	#pin position to bottom left 
	self.offset.y = get_viewport().size.y * .75
	update_ammo_display()
	_setup_reload_bar()
	_setup_bullet_icons()
	#_create_hud_frame()
	#_create_ammo_icon()
	#create_health_bar()


func _setup_reload_bar():
	reload_progress_bar.max_value = 100
	reload_progress_bar.value = 0
	reload_progress_bar.modulate = RELOAD_BAR_COLOR
	reload_progress_bar.custom_minimum_size.y = 4
	reload_progress_bar.visible = false
	reload_timer_circle.visible = false
	reload_time_label.visible = false
#
#func _create_hud_frame():
	#var hud_frame = ColorRect.new()
	##hud_frame.color = Color(0.1, 0.1, 0.1, 0.5)
	#hud_frame.color = Color(1, 1, 1, 1)
	#hud_frame.size = HUD_FRAME_SIZE
	#
	#var border = ColorRect.new()
	#border.color = Color(0.7, 0.7, 0.7, 0.3)
	#border.size = HUD_FRAME_SIZE + Vector2(4, 4)
#
	#var viewport_height = get_viewport().get_visible_rect().size.y
#
	#hud_frame.position = Vector2(1000, viewport_height) #- HUD_FRAME_SIZE.y - 10)
	#border.position = hud_frame.position - Vector2(2, 2)
#
	#$HUDPanel.add_child(border)
	#$HUDPanel.add_child(hud_frame)
	#$HUDPanel.move_child(border, 0)
	#$HUDPanel.move_child(hud_frame, 1)
#
#func _create_ammo_icon():
	#var ammo_icon = TextureRect.new()
	#ammo_icon.texture = bullet_icon
	#ammo_icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	#ammo_icon.custom_minimum_size = AMMO_ICON_SIZE
	#
	#var ammo_counter_height = $AmmoCounter.size.y
	#ammo_icon.position = Vector2(0, (ammo_counter_height - AMMO_ICON_SIZE.y) / 2)
	#
	#$AmmoCounter.add_child(ammo_icon)
#
	#ammo_label.add_theme_font_size_override("font_size", 18)
	#ammo_label.position.x = ammo_icon.position.x + AMMO_ICON_SIZE.x + 6

func _setup_bullet_icons():
	for child in bullet_container.get_children():
		child.queue_free()
		
	var display_count = min(MAX_AMMO, 10)
	for i in display_count:
		var icon = TextureRect.new()
		icon.texture = bullet_icon
		icon.custom_minimum_size = BULLET_ICON_SIZE
		icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		icon.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
		bullet_container.add_child(icon)

func update_ammo_display():
	ammo_label.text = "%d / %d" % [current_ammo, MAX_AMMO]
	ammo_label.modulate = Color(1.0, 0.3, 0.3) if current_ammo <= MAX_AMMO / 2 else Color.WHITE

	for i in bullet_container.get_child_count():
		var bullet = bullet_container.get_child(i)
		bullet.modulate = Color.WHITE if i < current_ammo else Color(1, 1, 1, 0.3)

func _process(delta):
	if is_reloading:
		reload_timer += delta
		var progress = reload_timer / reload_time * 100
		reload_progress_bar.value = progress

		var pulse = (sin(reload_timer * 10) * 0.2) + 0.8
		reload_progress_bar.modulate.a = pulse

		var time_left = max(0, reload_time - reload_timer)
		reload_time_label.text = "%.1fs" % time_left

		if reload_timer >= reload_time:
			_complete_reload()

func fire_weapon():
	if is_reloading or current_ammo <= 0:
		return false
	
	current_ammo -= 1
	update_ammo_display()
	
	if current_ammo <= 0:
		start_reload()
	
	return true

func start_reload():
	if is_reloading or current_ammo == MAX_AMMO:
		return
	
	is_reloading = true
	reload_timer = 0
	
	reload_progress_bar.visible = false
	reload_timer_circle.visible = false
	reload_time_label.visible = false
	ammo_label.text = "RELOADING..."
	
	for i in range(MAX_AMMO):
		if i < bullet_container.get_child_count():
			var bullet = bullet_container.get_child(i)
			var tween = create_tween()
			bullet.modulate = Color(0.5, 0.5, 0.5, 0.7)
			var delay = reload_time * (i / float(MAX_AMMO))
			tween.tween_interval(delay)
			tween.tween_property(bullet, "modulate", Color.WHITE, 0.2)

func _complete_reload():
	current_ammo = MAX_AMMO
	is_reloading = false
	reload_progress_bar.visible = false
	reload_timer_circle.visible = false
	reload_time_label.visible = false
	update_ammo_display()

func cancel_reload():
	if is_reloading:
		is_reloading = false
		reload_progress_bar.visible = false
		reload_timer_circle.visible = false
		reload_time_label.visible = false
#
#
#func create_health_bar():
	#var viewport_size = get_viewport().get_visible_rect().size
	#
	#var health_container = Control.new()
	#health_container.name = "HealthContainer"
	#health_container.position = Vector2(viewport_size.x * .03, viewport_size.y * .15)
	#
	#var bg = ColorRect.new()
	#bg.name = "HealthBG"
	##bg.color = Color(0.2, 0.2, 0.2, 0.8)
	#bg.color = Color(1, 1, 1, 1)
	#bg.size = Vector2(HEALTH_BAR_WIDTH, 100)
#
	#var fill = ColorRect.new()
	#fill.name = "HealthFill"
	#fill.color = Color(1.2, .3, 17)
	#fill.size = Vector2(HEALTH_BAR_WIDTH, 12)
#
	#var label = Label.new()
	#label.name = "HealthLabel"
	#label.text = "HEALTH"
	#label.position = Vector2((HEALTH_BAR_WIDTH - 60) / 2, -18)
	#label.add_theme_font_size_override("font_size", 12)
#
	#health_container.add_child(bg)
	#health_container.add_child(fill)
	#health_container.add_child(label)
	#add_child(health_container)
#
	#health_container.modulate.a = 0
	#var tween = create_tween()
	#tween.tween_property(health_container, "modulate:a", 1.0, 0.5)
#
#func update_health_bar(current_health, max_health):
	#var fill = get_node_or_null("HealthContainer/HealthFill")
	#if fill:
		#var percent = float(current_health) / max_health
		#fill.size.x = HEALTH_BAR_WIDTH * percent
#
		#if percent < 0.3:
			#fill.color = Color(0.9, 0.2, 0.2)
		#elif percent < 0.6:
			#fill.color = Color(0.9, 0.6, 0.2)
		#else:
			#fill.color = Color(0.2, 0.8, 0.3)
#
		#var tween = create_tween()
		#tween.tween_property(fill, "modulate", Color(1.5, 1.5, 1.5), 0.1)
		#tween.tween_property(fill, "modulate", Color(1, 1, 1), 0.2)
