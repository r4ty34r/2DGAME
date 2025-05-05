extends Node

# Reference to the HTTPRequest node
@onready var http_request = $HTTPRequest  # Adjust path if needed
# commented out to not flood rpi db with records
func _ready():
	print("\nhttpscript.gd: node ready, connecting signal and testing GET request")
	# Connect the request_completed signal
	http_request.request_completed.connect(_on_request_completed)
	
	# Test the /test endpoint (GET request)
	test_api()
	
	# Uncomment to test the /analytics endpoint (POST request)
	#send_analytics()
	#print("done connected http request in http script\n")
#
## Function to test the /test endpoint (GET)

func _process(_delta: float) -> void:
	if PlayerData.send_flag == true:
		print("\nhttpscript.gd: sending data")
		# packages stats and routes to flask backend
		send_analytics2()
		PlayerData.send_flag = false #prevents spamming requests

func test_api():
	#var url = "http://127.0.0.1:8000/test"
	#var url2 = "http://ocodes.xyz:8080/analytics/api/test"
	var url = "http://ocodes.xyz/analytics/api/test"
	var error = http_request.request(url)
	if error != OK:
		print("Error initiating GET request: ", error)


# Function to send data to /analytics endpoint (POST)
#func send_analytics():
	##var url = "http://127.0.0.1:8000/analytics" 
	#var analytics_url = "http://ocodes.xyz:8080/analytics/api/submit"
	#var headers = ["Content-Type: application/json"]
#
	##print("\nhttpscript.gd: sending actual player data", PlayerData.actual_data)
	#var json_data = JSON.stringify(PlayerData.actual_data)
	##var error = http_request.request(url, headers, HTTPClient.METHOD_POST, json_data)
	#var error = http_request.request(analytics_url, headers, HTTPClient.METHOD_POST, json_data)
#
	#if error != OK:
		#print("Error initiating POST request: ", error)

# Callback function to handle the response
func _on_request_completed(result, response_code, headers, body):
	if result == HTTPRequest.RESULT_SUCCESS:
		if response_code == 200:
			var json = JSON.new()
			var parse_result = json.parse(body.get_string_from_utf8())
			if parse_result == OK:
				var data = json.data
				print("httpscript.gd: Response from Flask: ", data)
			else:
				print("Failed to parse JSON: ", json.get_error_message())

		elif response_code == 301 or response_code == 302: # Redirect
			print("httpscript: \nredirecting")
			var redirect_url = headers.get("Location") # new route
			if redirect_url:
				print("Redirecting to: ", redirect_url)
				send_request_to_new_url(redirect_url)
		elif response_code == 400:
			print("Bad request: ", body.get_string_from_utf8())
		else:
			print("Unexpected response code: ", response_code)
	else:
		print("Request failed with result: ", result)

func send_analytics2():
	#print("\n httpscript.gd: send_analytics2: sending http data to flask")
	#var url = "http://127.0.0.1:8000/analytics"
	#var analytics_url = "http://ocodes.xyz:8080/analytics/api/submit"
	var url = "http://ocodes.xyz/analytics/api/submit"
	var headers = ["Content-Type: application/json"]
	
	# setting the data , var should be renamed 
	var testdbdata = {
		"player_id": PlayerData.user_name,
		"session_time": PlayerData.session_time,
		"score": PlayerData.user_score,
		"deaths": 420,
		"level": 69,
		"accuracy": PlayerData.accuracy,
		"damage" : PlayerData.damage_dealt,
		"shots_fired": PlayerData.shots_fired
	}
	
	#var json_data = JSON.stringify(analytics_data) # this was just a test 
	#var json_data2 = JSON.stringify(newdata) # actual live data from match
	
	
	var json_datadb = JSON.stringify(testdbdata)
	print("\nhttpscript.gd: json data to be sent: ",json_datadb) 
	#print("\nhttpscript.gd: actual player data", newdata) # printing here to ensure data isnt stale

	var error = http_request.request(url, headers, HTTPClient.METHOD_POST, json_datadb)
	if error != OK:
		print("Error initiating POST request in send2 function: ", error)


#handling redirect
func send_request_to_new_url(url: String):
	var testdbdata = {
		"player_id": PlayerData.user_name,
		"session_time": PlayerData.session_time,
		"score": PlayerData.enemies_killed,
		"deaths": 420,
		"level": 69,
		"accuracy": PlayerData.accuracy,
		"damage" : PlayerData.damage_dealt,
		"shots_fired": PlayerData.shots_fired
	}
	var json = JSON.stringify(testdbdata)
	var headers = ["Content-Type: application/json"]
	var error = http_request.request(url, headers, HTTPClient.METHOD_POST, json)
	# You can set the same headers and body as the original request, if needed
	#var error = http_request.request(url, headers, HTTPClient.METHOD_POST, json_datadb)
	if error != OK:
		print("Failed to send request to ", url)
	else:
		print("Request sent to new URL: ", url)
