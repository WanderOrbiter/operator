extends Node2D

@onready var output_label: RichTextLabel = $Panel/RichTextLabel
@onready var input_line: LineEdit = $Panel/LineEdit

var dialogue = {
	"start": {
		"text": "[color=green]SYSTEM ONLINE[/color]\nWelcome, operator. The console is active. Choose your first action.",
		"choices": [
			{"label": "Inspect the terminal logs", "next": "logs"},
			{"label": "Check the security camera", "next": "camera"},
			{"label": "Ignore alerts and wait", "next": "wait"}
		]
	},
	"logs": {
		"text": "The logs show an encrypted file and a warning about unauthorized access.",
		"choices": [
			{"label": "Attempt to decrypt the file", "next": "decrypt"},
			{"label": "Return to the main terminal", "next": "start"}
		]
	},
	"camera": {
		"text": "The camera feed shows a dark corridor. Something moves in the shadows.",
		"choices": [
			{"label": "Send a drone for closer inspection", "next": "drone"},
			{"label": "Switch the camera to the other corridor", "next": "corridor"}
		]
	},
	"wait": {
		"text": "You wait and the alert tone grows louder. The system demands a response.",
		"choices": [
			{"label": "Investigate the alarm location", "next": "investigate"},
			{"label": "Stay put and monitor the system", "next": "monitor"}
		]
	},
	"decrypt": {
		"text": "You begin decrypting the file. Success! It reveals coordinates for a hidden server room.",
		"choices": [
			{"label": "Head to the server room", "next": "server"},
			{"label": "Save the report and return", "next": "start"}
		]
	},
	"drone": {
		"text": "The drone enters the corridor. It detects a maintenance bot, not a threat.",
		"choices": [
			{"label": "Let the bot pass", "next": "start"},
			{"label": "Follow the bot remotely", "next": "follow"}
		]
	},
	"corridor": {
		"text": "The second corridor feed is empty, but there is a faint heat signature at the far end.",
		"choices": [
			{"label": "Zoom in on the heat signature", "next": "zoom"},
			{"label": "Return to the main terminal", "next": "start"}
		]
	},
	"investigate": {
		"text": "You move toward the alarm. A locked door blocks your way, but the panel is active.",
		"choices": [
			{"label": "Unlock the door with the console", "next": "unlock"},
			{"label": "Look for another route", "next": "route"}
		]
	},
	"monitor": {
		"text": "The system is stable, but the alert persists. The console waits for a decision.",
		"choices": [
			{"label": "Return to the main terminal", "next": "start"}
		]
	},
	"server": {
		"text": "You arrive at the server room and discover a hidden subsystem controlling the facility.",
		"choices": []
	},
	"follow": {
		"text": "Following the bot reveals a maintenance hatch leading deeper into the complex.",
		"choices": []
	},
	"zoom": {
		"text": "You zoom in on the heat signature. It is a human figure moving slowly through the darkness.",
		"choices": []
	},
	"unlock": {
		"text": "The door clicks open. Beyond it is a narrow hallway and an unknown noise.",
		"choices": []
	},
	"route": {
		"text": "A side corridor appears clear. You can bypass the locked door, but the alert will keep running.",
		"choices": []
	}
}

var current_choices: Array = []
var awaiting_choice: bool = false

func _ready() -> void:
	output_label.bbcode_enabled = true
	output_label.clear()
	input_line.connect("text_submitted", Callable(self, "_on_input_submitted"))
	input_line.grab_focus()
	show_node("start")

func show_node(node_id: String) -> void:
	var node_data = dialogue.get(node_id)
	if node_data == null:
		append_terminal("[color=red]Error:[/color] Node '%s' not found." % node_id)
		return
	append_terminal("\n[color=green]== %s ==[/color]" % node_id.capitalize())
	append_terminal(node_data.text)
	current_choices = []
	if node_data.has("choices") and node_data.choices.size() > 0:
		current_choices = node_data.choices
		display_choices(current_choices)
		awaiting_choice = true
		append_terminal("[color=yellow]Enter a number and press Enter.[/color]")
	else:
		awaiting_choice = false
		append_terminal("[color=cyan]No more choices available. The sequence has ended.[/color]")
		append_terminal("[color=yellow]Restart the scene if you want to play again.[/color]")
	input_line.text = ""
	input_line.grab_focus()

func display_choices(choices: Array) -> void:
	for i in range(choices.size()):
		append_terminal("[color=white]%d.[/color] %s" % [i + 1, choices[i].label])

func append_terminal(text: String) -> void:
	output_label.text += text + "\n"

	var last_line = output_label.get_line_count() - 1
	if last_line >= 0:
		output_label.scroll_to_line(last_line)

func _on_input_submitted(input_text: String) -> void:
	var entry = input_text.strip_edges()
	if not awaiting_choice:
		append_terminal("[color=yellow]There are no choices to select right now.[/color]")
		return
	if entry == "":
		append_terminal("[color=yellow]Enter a number from the list above.[/color]")
		return
	if not is_valid_integer(entry):
		append_terminal("[color=yellow]Invalid input. Type a number from the list.[/color]")
		return
	var option = int(entry) - 1
	if option < 0 or option >= current_choices.size():
		append_terminal("[color=yellow]Choice out of range. Select 1 to %d.[/color]" % current_choices.size())
		return
	process_choice(option)

func is_valid_integer(value: String) -> bool:
	return value.is_valid_int()

func process_choice(index: int) -> void:
	var choice = current_choices[index]
	append_terminal("[color=cyan]> %s[/color]" % choice.label)
	show_node(choice.next)
