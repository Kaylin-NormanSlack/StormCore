extends GutTest

var env: ScenarioEnvironment
var runner: ScenarioRunner

var test_root: Node
var implimented_tests_path := "res://addons/StormCore/tests/data/scenarios/implimented/"

func before_each():
	test_root = Node.new()
	test_root.name = "TestRoot"
	add_child(test_root)
	InputPoller.is_enabled = false
	GlobalBusManager.reset()
	
	GlobalAdapterRegistry.adapter_folder = "res://addons/StormCore/tests/test_adapters/"
	GlobalAdapterRegistry.reload()
	
	for adapter in GlobalAdapterRegistry.get_all():
		if adapter.get_parent() == null:
			test_root.add_child(adapter)
	
	env = ScenarioEnvironment.new()
	test_root.add_child(env)
	env.build()
	
	runner = ScenarioRunner.new()
	test_root.add_child(runner)
	runner.environment = env
	
func after_each():
	GlobalAdapterRegistry._clear_state()
	if is_instance_valid(test_root):
		test_root.free()
		
	test_root = null
	env = null
	runner = null

# Individual happy path tests
func test_happy_path_message_sent_successfully():
	var ok := runner.run_scenario_from_file(
		implimented_tests_path + "message_sent_successfully.json"
	)
	assert_true(ok, "Messeng_Sent not emitted")

#func test_stress_one_thousand_messages():
	#var ok := runner.run_scenario_from_file(
		#"res://tests/data/scenarios/implimented/stress_test_1000_messages.json"
	#)
	#assert_true(ok, "Tests were unable to be completed.")
	
func test_happy_path_send_receive_message_loop():
	var ok := runner.run_scenario_from_file(
		implimented_tests_path + "send_recieve_message_loop.json"
	)
	assert_true(ok, "Complete message loop has failed to be executed ")

func test_error_missing_payload():
	var ok := runner.run_scenario_from_file(
		implimented_tests_path + "test_missing_payload.json"
	)
	assert_true(ok, "Error Handling: Missing Payload failed.")
