CMD:bodypush(playerid, params[])
{
	
	if(IsPlayerInAnyVehicle(playerid)) return Sunucu(playerid, "Bu animasyon araçlarda kullanýlamaz.");
	if(GetPlayerAnimationIndex(playerid) != 0) ClearAnimations(playerid);
	ApplyAnimation(playerid,"GANGS","shake_cara",4.0,0,0,0,0,0);
	return 1;
}

CMD:lowbodypush(playerid, params[])
{
	
	if(IsPlayerInAnyVehicle(playerid)) return Sunucu(playerid, "Bu animasyon araçlarda kullanýlamaz.");
	if(GetPlayerAnimationIndex(playerid) != 0) ClearAnimations(playerid);
	ApplyAnimation(playerid,"GANGS","shake_carSH",4.0,0,0,0,0,0);
	return 1;
}

CMD:headbutt(playerid, params[])
{
	
	if(IsPlayerInAnyVehicle(playerid)) return Sunucu(playerid, "Bu animasyon araçlarda kullanýlamaz.");
	if(GetPlayerAnimationIndex(playerid) != 0) ClearAnimations(playerid);
	ApplyAnimation(playerid,"WAYFARER","WF_Fwd",4.0,0,0,0,0,0);
	return 1;
}

CMD:airkick(playerid, params[])
{
	if(IsPlayerInAnyVehicle(playerid)) return Sunucu(playerid, "Bu animasyon araçlarda kullanýlamaz.");
	if(GetPlayerAnimationIndex(playerid) != 0) ClearAnimations(playerid);
	ApplyAnimation(playerid,"FIGHT_C","FightC_M",4.0,0,1,1,0,0);
	return 1;
}

CMD:doorkick(playerid, params[])
{	
	if(IsPlayerInAnyVehicle(playerid)) return Sunucu(playerid, "Bu animasyon araçlarda kullanýlamaz.");
	if(GetPlayerAnimationIndex(playerid) != 0) ClearAnimations(playerid);
	ApplyAnimation(playerid,"POLICE","Door_Kick",4.0,0,0,0,0,0);
	return 1;
}

CMD:leftslap(playerid, params[])
{
	
	if(IsPlayerInAnyVehicle(playerid)) return Sunucu(playerid, "Bu animasyon araçlarda kullanýlamaz.");
	if(GetPlayerAnimationIndex(playerid) != 0) ClearAnimations(playerid);
	ApplyAnimation(playerid,"PED","BIKE_elbowL",4.0,0,0,0,0,0);
	return 1;
}

CMD:elbow(playerid, params[])
{
	
	if(IsPlayerInAnyVehicle(playerid)) return Sunucu(playerid, "Bu animasyon araçlarda kullanýlamaz.");
	if(GetPlayerAnimationIndex(playerid) != 0) ClearAnimations(playerid);
	ApplyAnimation(playerid,"FIGHT_D","FightD_3",4.0,0,1,1,0,0);
	return 1;
}

CMD:coprun(playerid, params[])
{
	if(IsPlayerInAnyVehicle(playerid)) return Sunucu(playerid, "Bu animasyon araçlarda kullanýlamaz.");
	if(GetPlayerAnimationIndex(playerid) != 0) ClearAnimations(playerid);
	ApplyAnimation(playerid,"SWORD","sword_block",50.0,0,1,1,1,1);
	return 1;
}

CMD:handsup(playerid, params[])
{
	
	if(IsPlayerInAnyVehicle(playerid)) return Sunucu(playerid, "Bu animasyon araçlarda kullanýlamaz.");
	if(GetPlayerAnimationIndex(playerid) != 0) ClearAnimations(playerid);
	SetPVarInt(playerid, "anim", 1);
	SetPlayerSpecialAction(playerid,SPECIAL_ACTION_HANDSUP);
	return 1;
}

CMD:piss(playerid, params[])
{
	
	if(IsPlayerInAnyVehicle(playerid)) return Sunucu(playerid, "Bu animasyon araçlarda kullanýlamaz.");
	if(GetPlayerAnimationIndex(playerid) != 0) ClearAnimations(playerid);
	SetPVarInt(playerid, "anim", 1);
	SetPlayerSpecialAction(playerid, 68);
	return 1;
}

CMD:sneak(playerid, params[])
{	
	if(IsPlayerInAnyVehicle(playerid)) return Sunucu(playerid, "Bu animasyon araçlarda kullanýlamaz.");
	AnimOynat(playerid, "PED", "Player_Sneak", 4.1, 1, 1, 1, 1, 1, 1);
	return 1;
}

CMD:drunk(playerid, params[])
{
	
	if(IsPlayerInAnyVehicle(playerid)) return Sunucu(playerid, "Bu animasyon araçlarda kullanýlamaz.");
	AnimOynat(playerid, "PED", "WALK_DRUNK", 4.0, 1, 1, 1, 1, 1, 1);
	return 1;
}

CMD:bomb(playerid, params[])
{
	
	if(IsPlayerInAnyVehicle(playerid)) return Sunucu(playerid, "Bu animasyon araçlarda kullanýlamaz.");
	AnimOynat(playerid, "BOMBER", "BOM_Plant", 4.0, 0, 0, 0, 0, 0, 1);
	return 1;
}

CMD:rob(playerid, params[])
{
	
	if(IsPlayerInAnyVehicle(playerid)) return Sunucu(playerid, "Bu animasyon araçlarda kullanýlamaz.");
	AnimOynat(playerid, "ped", "ARRESTgun", 4.0, 0, 1, 1, 1, 1, 1);
	return 1;
}

CMD:laugh(playerid, params[])
{
	
	if(IsPlayerInAnyVehicle(playerid)) return Sunucu(playerid, "Bu animasyon araçlarda kullanýlamaz.");
	AnimOynat(playerid, "RAPPING", "Laugh_01", 4.0, 1, 0, 0, 0, 0, 1);
	return 1;
}

CMD:lookout(playerid, params[])
{
	
	if(IsPlayerInAnyVehicle(playerid)) return Sunucu(playerid, "Bu animasyon araçlarda kullanýlamaz.");
	AnimOynat(playerid, "SHOP", "ROB_Shifty", 4.0, 0, 0, 0, 0, 0, 1);
	return 1;
}

CMD:robman(playerid, params[])
{
	
	if(IsPlayerInAnyVehicle(playerid)) return Sunucu(playerid, "Bu animasyon araçlarda kullanýlamaz.");
	AnimOynat(playerid, "SHOP", "ROB_Loop_Threat", 4.0, 1, 0, 0, 0, 0, 1);
	return 1;
}

CMD:hide(playerid, params[])
{
	
	if(IsPlayerInAnyVehicle(playerid)) return Sunucu(playerid, "Bu animasyon araçlarda kullanýlamaz.");
	AnimOynat(playerid, "ped", "cower", 3.0, 1, 0, 0, 0, 0, 1);
	return 1;
}

CMD:vomit(playerid, params[])
{	
	if(IsPlayerInAnyVehicle(playerid)) return Sunucu(playerid, "Bu animasyon araçlarda kullanýlamaz.");
	AnimOynat(playerid, "FOOD", "EAT_Vomit_P", 3.0, 1, 0, 0, 0, 0, 1);
	return 1;
}

CMD:eat(playerid, params[])
{
	
	if(IsPlayerInAnyVehicle(playerid)) return Sunucu(playerid, "Bu animasyon araçlarda kullanýlamaz.");
	AnimOynat(playerid, "FOOD", "EAT_Burger", 3.0, 1, 0, 0, 0, 0, 1);
	return 1;
}

CMD:slapass(playerid, params[])
{
	
	if(IsPlayerInAnyVehicle(playerid)) return Sunucu(playerid, "Bu animasyon araçlarda kullanýlamaz.");
	AnimOynat(playerid, "SWEET", "sweet_ass_slap", 4.0, 0, 0, 0, 0, 0, 1);
	return 1;
}

CMD:crack(playerid, params[])
{
	
	if(IsPlayerInAnyVehicle(playerid)) return Sunucu(playerid, "Bu animasyon araçlarda kullanýlamaz.");
	AnimOynat(playerid, "CRACK", "crckdeth2", 4.0, 1, 0, 0, 0, 0, 1);
	return 1;
}

