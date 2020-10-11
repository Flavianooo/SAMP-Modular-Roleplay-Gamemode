stock static Float: BalikNoktasi[][] =
{
	{127.4211,-1956.4722,5.7917},
	{128.5677,-1958.7454,5.7545},
	{129.5927,-1960.7712,5.7212},
	{130.4194,-1962.4041,5.6944},
	{131.1083,-1963.7615,5.6720},
	{131.7414,-1965.0186,5.6514},
	{132.5551,-1966.6173,5.6249}
};

Vice:BalikNoktalariYarat()
{
	for(new i = 0; i < sizeof(BalikNoktasi); i++)
	{
		CreateDynamic3DTextLabel("{99C794}[Balýk Noktasý]\n{FFFFFF}[/baliktut]", -1, BalikNoktasi[i][0],BalikNoktasi[i][1],BalikNoktasi[i][2] + 0.8, 2.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1,-1);
	}
	CreateDynamic3DTextLabel("{99C794}[Balýkçý Kulübesi]\n{FFFFFF}[/yemal]\n{FFFFFF}[/baliksat]", -1, 130.8684,-1945.5778,6.0826, 8.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, -1);
	CreateDynamicPickup(1239, 23, 130.8684,-1945.5778,6.0826);
}

CMD:baliktut(playerid, params[])
{
	if(!BalikNoktaYakin(playerid)) return Sunucu(playerid, "Bir balýk tutma noktasýna yakýn deðilsiniz.");
	if(Karakter[playerid][BalikTutuyor] == true) return Sunucu(playerid, "Zaten þu anda balýk tutuyorsunuz.");
	if(IsPlayerInAnyVehicle(playerid)) return Sunucu(playerid, "Araçta balýk tutamazsýnýz.");
	if(Karakter[playerid][BalikYemi] < 1) return Sunucu(playerid, "Yeminiz bulunmuyor, balýk tutamazsýnýz.");
	if(Karakter[playerid][Balik] >= MAX_OYUNCU_BALIK) return Sunucu(playerid, "Sahip olabileceðiniz maksimum balýk sayýsýna ulaþmýþsýnýz.");
	Sunucu(playerid, "Balýk tutuyorsunuz...");
	Karakter[playerid][BalikYemi]--;
	KarakterVeriKaydet(playerid);
	Karakter[playerid][BalikTutuyor] = true;
	TogglePlayerControllable(playerid, false);
	ApplyAnimation(playerid,"SWORD","sword_block",50.0,0,1,0,1,1);
	new baliksure = BalikTutmaSuresi(playerid);
	Karakter[playerid][BalikTimer] = SetTimerEx("BalikTutuyorTimer", baliksure, false, "i", playerid);
	return true;
}

Vice:BalikTutmaSuresi(playerid)
{
	new sure;
	switch(Karakter[playerid][BalikYetenek][1])
	{
		case 0: sure = 20 * TIMER_SANIYE;
		case 1: sure = 19 * TIMER_SANIYE;
		case 2..4: sure = 18 * TIMER_SANIYE;
		case 5..7: sure = 17 * TIMER_SANIYE;
		case 8..10: sure = 16 * TIMER_SANIYE;
		default: sure = 15 * TIMER_SANIYE; 
	}
	return sure;
}

CMD:yemal(playerid, params[])
{
	if(!IsPlayerInRangeOfPoint(playerid, 3.0, 130.8684,-1945.5778,6.0826)) return Sunucu(playerid, "Yem alabilmek için balýkçý kulübesinde olmalýsýn.");
	new yemsayi;
	if(sscanf(params, "d", yemsayi)) return Kullanim(playerid, "/yemal [yem sayýsý] (Yem baþýna $5 kesilir.)");
	if(yemsayi < 1) return Sunucu(playerid, "Yem sayýsý 1 veya daha büyük olmalý.");
	if((Karakter[playerid][BalikYemi] + yemsayi) > 20) return Sunucu(playerid, "20 yemden fazlasýna sahip olamazsýn. Þu anda maksimum %d yem alabilirsin.", 20-Karakter[playerid][BalikYemi]);
	Karakter[playerid][BalikYemi] += yemsayi;
	ParaVer(playerid, -yemsayi*5);
	KarakterVeriKaydet(playerid);
	Sunucu(playerid, "%s karþýlýðýnda %d adet yem satýn aldýn.", NumaraFormati(yemsayi*5), yemsayi);
	return true;
}

CMD:baliksat(playerid, params[])
{
	if(!IsPlayerInRangeOfPoint(playerid, 3.0, 130.8684,-1945.5778,6.0826)) return Sunucu(playerid, "Balýk satabilmek için balýkçý kulübesinde olmalýsýn.");
	if(Karakter[playerid][Balik] < 1) return Sunucu(playerid, "Satacak balýðýnýz bulunmuyor.");
	if(Karakter[playerid][Balik] > MAX_OYUNCU_BALIK) Karakter[playerid][Balik] = MAX_OYUNCU_BALIK;
	new balikmiktar = Karakter[playerid][Balik];
	Karakter[playerid][Balik] = 0;
	ParaVer(playerid, balikmiktar*BALIK_SATIS);
	KarakterVeriKaydet(playerid);
	Sunucu(playerid, "%d adet balýðý %s karþýlýðýnda sattýn.", balikmiktar, NumaraFormati(balikmiktar*BALIK_SATIS));
	return true;
}

CMD:balikdurum(playerid, params[])
{
	SunucuEx(playerid, "Balýk Sayýsý: %d | Yem Sayýsý: %d | Balýk Seviyesi: %d | EXP: (%d/100)", Karakter[playerid][Balik], Karakter[playerid][BalikYemi], Karakter[playerid][BalikYetenek][1], Karakter[playerid][BalikYetenek][0]);
	return true;
}

// FONKSÝYONLAR

Vice:BalikTutuyorTimer(playerid)
{
	TogglePlayerControllable(playerid, true);
	ApplyAnimation(playerid, "CARRY", "crry_prtial", 2.0, 0, 0, 0, 0, 0);
	Karakter[playerid][BalikTutuyor] = false;
	new balikrand = randomEx(1, 11);
	if(balikrand < 6)
	{
		Sunucu(playerid, "Oltaya balýk takýlmadý.");
	}
	else
	{
		Sunucu(playerid, "Oltaya bir balýk takýldý!");
		Karakter[playerid][Balik]++;
		Karakter[playerid][BalikYetenek][0]++;
		if(Karakter[playerid][BalikYetenek][0] >= 100)
		{
			Karakter[playerid][BalikYetenek][1]++;
			Sunucu(playerid, "Balýkçýlýk seviyeniz yükseldi. Artýk %d seviye bir balýkçýsýnýz.", Karakter[playerid][BalikYetenek][1]);
		}
		KarakterVeriKaydet(playerid);
	}
}

Vice:BalikNoktaYakin(playerid)
{
	for(new i = 0; i < sizeof(BalikNoktasi); i++)
	{
		if(IsPlayerInRangeOfPoint(playerid, 2.0, BalikNoktasi[i][0], BalikNoktasi[i][1], BalikNoktasi[i][2]))
		{
			return 1;
		}
	}
	return 0;
}