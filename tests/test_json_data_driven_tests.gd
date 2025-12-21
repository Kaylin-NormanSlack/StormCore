extends GutTest

var env: ScenarioEnvironment
var runner: ScenarioRunner

func before_each():
	GlobalBusManager.reset()
	GlobalAdapterRegistry.adapter_folder = "res://tests/test_adapters/"
	GlobalAdapterRegistry.reload()
	
	env = ScenarioEnvironment.new()
	env.build()
	
	runner = ScenarioRunner.new()
	runner.environment = env

# Individual happy path tests
func test_happy_path_message_sent_successfully():
	var ok := runner.run_scenario_from_file(
		"res://tests/data/scenarios/implimented/message_sent_successfully.json"
	)
	assert_true(ok, "Messeng_Sent not emitted")

#func test_stress_one_thousand_messages():
	#var ok := runner.run_scenario_from_file(
		#"res://tests/data/scenarios/planned/stress_test_1000_messages.json"
	#)
	#assert_true(ok, "Tests were unable to be completed.")
	
func test_happy_path_send_receive_message_loop():
	var ok := runner.run_scenario_from_file(
		"res://tests/data/scenarios/implimented/send_recieve_message_loop.json"
	)
	assert_true(ok, "Complete message loop has failed to be executed ")

func test_error_missing_payload():
	var ok := runner.run_scenario_from_file(
		"res://tests/data/scenarios/implimented/test_missing_payload.json"
	)
	assert_true(ok, "Error Handling: Missing Payload failed.")