CMD:fucku(playerid, params[])
{
	
	if(IsPlayerInAnyVehicle(playerid)) return Sunucu(playerid, "Bu animasyon araçlarda kullanýlamaz.");
	AnimOynat(playerid, "PED", "fucku", 4.0, 0, 0, 0, 0, 0, 1);
	return 1;
}

CMD:taichi(playerid, params[])
{
	
	if(IsPlayerInAnyVehicle(playerid)) return Sunucu(playerid, "Bu animasyon araçlarda kullanýlamaz.");
	AnimOynat(playerid, "PARK", "Tai_Chi_Loop", 4.0, 1, 0, 0, 0, 0, 1);
	return 1;
}

CMD:drinkwater(playerid, params[])
{
	if(IsPlayerInAnyVehicle(playerid)) return Sunucu(playerid, "Bu animasyon araçlarda kullanýlamaz.");
	AnimOynat(playerid, "BAR", "dnk_stndF_loop", 4.0, 1, 0, 0, 0, 0, 1);
	return 1;
}

CMD:checktime(playerid, params[])
{
	
	if(IsPlayerInAnyVehicle(playerid)) return Sunucu(playerid, "Bu animasyon araçlarda kullanýlamaz.");
	AnimOynat(playerid, "COP_AMBIENT", "Coplook_watch", 4.0, 0, 0, 0, 0, 0, 1);
	return 1;
}

CMD:sleep(playerid, params[])
{
	
	if(IsPlayerInAnyVehicle(playerid)) return Sunucu(playerid, "Bu animasyon araçlarda kullanýlamaz.");
	AnimOynat(playerid, "CRACK", "crckdeth4", 4.0, 0, 1, 1, 1, 0, 1);
	return 1;
}

CMD:blob(playerid, params[])
{
	
	if(IsPlayerInAnyVehicle(playerid)) return Sunucu(playerid, "Bu animasyon araçlarda kullanýlamaz.");
	AnimOynat(playerid, "CRACK", "crckidle1", 4.0, 0, 1, 1, 1, 0, 1);
	return 1;
}

CMD:opendoor(playerid, params[])
{
	
	if(IsPlayerInAnyVehicle(playerid)) return Sunucu(playerid, "Bu animasyon araçlarda kullanýlamaz.");
	AnimOynat(playerid, "AIRPORT", "thrw_barl_thrw", 4.0, 0, 0, 0, 0, 0, 1);
	return 1;
}

CMD:wavedown(playerid, params[])
{
	
	if(IsPlayerInAnyVehicle(playerid)) return Sunucu(playerid, "Bu animasyon araçlarda kullanýlamaz.");
	AnimOynat(playerid, "BD_FIRE", "BD_Panic_01", 4.0, 0, 0, 0, 0, 0, 1);
	return 1;
}

CMD:cpr(playerid, params[])
{
	
	if(IsPlayerInAnyVehicle(playerid)) return Sunucu(playerid, "Bu animasyon araçlarda kullanýlamaz.");
	AnimOynat(playerid, "MEDIC", "CPR", 4.0, 0, 0, 0, 0, 0, 1);
	return 1;
}

CMD:dive(playerid, params[])
{
	

	if(IsPlayerInAnyVehicle(playerid)) return Sunucu(playerid, "Bu animasyon araçlarda kullanýlamaz.");
	AnimOynat(playerid, "DODGE", "Crush_Jump", 4.0, 0, 1, 1, 1, 0, 1);
	return 1;
}

CMD:showoff(playerid, params[])
{
	

	if(IsPlayerInAnyVehicle(playerid)) return Sunucu(playerid, "Bu animasyon araçlarda kullanýlamaz.");
	AnimOynat(playerid, "Freeweights", "gym_free_celebrate", 4.0, 1, 0, 0, 0, 0, 1);
	return 1;
}

CMD:goggles(playerid, params[])
{
	

	if(IsPlayerInAnyVehicle(playerid)) return Sunucu(playerid, "Bu animasyon araçlarda kullanýlamaz.");
	AnimOynat(playerid, "goggles", "goggles_put_on", 4.0, 0, 0, 0, 0, 0, 1);
	return 1;
}

CMD:cry(playerid, params[])
{
	

	if(IsPlayerInAnyVehicle(playerid)) return Sunucu(playerid, "Bu animasyon araçlarda kullanýlamaz.");
	AnimOynat(playerid, "GRAVEYARD", "mrnF_loop", 4.0, 1, 0, 0, 0, 0, 1);
	return 1;
}

CMD:throw(playerid, params[])
{
	

	if(IsPlayerInAnyVehicle(playerid)) return Sunucu(playerid, "Bu animasyon araçlarda kullanýlamaz.");
	AnimOynat(playerid, "GRENADE", "WEAPON_throw", 4.0, 0, 0, 0, 0, 0, 1);
	return 1;
}

CMD:robbed(playerid, params[])
{
	

	if(IsPlayerInAnyVehicle(playerid)) return Sunucu(playerid, "Bu animasyon araçlarda kullanýlamaz.");
	AnimOynat(playerid, "SHOP", "SHP_Rob_GiveCash", 4.0, 1, 0, 0, 0, 0, 1);
	return 1;
}

CMD:hurt(playerid, params[])
{
	

	if(IsPlayerInAnyVehicle(playerid)) return Sunucu(playerid, "Bu animasyon araçlarda kullanýlamaz.");
	AnimOynat(playerid, "SWAT", "gnstwall_injurd", 4.0, 1, 0, 0, 0, 0, 1);
	return 1;
}

CMD:box(playerid, params[])
{
	

	if(IsPlayerInAnyVehicle(playerid)) return Sunucu(playerid, "Bu animasyon araçlarda kullanýlamaz.");
	AnimOynat(playerid, "GYMNASIUM", "GYMshadowbox", 4.0, 1, 0, 0, 0, 0, 1);
	return 1;
}

CMD:washhands(playerid, params[])
{
	

	if(IsPlayerInAnyVehicle(playerid)) return Sunucu(playerid, "Bu animasyon araçlarda kullanýlamaz.");
	AnimOynat(playerid, "BD_FIRE", "wash_up", 4.0, 1, 0, 0, 0, 0, 1);
	return 1;
}

CMD:crabs(playerid, params[])
{
	

	if(IsPlayerInAnyVehicle(playerid)) return Sunucu(playerid, "Bu animasyon araçlarda kullanýlamaz.");
	AnimOynat(playerid, "MISC", "Scratchballs_01", 4.0, 1, 0, 0, 0, 0, 1);
	return 1;
}

CMD:salute(playerid, params[])
{
	

	if(IsPlayerInAnyVehicle(playerid)) return Sunucu(playerid, "Bu animasyon araçlarda kullanýlamaz.");
	AnimOynat(playerid, "ON_LOOKERS", "Pointup_loop", 4.0, 1, 0, 0, 0, 0, 1);
	return 1;
}

CMD:jerkoff(playerid, params[])
{
	

	if(IsPlayerInAnyVehicle(playerid)) return Sunucu(playerid, "Bu animasyon araçlarda kullanýlamaz.");
	AnimOynat(playerid, "PAULNMAC", "wank_out", 4.0, 1, 0, 0, 0, 0, 1);
	return 1;
}

CMD:stop(playerid, params[])
{
	

	if(IsPlayerInAnyVehicle(playerid)) return Sunucu(playerid, "Bu animasyon araçlarda kullanýlamaz.");
	AnimOynat(playerid, "PED", "endchat_01", 4.0, 1, 0, 0, 0, 0, 1);
	return 1;
}

CMD:rap(playerid, params[])
{
	

	if(IsPlayerInAnyVehicle(playerid)) return Sunucu(playerid, "Bu animasyon araçlarda kullanýlamaz.");
	switch(strval(params))
	{
		case 1: AnimOynat(playerid, "RAPPING", "RAP_A_Loop", 4.0, 1, 0, 0, 0, 0, 1);
		case 2: AnimOynat(playerid, "RAPPING", "RAP_B_Loop", 4.0, 1, 0, 0, 0, 0, 1);
		case 3: AnimOynat(playerid, "RAPPING", "RAP_C_Loop", 4.0, 1, 0, 0, 0, 0, 1);
		default: Kullanim(playerid, "/rap [1-3]");
	}
	return 1;
}

