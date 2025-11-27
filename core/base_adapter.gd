extends Node
class_name BaseAdapter

# --- Core Metadata ---
var adapter_name : String = ""
var adapter_category : String = "generic"
var supported_events : Array = []
var adapter_version : String = "1.0.0"

# --- Metadata Accessors ---
func get_adapter_name() -> String:
	return adapter_name

func get_category() -> String:
	return adapter_category

func get_supported_events() -> Array:
	return supported_events

func get_version() -> String:
	return adapter_version
