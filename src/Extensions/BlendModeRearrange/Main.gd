extends Node

var api: Node
var blend_ui: Control
var tag_scroll: Control

# This script acts as a setup for the extension
func _enter_tree() -> void:
	## NOTE: use get_node_or_null("/root/ExtensionsApi") to access api.
	api = get_node_or_null("/root/ExtensionsApi")

	blend_ui = api.general.get_global().animation_timeline.find_child("BlendContainer")
	var new_parent: Control = api.general.get_global().animation_timeline.find_child("AnimationButtons")
	if !blend_ui or !new_parent:
		return
	blend_ui.get_parent().remove_child(blend_ui)
	new_parent.add_child(blend_ui)
	new_parent.move_child(blend_ui, 0)

	## change size flags
	var lay_options_container: Control = api.general.get_global().animation_timeline.find_child("LayerTools")
	if lay_options_container:
		lay_options_container.size_flags_vertical = Control.SIZE_SHRINK_BEGIN

	## Hide Tag UI for space
	tag_scroll = api.general.get_global().animation_timeline.find_child("TagScroll")
	if tag_scroll:
		var tag_container = tag_scroll.find_child("TagContainer")
		tag_container.child_entered_tree.connect(show_hide_tags.bind(true))
		tag_container.child_exiting_tree.connect(show_hide_tags.bind(false))
		tag_scroll.visible = tag_container.get_child_count() != 0


func show_hide_tags(child: Node, added: bool):
	if added:
		tag_scroll.visible = child.get_parent().get_child_count() != 0
		return
	## subtracted -1 because the child is still present in the tree
	tag_scroll.visible = child.get_parent().get_child_count() - 1 != 0


func _exit_tree() -> void:  # Extension is being uninstalled or disabled
	# remember to remove things that you added using this extension
	api.dialog.show_error("Please restart Pixelorama to apply the changes.")