CMD:wank(playerid, params[])
{
	

	if(IsPlayerInAnyVehicle(playerid)) return Sunucu(playerid, "Bu animasyon araçlarda kullanýlamaz.");
	switch(strval(params))
	{
		case 1: AnimOynat(playerid, "PAULNMAC", "wank_in", 4.0, 1, 0, 0, 0, 0, 1);
		case 2: AnimOynat(playerid, "PAULNMAC", "wank_loop", 4.0, 1, 0, 0, 0, 0, 1);
		case 3: AnimOynat(playerid, "PAULNMAC", "wank_out", 4.0, 1, 0, 0, 0, 0, 1);
		default: Kullanim(playerid, "/wank [1-3]");
	}
	return 1;
}

CMD:chat(playerid, params[])
{
	

	if(IsPlayerInAnyVehicle(playerid)) return Sunucu(playerid, "Bu animasyon araçlarda kullanýlamaz.");
	switch(strval(params))
	{
		case 1: AnimOynat(playerid, "PED", "IDLE_CHAT", 4.0, 1, 0, 0, 0, 0, 1);
		case 2: AnimOynat(playerid, "GANGS", "prtial_gngtlkA", 4.0, 1, 0, 0, 0, 0, 1);
		case 3:	AnimOynat(playerid, "GANGS", "prtial_gngtlkB", 4.0, 1, 0, 0, 0, 0, 1);
		case 4: AnimOynat(playerid, "GANGS", "prtial_gngtlkE", 4.0, 1, 0, 0, 0, 0, 1);
		case 5: AnimOynat(playerid, "GANGS", "prtial_gngtlkF", 4.0, 1, 0, 0, 0, 0, 1);
		case 6: AnimOynat(playerid, "GANGS", "prtial_gngtlkG", 4.0, 1, 0, 0, 0, 0, 1);
		case 7:	AnimOynat(playerid, "GANGS", "prtial_gngtlkH", 4.0, 1, 0, 0, 0, 0, 1);
		default: Kullanim(playerid, "/chat [1-7]");
	}
	return 1;
}

CMD:sit(playerid, params[])
{
	

	if(IsPlayerInAnyVehicle(playerid)) return Sunucu(playerid, "Bu animasyon araçlarda kullanýlamaz.");
	switch(strval(params))
	{
		case 1: AnimOynat(playerid, "Attractors", "Stepsit_in", 4.0, 0, 0, 0, 1, 0, 1);
		case 2: AnimOynat(playerid, "CRIB", "PED_Console_Loop", 4.0, 1, 0, 0, 0, 0, 1);
		case 3: AnimOynat(playerid, "INT_HOUSE", "LOU_In", 4.0, 0, 0, 0, 1, 1, 1);
		case 4: AnimOynat(playerid, "MISC", "SEAT_LR", 4.0, 1, 0, 0, 0, 0, 1);
		case 5: AnimOynat(playerid, "MISC", "Seat_talk_01", 4.0, 1, 0, 0, 0, 0, 1);
		case 6: AnimOynat(playerid, "MISC", "Seat_talk_02", 4.0, 1, 0, 0, 0, 0, 1);
		case 7: AnimOynat(playerid, "ped", "SEAT_down", 4.0, 0, 0, 0, 1, 1, 1);
		default: Kullanim(playerid, "/sit [1-7]");
	}
	return 1;
}

CMD:bat(playerid, params[])
{
	

	if(IsPlayerInAnyVehicle(playerid)) return Sunucu(playerid, "Bu animasyon araçlarda kullanýlamaz.");
	switch(strval(params))
	{
		case 1: AnimOynat(playerid,"BASEBALL","Bat_IDLE",4.1, 0, 1, 1, 1, 1, 1);
		case 2: AnimOynat(playerid, "CRACK", "Bbalbat_Idle_01", 4.0, 1, 0, 0, 0, 0, 1);
		case 3: AnimOynat(playerid, "CRACK", "Bbalbat_Idle_02", 4.0, 1, 0, 0, 0, 0, 1);
		default: Kullanim(playerid, "/bat [1-3]");
	}
	return 1;
}

CMD:lean(playerid, params[])
{
	

	if(IsPlayerInAnyVehicle(playerid)) return Sunucu(playerid, "Bu animasyon araçlarda kullanýlamaz.");
	switch(strval(params))
	{
		case 1: AnimOynat(playerid, "GANGS", "leanIDLE", 4.0, 0, 0, 0, 1, 0, 1);
		case 2: AnimOynat(playerid, "MISC", "Plyrlean_loop", 4.0, 0, 0, 0, 1, 0, 1);
		default: Kullanim(playerid, "/lean [1-2]");
	}
	return 1;
}

CMD:gesture(playerid, params[])
{
	

	if(IsPlayerInAnyVehicle(playerid)) return Sunucu(playerid, "Bu animasyon araçlarda kullanýlamaz.");
	switch(strval(params))
	{
		case 1: AnimOynat(playerid, "GHANDS", "gsign1", 4.0, 0, 0, 0, 0, 0, 1);
		case 2: AnimOynat(playerid, "GHANDS", "gsign1LH", 4.0, 0, 0, 0, 0, 0, 1);
		case 3: AnimOynat(playerid, "GHANDS", "gsign2", 4.0, 0, 0, 0, 0, 0, 1);
		case 4: AnimOynat(playerid, "GHANDS", "gsign2LH", 4.0, 0, 0, 0, 0, 0, 1);
		case 5: AnimOynat(playerid, "GHANDS", "gsign3", 4.0, 0, 0, 0, 0, 0, 1);
		case 6: AnimOynat(playerid, "GHANDS", "gsign3LH", 4.0, 0, 0, 0, 0, 0, 1);
		case 7: AnimOynat(playerid, "GHANDS", "gsign4", 4.0, 0, 0, 0, 0, 0, 1);
		case 8: AnimOynat(playerid, "GHANDS", "gsign4LH", 4.0, 0, 0, 0, 0, 0, 1);
		case 9: AnimOynat(playerid, "GHANDS", "gsign5", 4.0, 0, 0, 0, 0, 0, 1);
		case 10: AnimOynat(playerid, "GHANDS", "gsign5", 4.0, 0, 0, 0, 0, 0, 1);
		case 11: AnimOynat(playerid, "GHANDS", "gsign5LH", 4.0, 0, 0, 0, 0, 0, 1);
		case 12: AnimOynat(playerid, "GANGS", "Invite_No", 4.0, 0, 0, 0, 0, 0, 1);
		case 13: AnimOynat(playerid, "GANGS", "Invite_Yes", 4.0, 0, 0, 0, 0, 0, 1);
		case 14: AnimOynat(playerid, "GANGS", "prtial_gngtlkD", 4.0, 0, 0, 0, 0, 0, 1);
		case 15: AnimOynat(playerid, "GANGS", "smkcig_prtl", 4.0, 0, 0, 0, 0, 0, 1);
		default: Kullanim(playerid, "/gesture [1-15]");
	}
	return 1;
}

CMD:lay(playerid, params[])
{
	

	if(IsPlayerInAnyVehicle(playerid)) return Sunucu(playerid, "Bu animasyon araçlarda kullanýlamaz.");
	switch(strval(params))
	{
		case 1: AnimOynat(playerid, "BEACH", "bather", 4.0, 1, 0, 0, 0, 0, 1);
		case 2: AnimOynat(playerid, "BEACH", "Lay_Bac_Loop", 4.0, 1, 0, 0, 0, 0, 1);
		case 3: AnimOynat(playerid, "BEACH", "SitnWait_loop_W", 4.0, 1, 0, 0, 0, 0, 1);
		case 4: AnimOynat(playerid, "BEACH", "bather", 4.0, 1, 0, 0, 0, 0, 1);
		case 5: AnimOynat(playerid, "BEACH", "Lay_Bac_Loop", 4.0, 1, 0, 0, 0, 0, 1);
		case 6: AnimOynat(playerid, "BEACH", "ParkSit_W_loop", 4.0, 1, 0, 0, 0, 0, 1);
		case 7: AnimOynat(playerid, "BEACH", "SitnWait_loop_W", 4.0, 1, 0, 0, 0, 0, 1);
		case 8: AnimOynat(playerid, "BEACH", "ParkSit_M_loop", 4.0, 1, 0, 0, 0, 0, 1);
		default: Kullanim(playerid, "/lay [1-8]");
	}
	return 1;
}

