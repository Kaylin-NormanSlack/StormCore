extends Node

# Event-Driven Core for Godot

## Core Concepts
#- **Adapters**: Plugins that handle specific event types
#- **Buses**: Channels for event communication  
#- **Registry**: Auto-discovers adapters at runtime
#- **Scenario Testing**: JSON-driven integration tests
#
### Basic Usage
#1. Create buses for each domain (UI, game, audio)
#2. Place adapter scripts in `res://adapters/`
#3. The registry auto-discovers and registers them
#4. Adapters listen to buses and handle events
#
### Example Adapter
#[Simple example]
#
### Testing
#[How to write scenario JSON files]

func setup_core():
	# Register buses (one per concern)
	GlobalBusManager.register_bus("ui", BaseEventBus.new())
	GlobalBusManager.register_bus("game", BaseEventBus.new())
	GlobalBusManager.register_bus("audio", BaseEventBus.new())
	
	# Load adapters (auto-discovered)
	GlobalAdapterRegistry.adapter_folder = "res://game/adapters/"
	GlobalAdapterRegistry.reload()
	
	# Connect each adapter to appropriate bus
	for adapter in GlobalAdapterRegistry.get_all():
		adapter.listen_to_bus_named(adapter.get_preferred_bus())
	
	# Start the system
	GlobalBusManager.get_bus("game").emit_event({
		"type": "system_ready"
	})
