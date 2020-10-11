Vice:TextDrawlariYukle(playerid)
{
	YaraliTD[playerid] = CreatePlayerTextDraw(playerid, 499.000000, 105.000000, "Yaralisin:_60_saniye");
	PlayerTextDrawFont(playerid, YaraliTD[playerid], 1);
	PlayerTextDrawLetterSize(playerid, YaraliTD[playerid], 0.258332, 1.350000);
	PlayerTextDrawTextSize(playerid, YaraliTD[playerid], 400.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, YaraliTD[playerid], 1);
	PlayerTextDrawSetShadow(playerid, YaraliTD[playerid], 0);
	PlayerTextDrawAlignment(playerid, YaraliTD[playerid], 1);
	PlayerTextDrawColor(playerid, YaraliTD[playerid], -1962934017);
	PlayerTextDrawBackgroundColor(playerid, YaraliTD[playerid], 255);
	PlayerTextDrawBoxColor(playerid, YaraliTD[playerid], 50);
	PlayerTextDrawUseBox(playerid, YaraliTD[playerid], 0);
	PlayerTextDrawSetProportional(playerid, YaraliTD[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, YaraliTD[playerid], 0);

	KarakterSecimTD[0][playerid] = CreatePlayerTextDraw(playerid, 161.000000, 289.000000, "Anthony_Flaviano");
	PlayerTextDrawFont(playerid, KarakterSecimTD[0][playerid], 2);
	PlayerTextDrawLetterSize(playerid, KarakterSecimTD[0][playerid], 0.208333, 1.250000);
	PlayerTextDrawTextSize(playerid, KarakterSecimTD[0][playerid], 456.500000, 105.500000);
	PlayerTextDrawSetOutline(playerid, KarakterSecimTD[0][playerid], 1);
	PlayerTextDrawSetShadow(playerid, KarakterSecimTD[0][playerid], 0);
	PlayerTextDrawAlignment(playerid, KarakterSecimTD[0][playerid], 2);
	PlayerTextDrawColor(playerid, KarakterSecimTD[0][playerid], -1);
	PlayerTextDrawBackgroundColor(playerid, KarakterSecimTD[0][playerid], 255);
	PlayerTextDrawBoxColor(playerid, KarakterSecimTD[0][playerid], 118);
	PlayerTextDrawUseBox(playerid, KarakterSecimTD[0][playerid], 1);
	PlayerTextDrawSetProportional(playerid, KarakterSecimTD[0][playerid], 1);
	PlayerTextDrawSetSelectable(playerid, KarakterSecimTD[0][playerid], 0);

	KarakterSecimTD[1][playerid] = CreatePlayerTextDraw(playerid, 273.000000, 289.000000, "JIM_WILLBERG");
	PlayerTextDrawFont(playerid, KarakterSecimTD[1][playerid], 2);
	PlayerTextDrawLetterSize(playerid, KarakterSecimTD[1][playerid], 0.208333, 1.250000);
	PlayerTextDrawTextSize(playerid, KarakterSecimTD[1][playerid], 456.500000, 105.500000);
	PlayerTextDrawSetOutline(playerid, KarakterSecimTD[1][playerid], 1);
	PlayerTextDrawSetShadow(playerid, KarakterSecimTD[1][playerid], 0);
	PlayerTextDrawAlignment(playerid, KarakterSecimTD[1][playerid], 2);
	PlayerTextDrawColor(playerid, KarakterSecimTD[1][playerid], -1);
	PlayerTextDrawBackgroundColor(playerid, KarakterSecimTD[1][playerid], 255);
	PlayerTextDrawBoxColor(playerid, KarakterSecimTD[1][playerid], 118);
	PlayerTextDrawUseBox(playerid, KarakterSecimTD[1][playerid], 1);
	PlayerTextDrawSetProportional(playerid, KarakterSecimTD[1][playerid], 1);
	PlayerTextDrawSetSelectable(playerid, KarakterSecimTD[1][playerid], 0);

	KarakterSecimTD[2][playerid] = CreatePlayerTextDraw(playerid, 219.000000, 127.000000, "Preview_Model");
	PlayerTextDrawFont(playerid, KarakterSecimTD[2][playerid], 5);
	PlayerTextDrawLetterSize(playerid, KarakterSecimTD[2][playerid], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, KarakterSecimTD[2][playerid], 108.500000, 158.000000);
	PlayerTextDrawSetOutline(playerid, KarakterSecimTD[2][playerid], 0);
	PlayerTextDrawSetShadow(playerid, KarakterSecimTD[2][playerid], 0);
	PlayerTextDrawAlignment(playerid, KarakterSecimTD[2][playerid], 1);
	PlayerTextDrawColor(playerid, KarakterSecimTD[2][playerid], -1);
	PlayerTextDrawBackgroundColor(playerid, KarakterSecimTD[2][playerid], 125);
	PlayerTextDrawBoxColor(playerid, KarakterSecimTD[2][playerid], 255);
	PlayerTextDrawUseBox(playerid, KarakterSecimTD[2][playerid], 0);
	PlayerTextDrawSetProportional(playerid, KarakterSecimTD[2][playerid], 1);
	PlayerTextDrawSetSelectable(playerid, KarakterSecimTD[2][playerid], 1);
	PlayerTextDrawSetPreviewModel(playerid, KarakterSecimTD[2][playerid], 290);
	PlayerTextDrawSetPreviewRot(playerid, KarakterSecimTD[2][playerid], -10.000000, 0.000000, -5.000000, 0.920000);
	PlayerTextDrawSetPreviewVehCol(playerid, KarakterSecimTD[2][playerid], 1, 1);

	KarakterSecimTD[3][playerid] = CreatePlayerTextDraw(playerid, 385.000000, 289.000000, "BOS_SLOT");
	PlayerTextDrawFont(playerid, KarakterSecimTD[3][playerid], 2);
	PlayerTextDrawLetterSize(playerid, KarakterSecimTD[3][playerid], 0.208333, 1.250000);
	PlayerTextDrawTextSize(playerid, KarakterSecimTD[3][playerid], 456.500000, 105.500000);
	PlayerTextDrawSetOutline(playerid, KarakterSecimTD[3][playerid], 1);
	PlayerTextDrawSetShadow(playerid, KarakterSecimTD[3][playerid], 0);
	PlayerTextDrawAlignment(playerid, KarakterSecimTD[3][playerid], 2);
	PlayerTextDrawColor(playerid, KarakterSecimTD[3][playerid], -1);
	PlayerTextDrawBackgroundColor(playerid, KarakterSecimTD[3][playerid], 255);
	PlayerTextDrawBoxColor(playerid, KarakterSecimTD[3][playerid], 118);
	PlayerTextDrawUseBox(playerid, KarakterSecimTD[3][playerid], 1);
	PlayerTextDrawSetProportional(playerid, KarakterSecimTD[3][playerid], 1);
	PlayerTextDrawSetSelectable(playerid, KarakterSecimTD[3][playerid], 0);

	KarakterSecimTD[4][playerid] = CreatePlayerTextDraw(playerid, 331.000000, 127.000000, "Preview_Model");
	PlayerTextDrawFont(playerid, KarakterSecimTD[4][playerid], 5);
	PlayerTextDrawLetterSize(playerid, KarakterSecimTD[4][playerid], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, KarakterSecimTD[4][playerid], 108.500000, 158.000000);
	PlayerTextDrawSetOutline(playerid, KarakterSecimTD[4][playerid], 0);
	PlayerTextDrawSetShadow(playerid, KarakterSecimTD[4][playerid], 0);
	PlayerTextDrawAlignment(playerid, KarakterSecimTD[4][playerid], 1);
	PlayerTextDrawColor(playerid, KarakterSecimTD[4][playerid], -1);
	PlayerTextDrawBackgroundColor(playerid, KarakterSecimTD[4][playerid], 125);
	PlayerTextDrawBoxColor(playerid, KarakterSecimTD[4][playerid], 255);
	PlayerTextDrawUseBox(playerid, KarakterSecimTD[4][playerid], 0);
	PlayerTextDrawSetProportional(playerid, KarakterSecimTD[4][playerid], 1);
	PlayerTextDrawSetSelectable(playerid, KarakterSecimTD[4][playerid], 1);
	PlayerTextDrawSetPreviewModel(playerid, KarakterSecimTD[4][playerid], 0);
	PlayerTextDrawSetPreviewRot(playerid, KarakterSecimTD[4][playerid], -10.000000, 0.000000, -5.000000, 0.920000);
	PlayerTextDrawSetPreviewVehCol(playerid, KarakterSecimTD[4][playerid], 1, 1);

	KarakterSecimTD[5][playerid] = CreatePlayerTextDraw(playerid, 107.000000, 127.000000, "Preview_Model");
	PlayerTextDrawFont(playerid, KarakterSecimTD[5][playerid], 5);
	PlayerTextDrawLetterSize(playerid, KarakterSecimTD[5][playerid], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, KarakterSecimTD[5][playerid], 108.500000, 158.000000);
	PlayerTextDrawSetOutline(playerid, KarakterSecimTD[5][playerid], 0);
	PlayerTextDrawSetShadow(playerid, KarakterSecimTD[5][playerid], 0);
	PlayerTextDrawAlignment(playerid, KarakterSecimTD[5][playerid], 1);
	PlayerTextDrawColor(playerid, KarakterSecimTD[5][playerid], -1);
	PlayerTextDrawBackgroundColor(playerid, KarakterSecimTD[5][playerid], 125);
	PlayerTextDrawBoxColor(playerid, KarakterSecimTD[5][playerid], 255);
	PlayerTextDrawUseBox(playerid, KarakterSecimTD[5][playerid], 0);
	PlayerTextDrawSetProportional(playerid, KarakterSecimTD[5][playerid], 1);
	PlayerTextDrawSetSelectable(playerid, KarakterSecimTD[5][playerid], 1);
	PlayerTextDrawSetPreviewModel(playerid, KarakterSecimTD[5][playerid], 72);
	PlayerTextDrawSetPreviewRot(playerid, KarakterSecimTD[5][playerid], -10.000000, 0.000000, -5.000000, 0.920000);
	PlayerTextDrawSetPreviewVehCol(playerid, KarakterSecimTD[5][playerid], 1, 1);

	KarakterSecimTD[6][playerid] = CreatePlayerTextDraw(playerid, 497.000000, 289.000000, "BOS_SLOT");
	PlayerTextDrawFont(playerid, KarakterSecimTD[6][playerid], 2);
	PlayerTextDrawLetterSize(playerid, KarakterSecimTD[6][playerid], 0.208333, 1.250000);
	PlayerTextDrawTextSize(playerid, KarakterSecimTD[6][playerid], 456.500000, 105.500000);
	PlayerTextDrawSetOutline(playerid, KarakterSecimTD[6][playerid], 1);
	PlayerTextDrawSetShadow(playerid, KarakterSecimTD[6][playerid], 0);
	PlayerTextDrawAlignment(playerid, KarakterSecimTD[6][playerid], 2);
	PlayerTextDrawColor(playerid, KarakterSecimTD[6][playerid], -1);
	PlayerTextDrawBackgroundColor(playerid, KarakterSecimTD[6][playerid], 255);
	PlayerTextDrawBoxColor(playerid, KarakterSecimTD[6][playerid], 118);
	PlayerTextDrawUseBox(playerid, KarakterSecimTD[6][playerid], 1);
	PlayerTextDrawSetProportional(playerid, KarakterSecimTD[6][playerid], 1);
	PlayerTextDrawSetSelectable(playerid, KarakterSecimTD[6][playerid], 0);

	KarakterSecimTD[7][playerid] = CreatePlayerTextDraw(playerid, 443.000000, 127.000000, "Preview_Model");
	PlayerTextDrawFont(playerid, KarakterSecimTD[7][playerid], 5);
	PlayerTextDrawLetterSize(playerid, KarakterSecimTD[7][playerid], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, KarakterSecimTD[7][playerid], 108.500000, 158.000000);
	PlayerTextDrawSetOutline(playerid, KarakterSecimTD[7][playerid], 0);
	PlayerTextDrawSetShadow(playerid, KarakterSecimTD[7][playerid], 0);
	PlayerTextDrawAlignment(playerid, KarakterSecimTD[7][playerid], 1);
	PlayerTextDrawColor(playerid, KarakterSecimTD[7][playerid], -1);
	PlayerTextDrawBackgroundColor(playerid, KarakterSecimTD[7][playerid], 125);
	PlayerTextDrawBoxColor(playerid, KarakterSecimTD[7][playerid], 255);
	PlayerTextDrawUseBox(playerid, KarakterSecimTD[7][playerid], 0);
	PlayerTextDrawSetProportional(playerid, KarakterSecimTD[7][playerid], 1);
	PlayerTextDrawSetSelectable(playerid, KarakterSecimTD[7][playerid], 1);
	PlayerTextDrawSetPreviewModel(playerid, KarakterSecimTD[7][playerid], 0);
	PlayerTextDrawSetPreviewRot(playerid, KarakterSecimTD[7][playerid], -10.000000, 0.000000, -5.000000, 0.920000);
	PlayerTextDrawSetPreviewVehCol(playerid, KarakterSecimTD[7][playerid], 1, 1);

	AracGostergesi[playerid] = CreatePlayerTextDraw(playerid, 498.000000, 106.000000, "Benzin:_95.67 Hiz:_44_km/h KM:_230km");
	PlayerTextDrawFont(playerid, AracGostergesi[playerid], 1);
	PlayerTextDrawLetterSize(playerid, AracGostergesi[playerid], 0.237499, 1.150000);
	PlayerTextDrawTextSize(playerid, AracGostergesi[playerid], 400.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, AracGostergesi[playerid], 1);
	PlayerTextDrawSetShadow(playerid, AracGostergesi[playerid], 0);
	PlayerTextDrawAlignment(playerid, AracGostergesi[playerid], 1);
	PlayerTextDrawColor(playerid, AracGostergesi[playerid], -1378294017);
	PlayerTextDrawBackgroundColor(playerid, AracGostergesi[playerid], 255);
	PlayerTextDrawBoxColor(playerid, AracGostergesi[playerid], 50);
	PlayerTextDrawUseBox(playerid, AracGostergesi[playerid], 0);
	PlayerTextDrawSetProportional(playerid, AracGostergesi[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, AracGostergesi[playerid], 0);

	tarim9[playerid] = CreatePlayerTextDraw(playerid, 451.000000, 121.000000, "ld_beat:cross");
	PlayerTextDrawFont(playerid, tarim9[playerid], 4);
	PlayerTextDrawLetterSize(playerid, tarim9[playerid], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, tarim9[playerid], 17.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, tarim9[playerid], 1);
	PlayerTextDrawSetShadow(playerid, tarim9[playerid], 0);
	PlayerTextDrawAlignment(playerid, tarim9[playerid], 1);
	PlayerTextDrawColor(playerid, tarim9[playerid], -1);
	PlayerTextDrawBackgroundColor(playerid, tarim9[playerid], 255);
	PlayerTextDrawBoxColor(playerid, tarim9[playerid], 50);
	PlayerTextDrawUseBox(playerid, tarim9[playerid], 1);
	PlayerTextDrawSetProportional(playerid, tarim9[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, tarim9[playerid], 1);
	
	return true;
}

Vice:TextDrawlariSil(playerid)
{
	PlayerTextDrawDestroy(playerid, YaraliTD[playerid]);
	for(new i = 0; i < 8; i++)
	{
		PlayerTextDrawDestroy(playerid, KarakterSecimTD[i][playerid]);
	}
	PlayerTextDrawDestroy(playerid, AracGostergesi[playerid]);
	return true;
}

Vice:GenelTextDrawYukle()
{
	tarim[0] = TextDrawCreate(100.000000, -74.000000, "Preview_Model");
	TextDrawFont(tarim[0], 5);
	TextDrawLetterSize(tarim[0], 0.600000, 2.000000);
	TextDrawTextSize(tarim[0], 437.500000, 575.000000);
	TextDrawSetOutline(tarim[0], 0);
	TextDrawSetShadow(tarim[0], 0);
	TextDrawAlignment(tarim[0], 1);
	TextDrawColor(tarim[0], -1);
	TextDrawBackgroundColor(tarim[0], 0);
	TextDrawBoxColor(tarim[0], 255);
	TextDrawUseBox(tarim[0], 0);
	TextDrawSetProportional(tarim[0], 1);
	TextDrawSetSelectable(tarim[0], 0);
	TextDrawSetPreviewModel(tarim[0], 19787);
	TextDrawSetPreviewRot(tarim[0], 0.000000, 0.000000, -180.000000, 1.000000);
	TextDrawSetPreviewVehCol(tarim[0], 1, 1);

	tarim[1] = TextDrawCreate(144.000000, 108.000000, "mdl-2098:fiyatlar");
	TextDrawFont(tarim[1], 4);
	TextDrawLetterSize(tarim[1], 0.600000, 2.000000);
	TextDrawTextSize(tarim[1], 351.000000, 222.000000);
	TextDrawSetOutline(tarim[1], 1);
	TextDrawSetShadow(tarim[1], 0);
	TextDrawAlignment(tarim[1], 1);
	TextDrawColor(tarim[1], -1);
	TextDrawBackgroundColor(tarim[1], 255);
	TextDrawBoxColor(tarim[1], 50);
	TextDrawUseBox(tarim[1], 1);
	TextDrawSetProportional(tarim[1], 1);
	TextDrawSetSelectable(tarim[1], 0);

	tarim[2] = TextDrawCreate(219.000000, 208.000000, "80$~n~88$~n~72$~n~80$~n~68$");
	TextDrawFont(tarim[2], 3);
	TextDrawLetterSize(tarim[2], 0.254166, 2.099999);
	TextDrawTextSize(tarim[2], 402.500000, 20.500000);
	TextDrawSetOutline(tarim[2], 1);
	TextDrawSetShadow(tarim[2], 0);
	TextDrawAlignment(tarim[2], 1);
	TextDrawColor(tarim[2], 852308735);
	TextDrawBackgroundColor(tarim[2], 255);
	TextDrawBoxColor(tarim[2], 0);
	TextDrawUseBox(tarim[2], 1);
	TextDrawSetProportional(tarim[2], 1);
	TextDrawSetSelectable(tarim[2], 0);

	tarim[3] = TextDrawCreate(248.000000, 208.000000, "120$~n~100$~n~128$~n~108$~n~112$");
	TextDrawFont(tarim[3], 3);
	TextDrawLetterSize(tarim[3], 0.254166, 2.099999);
	TextDrawTextSize(tarim[3], 402.500000, 20.500000);
	TextDrawSetOutline(tarim[3], 1);
	TextDrawSetShadow(tarim[3], 0);
	TextDrawAlignment(tarim[3], 1);
	TextDrawColor(tarim[3], 852308735);
	TextDrawBackgroundColor(tarim[3], 255);
	TextDrawBoxColor(tarim[3], 0);
	TextDrawUseBox(tarim[3], 1);
	TextDrawSetProportional(tarim[3], 1);
	TextDrawSetSelectable(tarim[3], 0);

	tarim[4] = TextDrawCreate(277.000000, 208.000000, "128$~n~160$~n~140$~n~172$~n~148$");
	TextDrawFont(tarim[4], 3);
	TextDrawLetterSize(tarim[4], 0.254166, 2.099999);
	TextDrawTextSize(tarim[4], 402.500000, 20.500000);
	TextDrawSetOutline(tarim[4], 1);
	TextDrawSetShadow(tarim[4], 0);
	TextDrawAlignment(tarim[4], 1);
	TextDrawColor(tarim[4], 852308735);
	TextDrawBackgroundColor(tarim[4], 255);
	TextDrawBoxColor(tarim[4], 0);
	TextDrawUseBox(tarim[4], 1);
	TextDrawSetProportional(tarim[4], 1);
	TextDrawSetSelectable(tarim[4], 0);

	tarim[5] = TextDrawCreate(307.000000, 208.000000, "140$~n~180$~n~154$~n~200$~n~188$");
	TextDrawFont(tarim[5], 3);
	TextDrawLetterSize(tarim[5], 0.254166, 2.099999);
	TextDrawTextSize(tarim[5], 402.500000, 20.500000);
	TextDrawSetOutline(tarim[5], 1);
	TextDrawSetShadow(tarim[5], 0);
	TextDrawAlignment(tarim[5], 1);
	TextDrawColor(tarim[5], 852308735);
	TextDrawBackgroundColor(tarim[5], 255);
	TextDrawBoxColor(tarim[5], 0);
	TextDrawUseBox(tarim[5], 1);
	TextDrawSetProportional(tarim[5], 1);
	TextDrawSetSelectable(tarim[5], 0);

	tarim[6] = TextDrawCreate(338.000000, 208.000000, "192$~n~200$~n~220$~n~204$~n~228$");
	TextDrawFont(tarim[6], 3);
	TextDrawLetterSize(tarim[6], 0.254166, 2.099999);
	TextDrawTextSize(tarim[6], 402.500000, 20.500000);
	TextDrawSetOutline(tarim[6], 1);
	TextDrawSetShadow(tarim[6], 0);
	TextDrawAlignment(tarim[6], 1);
	TextDrawColor(tarim[6], 852308735);
	TextDrawBackgroundColor(tarim[6], 255);
	TextDrawBoxColor(tarim[6], 0);
	TextDrawUseBox(tarim[6], 1);
	TextDrawSetProportional(tarim[6], 1);
	TextDrawSetSelectable(tarim[6], 0);

	tarim[7] = TextDrawCreate(372.000000, 208.000000, "240$~n~232$~n~252$~n~256$~n~220$");
	TextDrawFont(tarim[7], 3);
	TextDrawLetterSize(tarim[7], 0.254166, 2.099999);
	TextDrawTextSize(tarim[7], 402.500000, 20.500000);
	TextDrawSetOutline(tarim[7], 1);
	TextDrawSetShadow(tarim[7], 0);
	TextDrawAlignment(tarim[7], 1);
	TextDrawColor(tarim[7], 852308735);
	TextDrawBackgroundColor(tarim[7], 255);
	TextDrawBoxColor(tarim[7], 0);
	TextDrawUseBox(tarim[7], 1);
	TextDrawSetProportional(tarim[7], 1);
	TextDrawSetSelectable(tarim[7], 0);

	tarim[8] = TextDrawCreate(407.000000, 208.000000, "252$~n~260$~n~272$~n~280$~n~292$");
	TextDrawFont(tarim[8], 3);
	TextDrawLetterSize(tarim[8], 0.254166, 2.099999);
	TextDrawTextSize(tarim[8], 402.500000, 20.500000);
	TextDrawSetOutline(tarim[8], 1);
	TextDrawSetShadow(tarim[8], 0);
	TextDrawAlignment(tarim[8], 1);
	TextDrawColor(tarim[8], 852308735);
	TextDrawBackgroundColor(tarim[8], 255);
	TextDrawBoxColor(tarim[8], 0);
	TextDrawUseBox(tarim[8], 1);
	TextDrawSetProportional(tarim[8], 1);
	TextDrawSetSelectable(tarim[8], 0);	

	ciftlik_0 = TextDrawCreate(252.000000, 32.000000, ".");
	TextDrawFont(ciftlik_0, 1);
	TextDrawLetterSize(ciftlik_0, 15.662546, -1.000000);
	TextDrawTextSize(ciftlik_0, 406.000000, 77.500000);
	TextDrawSetOutline(ciftlik_0, 1);
	TextDrawSetShadow(ciftlik_0, 0);
	TextDrawAlignment(ciftlik_0, 1);
	TextDrawColor(ciftlik_0, -1);
	TextDrawBackgroundColor(ciftlik_0, 255);
	TextDrawBoxColor(ciftlik_0, 0);
	TextDrawUseBox(ciftlik_0, 1);
	TextDrawSetProportional(ciftlik_0, 1);
	TextDrawSetSelectable(ciftlik_0, 0);

	ciftlik_1 = TextDrawCreate(354.000000, 6.000000, "Durum");
	TextDrawFont(ciftlik_1, 0);
	TextDrawLetterSize(ciftlik_1, 0.600000, 2.000000);
	TextDrawTextSize(ciftlik_1, 400.000000, 17.000000);
	TextDrawSetOutline(ciftlik_1, 1);
	TextDrawSetShadow(ciftlik_1, 0);
	TextDrawAlignment(ciftlik_1, 3);
	TextDrawColor(ciftlik_1, -1);
	TextDrawBackgroundColor(ciftlik_1, 255);
	TextDrawBoxColor(ciftlik_1, 0);
	TextDrawUseBox(ciftlik_1, 1);
	TextDrawSetProportional(ciftlik_1, 1);
	TextDrawSetSelectable(ciftlik_1, 0);
}