CMD:wave(playerid, params[])
{
	

	if(IsPlayerInAnyVehicle(playerid)) return Sunucu(playerid, "Bu animasyon araçlarda kullanýlamaz.");
	switch(strval(params))
	{
		case 1: AnimOynat(playerid, "ON_LOOKERS", "wave_loop", 4.0, 1, 0, 0, 0, 0, 1);
		case 2: AnimOynat(playerid, "KISSING", "gfwave2", 4.0, 1, 0, 0, 0, 0, 1);
		case 3: AnimOynat(playerid, "PED", "endchat_03", 4.0, 1, 0, 0, 0, 0, 1);
		default: Kullanim(playerid, "/wave [1-3]");
	}
	return 1;
}

CMD:signal(playerid, params[])
{
	

	if(IsPlayerInAnyVehicle(playerid)) return Sunucu(playerid, "Bu animasyon araçlarda kullanýlamaz.");
	switch(strval(params))
	{
		case 1: AnimOynat(playerid, "POLICE", "CopTraf_Come", 4.0, 1, 0, 0, 0, 0, 1);
		case 2: AnimOynat(playerid, "POLICE", "CopTraf_Stop", 4.0, 1, 0, 0, 0, 0, 1);
		default: Kullanim(playerid, "/signal [1-2]");
	}
	return 1;
}

CMD:nobreath(playerid, params[])
{
	

	if(IsPlayerInAnyVehicle(playerid)) return Sunucu(playerid, "Bu animasyon araçlarda kullanýlamaz.");
	switch(strval(params))
	{
		case 1: AnimOynat(playerid, "SWEET", "Sweet_injuredloop", 4.0, 1, 0, 0, 0, 0, 1);
		case 2: AnimOynat(playerid, "PED", "IDLE_tired", 4.0, 1, 0, 0, 0, 0, 1);
		case 3: AnimOynat(playerid, "FAT", "IDLE_tired", 4.0, 1, 0, 0, 0, 0, 1);
		default: Kullanim(playerid, "/nobreath [1-3]");
	}
	return 1;
}

CMD:fall(playerid, params[])
{
	

	if(IsPlayerInAnyVehicle(playerid)) return Sunucu(playerid, "Bu animasyon araçlarda kullanýlamaz.");
	switch(strval(params))
	{
		case 1: AnimOynat(playerid, "KNIFE", "KILL_Knife_Ped_Die", 4.0, 0, 1, 1, 1, 0, 1);
		case 2: AnimOynat(playerid, "PED", "KO_shot_face", 4.0, 0, 1, 1, 1, 0, 1);
		case 3: AnimOynat(playerid, "PED", "KO_shot_stom", 4.0, 0, 1, 1, 1, 0, 1);
		case 4: AnimOynat(playerid, "PED", "BIKE_fallR", 4.1, 0, 1, 1, 1, 0, 1);
		case 5: AnimOynat(playerid, "PED", "BIKE_fall_off", 4.1, 0, 1, 1, 1, 0, 1);
		default: Kullanim(playerid, "/fall [1-5]");
	}
	return 1;
}

CMD:pedmove(playerid, params[])
{
	

	if(IsPlayerInAnyVehicle(playerid)) return Sunucu(playerid, "Bu animasyon araçlarda kullanýlamaz.");
	switch(strval(params))
	{
		case 1: AnimOynat(playerid, "PED", "JOG_femaleA", 4.0, 1, 1, 1, 1, 1, 1);
		case 2: AnimOynat(playerid, "PED", "JOG_maleA", 4.0, 1, 1, 1, 1, 1, 1);
		case 3: AnimOynat(playerid, "PED", "WOMAN_walkfatold", 4.0, 1, 1, 1, 1, 1, 1);
		case 4: AnimOynat(playerid, "PED", "run_fat", 4.0, 1, 1, 1, 1, 1, 1);
		case 5: AnimOynat(playerid, "PED", "run_fatold", 4.0, 1, 1, 1, 1, 1, 1);
		case 6: AnimOynat(playerid, "PED", "run_old", 4.0, 1, 1, 1, 1, 1, 1);
		case 7: AnimOynat(playerid, "PED", "Run_Wuzi", 4.0, 1, 1, 1, 1, 1, 1);
		case 8: AnimOynat(playerid, "PED", "swat_run", 4.0, 1, 1, 1, 1, 1, 1);
		case 9: AnimOynat(playerid, "PED", "WALK_fat", 4.0, 1, 1, 1, 1, 1, 1);
		case 10: AnimOynat(playerid, "PED", "WALK_fatold", 4.0, 1, 1, 1, 1, 1, 1);
		case 11: AnimOynat(playerid, "PED", "WALK_gang1", 4.0, 1, 1, 1, 1, 1, 1);
		case 12: AnimOynat(playerid, "PED", "WALK_gang2", 4.0, 1, 1, 1, 1, 1, 1);
		case 13: AnimOynat(playerid, "PED", "WALK_old", 4.0, 1, 1, 1, 1, 1, 1);
		case 14: AnimOynat(playerid, "PED", "WALK_shuffle", 4.0, 1, 1, 1, 1, 1, 1);
		case 15: AnimOynat(playerid, "PED", "woman_run", 4.0, 1, 1, 1, 1, 1, 1);
		case 16: AnimOynat(playerid, "PED", "WOMAN_runbusy", 4.0, 1, 1, 1, 1, 1, 1);
		case 17: AnimOynat(playerid, "PED", "WOMAN_runfatold", 4.0, 1, 1, 1, 1, 1, 1);
		case 18: AnimOynat(playerid, "PED", "woman_runpanic", 4.0, 1, 1, 1, 1, 1, 1);
		case 19: AnimOynat(playerid, "PED", "WOMAN_runsexy", 4.0, 1, 1, 1, 1, 1, 1);
		case 20: AnimOynat(playerid, "PED", "WOMAN_walkbusy", 4.0, 1, 1, 1, 1, 1, 1);
		case 21: AnimOynat(playerid, "PED", "WOMAN_walkfatold", 4.0, 1, 1, 1, 1, 1, 1);
		case 22: AnimOynat(playerid, "PED", "WOMAN_walknorm", 4.0, 1, 1, 1, 1, 1, 1);
		case 23: AnimOynat(playerid, "PED", "WOMAN_walkold", 4.0, 1, 1, 1, 1, 1, 1);
		case 24: AnimOynat(playerid, "PED", "WOMAN_walkpro", 4.0, 1, 1, 1, 1, 1, 1);
		case 25: AnimOynat(playerid, "PED", "WOMAN_walksexy", 4.0, 1, 1, 1, 1, 1, 1);
		case 26: AnimOynat(playerid, "PED", "WOMAN_walkshop", 4.0, 1, 1, 1, 1, 1, 1);
		default: Kullanim(playerid, "/pedmove [1-26]");
	}
	return 1;
}

CMD:stripclub(playerid, params[])
{
	

	if(IsPlayerInAnyVehicle(playerid)) return Sunucu(playerid, "Bu animasyon araçlarda kullanýlamaz.");
	switch(strval(params))
	{
		case 1: AnimOynat(playerid, "STRIP", "PLY_CASH", 4.0, 1, 0, 0, 0, 0, 1);
		case 2: AnimOynat(playerid, "STRIP", "PUN_CASH", 4.0, 1, 0, 0, 0, 0, 1);
		default: Kullanim(playerid, "/stripclub [1-2]");
	}
	return 1;
}

CMD:smoke(playerid, params[])
{
	

	if(IsPlayerInAnyVehicle(playerid)) return Sunucu(playerid, "Bu animasyon araçlarda kullanýlamaz.");
	switch(strval(params))
	{
		case 1: AnimOynat(playerid, "SMOKING", "M_smk_in", 4.0, 0, 0, 0, 0, 0, 1);
		case 2: AnimOynat(playerid, "SMOKING", "M_smklean_loop", 4.0, 1, 0, 0, 0, 0, 1);
		default: Kullanim(playerid, "/smoke [1-2]");
	}
	return 1;
}

