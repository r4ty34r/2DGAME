extends Area2D

@export var speed: float = 1000.0
@export var lifetime: float = 3.0

func _ready():
	$Timer.wait_time = lifetime
	$Timer.start()

func _process(delta):
	global_position += Vector2.RIGHT.rotated(rotation) * speed * delta

func _on_Timer_timeout():
	queue_free()

func _on_body_entered(body):
	if body.is_in_group("Walls"):
		queue_free()  # Destroy bullet on collision
	if body.is_in_group("players"):  # Ensure the player is in the "player" group
		body.damage()
		queue_free()
