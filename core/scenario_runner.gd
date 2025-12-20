# res://core/scenario_runner.gd
extends Node
class_name ScenarioRunner

var environment: ScenarioEnvironment

func _run_single_scenario(scenario: Dictionary) -> bool:
	environment.reset()

	var scenario_name: String = scenario.get("name", "Unnamed Scenario")
	var events: Array = scenario.get("events", [])
	var final_state: Dictionary = scenario.get("final_expected_state", {})

	var scenario_passed: bool = true

	for step in events:
		var step_dict: Dictionary = step
		var step_passed: bool = _run_scenario_step(step_dict)
		if not step_passed:
			scenario_passed = false

	var state_passed: bool = _validate_final_state(final_state)
	if not state_passed:
		scenario_passed = false

	if scenario_passed:
		print("[Scenario PASS] %s" % scenario_name)
	else:
		print("[Scenario FAIL] %s" % scenario_name)

	return scenario_passed


func _run_scenario_step(step: Dictionary) -> bool:
	if not step.has("input"):
		push_error("ScenarioRunner: Scenario step missing 'input'")
		return false

	var input_event: Dictionary = step["input"]
	var expected_emits: Array = step.get("expect_emit", [])

	environment.run_event(input_event)

	var actual_emits: Array = environment.get_emitted_events()
	environment.clear_emitted_events()

	return _validate_emitted_events(actual_emits, expected_emits)


func _validate_emitted_events(actual: Array, expected: Array) -> bool:
	for exp in expected:
		var exp_dict: Dictionary = exp
		var found: bool = false

		for act in actual:
			var act_dict: Dictionary = act
			if _events_match(act_dict, exp_dict):
				found = true
				break

		if not found:
			push_error(
				"ScenarioRunner: Expected emit %s but actual emits were %s"
				% [str(exp_dict), str(actual)]
			)
			return false

	return true


func _events_match(a: Dictionary, b: Dictionary) -> bool:
	if not (a.has("type") and b.has("type")):
		return false
	if a["type"] != b["type"]:
		return false

	for k in b.keys():
		if not a.has(k):
			return false
		if a[k] != b[k]:
			return false

	return true


func _validate_final_state(expected_state: Dictionary) -> bool:
	var passed: bool = true

	for adapter_name in expected_state.keys():
		var name_str: String = adapter_name
		var adapter: BaseAdapter = GlobalAdapterRegistry.get_by_name(name_str)

		if adapter == null:
			push_error("ScenarioRunner: No adapter named '%s' for final state check" % name_str)
			passed = false
			continue

		var expected: Dictionary = expected_state[name_str]
		var actual: Dictionary = adapter.get_final_state() if adapter.has_method("get_final_state") else {}

		for key in expected.keys():
			if not actual.has(key) or actual[key] != expected[key]:
				push_error(
					"ScenarioRunner: Final state mismatch for '%s': expected %s, got %s"
					% [name_str, str(expected), str(actual)]
				)
				passed = false

	return passed


func _load_json(path: String) -> Dictionary:
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		return {}

	var text: String = file.get_as_text()
	var data = JSON.parse_string(text)

	if typeof(data) != TYPE_DICTIONARY:
		return {}

	return data
	
func run_scenario_from_file(path: String) -> bool:
	var scenario_data: Dictionary = _load_json(path)
	if scenario_data.is_empty():
		return false
	
	# Check if it's a single scenario (has "name" and "events")
	if scenario_data.has("name") and scenario_data.has("events"):
		return _run_single_scenario(scenario_data)
	
	# Otherwise, assume it's the old format with "scenarios" array
	if scenario_data.has("scenarios"):
		# For backward compatibility, run first scenario only
		# or implement a different method for multiple scenarios
		var scenarios = scenario_data["scenarios"]
		if scenarios.size() > 0:
			return _run_single_scenario(scenarios[0])
	
	push_error("ScenarioRunner: Invalid scenario format in %s" % path)
	return false
