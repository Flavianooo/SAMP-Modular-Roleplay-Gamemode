// Araç Pickup ve Yazýlarý
Vice:AracNoktalariYarat()
{
	CreateDynamicPickup(1239, 23, 951.8502,-1705.6200,13.6137); // sunshine
	CreateDynamic3DTextLabel("{99C794}[Sunshine Autos]{FFFFFF}\n{FFFFFF}[/aracal]", -1, 951.8502,-1705.6200,13.6137 + 0.8, 15, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1,-1);

	CreateDynamicPickup(1239, 23, 2335.8347 ,1657.3992, 3040.9275); // sunshine
	CreateDynamic3DTextLabel("{99C794}[Vice Sürücü Kursu]{FFFFFF}\n{FFFFFF}[/ehliyet]", -1, 2335.8347 ,1657.3992, 3040.9275 + 0.8, 15, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1,-1);
}

// YÖNETÝCÝ KOMUTLARI

CMD:aracver(playerid, params[])
{
	if(Hesap[playerid][Yonetici] < 7) return YetersizYetki(playerid);

	if(AracBosSlot() != -1)
	{
		new renkler[2], aracsahip, model[32];
		if(sscanf(params, "us[32]I(0)I(0)", aracsahip, model, renkler[0], renkler[1])) return Kullanim(playerid, "/aracver [araç sahibi] [model] [renk 1] [renk 2]");
		if(!IsPlayerConnected(aracsahip)) return Sunucu(playerid, "Girilen araç sahibi oyunda deðil.");
		if(!Karakter[aracsahip][Giris]) return Sunucu(playerid, "Girilen araç sahibi giriþ yapmamýþ.");
		if((model[0] = GetVehicleModelByName(model)) == 0) return Sunucu(playerid, "Geçersiz model girdin.");
		new Float:x, Float:y, Float:z, Float:a, index;
		GetPlayerPos(playerid, Float:x, Float:y, Float:z);
		GetPlayerFacingAngle(playerid, Float:a);
		index = FiyatIndexCek(model[0]);
		AracYarat(playerid, Karakter[aracsahip][id], model[0], renkler[0], renkler[1], x + 2, y, z, a, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
		if(index == -1) Sunucu(playerid, "Bu araç vergi ödemeyecek, galeride geçerli bir fiyatý bulunmuyor.");
		Sunucu(playerid, "%s adlý kiþiye %s model aracý verdin.", RPIsim(aracsahip), GetVehicleNameByModel(model[0]));
	}
	else Sunucu(playerid, "Sunucu araç sýnýrýna ulaþmýþ görünüyor. Araç veremezsin.");
	return true;
}

CMD:aracsil(playerid, params[])
{
	if(Hesap[playerid][Yonetici] < 7) return YetersizYetki(playerid);
	new aracid;
	if(sscanf(params, "d", aracid)) return Kullanim(playerid, "/aracsil [id]");
	if(!Araclar[aracid][Gecerli]) return Sunucu(playerid, "Geçersiz araç.");
	AracSil(aracid);
	Sunucu(playerid, "%d ID'li araç silindi.", aracid);
	return true;
}

CMD:aracduzenle(playerid, params[])
{
	if(Hesap[playerid][Yonetici] < 7) return YetersizYetki(playerid);
	new aracid, secenek[32], ekstra[64];
	if(sscanf(params, "ds[32]S()[64]", aracid, secenek, ekstra)) 
	{
		Kullanim(playerid, "/aracduzenle [id] [seçenek]");
		GenelMesajGonder(playerid, "renk1, renk2, vw, plaka, sahip, tur, kilit, vergi, benzin, kilometre");
		return true;
	}
	if(!Araclar[aracid][Gecerli]) return Sunucu(playerid, "Geçersiz araç.");
	if(!strcmp(secenek, "renk1", true))
	{
		new renk;
		if(sscanf(ekstra, "d", renk)) return Kullanim(playerid, "/aracduzenle [id] renk1 [renk kodu]");
		if(renk < 0 || renk > 255) return Sunucu(playerid, "Geçersiz renk kodu girdin.");
		Araclar[aracid][Renk][0] = renk;
		AracVeriKaydet(aracid);
		ChangeVehicleColor(aracid, Araclar[aracid][Renk][0], Araclar[aracid][Renk][1]);
		Sunucu(playerid, "%d ID'li aracýn birinci rengini %d olarak deðiþtirdin.", aracid, renk);
	}
	else if(!strcmp(secenek, "renk2", true))
	{
		new renk;
		if(sscanf(ekstra, "d", renk)) return Kullanim(playerid, "/aracduzenle [id] renk2 [renk kodu]");
		if(renk < 0 || renk > 255) return Sunucu(playerid, "Geçersiz renk kodu girdin.");
		Araclar[aracid][Renk][1] = renk;
		AracVeriKaydet(aracid);
		ChangeVehicleColor(aracid, Araclar[aracid][Renk][0], Araclar[aracid][Renk][1]);
		Sunucu(playerid, "%d ID'li aracýn ikinci rengini %d olarak deðiþtirdin.", aracid, renk);
	}
	else if(!strcmp(secenek, "vw", true))
	{
		new vw;
		if(sscanf(ekstra, "d", vw)) return Kullanim(playerid, "/aracduzenle [id] vw [yeni world deðeri]");
		Araclar[aracid][World] = vw;
		SetVehicleVirtualWorld(aracid, vw);
		AracVeriKaydet(aracid);
		Sunucu(playerid, "%d ID'li aracýn world deðerini %d olarak deðiþtirdin.", aracid, vw);
	}
	else if(!strcmp(secenek, "plaka", true))
	{
		new plaka[32];
		if(sscanf(ekstra, "s[32]", plaka)) return Kullanim(playerid, "/aracduzenle [id] plaka [yeni plaka]");
		format(Araclar[aracid][Plaka], 32, "%s", plaka);
		SetVehicleNumberPlate(aracid, plaka);
		AracVeriKaydet(aracid);
		AracSpawnla(aracid);
		Sunucu(playerid, "%d ID'li aracýn plakasýný %s olarak deðiþtirdin.", aracid, plaka);
	}
	else if(!strcmp(secenek, "tur", true))
	{
		new tur;
		if(sscanf(ekstra, "d", tur))
		{
			Kullanim(playerid, "/aracduzenle [id] tur [yeni tür]");
			GenelMesajGonder(playerid, "Türler: 1 - Ehliyet Aracý | 2 - Meslek Aracý");
			return true;
		}
		if(tur < 1 || tur > 2) return Sunucu(playerid, "Geçersiz tür girdiniz.");
		Araclar[aracid][AracTur] = tur;
		AracVeriKaydet(aracid);
		Sunucu(playerid, "%d ID'li aracýn türünü '%s' olarak deðiþtirdin.", aracid, AracTurIsim(aracid));
	}
	else if(!strcmp(secenek, "sahip", true))
	{
		new sahip;
		if(sscanf(ekstra, "d", sahip)) return Kullanim(playerid, "/aracduzenle [id] sahip [yeni sahip id]");
		if(!IsPlayerConnected(sahip)) return Sunucu(playerid, "Oyuncu baðlý deðil.");
		if(!Karakter[sahip][Giris]) return Sunucu(playerid, "Oyuncu giriþ yapmamýþ.");
		Araclar[aracid][Sahip] = Karakter[sahip][id];
		AracVeriKaydet(aracid);
		Sunucu(playerid, "%d ID'li aracýn sahibini %s olarak deðiþtirdin.", aracid, RPIsim(sahip));
	}
	else if(!strcmp(secenek, "kilit", true))
	{
		switch(Araclar[aracid][AracKilit])
		{
			case 0:
			{
				Sunucu(playerid, "%d ID'li aracý kilitledin.", aracid);
				AracKilitDegistir(playerid, aracid, 1);
			}
			case 1:
			{
				Sunucu(playerid, "%d ID'li aracýn kilidini açtýn.", aracid);
				AracKilitDegistir(playerid, aracid, 0);
			}
		}
	}
	else if(!strcmp(secenek, "vergi", true))
	{
		new vergi;
		if(sscanf(ekstra, "d", vergi)) return Kullanim(playerid, "/aracduzenle [id] vergi [yeni vergi]");
		if(vergi < 0) return Sunucu(playerid, "Vergi sýfýrdan küçük olamaz.");
		Araclar[aracid][Vergi] = vergi;
		Sunucu(playerid, "%d ID'li aracýn vergi miktarýný %s olarak deðiþtirdin.", aracid, NumaraFormati(vergi));
	}
	else if(!strcmp(secenek, "benzin", true))
	{
		new Float:benzin;
		if(sscanf(ekstra, "f", benzin)) return Kullanim(playerid, "/aracduzenle [id] benzin [yeni benzin deðeri]");
		if(benzin < 0 || benzin > 100) return Sunucu(playerid, "Benzin deðeri 1 ile 100 arasýnda olmalý.");
		Araclar[aracid][Benzin] = benzin;
		AracVeriKaydet(aracid);
		Sunucu(playerid, "%d ID'li aracýn benzinini %.2f olarak deðiþtirdin.", aracid, benzin);
	}
	else if(!strcmp(secenek, "kilometre", true))
	{
		new Float:km;
		if(sscanf(ekstra, "f", km)) return Kullanim(playerid, "/aracduzenle [id] kilometre [yeni kilometre]");
		if(km < 0) return Sunucu(playerid, "Kilometre deðeri 0 veya 0'dan büyük olmalý.");
		Araclar[aracid][Kilometre] = km;
		AracVeriKaydet(aracid);
		Sunucu(playerid, "%d ID'li aracýn kilometresini %.2f olarak deðiþtirdin.", aracid, km);
	}
	else Sunucu(playerid, "Geçersiz parametre girdin.");
	return true;
}

CMD:aracspawn(playerid, params[])
{
	if(Hesap[playerid][Yonetici] < 1) return YetersizYetki(playerid);
	new aracid;
	if(sscanf(params, "d", aracid)) return Kullanim(playerid, "/aracspawn [id]");
	if(!Araclar[aracid][Gecerli]) return Sunucu(playerid, "Geçersiz araç.");
	AracSpawnla(aracid);
	Sunucu(playerid, "%d ID'li aracý spawnladýn.", aracid);
	return true;
}
alias:aracspawn("aspawn");

CMD:acek(playerid, params[])
{	
	if(Hesap[playerid][Yonetici] < 1) return YetersizYetki(playerid);
	new aracid;
	if(sscanf(params, "d", aracid)) return Kullanim(playerid, "/acek [id]");
	if(!Araclar[aracid][Gecerli]) return Sunucu(playerid, "Geçersiz araç.");
	new Float:x, Float:y, Float:z;
	GetPlayerPos(playerid, Float:x, Float:y, Float:z);
	SetVehiclePos(aracid, Float:x + 1.5, Float:y, Float:z);
	Sunucu(playerid, "%d ID'li aracý kendine çektin.", aracid);
	return true;
}

// OYUNCU KOMUTLARI

CMD:park(playerid, params[])
{
	if(!IsPlayerInAnyVehicle(playerid)) return Sunucu(playerid, "Bir araçta deðilsin.");
	new aracid = GetPlayerVehicleID(playerid);
	if(!AracSahipKontrol(playerid, aracid)) return Sunucu(playerid, "Bulunduðun aracýn sahibi deðilsin.");
	if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return Sunucu(playerid, "Park iþlemi için aracýn sürücü koltuðunda olmalýsýn.");
	if(GetEngineStatus(aracid) != 0) return Sunucu(playerid, "Park iþlemi için araç motoru kapalý olmalý.");
	if(Karakter[playerid][Para] < 300) return Sunucu(playerid, "Park iþlemi için $300 ihtiyacýn var.");
	ParaVer(playerid, -300);
	GetVehiclePos(aracid, Araclar[aracid][AracPos][0], Araclar[aracid][AracPos][1], Araclar[aracid][AracPos][2]);
	GetVehicleZAngle(aracid, Araclar[aracid][AracPos][3]);
	AracVeriKaydet(aracid);
	new aracsql = Araclar[aracid][id];
	Araclar[aracid][Gecerli] = false;
	Araclar[aracid][id] = 0;
	Araclar[aracid][Sahip] = 0;
	DestroyVehicle(aracid);
	new yeniid = AracGetir(playerid, aracsql);
	PutPlayerInVehicle(playerid, yeniid, 0);
	Sunucu(playerid, "Aracýnýzýn park pozisyonu ayarlandý. Sonraki spawn iþlemlerinde araç burada spawn olacak.");
	return true;
}

CMD:araclarim(playerid, params[])
{
	new query[144];
	mysql_format(conn, query, sizeof(query), "SELECT * FROM araclar WHERE Sahip = %i", Karakter[playerid][id]);
	mysql_tquery(conn, query, "AracListele", "i", playerid);
	return true;
}

Vice:AracListele(playerid)
{
	new rows;
	cache_get_row_count(rows);
	if(rows)
	{
		new dialogstr[1024], aracid, model, plaka[32], Float:x, Float:y, Float:z;
		strcat(dialogstr, "Araç Modeli\tAraç Plakasý\tPark Lokasyonu\n");
		for(new i = 0; i < rows && i < MAX_OYUNCU_ARAC; i++)
		{
			new spawndurum = 0;
			cache_get_value_name_int(i, "id", Karakter[playerid][AracSpawnID][i]);
			for(new a = 0; a < MAX_VEHICLES; a++)
			{
				if(Araclar[a][id] == Karakter[playerid][AracSpawnID][i])
				{
					spawndurum = 1;
					aracid = a;
					break;
				}
			}
			cache_get_value_name_int(i, "Model", model);
			cache_get_value_name(i, "Plaka", plaka, 32);
			cache_get_value_name_float(i, "X", x);
			cache_get_value_name_float(i, "Y", y);
			cache_get_value_name_float(i, "Z", z);

			switch(spawndurum)
			{
				case 0: format(dialogstr, sizeof(dialogstr), "%s{99C794}%s{FFFFFF} - Spawn Edilmemiþ\t%s\t%s\n", dialogstr, GetVehicleNameByModel(model), plaka, LokasyonBul(x, y, z));
				default: format(dialogstr, sizeof(dialogstr), "%s{99C794}%s{FFFFFF} - ID: {3C5DA5}%d{FFFFFF}\t%s\t%s\n", dialogstr, GetVehicleNameByModel(model), aracid, plaka, LokasyonBul(x, y, z));
			}
		}
		Dialog_Show(playerid, DIALOG_ARACLARIM, DIALOG_STYLE_TABLIST_HEADERS, "{99C794}Üstünüze Kayýtlý Araçlar", dialogstr, "Spawnla", "Ýptal");
	}
	else Sunucu(playerid, "Üstünüze kayýtlý herhangi bir araç bulunamadý.");
	return true;
}

Dialog:DIALOG_ARACLARIM(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		new spawndurum = 0, aracid;
		for(new a = 0; a < MAX_VEHICLES; a++)
		{
			if(Araclar[a][id] == Karakter[playerid][AracSpawnID][listitem])
			{
				spawndurum = 1;
				aracid = a;
				break;
			}
		}
		if(spawndurum == 1)
		{
			new Float:x, Float:y, Float:z;
			GetVehiclePos(aracid, Float:x, Float:y, Float:z);
			SetPlayerCheckpoint(playerid, x, y, z, 5.0);
			Sunucu(playerid, "%s(%d) model aracýný iþaretledin.", AracModelCek(aracid), aracid);
		}
		else
		{
			AracGetir(playerid, Karakter[playerid][AracSpawnID][listitem]);
		}
	}
	return true;
}

