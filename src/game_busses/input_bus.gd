# This script only declares signals that can be interpreted by the global
#bus manager.
extends BaseEventBus
class_name InputBus

signal move_axis(payload)
signal shoot(payload)
