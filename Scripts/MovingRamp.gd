extends Spatial

export var size_of_ramps = 25
var padding
var player = null
var ramp_count

func _ready():
	player = get_parent().find_node("Player")
	ramp_count = get_child_count()
	padding = ramp_count * size_of_ramps
	set_fixed_process(true)

func _fixed_process(delta):
	for child in get_children():
		if child.get_translation().z + size_of_ramps * 2 < player.get_translation().z:
			child.set_translation(Vector3(0.0, 0.0, child.get_translation().z + padding))
			for subchild in child.get_children():
				if "passed" in subchild:
					subchild.passed = false
					if subchild.is_visible() == false:
						subchild.show()