Vice:AracGetir(playerid, aracsql)
{
	new query[144], Cache:VeriCek, rows;
	mysql_format(conn, query, sizeof(query), "SELECT * FROM araclar WHERE id = %i", aracsql);
	VeriCek = mysql_query(conn, query);
	cache_get_row_count(rows);
	if(rows)
	{
		new aracid = AracBosSlot();
		if(aracid == -1) return Sunucu(playerid, "Sunucudaki araç limitine ulaþýlmýþ. Lütfen daha sonra spawnlamayý deneyin.");
		
		// Araç Yükleme ve Oluþturma
		new model, Float:x, Float:y, Float:z, Float:a, renk1, renk2;
		cache_get_value_name_int(0, "Model", model);
		cache_get_value_name_float(0, "X", x);
		cache_get_value_name_float(0, "Y", y);
		cache_get_value_name_float(0, "Z", z);
		cache_get_value_name_float(0, "A", a);
		cache_get_value_name_int(0, "Renk1", renk1);
		cache_get_value_name_int(0, "Renk2", renk2);
		aracid = CreateVehicle(model, x, y, z, a, renk1, renk2, -1);
		Araclar[aracid][Gecerli] = true;
		Araclar[aracid][Model] = model;
		Araclar[aracid][AracPos][0] = x;
		Araclar[aracid][AracPos][1] = y;
		Araclar[aracid][AracPos][2] = z;
		Araclar[aracid][AracPos][3] = a;
		Araclar[aracid][Renk][0] = renk1;
		Araclar[aracid][Renk][1] = renk2;
		// Araç Verileri Çekme
		cache_get_value_name_int(0, "id", Araclar[aracid][id]);
		cache_get_value_name_int(0, "Sahip", Araclar[aracid][Sahip]);
		cache_get_value_name_int(0, "Tur", Araclar[aracid][AracTur]);
		cache_get_value_name_int(0, "World", Araclar[aracid][World]);
		cache_get_value_name_int(0, "Interior", Araclar[aracid][Interior]);
		cache_get_value_name(0, "Plaka", Araclar[aracid][Plaka], 32);

		cache_get_value_name_int(0, "Vergi", Araclar[aracid][Vergi]);

		cache_get_value_name_float(0, "Benzin", Araclar[aracid][Benzin]);
		cache_get_value_name_float(0, "Kilometre", Araclar[aracid][Kilometre]);
		
		cache_get_value_name_int(0, "AracKilit", Araclar[aracid][AracKilit]);
		cache_delete(VeriCek);
		mysql_format(conn, query, sizeof(query), "SELECT * FROM silahlar WHERE SilahArac = %i", Araclar[aracid][id]);
		mysql_tquery(conn, query, "AracSilahYukle", "i", aracid);
		AracSpawnla(aracid);
		Sunucu(playerid, "%s model araç park yerine spawnlandý.", AracModelCek(aracid));
		return aracid;
	}
	else
	{ 
		Sunucu(playerid, "Araç spawnlanýrken bir hata oluþtu. Lütfen yetkililere bildirin.");
		cache_delete(VeriCek);
	}
	return true;
}

