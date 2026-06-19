extends Node


@onready var reader :PlotsReader = $Reader
@onready var terminal: Terminal = get_tree().get_current_scene()

# Manager.gd
# This script mananges the text reader(reader.gd) and the terminal(terminal.gd)

func next_plot():
    var plot :Plot = reader.load_next_plot()
    match plot.type:
        Plot.PlotType.MESSAGE:
            terminal.display_message(plot.content)
        Plot.PlotType.CHOICE:
            terminal.display_choice(plot.content)
        Plot.PlotType.SCRIPT:
            var script_content :String = plot.content
            # get the first word of the script content as the function name
            var function_name :String = script_content.split(" ")[0]
            # Execute the script content here
        # 