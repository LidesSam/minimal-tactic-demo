extends Node

var world=null

enum {ALPHARED,BETABLUE,GAMMAGREEN}
var playerNames =["alphared","betablue","gammagreen", "freeunit"]

func get_player_name(group):
	if group<0 or group>= playerNames.size():
		group=0
	return playerNames[group] 