CMD:aracal(playerid, params[])
{
	if(!IsPlayerInRangeOfPoint(playerid, 4.0, 951.8502, -1705.6200, 13.6137)) return Sunucu(playerid, "Sunshine Autos araç galerisinde deðilsin.");
	new dialogstr[2048];
	for(new i; i < sizeof(SatilikAraclar); i++)
	{
		format(dialogstr, sizeof(dialogstr), "%s%d\n%s\n", dialogstr, SatilikAraclar[i][0], GetVehicleNameByModel(SatilikAraclar[i][0]));
	}
	ShowPlayerDialog(playerid, 23301, DIALOG_STYLE_PREVMODEL, "Satilik Araclar", dialogstr, "Sec", "Iptal");
	return true;
}

Dialog:DIALOG_ARAC_SATINAL(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		new aracfiyat = GetPVarInt(playerid, "AracFiyat");
		if(Karakter[playerid][Para] < aracfiyat) return Sunucu(playerid, "Bu aracý satýn almak için yeterli miktarda paran yok.");
		new renkler[256];
		strcat(renkler, "{FFFFFF}Siyah\n{F3F3F3}Beyaz\n{28719C}Mavi\n{830506}Kýrmýzý\n{854368}Pembe\n{D28C08}Sarý\n{00800F}Yeþil\nRenk Kodu Gir");
		Dialog_Show(playerid, DIALOG_ARAC_SATINAL_RENK, DIALOG_STYLE_LIST, "{99C794}Araç Rengi Seç", renkler, "Onayla", "Ýptal");
	}
	else
	{
		DeletePVar(playerid, "AracModel");
		DeletePVar(playerid, "AracFiyat");
	}
	return true;
}

