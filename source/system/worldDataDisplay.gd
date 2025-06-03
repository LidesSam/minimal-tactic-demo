extends Control

#move to a new clas data display
func update_data_display(hoverUnit):
#	print(unit.get_unitName())
	show()
#	$Sprite.texture = unit.get_spr_texture()
	if(hoverUnit==null):
		$tunit/data/ownerLbl.text= ""
		$tunit/data/namelbl.text= ""
		$tunit/data/movelbl.text= ""
		$tunit/data/atklbl.text= ""
	else:
		#$tunit/data/ownerLb.text= str("Owner: " ,hoverUnit.playerID)
		$tunit/data/namelbl.text= str("Name: " ,hoverUnit.get_unitName())
		$tunit/data/movelbl.text= str("Moves",hoverUnit.get_move_range())
		$tunit/data/atklbl.text= str("Atk:",hoverUnit.get_atk_range())
	
func resetDataDisplay():
	$DataDisplay.hide()
