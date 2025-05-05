extends Area2D


@export var speed: float = 1000.0
var direction: Vector2 = Vector2.ZERO

func _ready() -> void:
	rotation = direction.angle()

func _physics_process(delta: float) -> void:
	# Move bullet along its initial direction
	position += direction * speed * delta
	


func _on_body_entered(body):
	if body.is_in_group("enemies"):
		body.damage()
		#PlayerData.enemies_killed+=1 # remove this when game is not one shot kill and add to enemy die function
		PlayerData.shots_landed += 1
		queue_free()  # Destroy bullet on collision
	
	if body.is_in_group("Walls"):
		#increment shots missed 
		PlayerData.shots_missed += 1
		queue_free()  # Destroy bullet on collision