Dialog:DIALOG_ARAC_SATINAL_RENK(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		if(AracBosSlot() == -1) return Sunucu(playerid, "Satýþlar þu anda kapalý. Daha sonra tekrar uðra!");
		new aracmodel = GetPVarInt(playerid, "AracModel"), aracfiyat = GetPVarInt(playerid, "AracFiyat");
		if(Karakter[playerid][Para] < aracfiyat) return Sunucu(playerid, "Bu aracý satýn almak için yeterli miktarda paran yok.");
		new aracrenk = -1;
		switch(listitem)
		{
			case 0: aracrenk = 0;
			case 1: aracrenk = 1;
			case 2: aracrenk = 2;
			case 3: aracrenk = 3;
			case 4: aracrenk = 5;
			case 5: aracrenk = 6;
			case 6: aracrenk = 229;
			default: return Dialog_Show(playerid, DIALOG_ARAC_RENK_GIR, DIALOG_STYLE_INPUT, "{99C794}Araç Renk Kodu Gir", "Aracýnýza geçerli bir renk kodu girin.(0-255 arasýnda)\nEðer kodu kaldýrmak istiyorsanýz -1 girin.", "Onayla", "Ýptal");
		}
		if(GetPVarInt(playerid, "AracRenk") > 0) aracrenk = GetPVarInt(playerid, "aracrenk") - 1;
		if(aracrenk == -1)
		{
			new renkler[360];
			strcat(renkler, "{FFFFFF}Siyah\n{F3F3F3}Beyaz\n{28719C}Mavi\n{830506}Kýrmýzý\n{854368}Pembe\n{D28C08}Sarý\n{00800F}Yeþil\nRenk Kodu Gir");
			Dialog_Show(playerid, DIALOG_ARAC_SATINAL_RENK, DIALOG_STYLE_LIST, "{99C794}Araç Rengi Seç", renkler, "Onayla", "Ýptal");
			return true;
		}
		AracYarat(playerid, Karakter[playerid][id], aracmodel, aracrenk, aracrenk, 951.2847, -1745.4594, 13.5469, 88.0971, 0, 0);
		ParaVer(playerid, -aracfiyat);
		DeletePVar(playerid, "AracRenk");
		DeletePVar(playerid, "AracModel");
		DeletePVar(playerid, "AracFiyat");
		Sunucu(playerid, "%s model aracý %s karþýlýðýnda satýn aldýn. Aracýn galeri çýkýþýnda seni bekliyor.", GetVehicleNameByModel(aracmodel), NumaraFormati(aracfiyat));
		Log_Kaydet("loglar/arac_satin_alim.txt", "[%s] %s adli kisi %s model araci %s karsiliginda satin aldi.", TarihCek(), RPIsim(playerid), GetVehicleNameByModel(aracmodel), NumaraFormati(aracfiyat));
	}
	else
	{
		DeletePVar(playerid, "AracRenk");
		DeletePVar(playerid, "AracModel");
		DeletePVar(playerid, "AracFiyat");
	}
	return true;
}

Dialog:DIALOG_ARAC_RENK_GIR(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		if(strval(inputtext) < -1 || strval(inputtext) > 255) return Dialog_Show(playerid, DIALOG_ARAC_RENK_GIR, DIALOG_STYLE_INPUT, "{99C794}Araç Renk Kodu Gir", "Aracýnýza geçerli bir renk kodu girin.(0-255 arasýnda)", "Onayla", "Ýptal");
		SetPVarInt(playerid, "AracRenk", strval(inputtext) + 1);
		new renkler[360];
		if(strval(inputtext) == -1)
		{
			format(renkler, sizeof(renkler), "{FFFFFF}Siyah\n{F3F3F3}Beyaz\n{28719C}Mavi\n{830506}Kýrmýzý\n{854368}Pembe\n{D28C08}Sarý\n{00800F}Yeþil\nRenk Kodu Gir");
		}
		else
		{
			format(renkler, sizeof(renkler), "{FFFFFF}Siyah\n{F3F3F3}Beyaz\n{28719C}Mavi\n{830506}Kýrmýzý\n{854368}Pembe\n{D28C08}Sarý\n{00800F}Yeþil\nRenk Kodu Girildi: %d(Geçerli Renk)", strval(inputtext));			
		}
		Dialog_Show(playerid, DIALOG_ARAC_SATINAL_RENK, DIALOG_STYLE_LIST, "{99C794}Araç Rengi Seç", renkler, "Onayla", "Ýptal");
	}
	else
	{
		DeletePVar(playerid, "AracRenk");
	}
	return true;
}