CMD:dj(playerid, params[])
{
	

	if(IsPlayerInAnyVehicle(playerid)) return Sunucu(playerid, "Bu animasyon araçlarda kullanýlamaz.");
	switch(strval(params))
	{
		case 1: AnimOynat(playerid, "SCRATCHING", "scdldlp", 4.0, 1, 0, 0, 0, 0, 1);
		case 2: AnimOynat(playerid, "SCRATCHING", "scdlulp", 4.0, 1, 0, 0, 0, 0, 1);
		case 3: AnimOynat(playerid, "SCRATCHING", "scdrdlp", 4.0, 1, 0, 0, 0, 0, 1);
		case 4: AnimOynat(playerid, "SCRATCHING", "scdrulp", 4.0, 1, 0, 0, 0, 0, 1);
		default: Kullanim(playerid, "/dj [1-4]");
	}
	return 1;
}

CMD:reload(playerid, params[])
{
	

	if(IsPlayerInAnyVehicle(playerid)) return Sunucu(playerid, "Bu animasyon araçlarda kullanýlamaz.");
	switch(strval(params))
	{
		case 1: AnimOynat(playerid, "BUDDY", "buddy_reload", 4.0, 0, 0, 0, 0, 0, 1);
		case 2: AnimOynat(playerid, "PYTHON", "python_reload", 4.0, 0, 0, 0, 0, 0, 1);
		default: Kullanim(playerid, "/reload [1-2]");
	}
	return 1;
}

CMD:tag(playerid, params[])
{
	

	if(IsPlayerInAnyVehicle(playerid)) return Sunucu(playerid, "Bu animasyon araçlarda kullanýlamaz.");
	switch(strval(params))
	{
		case 1: AnimOynat(playerid, "GRAFFITI", "graffiti_Chkout", 4.0, 1, 0, 0, 0, 0, 1);
		case 2: AnimOynat(playerid, "GRAFFITI", "spraycan_fire", 4.0, 1, 0, 0, 0, 0, 1);
		default: Kullanim(playerid, "/tag [1-2]");
	}
	return 1;
}

CMD:deal(playerid, params[])
{
	

	if(IsPlayerInAnyVehicle(playerid)) return Sunucu(playerid, "Bu animasyon araçlarda kullanýlamaz.");
	switch(strval(params))
	{
		case 1: AnimOynat(playerid, "DEALER", "DEALER_DEAL", 4.0, 1, 0, 0, 0, 0, 1);
		case 2: AnimOynat(playerid, "DEALER", "shop_pay", 4.0, 1, 0, 0, 0, 0, 1);
		default: Kullanim(playerid, "/deal [1-2]");
	}
	return 1;
}

CMD:crossarms(playerid, params[])
{
	

	if(IsPlayerInAnyVehicle(playerid)) return Sunucu(playerid, "Bu animasyon araçlarda kullanýlamaz.");
	switch(strval(params))
	{
		case 1: AnimOynat(playerid, "COP_AMBIENT", "Coplook_loop", 4.0, 0, 1, 1, 1, -1, 1);
		case 2: AnimOynat(playerid, "DEALER", "DEALER_IDLE", 4.0, 1, 0, 0, 0, 0, 1);
		case 3: AnimOynat(playerid, "GRAVEYARD", "mrnM_loop", 4.0, 1, 0, 0, 0, 0, 1);
		case 4: AnimOynat(playerid, "GRAVEYARD", "prst_loopa", 4.0, 1, 0, 0, 0, 0, 1);
		case 5: AnimOynat(playerid, "DEALER", "DEALER_IDLE_01", 4.0, 1, 0, 0, 0, 0, 1);
		default: Kullanim(playerid, "/crossarms [1-5]");
	}
	return 1;
}

CMD:cheer(playerid, params[])
{
	

	if(IsPlayerInAnyVehicle(playerid)) return Sunucu(playerid, "Bu animasyon araçlarda kullanýlamaz.");
	switch(strval(params))
	{
		case 1: AnimOynat(playerid, "ON_LOOKERS", "shout_01", 4.0, 1, 0, 0, 0, 0, 1);
		case 2: AnimOynat(playerid, "ON_LOOKERS", "shout_02", 4.0, 1, 0, 0, 0, 0, 1);
		case 3: AnimOynat(playerid, "ON_LOOKERS", "shout_in", 4.0, 1, 0, 0, 0, 0, 1);
		case 4: AnimOynat(playerid, "RIOT", "RIOT_ANGRY_B", 4.0, 1, 0, 0, 0, 0, 1);
		case 5: AnimOynat(playerid, "RIOT", "RIOT_CHANT", 4.0, 1, 0, 0, 0, 0, 1);
		case 6: AnimOynat(playerid, "RIOT", "RIOT_shout", 4.0, 1, 0, 0, 0, 0, 1);
		case 7: AnimOynat(playerid, "STRIP", "PUN_HOLLER", 4.0, 1, 0, 0, 0, 0, 1);
		case 8: AnimOynat(playerid, "OTB", "wtchrace_win", 4.0, 1, 0, 0, 0, 0, 1);
		default: Kullanim(playerid, "/cheer [1-8]");
	}
	return 1;
}

CMD:siteat(playerid, params[])
{
	

	if(IsPlayerInAnyVehicle(playerid)) return Sunucu(playerid, "Bu animasyon araçlarda kullanýlamaz.");
	switch(strval(params))
	{
		case 1: AnimOynat(playerid, "FOOD", "FF_Sit_Eat3", 4.0, 1, 0, 0, 0, 0, 1);
		case 2: AnimOynat(playerid, "FOOD", "FF_Sit_Eat2", 4.0, 1, 0, 0, 0, 0, 1);
		default: Kullanim(playerid, "/siteat [1-2]");
	}
	return 1;
}

CMD:bar(playerid, params[])
{
	

	if(IsPlayerInAnyVehicle(playerid)) return Sunucu(playerid, "Bu animasyon araçlarda kullanýlamaz.");
	switch(strval(params))
	{
		case 1: AnimOynat(playerid, "BAR", "Barcustom_get", 4.0, 0, 1, 0, 0, 0, 1);
		case 2: AnimOynat(playerid, "BAR", "Barserve_bottle", 4.0, 0, 0, 0, 0, 0, 1);
		case 3: AnimOynat(playerid, "BAR", "Barserve_give", 4.0, 0, 0, 0, 0, 0, 1);
		case 4: AnimOynat(playerid, "BAR", "dnk_stndM_loop", 4.0, 0, 0, 0, 0, 0, 1);
		case 5: AnimOynat(playerid, "BAR", "BARman_idle", 4.0, 1, 0, 0, 0, 0, 1);
		default: Kullanim(playerid, "/bar [1-5]");
	}
	return 1;
}

CMD:dance(playerid, params[])
{
	

	if(IsPlayerInAnyVehicle(playerid)) return Sunucu(playerid, "Bu animasyon araçlarda kullanýlamaz.");
	if(GetPlayerAnimationIndex(playerid) != 0) ClearAnimations(playerid);

	switch(strval(params))
	{
		case 1: SetPlayerSpecialAction(playerid, 5), SetPVarInt(playerid, "anim", 1);
		case 2: SetPlayerSpecialAction(playerid, 6), SetPVarInt(playerid, "anim", 1);
		case 3: SetPlayerSpecialAction(playerid, 7), SetPVarInt(playerid, "anim", 1);
		case 4: SetPlayerSpecialAction(playerid, 8), SetPVarInt(playerid, "anim", 1);
		case 5: AnimOynat(playerid, "DANCING", "DAN_Down_A", 4.0, 1, 0, 0, 0, 0, 1);
		case 6: AnimOynat(playerid, "DANCING", "DAN_Left_A", 4.0, 1, 0, 0, 0, 0, 1);
		case 7: AnimOynat(playerid, "DANCING", "DAN_Loop_A", 4.0, 1, 0, 0, 0, 0, 1);
		case 8: AnimOynat(playerid, "DANCING", "DAN_Right_A", 4.0, 1, 0, 0, 0, 0, 1);
		case 9: AnimOynat(playerid, "DANCING", "DAN_Up_A", 4.0, 1, 0, 0, 0, 0, 1);
		case 10: AnimOynat(playerid, "DANCING", "dnce_M_a", 4.0, 1, 0, 0, 0, 0, 1);
		case 11: AnimOynat(playerid, "DANCING", "dnce_M_b", 4.0, 1, 0, 0, 0, 0, 1);
		case 12: AnimOynat(playerid, "DANCING", "dnce_M_c", 4.0, 1, 0, 0, 0, 0, 1);
		case 13: AnimOynat(playerid, "DANCING", "dnce_M_c", 4.0, 1, 0, 0, 0, 0, 1);
		case 14: AnimOynat(playerid, "DANCING", "dnce_M_d", 4.0, 1, 0, 0, 0, 0, 1);
		default: Kullanim(playerid, "/dance [1-14]");
	}
	return 1;
}

