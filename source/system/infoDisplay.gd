extends Control

signal closeInfoDisplay

var units=null
var uidxoffset=0
func display_units(_units,group):
	$CurrentTeamLbl.text=group
	units=_units
	var i =0
	for disp in $units.get_children():
		var uidx= i + uidxoffset
		if(uidx<units.size()):
			disp.set_unit_data(units[uidx])
		else:
			disp.set_unit_data_as_empty()
		i+=1
	show()
	
func close():
	hide()