CMD:arac(playerid, params[])
{
	new secenek[32], ekstra[64];
	if(sscanf(params, "s[32]S()[64]", secenek, ekstra)) 
	{
		Kullanim(playerid, "/arac [secenek]");
		GenelMesajGonder(playerid, "motor(Y), far(N), kilit, anahtarver, anahtarsifirla, vergiode");
		return true;
	}
	if(!strcmp(secenek, "motor", true))
	{
		if(!IsPlayerInAnyVehicle(playerid)) return Sunucu(playerid, "Bir araçta deðilsin.");
		if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return Sunucu(playerid, "Sürücü koltuðunda deðilsin.");
		if(GetPVarInt(playerid, "MotorCalistiriyor") == 1) return Sunucu(playerid, "Zaten þu anda motoru çalýþtýrýyorsun.");
		if(GetPVarInt(playerid, "BenzinAliyor") == 1) return Sunucu(playerid, "Benzin doldururken motoru çalýþtýramazsýn.");
		new aracid = GetPlayerVehicleID(playerid);
		switch(GetEngineStatus(aracid))
		{
			case 0:
			{
				if(Araclar[aracid][AracTur] != 1)
				{
					if(!AracSahipKontrol(playerid, aracid) && !AracAnahtarKontrol(playerid, aracid)) return Sunucu(playerid, "Aracýn veya anahtarýnýn sahibi deðilsin. Motoru çalýþtýramazsýn.");
				}
				else
				{
					if(Karakter[playerid][EhliyetTesti] == 0) return Sunucu(playerid, "Ehliyet testinde deðilsin. Bu aracý çalýþtýramazsýn.");
				}
				SetPVarInt(playerid, "MotorCalistiriyor", 1);
				cmd(playerid, 1, "aracýn anahtarýný çevirerek motoru çalýþtýrmayý dener.");
				SetTimerEx("AracMotoru", 2 * 742, false, "ii", playerid, aracid);
			}
			case 1:
			{
				if(Araclar[aracid][AracTur] != 1)
				{
					if(!AracSahipKontrol(playerid, aracid) && !AracAnahtarKontrol(playerid, aracid)) return Sunucu(playerid, "Aracýn veya anahtarýnýn sahibi deðilsin. Motoru çalýþtýramazsýn.");
				}
				else
				{
					if(Karakter[playerid][EhliyetTesti] == 0) return Sunucu(playerid, "Ehliyet testinde deðilsin. Bu aracýn motorunu kapatamazsýn.");
				}
				cmd(playerid, 1, "aracýn anahtarýný çevirerek motoru kapatýr.");
				SwitchEngine(aracid, false);
			}
		}
	}
	else if(!strcmp(secenek, "sistemesat", true))
	{
		if(!IsPlayerInRangeOfPoint(playerid, 5.0, 549.1940,-1286.0798,17.2482)) return Sunucu(playerid, "Araç satým noktasýnda deðilsin.");
		if(!IsPlayerInAnyVehicle(playerid)) return Sunucu(playerid, "Bir araçta deðilsin.");
		if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return Sunucu(playerid, "Sürücü koltuðunda deðilsin.");
		new aracid = GetPlayerVehicleID(playerid);
		if(!AracSahipKontrol(playerid, aracid)) return Sunucu(playerid, "Bu aracýn sahibi deðilsin.");
		if(Araclar[aracid][Vergi] > 0) return Sunucu(playerid, "Vergisi ödenmemiþ aracý satamazsýnýz.");
		new fiyat = AracFiyatCek(aracid), satis;
		switch(Hesap[playerid][EkonomiPaketi])
		{
			case 0: satis = YuzdeHesapla(fiyat, 50);
			default: satis = YuzdeHesapla(fiyat, 60);
		}
		Dialog_Show(playerid, DIALOG_ARAC_SISTEMESAT, DIALOG_STYLE_MSGBOX, "{99C794}Aracý Sisteme Sat", "%s model aracý %s karþýlýðýnda satmak istediðinize emin misiniz?", "Onayla", "Ýptal", AracModelCek(aracid), NumaraFormati(satis));
	}
	else if(!strcmp(secenek, "kilit", true))
	{
		if(!AracYakin(playerid)) return Sunucu(playerid, "Bir araca yakýn deðilsin.");
		new aracid = AracYakin(playerid);
		if(!AracSahipKontrol(playerid, aracid) && !AracAnahtarKontrol(playerid, aracid)) return Sunucu(playerid, "Yakýnýndaki aracýn veya anahtarýnýn sahibi deðilsin.");
		switch(Araclar[aracid][AracKilit])
		{
			case 0:
			{
				cmd(playerid, 1, "yanýndaki aracý kilitler.");
				AracKilitDegistir(playerid, aracid, 1);
			}
			case 1:
			{
				cmd(playerid, 1, "yanýndaki aracýn kilidini açar.");
				AracKilitDegistir(playerid, aracid, 0);
			}
		}
	}
	else if(!strcmp(secenek, "far", true))
	{
		if(!IsPlayerInAnyVehicle(playerid)) return Sunucu(playerid, "Bir araçta deðilsin.");
		if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return Sunucu(playerid, "Sürücü koltuðunda deðilsin.");
		new aracid = GetPlayerVehicleID(playerid);
		if(GetEngineStatus(aracid) == 0) return Sunucu(playerid, "Araç motoru kapalýyken farlarý kontrol edemezsin.");
		switch(GetLightStatus(aracid))
		{
			case false: SetLightStatus(aracid, true);
			case true: SetLightStatus(aracid, false);
		}
	}
	else if(!strcmp(secenek, "anahtarver", true))
	{
		if(!IsPlayerInAnyVehicle(playerid)) return Sunucu(playerid, "Bir araçta deðilsin.");
		if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return Sunucu(playerid, "Sürücü koltuðunda deðilsin.");
		new aracid = GetPlayerVehicleID(playerid);
		if(!AracSahipKontrol(playerid, aracid)) return Sunucu(playerid, "Bu aracýn sahibi deðilsin.");
		new oyuncu;
		if(sscanf(ekstra, "u", oyuncu)) return Kullanim(playerid, "/arac anahtarver [id/isim]");
		if(playerid == oyuncu) return Sunucu(playerid, "Kendine anahtar veremezsin.");
		if(!IsPlayerConnected(oyuncu)) return Sunucu(playerid, "Oyuncu bulunamadý.");
		if(!Karakter[oyuncu][Giris]) return Sunucu(playerid, "Oyuncu henüz giriþ yapmamýþ.");
		if(!OyuncuYakin(playerid, oyuncu, 5.0)) return Sunucu(playerid, "Kiþiye yakýn deðilsin.");
		if(Karakter[oyuncu][AracAnahtar] > 0) return Sunucu(playerid, "Bu kiþi bir araç anahtarýna sahip. Öncelikle anahtarlarýný sýfýrlamalý.");
		Karakter[oyuncu][AracAnahtar] = Araclar[aracid][id];
		Sunucu(playerid, "%s adlý kiþiye %s(%d) model aracýnýn anahtarýný verdin.", RPIsim(oyuncu), AracModelCek(aracid), aracid);
		Sunucu(oyuncu, "%s adlý kiþiden %s(%d) model aracýn anahtarlarýný aldýn.", RPIsim(playerid), AracModelCek(aracid), aracid);
	}
	else if(!strcmp(secenek, "anahtarsifirla", true))
	{
		if(!IsPlayerInAnyVehicle(playerid)) return Sunucu(playerid, "Bir araçta deðilsin.");
		new aracid = GetPlayerVehicleID(playerid);
		if(!AracSahipKontrol(playerid, aracid)) return Sunucu(playerid, "Bu aracýn sahibi deðilsin.");
		foreach(new i : Player)
		{
			if(Karakter[i][AracAnahtar] == Araclar[aracid][id])
			{
				Karakter[i][AracAnahtar] = 0;
			}
		}
		new query[144];
		mysql_format(conn, query, sizeof(query), "UPDATE oyuncular SET AracAnahtar = 0 WHERE AracAnahtar = %i", Araclar[aracid][id]);
		mysql_tquery(conn, query);
		Sunucu(playerid, "Aracýn anahtarýna sahip olan kiþilerden anahtar silindi.");
	}
	else if(!strcmp(secenek, "anahtarsil", true))
	{
		if(Karakter[playerid][AracAnahtar] == 0) return Sunucu(playerid, "Bir aracýn anahtarýna sahip deðilsin.");
		Karakter[playerid][AracAnahtar] = 0;
		Sunucu(playerid, "Sahip olduðun araç anahtarýný sildin.");
	}
	else if(!strcmp(secenek, "vergiode", true))
	{
		if(!IsPlayerInAnyVehicle(playerid)) return Sunucu(playerid, "Bir araçta deðilsin.");
		if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return Sunucu(playerid, "Vergi ödeyebilmek için sürücü koltuðunda olmalýsýn.");
		new aracid = GetPlayerVehicleID(playerid);
		if(!AracSahipKontrol(playerid, aracid)) return Sunucu(playerid, "Bu aracýn sahibi deðilsin.");
		if(Araclar[aracid][Vergi] < 1) return Sunucu(playerid, "Bu aracýn ödenecek vergisi bulunmuyor.");
		Dialog_Show(playerid, DIALOG_ARAC_VERGIODE, DIALOG_STYLE_MSGBOX, "{99C794}Araç Vergisini Öde", "{FFFFFF}Aracýnýzýn {3C5DA5}%s{FFFFFF} vergisi birikmiþ.\n{FFFFFF}Þimdi ödemek istediðinize emin misiniz?", "Onayla", "Ýptal", NumaraFormati(Araclar[aracid][Vergi]));
	}
	else Sunucu(playerid, "Geçersiz parametre girdin.");
	return true;
}