CMD:spank(playerid, params[])
{
	

	if(IsPlayerInAnyVehicle(playerid)) return Sunucu(playerid, "Bu animasyon araçlarda kullanýlamaz.");
	switch(strval(params))
	{
		case 1: AnimOynat(playerid, "SNM", "SPANKINGW", 4.1, 1, 0, 0, 0, 0, 1);
		case 2: AnimOynat(playerid, "SNM", "SPANKINGP", 4.1, 1, 0, 0, 0, 0, 1);
		case 3: AnimOynat(playerid, "SNM", "SPANKEDW", 4.1, 1, 0, 0, 0, 0, 1);
		case 4: AnimOynat(playerid, "SNM", "SPANKEDP", 4.1, 1, 0, 0, 0, 0, 1);
		default: Kullanim(playerid, "/spank [1-4]");
	}
	return 1;
}

CMD:sexy(playerid, params[])
{
	

	if(IsPlayerInAnyVehicle(playerid)) return Sunucu(playerid, "Bu animasyon araçlarda kullanýlamaz.");
	switch(strval(params))
	{
		case 1: AnimOynat(playerid, "STRIP", "strip_E", 4.1, 1, 0, 0, 0, 0, 1);
		case 2: AnimOynat(playerid, "STRIP", "strip_G", 4.1, 1, 0, 0, 0, 0, 1);
		case 3: AnimOynat(playerid, "STRIP", "STR_A2B", 4.1, 0, 0, 0, 0, 0, 1);
		case 4: AnimOynat(playerid, "STRIP", "STR_Loop_A", 4.1, 1, 0, 0, 0, 0, 1);
		case 5: AnimOynat(playerid, "STRIP", "STR_Loop_B", 4.1, 1, 0, 0, 0, 0, 1);
		case 6: AnimOynat(playerid, "STRIP", "STR_Loop_C", 4.1, 1, 0, 0, 0, 0, 1);
		default: Kullanim(playerid, "/sexy [1-6]");
	}
	return 1;
}

CMD:holdup(playerid, params[])
{
	

	if(IsPlayerInAnyVehicle(playerid)) return Sunucu(playerid, "Bu animasyon araçlarda kullanýlamaz.");
	switch(strval(params))
	{
		case 1: AnimOynat(playerid, "POOL", "POOL_ChalkCue", 4.1, 0, 1, 1, 1, 1, 1);
		case 2: AnimOynat(playerid, "POOL", "POOL_Idle_Stance", 4.1, 0, 1, 1, 1, 1, 1);
		default: Kullanim(playerid, "/holdup [1-2]");
	}
	return 1;
}

CMD:copa(playerid, params[])
{
	

	if(IsPlayerInAnyVehicle(playerid)) return Sunucu(playerid, "Bu animasyon araçlarda kullanýlamaz.");
	switch(strval(params))
	{
		case 1: AnimOynat(playerid, "POLICE", "CopTraf_Away", 4.1, 0, 0, 0, 0, 0, 1);
		case 2: AnimOynat(playerid, "POLICE", "CopTraf_Come", 4.1, 0, 0, 0, 0, 0, 1);
		case 3: AnimOynat(playerid, "POLICE", "CopTraf_Left", 4.1, 0, 0, 0, 0, 0, 1);
		case 4: AnimOynat(playerid, "POLICE", "CopTraf_Stop", 4.1, 0, 0, 0, 0, 0, 1);
		case 5: AnimOynat(playerid, "POLICE", "Cop_move_FWD", 4.1, 1, 1, 1, 1, 1, 1);
		case 6: AnimOynat(playerid, "POLICE", "crm_drgbst_01", 4.1, 0, 0, 0, 1, 5000, 1);
		case 7: AnimOynat(playerid, "POLICE", "Door_Kick", 4.1, 0, 1, 1, 1, 1, 1);
		case 8: AnimOynat(playerid, "POLICE", "plc_drgbst_01", 4.1, 0, 0, 0, 0, 5000, 1);
		case 9: AnimOynat(playerid, "POLICE", "plc_drgbst_02", 4.1, 0, 0, 0, 0, 0, 1);
		default: Kullanim(playerid, "/copa [1-9]");
	}
	return 1;
}

CMD:misc(playerid, params[])
{
	

	if(IsPlayerInAnyVehicle(playerid)) return Sunucu(playerid, "Bu animasyon araçlarda kullanýlamaz.");
	switch(strval(params))
	{
		case 1: AnimOynat(playerid, "CAR", "Fixn_Car_Loop", 4.1, 1, 0, 0, 0, 0, 1);
		case 2: AnimOynat(playerid, "CAR", "flag_drop", 4.1, 0, 0, 0, 0, 0, 1);
		case 3: AnimOynat(playerid, "PED", "bomber", 4.1, 0, 0, 0, 0, 0, 1);
		default: Kullanim(playerid, "/misc [1-3]");
	}
	return 1;
}

CMD:snatch(playerid, params[])
{
	

	if(IsPlayerInAnyVehicle(playerid)) return Sunucu(playerid, "Bu animasyon araçlarda kullanýlamaz.");
	switch(strval(params))
	{
		case 1: AnimOynat(playerid, "PED", "BIKE_elbowL", 4.1, 0, 0, 0, 0, 0, 1);
		case 2: AnimOynat(playerid, "PED", "BIKE_elbowR", 4.1, 0, 0, 0, 0, 0, 1);
		default: Kullanim(playerid, "/snatch [1-2]");
	}
	return 1;
}

CMD:blowjob(playerid, params[])
{
	
	if(IsPlayerInAnyVehicle(playerid)) return Sunucu(playerid, "Bu animasyon araçlarda kullanýlamaz.");
	switch(strval(params))
	{
		case 1: AnimOynat(playerid, "BLOWJOBZ", "BJ_COUCH_LOOP_P", 4.1, 1, 0, 0, 0, 0, 1);
		case 2: AnimOynat(playerid, "BLOWJOBZ", "BJ_STAND_LOOP_P", 4.1, 1, 0, 0, 0, 0, 1);
		case 3: AnimOynat(playerid, "BLOWJOBZ", "BJ_COUCH_START_W", 4.1, 1, 0, 0, 0, 0, 1);
		case 4: AnimOynat(playerid, "BLOWJOBZ", "w", 4.1, 1, 0, 0, 0, 0, 1);
		case 5: AnimOynat(playerid, "BLOWJOBZ", "BJ_COUCH_END_W", 4.1, 1, 0, 0, 0, 0, 1);
		case 6: AnimOynat(playerid, "BLOWJOBZ", "BJ_COUCH_START_P", 4.1, 1, 0, 0, 0, 0, 1);
		case 7: AnimOynat(playerid, "BLOWJOBZ", "BJ_COUCH_END_P", 4.1, 1, 0, 0, 0, 0, 1);
		case 8: AnimOynat(playerid, "BLOWJOBZ", "BJ_STAND_START_W", 4.1, 1, 0, 0, 0, 0, 1);
		case 9: AnimOynat(playerid, "BLOWJOBZ", "BJ_STAND_LOOP_W", 4.1, 1, 0, 0, 0, 0, 1);
		case 10: AnimOynat(playerid, "BLOWJOBZ", "BJ_STAND_END_W", 4.1, 1, 0, 0, 0, 0, 1);
		case 11: AnimOynat(playerid, "BLOWJOBZ", "BJ_STAND_START_P", 4.1, 1, 0, 0, 0, 0, 1);
		case 12: AnimOynat(playerid, "BLOWJOBZ", "BJ_STAND_END_P", 4.1, 1, 0, 0, 0, 0, 1);
		default: Kullanim(playerid, "/blowjob [1-12]");
	}
	return 1;
}

