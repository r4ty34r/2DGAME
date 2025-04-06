extends Camera2D

@export var period = 0.3
@export var magnitude = 4.0  # Note: increased value since we're using pixels
@export var decay = true     # Whether the shake should decrease over time

var shake_tween: Tween
var initial_offset = Vector2.ZERO

func _ready():
	# Store the initial offset to restore it after shaking
	initial_offset = offset

func camera_shake(duration: float = period, strength: float = magnitude):
	# Cancel any existing shake
	if shake_tween and shake_tween.is_valid():
		shake_tween.kill()
	
	# Reset to initial position
	offset = initial_offset
	
	# Create new tween
	shake_tween = create_tween()
	
	# Calculate how many steps to perform during the shake
	var steps = int(duration / 0.05)  # Shake roughly 20 times per second
	
	for i in range(steps):
		# Generate random offset within the magnitude
		var random_offset = Vector2(
			randf_range(-strength, strength),
			randf_range(-strength, strength)
		)
		
		# If decay is enabled, reduce the shake intensity over time
		if decay:
			random_offset *= (1.0 - float(i) / steps)
		
		# Add the step to the tween
		shake_tween.tween_property(
			self,              # Target object
			"offset",          # Property to animate
			initial_offset + random_offset,  # Target value
			0.05               # Duration of this step
		)
	
	# Add a final step to reset position
	shake_tween.tween_property(self, "offset", initial_offset, 0.05)

# Example of shake with configurable intensity
func small_shake():
	camera_shake(0.2, magnitude * 0.5)

func medium_shake():
	camera_shake()

func big_shake():
	camera_shake(0.4, magnitude * 1.5)