CMD:ehliyet(playerid, params[])
{
	if(Karakter[playerid][Ehliyet] > 0) return Sunucu(playerid, "Zaten ehliyet sahibisiniz.");
	if(!IsPlayerInRangeOfPoint(playerid, 10.0, 2335.8347 ,1657.3992, 3040.9275)) return Sunucu(playerid, "Ehliyet alma noktasýnda deðilsin.");
	if(Karakter[playerid][Para] < 75) return Sunucu(playerid, "Ehliyet testine katýlmak için $75'a ihtiyacýn var.");
	ParaVer(playerid, -75);
	Karakter[playerid][EhliyetTesti] = 1;
	Sunucu(playerid, "Dýþarýdaki ehliyet araçlarýndan birine binerek teste baþlayabilirsin.");
	return true;
}

Dialog:DIALOG_ARAC_SISTEMESAT(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		if(!IsPlayerInRangeOfPoint(playerid, 5.0, 549.1940,-1286.0798,17.2482)) return Sunucu(playerid, "Araç satým noktasýnda deðilsin.");
		if(!IsPlayerInAnyVehicle(playerid)) return Sunucu(playerid, "Bir araçta deðilsin.");
		if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return Sunucu(playerid, "Sürücü koltuðunda deðilsin.");
		new aracid = GetPlayerVehicleID(playerid);
		if(!AracSahipKontrol(playerid, aracid)) return Sunucu(playerid, "Bu aracýn sahibi deðilsin.");
		if(Araclar[aracid][Vergi] > 0) return Sunucu(playerid, "Vergisi ödenmemiþ aracý satamazsýnýz.");
		new fiyat = AracFiyatCek(aracid), satis;
		switch(Hesap[playerid][EkonomiPaketi])
		{
			case 0: satis = YuzdeHesapla(fiyat, 50);
			default: satis = YuzdeHesapla(fiyat, 60);
		}
		Sunucu(playerid, "%s model aracýnýzý %s karþýlýðýnda sisteme sattýnýz.", AracModelCek(aracid), NumaraFormati(satis));
		Log_Kaydet("loglar/arac_sisteme_satis.txt", "[%s] %s adli kisi %s(%d) model araci %s karsiliginda sisteme satti.", TarihCek(), RPIsim(playerid), AracModelCek(aracid), Araclar[aracid][id], NumaraFormati(satis));
		AracSil(aracid);
		ParaVer(playerid, satis);
	}
	return true;
}

Dialog:DIALOG_ARAC_VERGIODE(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		if(!IsPlayerInAnyVehicle(playerid)) return Sunucu(playerid, "Bir araçta deðilsin.");
		if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return Sunucu(playerid, "Vergi ödeyebilmek için sürücü koltuðunda olmalýsýn.");
		new aracid = GetPlayerVehicleID(playerid);
		if(!AracSahipKontrol(playerid, aracid)) return Sunucu(playerid, "Bu aracýn sahibi deðilsin.");
		if(Araclar[aracid][Vergi] < 1) return Sunucu(playerid, "Bu aracýn ödenecek vergisi bulunmuyor.");
		new vergi = Araclar[aracid][Vergi];
		if(Karakter[playerid][Para] < vergi || vergi < 0) return Sunucu(playerid, "Bu aracýn vergisini ödemeye yetecek paranýz bulunmuyor.");
		ParaVer(playerid, -vergi);
		Araclar[aracid][Vergi] = 0;
		Sunucu(playerid, "Aracýn %s kadarlýk vergisini ödedin.", NumaraFormati(vergi));
		Log_Kaydet("loglar/arac_vergi_odeme.txt", "[%s] %s adli kisi %s(%d) model aracin %s vergisini odedi.", TarihCek(), RPIsim(playerid), AracModelCek(aracid), Araclar[aracid][id], NumaraFormati(vergi));
	}
	return true;
}

Vice:AracKilitDegistir(playerid, aracid, islem)
{
	switch(islem)
	{
		case 1:
		{
			Araclar[aracid][AracKilit] = 1;
			SwitchDoors(aracid, true);
		}
		case 0:
		{
			Araclar[aracid][AracKilit] = 0;
			SwitchDoors(aracid, false);
		}
	}
	return true;
}

Vice:AracMotoru(playerid, aracid)
{
	DeletePVar(playerid, "MotorCalistiriyor");
	new domessage[96];
	format(domessage, sizeof(domessage), "%s model aracýn motoru çalýþtý.", AracModelCek(aracid));
	cmd(playerid, 2, domessage);
	SwitchEngine(aracid, true);
	return true;
}

public OnVehicleSpawn(vehicleid)
{
	SetVehicleParamsEx(vehicleid, false, false, false, Araclar[vehicleid][AracKilit], false, false, false);
	SetVehicleNumberPlate(vehicleid, Araclar[vehicleid][Plaka]);
	SetVehicleVirtualWorld(vehicleid, Araclar[vehicleid][World]);
	ChangeVehicleColor(vehicleid, Araclar[vehicleid][Renk][0], Araclar[vehicleid][Renk][1]);
	SetVehicleHealth(vehicleid, 1000.0);
	return true;
}

public OnVehicleDeath(vehicleid, killerid)
{

	return true;
}