CMD:kiss(playerid, params[])
{
	

	if(IsPlayerInAnyVehicle(playerid)) return Sunucu(playerid, "Bu animasyon araçlarda kullanýlamaz.");
	switch(strval(params))
	{
		case 1: AnimOynat(playerid, "KISSING", "Playa_Kiss_01", 4.1, 0, 0, 0, 0, 0, 1);
		case 2: AnimOynat(playerid, "KISSING", "Playa_Kiss_02", 4.1, 0, 0, 0, 0, 0, 1);
		case 3: AnimOynat(playerid, "KISSING", "Playa_Kiss_03", 4.1, 0, 0, 0, 0, 0, 1);
		case 4: AnimOynat(playerid, "KISSING", "Grlfrd_Kiss_01", 4.1, 0, 0, 0, 0, 0, 1);
		case 5: AnimOynat(playerid, "KISSING", "Grlfrd_Kiss_02", 4.1, 0, 0, 0, 0, 0, 1);
		case 6: AnimOynat(playerid, "KISSING", "Grlfrd_Kiss_03", 4.1, 0, 0, 0, 0, 0, 1);
		default: Kullanim(playerid, "/kiss [1-6]");
	}
	return 1;
}

CMD:idles(playerid, params[])
{
	

	if(IsPlayerInAnyVehicle(playerid)) return Sunucu(playerid, "Bu animasyon araçlarda kullanýlamaz.");
	switch(strval(params))
	{
		case 1: AnimOynat(playerid, "PLAYIDLES", "shift", 4.1, 1, 1, 1, 1, 1, 1);
		case 2: AnimOynat(playerid, "PLAYIDLES", "shldr", 4.1, 1, 1, 1, 1, 1, 1);
		case 3: AnimOynat(playerid, "PLAYIDLES", "stretch", 4.1, 1, 1, 1, 1, 1, 1);
		case 4: AnimOynat(playerid, "PLAYIDLES", "strleg", 4.1, 1, 1, 1, 1, 1, 1);
		case 5: AnimOynat(playerid, "PLAYIDLES", "time", 4.1, 1, 1, 1, 1, 1, 1);
		case 6: AnimOynat(playerid, "COP_AMBIENT", "Copbrowse_loop", 4.1, 1, 0, 0, 0, 0, 1);
		case 7: AnimOynat(playerid, "COP_AMBIENT", "Coplook_loop", 4.1, 1, 0, 0, 0, 0, 1);
		case 8: AnimOynat(playerid, "COP_AMBIENT", "Coplook_shake", 4.1, 1, 0, 0, 0, 0, 1);
		case 9: AnimOynat(playerid, "COP_AMBIENT", "Coplook_think", 4.1, 1, 0, 0, 0, 0, 1);
		case 10: AnimOynat(playerid, "COP_AMBIENT", "Coplook_watch", 4.1, 1, 0, 0, 0, 0, 1);
		case 11: AnimOynat(playerid, "PED", "roadcross", 4.1, 1, 0, 0, 0, 0, 1);
		case 12: AnimOynat(playerid, "PED", "roadcross_female", 4.1, 1, 0, 0, 0, 0, 1);
		case 13: AnimOynat(playerid, "PED", "roadcross_gang", 4.1, 1, 0, 0, 0, 0, 1);
		case 14: AnimOynat(playerid, "PED", "roadcross_old", 4.1, 1, 0, 0, 0, 0, 1);
		case 15: AnimOynat(playerid, "PED", "woman_idlestance", 4.1, 1, 0, 0, 0, 0, 1);
		default: Kullanim(playerid, "/idles [1-15]");
	}
	return 1;
}

CMD:aim(playerid, params[])
{
	
	if(IsPlayerInAnyVehicle(playerid)) return Sunucu(playerid, "Bu animasyon araçlarda kullanýlamaz.");
	switch(strval(params))
	{
		case 1: AnimOynat(playerid,"PED","gang_gunstand",4.0,1,1,1,1,1);
		case 2: AnimOynat(playerid,"ped", "ARRESTgun", 4.0, 0, 1, 1, 1, -1);
		case 3: AnimOynat(playerid, "SHOP", "ROB_Loop_Threat", 4.0, 1, 0, 0, 0, 0);
		default: Kullanim(playerid,"/aim [1-3]");
	}
	return 1;
}

CMD:sunbathe(playerid, params[])
{
	if(IsPlayerInAnyVehicle(playerid)) return Sunucu(playerid, "Bu animasyon araçlarda kullanýlamaz.");
	switch(strval(params))
	{
		case 1: AnimOynat(playerid, "SUNBATHE", "batherdown", 4.1, 0, 1, 1, 1, 1, 1);
		case 2: AnimOynat(playerid, "SUNBATHE", "batherup", 4.1, 0, 1, 1, 1, 1, 1);
		case 3: AnimOynat(playerid, "SUNBATHE", "Lay_Bac_in", 4.1, 0, 1, 1, 1, 1, 1);
		case 4: AnimOynat(playerid, "SUNBATHE", "Lay_Bac_out", 4.1, 0, 1, 1, 1, 1, 1);
		case 5: AnimOynat(playerid, "SUNBATHE", "ParkSit_M_IdleA", 4.1, 0, 1, 1, 1, 1, 1);
		case 6: AnimOynat(playerid, "SUNBATHE", "ParkSit_M_IdleB", 4.1, 0, 1, 1, 1, 1, 1);
		case 7: AnimOynat(playerid, "SUNBATHE", "ParkSit_M_IdleC", 4.1, 0, 1, 1, 1, 1, 1);
		case 8: AnimOynat(playerid, "SUNBATHE", "ParkSit_M_in", 4.1, 0, 1, 1, 1, 1, 1);
		case 9: AnimOynat(playerid, "SUNBATHE", "ParkSit_M_out", 4.1, 0, 1, 1, 1, 1, 1);
		case 10: AnimOynat(playerid, "SUNBATHE", "ParkSit_W_idleA", 4.1, 0, 1, 1, 1, 1, 1);
		case 11: AnimOynat(playerid, "SUNBATHE", "ParkSit_W_idleB", 4.1, 0, 1, 1, 1, 1, 1);
		case 12: AnimOynat(playerid, "SUNBATHE", "ParkSit_W_idleC", 4.1, 0, 1, 1, 1, 1, 1);
		case 13: AnimOynat(playerid, "SUNBATHE", "ParkSit_W_in", 4.1, 0, 1, 1, 1, 1, 1);
		case 14: AnimOynat(playerid, "SUNBATHE", "ParkSit_W_out", 4.1, 0, 1, 1, 1, 1, 1);
		case 15: AnimOynat(playerid, "SUNBATHE", "SBATHE_F_LieB2Sit", 4.1, 0, 1, 1, 1, 1, 1);
		case 16: AnimOynat(playerid, "SUNBATHE", "SBATHE_F_Out", 4.1, 0, 1, 1, 1, 1, 1);
		case 17: AnimOynat(playerid, "SUNBATHE", "SitnWait_in_W", 4.1, 0, 1, 1, 1, 1, 1);
		case 18: AnimOynat(playerid, "SUNBATHE", "SitnWait_out_W", 4.1, 0, 1, 1, 1, 1, 1);
		default: Kullanim(playerid, "/sunbathe [1-18]");
	}
	return 1;
}

