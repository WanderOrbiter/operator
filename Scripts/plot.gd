class_name Plot
extends Resource


enum PlotType {
    MESSAGE,
    CHOICE,
    SCRIPT
}
@export var type:PlotType
@export var content:String

func _init(_plot:String):
    pass
