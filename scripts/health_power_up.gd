# Step 1: Create a health_powerup.gd script for the power-up
extends Area2D


@export var heal_amount = 50  # Amount of health to restore
@export var collection_effect_scene: PackedScene  # Optional particle effect for collection


func _on_body_entered(body):
	if body.is_in_group("players"):
		body.add_health(heal_amount)
		print("health_power_up.gd: player health incremented\n")
		
		
		## Optional: Spawn collection effect
		#if collection_effect_scene:
			#var effect = collection_effect_scene.instantiate()
			#effect.global_position = global_position
			#get_parent().add_child(effect)
		
		# Remove the power-up
		queue_free()
