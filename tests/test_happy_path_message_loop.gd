extends GutTest

var env: ScenarioEnvironment
var runner: ScenarioRunner

func before_each():
	# Build a clean environment for each test
	env = ScenarioEnvironment.new()
	env.build()

	runner = ScenarioRunner.new()
	runner.environment = env


func test_happy_path_message_loop() -> void:
	var env := ScenarioEnvironment.new()
	env.build()                               # 🔥 REQUIRED
	var runner := ScenarioRunner.new()
	runner.environment = env

	var ok := runner.run_scenario_from_file("res://tests/data/happy_path_message_loop.json")
	assert_true(ok, "Happy Path scenario should pass")