CMD:lowrider(playerid, params[])
{
	new sistempasif = 1;
	if(sistempasif == 1) return Sunucu(playerid, "Bu animasyon geçici olarak devre dýþý býrakýlmýþtýr.");
	
	static aid;
	aid = GetPlayerVehicleID(playerid);
	if(GetVehicleModel(aid) != 536 && GetVehicleModel(aid) != 575 && GetVehicleModel(aid) != 567) return Sunucu(playerid, "Bu anim sadece lowrider araçlarda kullanýlabilir.");

	switch(strval(params))
	{
		case 1: AnimOynat(playerid, "LOWRIDER", "lrgirl_bdbnce", 4.1, 0, 1, 1, 1, 1, 1);
		case 2: AnimOynat(playerid, "LOWRIDER", "lrgirl_hair", 4.1, 0, 1, 1, 1, 1, 1);
		case 3: AnimOynat(playerid, "LOWRIDER", "lrgirl_hurry", 4.1, 0, 1, 1, 1, 1, 1);
		case 4: AnimOynat(playerid, "LOWRIDER", "lrgirl_idleloop", 4.1, 0, 1, 1, 1, 1, 1);
		case 5: AnimOynat(playerid, "LOWRIDER", "lrgirl_idle_to_l0", 4.1, 0, 1, 1, 1, 1, 1);
		case 6: AnimOynat(playerid, "LOWRIDER", "lrgirl_l0_bnce", 4.1, 0, 1, 1, 1, 1, 1);
		case 7: AnimOynat(playerid, "LOWRIDER", "lrgirl_l0_loop", 4.1, 0, 1, 1, 1, 1, 1);
		case 8: AnimOynat(playerid, "LOWRIDER", "lrgirl_l0_to_l1", 4.1, 0, 1, 1, 1, 1, 1);
		case 9: AnimOynat(playerid, "LOWRIDER", "lrgirl_l12_to_l0", 4.1, 0, 1, 1, 1, 1, 1);
		case 10: AnimOynat(playerid, "LOWRIDER", "lrgirl_l1_bnce", 4.1, 0, 1, 1, 1, 1, 1);
		case 11: AnimOynat(playerid, "LOWRIDER", "lrgirl_l1_loop", 4.1, 0, 1, 1, 1, 1, 1);
		case 12: AnimOynat(playerid, "LOWRIDER", "lrgirl_l1_to_l2", 4.1, 0, 1, 1, 1, 1, 1);
		case 13: AnimOynat(playerid, "LOWRIDER", "lrgirl_l2_bnce", 4.1, 0, 1, 1, 1, 1, 1);
		case 14: AnimOynat(playerid, "LOWRIDER", "lrgirl_l2_loop", 4.1, 0, 1, 1, 1, 1, 1);
		case 15: AnimOynat(playerid, "LOWRIDER", "lrgirl_l2_to_l3", 4.1, 0, 1, 1, 1, 1, 1);
		case 16: AnimOynat(playerid, "LOWRIDER", "lrgirl_l345_to_l1", 4.1, 0, 1, 1, 1, 1, 1);
		case 17: AnimOynat(playerid, "LOWRIDER", "lrgirl_l3_bnce", 4.1, 0, 1, 1, 1, 1, 1);
		case 18: AnimOynat(playerid, "LOWRIDER", "lrgirl_l3_loop", 4.1, 0, 1, 1, 1, 1, 1);
		case 19: AnimOynat(playerid, "LOWRIDER", "lrgirl_l3_to_l4", 4.1, 0, 1, 1, 1, 1, 1);
		case 20: AnimOynat(playerid, "LOWRIDER", "lrgirl_l4_bnce", 4.1, 0, 1, 1, 1, 1, 1);
		case 21: AnimOynat(playerid, "LOWRIDER", "lrgirl_l4_loop", 4.1, 0, 1, 1, 1, 1, 1);
		case 22: AnimOynat(playerid, "LOWRIDER", "lrgirl_l4_to_l5", 4.1, 0, 1, 1, 1, 1, 1);
		case 23: AnimOynat(playerid, "LOWRIDER", "lrgirl_l5_bnce", 4.1, 0, 1, 1, 1, 1, 1);
		case 24: AnimOynat(playerid, "LOWRIDER", "lrgirl_l5_loop", 4.1, 0, 1, 1, 1, 1, 1);
		case 25: AnimOynat(playerid, "LOWRIDER", "prtial_gngtlkB", 4.1, 0, 1, 1, 1, 1, 1);
		case 26: AnimOynat(playerid, "LOWRIDER", "prtial_gngtlkC", 4.1, 0, 1, 1, 1, 1, 1);
		case 27: AnimOynat(playerid, "LOWRIDER", "prtial_gngtlkD", 4.1, 0, 1, 1, 1, 1, 1);
		case 28: AnimOynat(playerid, "LOWRIDER", "prtial_gngtlkE", 4.1, 0, 1, 1, 1, 1, 1);
		case 29: AnimOynat(playerid, "LOWRIDER", "prtial_gngtlkF", 4.1, 0, 1, 1, 1, 1, 1);
		case 30: AnimOynat(playerid, "LOWRIDER", "prtial_gngtlkG", 4.1, 0, 1, 1, 1, 1, 1);
		case 31: AnimOynat(playerid, "LOWRIDER", "prtial_gngtlkH", 4.1, 0, 1, 1, 1, 1, 1);
		default: Kullanim(playerid, "/lowrider [1-31]");
	}
	return 1;
}

CMD:carchat(playerid, params[])
{
	
	static aid;
	aid = GetPlayerVehicleID(playerid);
	if(GetVehicleModel(aid) != 536 && GetVehicleModel(aid) != 575 && GetVehicleModel(aid) != 567) return Sunucu(playerid, "Bu anim sadece lowrider araçlarda kullanýlabilir.");
	switch(strval(params))
	{
		case 1: AnimOynat(playerid, "CAR_CHAT", "carfone_in", 4.1, 0, 1, 1, 1, 1, 1);
		case 2: AnimOynat(playerid, "CAR_CHAT", "carfone_loopA", 4.1, 0, 1, 1, 1, 1, 1);
		case 3: AnimOynat(playerid, "CAR_CHAT", "carfone_loopA_to_B", 4.1, 0, 1, 1, 1, 1, 1);
		case 4: AnimOynat(playerid, "CAR_CHAT", "carfone_loopB", 4.1, 0, 1, 1, 1, 1, 1);
		case 5: AnimOynat(playerid, "CAR_CHAT", "carfone_loopB_to_A", 4.1, 0, 1, 1, 1, 1, 1);
		case 6: AnimOynat(playerid, "CAR_CHAT", "carfone_out", 4.1, 0, 1, 1, 1, 1, 1);
		case 7: AnimOynat(playerid, "CAR_CHAT", "CAR_Sc1_BL", 4.1, 0, 1, 1, 1, 1, 1);
		case 8: AnimOynat(playerid, "CAR_CHAT", "CAR_Sc1_BR", 4.1, 0, 1, 1, 1, 1, 1);
		case 9: AnimOynat(playerid, "CAR_CHAT", "CAR_Sc1_FL", 4.1, 0, 1, 1, 1, 1, 1);
		case 10: AnimOynat(playerid, "CAR_CHAT", "CAR_Sc1_FR", 4.1, 0, 1, 1, 1, 1, 1);
		case 11: AnimOynat(playerid, "CAR_CHAT", "CAR_Sc2_FL", 4.1, 0, 1, 1, 1, 1, 1);
		case 12: AnimOynat(playerid, "CAR_CHAT", "CAR_Sc3_BR", 4.1, 0, 1, 1, 1, 1, 1);
		case 13: AnimOynat(playerid, "CAR_CHAT", "CAR_Sc3_FL", 4.1, 0, 1, 1, 1, 1, 1);
		case 14: AnimOynat(playerid, "CAR_CHAT", "CAR_Sc3_FR", 4.1, 0, 1, 1, 1, 1, 1);
		case 15: AnimOynat(playerid, "CAR_CHAT", "CAR_Sc4_BL", 4.1, 0, 1, 1, 1, 1, 1);
		case 16: AnimOynat(playerid, "CAR_CHAT", "CAR_Sc4_BR", 4.1, 0, 1, 1, 1, 1, 1);
		case 17: AnimOynat(playerid, "CAR_CHAT", "CAR_Sc4_FL", 4.1, 0, 1, 1, 1, 1, 1);
		case 18: AnimOynat(playerid, "CAR_CHAT", "CAR_Sc4_FR", 4.1, 0, 1, 1, 1, 1, 1);
		case 19: AnimOynat(playerid, "CAR", "Sit_relaxed", 4.1, 0, 1, 1, 1, 1, 1);
//case 20: AnimOynat(playerid, "CAR", "Tap_hand", 4.1, 1, 0, 0, 0, 0, 1);
		default: Kullanim(playerid, "/carchat [1-19]");
	}
	return 1;
}