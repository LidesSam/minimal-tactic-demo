extends Control

signal closeInfoDisplay

var unitOwner= null
var units=null
var uidxoffset=0
@onready var cursor = $cursor


func display_units(_units_owner,group):
	unitOwner=_units_owner
	display_units_of_group(group)
	
func display_units_of_group(group):
	$CurrentTeamLbl.text=Global.get_player_name(group)
	print(unitOwner)
	units=unitOwner.get_units_of_group(group)
	var i =0
	for disp in $units.get_children():
		
		var uidx= i + uidxoffset
		if(uidx<units.size()):
			disp.set_unit_data(units[uidx])
		else:
			disp.set_unit_data_as_empty()
		i+=1
	show()
	pass
	
func close():
	hide()
