extends GutTest

var env: ScenarioEnvironment
var runner: ScenarioRunner

func before_each():
	# Build a clean environment for each test
	env = ScenarioEnvironment.new()
	env.build()

	runner = ScenarioRunner.new()
	runner.environment = env


func test_happy_path_message_loop():
	var json_path = "res://tests/data/happy_path_message_loop.json"

	var passed = runner.run_scenario_from_file(json_path)

	assert_true(passed, "Happy Path scenario should pass")
