class_name PlotsReader
extends Node

# Reader.gd
# This script manages the text reader interface, allowing the system to read plots and make choices.

var current_plots:Array = [] # Store the current plots loaded from the .nga file


# Read the plots by terminal and Display the message by terminal.
func load_next_plot() -> Plot:
    # Read .nga files in the "res://Plots/" directory and return the next plot as a Plot object.
    pass

func load_plots_file_by_id(plot_id :String) -> Plot:
    # Read .nga files in the "res://Plots/" directory and return the plot with the given id as a Plot object.
    var file := FileAccess.open("res://Plots/" + plot_id + ".nga", FileAccess.READ)
    if file:
        var content :String = file.get_as_text()
        file.close()
    var lines :Array = content.split("\n")
    # cut off the empry lines
    current_plots = lines.filter(func(line):
        return line.strip_edges() != ""
    )
    
func get_message_by_id(id :int) -> String:
    # Read lines in the content and return the message with the given id as the number of lines.
    
    return current_plots[id] # return the first line as the message
    pass