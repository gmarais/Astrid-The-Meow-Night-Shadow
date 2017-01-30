extends Control

onready var initial_pos = self.get_global_pos()
onready var initial_scale = self.get_scale()
onready var anchorTop = self.get_anchor(MARGIN_TOP)
onready var anchorBottom = self.get_anchor(MARGIN_BOTTOM)
onready var anchorLeft = self.get_anchor(MARGIN_LEFT)
onready var anchorRight = self.get_anchor(MARGIN_RIGHT)

func _ready():
	if anchorLeft != ANCHOR_BEGIN \
	|| anchorRight != ANCHOR_BEGIN \
	|| anchorTop != ANCHOR_BEGIN \
	|| anchorBottom != ANCHOR_BEGIN :
		set_process(true)
	get_node("/root").connect("size_changed", self, "resize")

func resize():
	initial_pos = self.get_global_pos()
	initial_scale = self.get_scale()

func _process(delta):
	if (self.get_scale() != initial_scale):
		var desired_pos = Vector2(0,0)
		if anchorLeft == anchorRight && anchorLeft != ANCHOR_CENTER:
			if anchorLeft == ANCHOR_BEGIN:
				desired_pos.x = initial_pos.x
			elif anchorLeft == ANCHOR_END:
				desired_pos.x = initial_pos.x + (self.get_size().x * (initial_scale.x - self.get_scale().x))
		else:
			desired_pos.x = initial_pos.x + (self.get_size().x * (initial_scale.x - self.get_scale().x)) / 2

		if anchorTop == anchorBottom && anchorTop != ANCHOR_CENTER:
			if anchorTop == ANCHOR_BEGIN:
				desired_pos.y = initial_pos.y
			elif anchorTop == ANCHOR_END:
				desired_pos.y = initial_pos.y + (self.get_size().y * (initial_scale.y - self.get_scale().y))
		else:
			desired_pos.y = initial_pos.y + (self.get_size().y * (initial_scale.y - self.get_scale().y)) / 2

		if self.get_global_pos() != desired_pos:
			self.set_global_pos(desired_pos)