Vice:AraclariYukle()
{
	new rows, rowcount = 0;
	cache_get_row_count(rows);
	if(rows)
	{
		new query[144];
		for(new i = 0; i < rows; i++)
		{
			new aracid = AracBosSlot();
			if(aracid == -1) return false;
			
			// Araç Yükleme ve Oluþturma
			new model, Float:x, Float:y, Float:z, Float:a, renk1, renk2;
			cache_get_value_name_int(i, "Model", model);
			cache_get_value_name_float(i, "X", x);
			cache_get_value_name_float(i, "Y", y);
			cache_get_value_name_float(i, "Z", z);
			cache_get_value_name_float(i, "A", a);
			cache_get_value_name_int(i, "Renk1", renk1);
			cache_get_value_name_int(i, "Renk2", renk2);
			aracid = CreateVehicle(model, x, y, z, a, renk1, renk2, -1);
			Araclar[aracid][Gecerli] = true;
			Araclar[aracid][Model] = model;
			Araclar[aracid][AracPos][0] = x;
			Araclar[aracid][AracPos][1] = y;
			Araclar[aracid][AracPos][2] = z;
			Araclar[aracid][AracPos][3] = a;
			Araclar[aracid][Renk][0] = renk1;
			Araclar[aracid][Renk][1] = renk2;
			
			// Araç Verileri Çekme
			cache_get_value_name_int(i, "id", Araclar[aracid][id]);
			cache_get_value_name_int(i, "Sahip", Araclar[aracid][Sahip]);
			cache_get_value_name_int(i, "Tur", Araclar[aracid][AracTur]);
			cache_get_value_name_int(i, "World", Araclar[aracid][World]);
			cache_get_value_name_int(i, "Interior", Araclar[aracid][Interior]);
			cache_get_value_name(i, "Plaka", Araclar[aracid][Plaka], 32);

			cache_get_value_name_int(i, "Vergi", Araclar[aracid][Vergi]);

			cache_get_value_name_float(i, "Benzin", Araclar[aracid][Benzin]);
			cache_get_value_name_float(i, "Kilometre", Araclar[aracid][Kilometre]);
			
			cache_get_value_name_int(i, "AracKilit", Araclar[aracid][AracKilit]);

			mysql_format(conn, query, sizeof(query), "SELECT * FROM silahlar WHERE SilahArac = %i", Araclar[aracid][id]);
			mysql_tquery(conn, query, "AracSilahYukle", "i", aracid);
			rowcount++;
			AracSpawnla(aracid);
		}
	}
	printf("[MySQL] Veritabanýndan '%i' adet araç yüklendi.", rowcount);
	return true;
}

Vice:AracSilahYukle(aracid)
{
	new rows;
	cache_get_row_count(rows);
	if(rows)
	{
		new silahmodel, silahmermi, silahseri;
		for(new i = 0; i < rows && i < MAX_OYUNCU_SILAH; i++)
		{
			cache_get_value_name_int(i, "SilahModel", silahmodel);
			cache_get_value_name_int(i, "SilahMermi", silahmermi);
			cache_get_value_name_int(i, "SilahSeri", silahseri);
			Araclar[aracid][AracSilah][i] = silahmodel;
			Araclar[aracid][AracSilahMermi][i] = silahmermi;
			Araclar[aracid][AracSilahSeri][i] = silahseri;
		}
	}
}

Vice:AracVeriKaydet(aracid)
{
	new query[1400];
	mysql_format(conn, query, sizeof(query), "UPDATE araclar SET Model = %i, Sahip = %i, Renk1 = %i, Renk2 = %i, X = %.4f, Y = %.4f, Z = %.4f, A = %.4f, Plaka = '%e' WHERE id = %i",
		Araclar[aracid][Model],
		Araclar[aracid][Sahip],
		Araclar[aracid][Renk][0],
		Araclar[aracid][Renk][1],
		Araclar[aracid][AracPos][0],
		Araclar[aracid][AracPos][1],
		Araclar[aracid][AracPos][2],
		Araclar[aracid][AracPos][3],
		Araclar[aracid][Plaka],
	Araclar[aracid][id]);
	mysql_tquery(conn, query);
	mysql_format(conn, query, sizeof(query), "UPDATE araclar SET World = %i, Interior = %i, Tur = %i, AracKilit = %i, Vergi = %i, Benzin = %.2f WHERE id = %i",
		Araclar[aracid][World],
		Araclar[aracid][Interior],
		Araclar[aracid][AracTur],
		Araclar[aracid][AracKilit],
		Araclar[aracid][Vergi],
		Araclar[aracid][Benzin],
	Araclar[aracid][id]);
	mysql_tquery(conn, query);
	return true;
}

Vice:AracYarat(veren, sahip, model, renk1, renk2, Float:x, Float:y, Float:z, Float:a, world, interior)
{
	if(AracBosSlot() != -1)
	{
		new aracid;
		aracid = CreateVehicle(model, x, y, z, a, renk1, renk2, -1);
		Araclar[aracid][Gecerli] = true;
		Araclar[aracid][Model] = model;
		Araclar[aracid][Sahip] = sahip;
		Araclar[aracid][Renk][0] = renk1;
		Araclar[aracid][Renk][1] = renk2;
		Araclar[aracid][AracPos][0] = x;
		Araclar[aracid][AracPos][1] = y;
		Araclar[aracid][AracPos][2] = z;
		Araclar[aracid][AracPos][3] = a;
		Araclar[aracid][AracTur] = 0;
		Araclar[aracid][AracKilit] = 0;

		Araclar[aracid][Vergi] = 0;

		Araclar[aracid][Benzin] = 100.0;

		Araclar[aracid][World] = world;
		Araclar[aracid][Interior] = interior;

		new query[256];
		mysql_format(conn, query, sizeof(query), "INSERT INTO araclar (Sahip, Model, Renk1, Renk2, X, Y, Z, A, World, Interior, Tur, Benzin) VALUES(%i, %i, %i, %i, %.4f, %.4f, %.4f, %.4f, %i, %i, %i, %.2f)", 
		Araclar[aracid][Sahip],
		Araclar[aracid][Model],
		Araclar[aracid][Renk][0],
		Araclar[aracid][Renk][1],
		Araclar[aracid][AracPos][0],
		Araclar[aracid][AracPos][1],
		Araclar[aracid][AracPos][2],
		Araclar[aracid][AracPos][3],
		Araclar[aracid][World],
		Araclar[aracid][Interior],
		Araclar[aracid][AracTur],
		Araclar[aracid][Benzin]);
		mysql_tquery(conn, query, "AracYaratildi", "i", aracid);
	}
	else 
	{
		Sunucu(veren, "Sunucu araç limitine ulaþmýþ görünüyor.");
	}
	return true;
}

