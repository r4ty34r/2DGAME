extends CharacterBody2D

# Enemy Stats
@export var speed: float = 150.0
@export var min_distance: float = 100.0  # Minimum distance to keep from player
@export var max_distance: float = 200.0  # Maximum distance before chasing player
@export var bullet_scene: PackedScene = preload("res://scenes/enemy_bullet.tscn")
@export var shoot_interval: float = 1.0
@export var health: float = 100.0
@export var damage_amount: float = 100.0

# State Tracking
enum EnemyState {IDLE, CHASE, ATTACK, RETREAT}
var current_state: EnemyState = EnemyState.IDLE

# References
@onready var player: Node2D = get_tree().get_first_node_in_group("players")
@onready var shoot_timer: Timer = $ShootTimer

func _ready():
	# Fix for double timer initialization in original code
	#shoot_timer.wait_time = shoot_interval
	#shoot_timer.start()
	$ShootTimer.wait_time = shoot_interval
	$ShootTimer.start()
func _physics_process(delta):
	if not player:
		player = get_tree().get_first_node_in_group("players")
		if not player:
			return
			
	# Determine distance to player
	var distance = global_position.distance_to(player.global_position)
	
	# Update state based on distance
	update_state(distance)
	
	# Execute behavior based on state
	match current_state:
		EnemyState.IDLE:
			# Just look at player
			look_at(player.global_position)
			velocity = Vector2.ZERO
			
		EnemyState.CHASE:
			# Move towards player
			look_at(player.global_position)
			var direction = (player.global_position - global_position).normalized()
			velocity = direction * speed
			
		EnemyState.ATTACK:
			# Stay in place and attack
			look_at(player.global_position)
			velocity = Vector2.ZERO
			
		EnemyState.RETREAT:
			# Move away from player
			look_at(player.global_position)
			var direction = (global_position - player.global_position).normalized()
			velocity = direction * (speed * 0.8)
	
	# Apply movement
	move_and_slide()

func update_state(distance: float):
	# Determine state based on distance
	if distance < min_distance:
		current_state = EnemyState.RETREAT
	elif distance < max_distance:
		current_state = EnemyState.ATTACK
	else:
		current_state = EnemyState.CHASE

func _on_ShootTimer_timeout():
	if player and current_state == EnemyState.ATTACK:
		shoot()

func shoot():
	if bullet_scene:
		var bullet = bullet_scene.instantiate()
		get_parent().add_child(bullet)
		bullet.global_position = global_position
		
		# Add slight randomness to shooting for more natural behavior
		var random_spread = randf_range(-5, 5)
		bullet.rotation = rotation + deg_to_rad(random_spread)

func damage(amount: float = damage_amount):
	health -= amount
	
	# Flash sprite when hit
	var sprite = $Sprite2D
	if sprite:
		var tween = create_tween()
		tween.tween_property(sprite, "modulate", Color.RED, 0.1)
		tween.tween_property(sprite, "modulate", Color.WHITE, 0.1)
	
	if health <= 0:
		get_parent().updateScore()
		queue_free()


func _on_shoot_timer_timeout() -> void:
	if player and current_state == EnemyState.ATTACK:
		shoot()
	
