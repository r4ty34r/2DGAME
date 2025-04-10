extends Node

# Reference to the HTTPRequest node
@onready var http_request = $HTTPRequest  # Adjust path if needed

func _ready():
	# Connect the request_completed signal
	http_request.request_completed.connect(_on_request_completed)
	
	# Test the /test endpoint (GET request)
	test_api()
	
	# Uncomment to test the /analytics endpoint (POST request)
	#send_analytics()
	print("done connected http request in http script\n")

# Function to test the /test endpoint (GET)

func _process(_delta: float) -> void:
	if PlayerData.send_flag == true:
		print("\ninside http process func... analytics data to be sent soon ")
		send_analytics2()
		PlayerData.send_flag = false

func test_api():
	var url = "http://127.0.0.1:8000/test"
	var error = http_request.request(url)
	if error != OK:
		print("Error initiating GET request: ", error)


# Function to send data to /analytics endpoint (POST)
func send_analytics():
	var url = "http://127.0.0.1:8000/analytics"
	var headers = ["Content-Type: application/json"]
	
	# Example analytics data
	var analytics_data = {
		"player_id": "player123",
		"session_time": 300,  # in seconds
		"score": 1500,
		"deaths": 3,
		"level": 5
	}
	print("\nhttpscript.gd: sending actual player data", PlayerData.actual_data)
	var json_data = JSON.stringify(PlayerData.actual_data)
	var error = http_request.request(url, headers, HTTPClient.METHOD_POST, json_data)
	if error != OK:
		print("Error initiating POST request: ", error)

# Callback function to handle the response
func _on_request_completed(result, response_code, headers, body):
	if result == HTTPRequest.RESULT_SUCCESS:
		if response_code == 200:
			var json = JSON.new()
			var parse_result = json.parse(body.get_string_from_utf8())
			if parse_result == OK:
				var data = json.data
				print("Response from Flask: ", data)
			else:
				print("Failed to parse JSON: ", json.get_error_message())
		elif response_code == 400:
			print("Bad request: ", body.get_string_from_utf8())
		else:
			print("Unexpected response code: ", response_code)
	else:
		print("Request failed with result: ", result)

func send_analytics2():
	print("\n httpscript.gd: send_analytics2: sending http data to flask")
	var url = "http://127.0.0.1:8000/analytics"
	var headers = ["Content-Type: application/json"]
	
	# Example analytics data
	var analytics_datasample = {
		"player_id": "TESTPLAYER",
		"session_time": 300,  # in seconds
		"score": 6969,
		"deaths": 1,
		"level": 1
	}
	#print("\nhttpscript.gd: actual playerdata is: ", PlayerData.actual_data)
	 #Example analytics data
	var analytics_data = analytics_datasample
	
	var newdata = {
		"player_id": PlayerData.user_name,
		"session_time": 69420,
		"score": PlayerData.enemies_killed,
		"deaths": 420,
		"Level": 69
	}
	
	var json_data = JSON.stringify(analytics_data)
	var json_data2 = JSON.stringify(newdata)
	print("\nhttpscript.gd: json data to be sent: ",json_data2)
	print("\nhttpscript.gd: actual player data", newdata)

	var error = http_request.request(url, headers, HTTPClient.METHOD_POST, json_data2)
	if error != OK:
		print("Error initiating POST request in send2 function: ", error)
	