Vice:AracSil(aracid)
{
	if(aracid == -1 || !Araclar[aracid][Gecerli]) return false;
	new query[144];
	mysql_format(conn, query, sizeof(query), "DELETE FROM araclar WHERE id = %i", Araclar[aracid][id]);
	mysql_tquery(conn, query);
	mysql_format(conn, query, sizeof(query), "DELETE FROM silahlar WHERE SilahArac = %i", Araclar[aracid][id]);
	mysql_tquery(conn, query);
	Araclar[aracid][Gecerli] = false;
	Araclar[aracid][id] = 0;
	Araclar[aracid][Sahip] = 0;
	DestroyVehicle(aracid);

	return true;
}

Vice:AracYaratildi(aracid)
{
	if(aracid == -1 || !Araclar[aracid][Gecerli]) return 0;
	Araclar[aracid][id] = cache_insert_id();
	static iharfler[][] ={"A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"};
	if(Araclar[aracid][id] < 100) {
		format(Araclar[aracid][Plaka], 12, "%s%s%d %s00%d", iharfler[random(sizeof(iharfler))], iharfler[random(sizeof(iharfler))], randomEx(1, 10), iharfler[random(sizeof(iharfler))], Araclar[aracid][id]);
	}
	else if(Araclar[aracid][id] < 1000) {
		format(Araclar[aracid][Plaka], 12, "%s%s%d %s0%d", iharfler[random(sizeof(iharfler))], iharfler[random(sizeof(iharfler))], randomEx(1, 10), iharfler[random(sizeof(iharfler))], Araclar[aracid][id]);
	}
	else if(Araclar[aracid][id] > 1000) {
		format(Araclar[aracid][Plaka], 12, "%s%s%d %s%d", iharfler[random(sizeof(iharfler))], iharfler[random(sizeof(iharfler))], randomEx(1, 10), iharfler[random(sizeof(iharfler))], Araclar[aracid][id]);
	}
	AracVeriKaydet(aracid);
	AracSpawnla(aracid);
	return true;
}

Vice:AracSpawnla(aracid)
{
	SetVehicleToRespawn(aracid);
	return true;
}

Vice:AracBosSlot()
{
	for(new i = 1; i < MAX_VEHICLES; i++)
	{
		if(Araclar[i][Gecerli]) continue;
		return i;
	}
	return -1;
}

Vice:FiyatIndexCek(model)
{
	new mid = -1;
	for(new i = 0; i < sizeof(SatilikAraclar); i++)
	{
		if(SatilikAraclar[i][0] == model)
		{
			mid = i;
			break;
		}
	}
	return mid;
}

stock GetVehicleModelByName(const name[])
{
	if(IsNumeric(name) && (strval(name) >= 400 && strval(name) <= 611))
		return strval(name);

	for (new i = 0; i < sizeof(aracIsimler); i++)
	{
		if(strfind(aracIsimler[i], name, true) != -1)
		{
			return i + 400;
		}
	}
	return 0;
}

stock GetVehicleNameByModel(model)
{
	new aracismi[64];
	format(aracismi, 64, "Bilinmiyor");
	for(new i = 0; i < sizeof(aracIsimler); i++)
	{
		if((i + 400) == model)
		{
			format(aracismi, sizeof(aracismi), "%s", aracIsimler[i]);  
			return aracismi;
		}
	}
	return aracismi;
}

stock AracModelCek(aracid)
{
	new model, modelisim[32];
	format(modelisim, sizeof(modelisim), "Bilinmiyor");
	model = GetVehicleModel(aracid);
	format(modelisim, 32, "%s", GetVehicleNameByModel(model));
	return modelisim;
}

stock GetEngineStatus(vehicleid)
{
	static aengine, alights, aalarm, adoors, abonnet, aboot, aobjective;

	GetVehicleParamsEx(vehicleid, aengine, alights, aalarm, adoors, abonnet, aboot, aobjective);

	if(aengine != 1)
		return 0;

	return 1;
}

stock GetLightStatus(vehicleid)
{
	static aengine, alights, aalarm, adoors, abonnet, aboot, aobjective;

	GetVehicleParamsEx(vehicleid, aengine, alights, aalarm, adoors, abonnet, aboot, aobjective);

	if(alights != 1)
		return 0;

	return 1;
}

stock SetLightStatus(vehicleid, status)
{
	static aengine, alights, aalarm, adoors, abonnet, aboot, aobjective;

	GetVehicleParamsEx(vehicleid, aengine, alights, aalarm, adoors, abonnet, aboot, aobjective);
	return SetVehicleParamsEx(vehicleid, aengine, status, aalarm, adoors, abonnet, aboot, aobjective);
}

Vice:AracSahipKontrol(playerid, aracid)
{
	if(Araclar[aracid][Gecerli] && Karakter[playerid][id] == Araclar[aracid][Sahip]) return 1;
	return 0;
}

Vice:AracAnahtarKontrol(playerid, aracid)
{
	if(Araclar[aracid][Gecerli] && Karakter[playerid][AracAnahtar] == Araclar[aracid][id]) return 1;
	return 0;
}

Vice:AracYakin(playerid)
{
	new Float:x, Float:y, Float:z;
	for(new i = 0; i < MAX_VEHICLES; i++)
	{
		GetVehiclePos(i, Float:x, Float:y, Float:z);
		if(IsPlayerInRangeOfPoint(playerid, 4.0, Float:x, Float:y, Float:z))
		{
			return i;
		}
	}
	return 0;
}

stock AracTurIsim(aracid)
{
	new isim[32];
	switch(Araclar[aracid][AracTur])
	{
		case 1: isim = "Ehliyet Aracý";
		case 2: isim = "Meslek Aracý";
		default: isim = "Yok";
	}
	return isim;
}

Vice:AracFiyatCek(aracid)
{
	new fiyat = 0;
	for(new i; i < sizeof(SatilikAraclar); i++)
	{
		if(Araclar[aracid][Model] == SatilikAraclar[i][0]) fiyat = SatilikAraclar[i][1];
	}
	return fiyat;
}

stock AracSahipIsim(aracid)
{
	new isimcek[40], isim[64], query[144], Cache:VeriCek;
	mysql_format(conn, query, sizeof(query), "SELECT * FROM karakterler WHERE id = %i", Araclar[aracid][Sahip]);
	VeriCek = mysql_query(conn, query);
	cache_get_value_name(0, "isim", isimcek);
	cache_delete(VeriCek);
	for(new i = 0; i < strlen(isimcek); i++)
	{
		if(isimcek[i] == '_') isimcek[i] = ' ';
	}
	format(isim, sizeof(isim), "%s", isimcek);
	return isim;
}

Vice:AracVergiHesapla(aracid)
{
	new vergi;
	new aracfiyat = AracFiyatCek(aracid);
	if(aracfiyat > 0)
	{
		vergi = YuzdeHesapla(aracfiyat, 0.05);
	}
	else vergi = 0;
	return vergi;
}