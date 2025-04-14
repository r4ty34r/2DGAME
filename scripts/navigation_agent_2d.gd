extends NavigationAgent2D

func _ready() -> void:
	var agent: RID = get_rid()
	# Enable avoidance
	NavigationServer2D.agent_set_avoidance_enabled(agent, true)
	# Create avoidance callback
	NavigationServer2D.agent_set_avoidance_callback(agent, Callable(self, "_avoidance_done"))

	# Disable avoidance
	NavigationServer2D.agent_set_avoidance_enabled(agent, false)
	# Delete avoidance callback
	NavigationServer2D.agent_set_avoidance_callback(agent, Callable())
