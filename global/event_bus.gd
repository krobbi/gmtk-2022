extends Node

signal shake_camera_request(amount) # warning-ignore: UNUSED_SIGNAL

func safe_connect(signal_name: String, target: Object, method: String) -> void:
	var error: int = connect(signal_name, target, method)
	
	if error and is_connected(signal_name, target, method):
		disconnect(signal_name, target, method)


func safe_disconnect(signal_name: String, target: Object, method: String) -> void:
	if is_connected(signal_name, target, method):
		disconnect(signal_name, target, method)
