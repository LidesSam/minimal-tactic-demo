extends HBoxContainer

@onready var spr = $ReferenceRect/spr

func set_unit_data(unit):
	spr.play(unit.spr.animation)
	$lp.text =str(str(unit.lp).pad_zeros(2),"/",str(unit.maxlp).pad_zeros(2))
	$unitname.text = unit.unitName
	
func set_unit_data_as_empty():
	spr.play("empty")
	$lp.text ="00/00"
	$unitname.text = ("--/--")
	
