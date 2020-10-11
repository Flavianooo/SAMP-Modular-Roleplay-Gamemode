CMD:ahelp(playerid, params[])
{
	if(!Karakter[playerid][Giris]) return GirisYapmadi(playerid);
	if(!Hesap[playerid][Yonetici]) return YetersizYetki(playerid);

	if(Hesap[playerid][Yonetici] > 0)
	{
		GenelMesajGonder(playerid, "--------------------[A1]--------------------");
		GenelMesajGonder(playerid, "{FFFFFF}/a, /aduty, /git, /cek, /dondur, /coz, /sethp, /setarmor, /setskin");
		GenelMesajGonder(playerid, "{FFFFFF}/getinterior, /getvw, /tp, /yakindakiler");
	}
	if(Hesap[playerid][Yonetici] > 1)
	{
		GenelMesajGonder(playerid, "--------------------[A2]--------------------");
		GenelMesajGonder(playerid, "{FFFFFF}/raporlar, /raporcevap, /checkstats, /setint, /setvw, /gotopos");
	}
	if(Hesap[playerid][Yonetici] > 2)
	{
		GenelMesajGonder(playerid, "--------------------[A3]--------------------");
		GenelMesajGonder(playerid, "{FFFFFF}/banat");
	}
	if(Hesap[playerid][Yonetici] > 3)
	{
		GenelMesajGonder(playerid, "--------------------[A4]--------------------");
		GenelMesajGonder(playerid, "{FFFFFF}YOK");
	}
	if(Hesap[playerid][Yonetici] > 4)
	{
		GenelMesajGonder(playerid, "--------------------[A5]--------------------");
		GenelMesajGonder(playerid, "{FFFFFF}YOK");
	}
	if(Hesap[playerid][Yonetici] > 5)
	{
		GenelMesajGonder(playerid, "--------------------[A6]--------------------");
		GenelMesajGonder(playerid, "{FFFFFF}/oyuncuduzenle, /aparaver, /yakindakiler");
	}
	if(Hesap[playerid][Yonetici] > 6)
	{
		GenelMesajGonder(playerid, "--------------------[A7]--------------------");
		GenelMesajGonder(playerid, "{FFFFFF}/aracver, /aracduzenle, /aparaver, /setname");
	}
	if(Hesap[playerid][Yonetici] > 8)
	{
		GenelMesajGonder(playerid, "--------------------[A8+]--------------------");
		GenelMesajGonder(playerid, "{FFFFFF}/jetpack, /oyuncuduzenle, /herkesiat");
	}
	return true;
}
alias:ahelp("ah");

CMD:izle(playerid, params[])
{
	if(Hesap[playerid][Yonetici] < 1) return YetersizYetki(playerid);
	new oyuncu;
	if(sscanf(params, "u", oyuncu)) return Kullanim(playerid, "/izle [id/isim]");
	if(!IsPlayerConnected(oyuncu) || !Karakter[oyuncu][Giris]) return Sunucu(playerid, "Ge�ersiz oyuncu/oyuncu giri� yapmam��.");
	if(oyuncu == playerid) return Sunucu(playerid, "Kendini izleyemezsin.");
	if(GetPlayerState(oyuncu) == PLAYER_STATE_SPECTATING) return Sunucu(playerid, "Bu oyuncu izlenebilir durumda de�il.(O da izleme modunda)");
	if(GetPlayerState(playerid) != PLAYER_STATE_SPECTATING)
	{
		GetPlayerPos(playerid, Karakter[playerid][SpecPos][0], Karakter[playerid][SpecPos][1], Karakter[playerid][SpecPos][2]);
		GetPlayerFacingAngle(playerid, Karakter[playerid][SpecPos][3]);
		Karakter[playerid][SpecInterior] = GetPlayerInterior(playerid);
		Karakter[playerid][SpecWorld] = GetPlayerVirtualWorld(playerid);
	}
	TogglePlayerSpectating(playerid, true);
	if(IsPlayerInAnyVehicle(oyuncu)) PlayerSpectateVehicle(playerid, GetPlayerVehicleID(oyuncu));
	else PlayerSpectatePlayer(playerid, oyuncu);
	SetPlayerInterior(playerid, GetPlayerInterior(oyuncu));
	SetPlayerVirtualWorld(playerid, GetPlayerVirtualWorld(oyuncu));
	Sunucu(playerid, "%s adl� ki�iyi izlemeye ba�lad�n�z.", RPIsim(oyuncu));
	return true;
}
alias:izle("spec");

CMD:izlebitir(playerid, params[])
{
	if(Hesap[playerid][Yonetici] < 1) return YetersizYetki(playerid);
	PlayerSpectatePlayer(playerid, INVALID_PLAYER_ID);
	PlayerSpectateVehicle(playerid, INVALID_VEHICLE_ID);
	SetSpawnInfo(playerid, NO_TEAM, Karakter[playerid][Skin], Karakter[playerid][SpecPos][0], Karakter[playerid][SpecPos][1], Karakter[playerid][SpecPos][2], Karakter[playerid][SpecPos][3], 0, 0, 0, 0, 0, 0);
	TogglePlayerSpectating(playerid, false);
	TogglePlayerSpectating(playerid, false);
	SpawnPlayer(playerid);
	SetPlayerInterior(playerid, Karakter[playerid][SpecInterior]);
	SetPlayerVirtualWorld(playerid, Karakter[playerid][SpecWorld]);
	SetTimerEx("OyuncuCoz", 4000, false, "i", playerid);

	return true;
}
alias:izlebitir("specoff");

CMD:yakindakiler(playerid, params[])
{
	if(Hesap[playerid][Yonetici] < 1) return YetersizYetki(playerid);
	if(EvYakin(playerid) != -1)
	{
		Sunucu(playerid, "Yak�ndaki ev: %d", EvYakin(playerid));
	}
	if(BinaYakin(playerid) != -1)
	{
		Sunucu(playerid, "Yak�ndaki bina: %d", BinaYakin(playerid));
	}
	if(IsyeriYakin(playerid) != -1)
	{
		Sunucu(playerid, "Yak�ndaki i�yeri: %d", IsyeriYakin(playerid));
	}
	return true;
}

CMD:anick(playerid, params[])
{
	if(Hesap[playerid][Yonetici] < 9) return YetersizYetki(playerid);
	new hedef, nick[32];
	if(sscanf(params, "us[32]", hedef, nick)) return Kullanim(playerid, "/anick [id/isim] [nick]");
	if(!IsPlayerConnected(hedef)) return Sunucu(playerid, "Ge�ersiz ki�i.");
	if(!Karakter[hedef][Giris]) return Sunucu(playerid, "Ki�i giri� yapmam��.");
	if(isnull(nick) || strlen(nick) > 32) return Sunucu(playerid, "Nick bo� b�rak�lamaz, 32 karakterden fazla olamaz.");
	format(Hesap[hedef][YoneticiIsim], 32, "%s", nick);
	HesapVeriKaydet(hedef);
	Sunucu(playerid, "%s adl� ki�inin admin ismini '%s' olarak ayarlad�n.", RPIsim(hedef), nick);
	Sunucu(hedef, "%s(%s), admin ismini '%s' olarak de�i�tirdi.", RPIsim(playerid), Hesap[playerid][YoneticiIsim], nick);
	Log_Kaydet("loglar/y_anick_loglari.txt", "[%s] %s(%s) adli yetkili %s adli kisinin yonetici ismini %s olarak degistirdi.", TarihCek(), RPIsim(playerid), Hesap[playerid][YoneticiIsim], RPIsim(hedef), nick);
	return true;
}

CMD:jetpack(playerid, params[])
{
	if(Hesap[playerid][Yonetici] < 9) return YetersizYetki(playerid);
	
	SetPlayerSpecialAction(playerid, SPECIAL_ACTION_USEJETPACK);
	Sunucu(playerid, "Jetpack ald�n�z.");
	return true;
}

CMD:goto(playerid, params[])
{
	if(Hesap[playerid][Yonetici] < 1) return YetersizYetki(playerid);

	new hedefid, Float:Pos[3], vw, interior;
	if(sscanf(params, "u", hedefid)) return Kullanim(playerid, "/goto [id/isim]");
	if(!IsPlayerConnected(hedefid)) return Sunucu(playerid, "Bu ki�i giri� yapmam��.");
	if(!Karakter[hedefid][Giris]) return Sunucu(playerid, "Bu ki�i giri� yapmam��.");
	if(hedefid == playerid) return Sunucu(playerid, "Kendinize ���nlanamazs�n�z.");
 
	vw = GetPlayerVirtualWorld(hedefid);
	interior = GetPlayerInterior(hedefid);
	GetPlayerPos(hedefid, Pos[0], Pos[1], Pos[2]);

	SetPlayerPos(playerid, Pos[0]+1, Pos[1]+1, Pos[2]);
	SetPlayerInterior(playerid, interior);
	SetPlayerVirtualWorld(playerid, vw);

	Sunucu(hedefid, "Bir y�netici yan�n�za ���nland�.");
	Sunucu(playerid, "Bir oyuncunun yan�na ���nland�n�z.");
	return true;
}
alias:goto("git");

CMD:gethere(playerid, params[])
{
	if(Hesap[playerid][Yonetici] < 1) return YetersizYetki(playerid);

	new hedefid, Float:Pos[3], vw, interior;
	if(sscanf(params, "u", hedefid)) return Kullanim(playerid, "/gethere [id/isim]");
	if(!IsPlayerConnected(hedefid)) return Sunucu(playerid, "Bu ki�i giri� yapmam��.");
	if(!Karakter[hedefid][Giris]) return Sunucu(playerid, "Bu ki�i giri� yapmam��.");
	if(hedefid == playerid) return Sunucu(playerid, "Kendinizi �ekemezsiniz.");

	vw = GetPlayerVirtualWorld(playerid);
	interior = GetPlayerInterior(playerid);
	GetPlayerPos(playerid, Pos[0], Pos[1], Pos[2]);

	SetPlayerPos(hedefid, Pos[0]+1, Pos[1]+1, Pos[2]);
	SetPlayerInterior(hedefid, interior);
	SetPlayerVirtualWorld(hedefid, vw);

	Sunucu(hedefid, "Bir y�netici sizi kendi yan�na ���nlad�.");
	Sunucu(playerid, "Bir oyuncuyu yan�n�za �ektiniz.");
	return true;
}
alias:gethere("cek");

CMD:sethp(playerid, params[])
{
	if(Hesap[playerid][Yonetici] < 1) return YetersizYetki(playerid);

	new hedefid, Float:can;
	if(sscanf(params, "uf", hedefid, can)) return Kullanim(playerid, "/sethp [id/isim] [can]");
	if(!IsPlayerConnected(hedefid)) return Sunucu(playerid, "Bu ki�i giri� yapmam��.");
	if(!Karakter[hedefid][Giris]) return Sunucu(playerid, "Bu ki�i giri� yapmam��.");

	Karakter[hedefid][Can] = can;
	SetPlayerHealth(hedefid, can);

	Sunucu(playerid, "%s(%d) isimli oyuncunun can de�erini de�i�tirdiniz.", RPIsim(hedefid), hedefid);
	Sunucu(hedefid, "%s adl� yetkili can de�erinizi de�i�tirdi.", Hesap[playerid][YoneticiIsim]);
	return true;
}

CMD:zirhduzenle(playerid, params[])
{
	if(Hesap[playerid][Yonetici] < 1) return YetersizYetki(playerid);

	new hedefid, Float:zirh;
	if(sscanf(params, "uf", hedefid, zirh)) return Kullanim(playerid, "/zirhduzenle [id/isim] [z�rh]");
	if(!IsPlayerConnected(hedefid)) return Sunucu(playerid, "Bu ki�i giri� yapmam��.");
	if(!Karakter[hedefid][Giris]) return Sunucu(playerid, "Bu ki�i giri� yapmam��.");

	Karakter[hedefid][Zirh] = zirh;
	SetPlayerArmour(hedefid, zirh);

	Sunucu(playerid, "%s(%d) isimli oyuncunun z�rh de�erini de�i�tirdiniz.", RPIsim(hedefid), hedefid);
	Sunucu(hedefid, "%s adl� yetkili z�rh de�erinizi de�i�tirdi.", Hesap[playerid][YoneticiIsim]);
	return true;
}
alias:zirhduzenle("setarmor");

CMD:setskin(playerid, params[])
{
	if(Hesap[playerid][Yonetici] < 1) return YetersizYetki(playerid);

	new hedefid, skin;
	if(sscanf(params, "ud", hedefid, skin)) return Kullanim(playerid, "/setskin [id/isim] [model id]");
	if(!IsPlayerConnected(hedefid)) return Sunucu(playerid, "Bu ki�i giri� yapmam��.");
	if(!Karakter[hedefid][Giris]) return Sunucu(playerid, "Bu ki�i giri� yapmam��.");

	Karakter[hedefid][Skin] = skin;
	SetPlayerSkin(hedefid, Karakter[hedefid][Skin]);

	Sunucu(playerid, "%s(%d) isimli oyuncunun skinini %d olarak de�i�tirdiniz.", RPIsim(hedefid), hedefid, skin);
	Sunucu(hedefid, "%s isimli y�netici skininizi %d olarak de�i�tirdi.", Hesap[playerid][YoneticiIsim], skin);
	return true;
}

CMD:aduty(playerid, params[])
{
	if(Hesap[playerid][Yonetici] < 1) return YetersizYetki(playerid);

	switch(Hesap[playerid][Awork])
	{
		case false:
		{
			Hesap[playerid][Awork] = true;
			Sunucu(playerid, "Awork a�t�n�z.");
		}
		case true:
		{
			Hesap[playerid][Awork] = false;
			Sunucu(playerid, "Awork kapatt�n�z.");
		}
	}
	return true;
}
alias:aduty("awork");

CMD:dondur(playerid, params[])
{
	if(!Hesap[playerid][Yonetici]) return YetersizYetki(playerid);

	new hedefid;
	if(sscanf(params, "u", hedefid)) return Kullanim(playerid, "/dondur [id/isim]");
	if(!IsPlayerConnected(hedefid)) return Sunucu(playerid, "Bu ki�i giri� yapmam��.");
	if(!Karakter[hedefid][Giris]) return Sunucu(playerid, "Bu ki�i giri� yapmam��.");

	TogglePlayerControllable(hedefid, false);
	Sunucu(hedefid, "%s isimli y�netici sizi dondurdu.", RPIsim(playerid));
	Sunucu(playerid, "%s(%d) isimli oyuncuyu dondurdunuz.", RPIsim(hedefid), hedefid);
	return true;
}
alias:dondur("freeze");

CMD:coz(playerid, params[])
{
	if(!Hesap[playerid][Yonetici]) return YetersizYetki(playerid);

	new hedefid;
	if(sscanf(params, "u", hedefid)) return Kullanim(playerid, "/coz [id/isim]");
	if(!IsPlayerConnected(hedefid)) return Sunucu(playerid, "Bu ki�i giri� yapmam��.");
	if(!Karakter[hedefid][Giris]) return Sunucu(playerid, "Bu ki�i giri� yapmam��.");

	TogglePlayerControllable(hedefid, true);
	Sunucu(hedefid, "%s isimli y�netici sizi ��zd�.", RPIsim(playerid));
	Sunucu(playerid, "%s(%d) isimli oyuncuyu ��zd�n�z.", RPIsim(hedefid), hedefid);
	return true;
}
alias:coz("unfreeze");

CMD:kick(playerid, params[])
{
	if(Hesap[playerid][Yonetici] < 1) return YetersizYetki(playerid);

	new hedefid, sebep[124];
	if(sscanf(params, "us[124]", hedefid, sebep)) return Kullanim(playerid, "/kick [id/isim] [sebep]");
	if(!IsPlayerConnected(hedefid)) return Sunucu(playerid, "Bu ki�i giri� yapmam��.");
	if(!Karakter[hedefid][Giris]) return Sunucu(playerid, "Bu ki�i giri� yapmam��.");
	if(strlen(sebep) < 0 || strlen(sebep) > 124) return Sunucu(playerid, "Minimum 0-124 karakter aras� bir metin girmelisiniz.");

	HerkeseGonder(RENK_VICE, "[!]{C8C8C8} %s, %s adl� yetkili taraf�ndan sunucudan at�ld�. Sebep: %s", RPIsim(hedefid), Hesap[playerid][YoneticiIsim], sebep);
	KickEx(hedefid);
	return true;
}

CMD:banat(playerid, params[])
{
	if(Hesap[playerid][Yonetici] < 3) return YetersizYetki(playerid);

	new hedefid, sebep[124], tarih[124], ay, yil, gun, saat, dakika, saniye;
	if(sscanf(params, "us[124]", hedefid, sebep)) return Kullanim(playerid, "/banat [id/isim] [sebep]");
	if(!IsPlayerConnected(hedefid)) return Sunucu(playerid, "Bu ki�i giri� yapmam��.");
	if(!Karakter[hedefid][Giris]) return Sunucu(playerid, "Bu ki�i giri� yapmam��.");
	if(strlen(sebep) < 0 || strlen(sebep) > 124) return Sunucu(playerid, "Minimum 0-124 karakter aras� bir metin girmelisiniz.");

	getdate(yil, ay, gun);
	gettime(saat,dakika,saniye);
	format(tarih, sizeof(tarih), "%d/%d/%d - %d:%d:%d", ay, yil, gun, saat, dakika, saniye);
	Karakter[hedefid][Yasakli] = 1;
	KarakterVeriKaydet(hedefid);
	HerkeseGonder(RENK_VICE, "[!]{C8C8C8} %s, %s adl� yetkili taraf�ndan sunucudan yasakland�. Sebep: %s", RPIsim(hedefid), Hesap[playerid][YoneticiIsim], sebep);
	KickEx(hedefid);
	return true;
}

CMD:herkesiat(playerid, params[])
{
	if(Hesap[playerid][Yonetici] < 9) return YetersizYetki(playerid);

	foreach(new i:Player)
	{
		if(IsPlayerConnected(i))
		{
			KarakterVeriKaydet(i);
			HesapVeriKaydet(i);
			HerkeseGonder(RENK_ADMIN, "[!]{FFFFFF} %s isimli y�netici t�m oyuncular� sunucudan att�.", Hesap[playerid][YoneticiIsim]);
			KickEx(i);
		}
	}
	return true;
}

CMD:aisimdegistir(playerid, params[])
{
	if(Hesap[playerid][Yonetici] < 7) return YetersizYetki(playerid);

	new hedefid, isim[124];
	if(sscanf(params, "us[124]", hedefid, isim)) return Kullanim(playerid, "/aisimdegistir [id/isim] [yeni_isim]");
	if(!IsPlayerConnected(hedefid)) return Sunucu(playerid, "Bu ki�i giri� yapmam��.");
	if(!Karakter[hedefid][Giris]) return Sunucu(playerid, "Bu ki�i giri� yapmam��.");

	format(Karakter[hedefid][Isim], 124, "%s", isim);
	SetPlayerName(hedefid, Karakter[hedefid][Isim]);
	KarakterVeriKaydet(hedefid);

	Sunucu(playerid, "%s(%d) isimli oyuncunun ismini de�i�tirdiniz. �sim: %s", RPIsim(hedefid), hedefid, isim);
	Sunucu(hedefid, "%s adl� yetkili taraf�ndan isminiz %s olarak de�i�tirildi.", Hesap[playerid][YoneticiIsim], isim);
	Log_Kaydet("loglar/y_aisimdegistir_loglari.txt", "[%s] %s adli yetkili %s adli kisinin ismini %s olarak degistirdi.", TarihCek(), RPIsim(playerid), RPIsim(hedefid), isim);
	return true;
}
alias:aisimdegistir("setname");

CMD:getint(playerid, params[])
{
	if(Hesap[playerid][Yonetici] < 1) return YetersizYetki(playerid);

	new hedef;
	if(sscanf(params, "u", hedef)) return Kullanim(playerid, "/getint [id/isim]");
	if(!IsPlayerConnected(hedef)) return Sunucu(playerid, "Oyuncu ba�l� de�il.");
	Sunucu(playerid, "Oyuncunun interior de�eri: %d", GetPlayerInterior(hedef));
	return true;
}

CMD:getvw(playerid, params[])
{
	if(Hesap[playerid][Yonetici] < 1) return YetersizYetki(playerid);
	new hedef;
	if(sscanf(params, "u", hedef)) return Kullanim(playerid, "/getvw [id/isim]");
	if(!IsPlayerConnected(hedef)) return Sunucu(playerid, "Oyuncu ba�l� de�il.");
	Sunucu(playerid, "Oyuncunun interior de�eri: %d", GetPlayerVirtualWorld(hedef));
	return true;
}

CMD:kontrol(playerid, params[])
{
	if(Hesap[playerid][Yonetici] < 1) return YetersizYetki(playerid);
	new hedefid;
	if(sscanf(params, "u", hedefid)) return Kullanim(playerid, "/kontrol [id/isim]");
	if(!IsPlayerConnected(hedefid)) return Sunucu(playerid, "Bu ki�i giri� yapmam��.");
	if(!Karakter[hedefid][Giris]) return Sunucu(playerid, "Bu ki�i giri� yapmam��.");

	KarakterGoster(hedefid, playerid);
	return true;
}
alias:kontrol("bilgiler","check");

CMD:setint(playerid, params[])
{
	if(!Hesap[playerid][Yonetici]) return YetersizYetki(playerid);
	new hedefid, int;
	if(sscanf(params, "ud", hedefid, int)) return Kullanim(playerid, "/setint [id/isim] [int]");
	if(!IsPlayerConnected(hedefid)) return Sunucu(playerid, "Bu ki�i giri� yapmam��.");
	if(!Karakter[hedefid][Giris]) return Sunucu(playerid, "Bu ki�i giri� yapmam��.");

	Karakter[hedefid][Interior] = int;
	SetPlayerInterior(hedefid, Karakter[hedefid][Interior]);
	Sunucu(playerid, "%s(%d) isimli oyuncunun interiorunu de�i�tirdiniz. Int: %d", RPIsim(hedefid), hedefid, int);
	return true;
}

CMD:setvw(playerid, params[])
{
	if(!Hesap[playerid][Yonetici]) return YetersizYetki(playerid);

	new hedefid, vw;
	if(sscanf(params, "ud", hedefid, vw)) return Kullanim(playerid, "/setvw [id/isim] [vw]");
	if(!IsPlayerConnected(hedefid)) return Sunucu(playerid, "Bu ki�i giri� yapmam��.");
	if(!Karakter[hedefid][Giris]) return Sunucu(playerid, "Bu ki�i giri� yapmam��.");
	if(vw < 0) return Sunucu(playerid, "Hatal� world.");
	Karakter[hedefid][VW] = vw;
	SetPlayerVirtualWorld(hedefid, Karakter[hedefid][VW]);
	Sunucu(playerid, "%s(%d) isimli oyuncunun world de�erini de�i�tirdiniz. VW: %d", RPIsim(hedefid), hedefid, vw);
	return true;
}

CMD:oyuncuduzenle(playerid, params[])
{
	if(Hesap[playerid][Yonetici] < 9) return YetersizYetki(playerid);

	new hedefid, secenek[64], ekstra[128];
	if(sscanf(params, "us[64]S()[128]", hedefid, secenek, ekstra))
	{
		Kullanim(playerid, "/oyuncuduzenle [id/isim] [se�enek] [yeni de�er]");
		GenelMesajGonder(playerid, "yas, cinsiyet, ten, koken, saat");
	}
	else
	{
		if(!IsPlayerConnected(hedefid)) return Sunucu(playerid, "Bu ki�i giri� yapmam��.");
		if(!Karakter[hedefid][Giris]) return Sunucu(playerid, "Bu ki�i giri� yapmam��.");

		if(!strcmp(secenek, "yas", true))
		{
			new yeniyas;
			if(sscanf(ekstra, "d", yeniyas)) return Sunucu(playerid, "/oyuncuduzenle [id/isim] [yas] [18-75]");
			if(yeniyas < 18 || yeniyas > 75) return Sunucu(playerid, "Ge�ersiz ya� de�eri girdiniz.");

			Karakter[hedefid][Yas] = yeniyas;

			AdminGonder(RENK_ADMIN, "[YETK�L�] %s isimli y�netici %s(%d) isimli oyuncunun ya��n� g�ncelledi.", RPIsim(playerid), RPIsim(hedefid), hedefid);
			Sunucu(hedefid, "%s isimli y�netici ya��n�z� g�ncelledi.", RPIsim(playerid));
		}
		else if(!strcmp(secenek, "cinsiyet", true))
		{
			new cinsiyet;
			if(sscanf(ekstra, "d", cinsiyet)) return Sunucu(playerid, "/oyuncuduzenle [id/isim] [cinsiyet] [yeni de�er]");
			if(cinsiyet < 0 || cinsiyet > 3) return Sunucu(playerid, "Ge�ersiz cinsiyet girdiniz.");

			switch(cinsiyet)
			{
				case 0: Karakter[hedefid][Cinsiyet] = cinsiyet;
				case 1: Karakter[hedefid][Cinsiyet] = cinsiyet;
				case 2: Karakter[hedefid][Cinsiyet] = cinsiyet;
				case 3: Karakter[hedefid][Cinsiyet] = cinsiyet;
			}

			AdminGonder(RENK_ADMIN, "[YETK�L�] %s isimli y�netici %s(%d) isimli oyuncunun cinsiyetini de�i�tirdi.", RPIsim(playerid), RPIsim(hedefid), hedefid);
			Sunucu(hedefid, "%s isimli y�netici cinsiyetinizi g�ncelledi.", RPIsim(playerid));
		}
		else if(!strcmp(secenek, "ten", true))
		{
			new ten;
			if(sscanf(ekstra, "d", ten)) return Sunucu(playerid, "/oyuncuduzenle [id/isim] [ten] [yeni de�er]");
			if(ten < 0 || ten > 3) return Sunucu(playerid, "Ge�ersiz ten rengi girdiniz.");

			switch(ten)
			{
				case 0: Karakter[hedefid][Ten] = ten;
				case 1: Karakter[hedefid][Ten] = ten;
				case 2: Karakter[hedefid][Ten] = ten;
				case 3: Karakter[hedefid][Ten] = ten;
			}

			AdminGonder(RENK_ADMIN, "[YETK�L�] %s isimli y�netici %s(%d) isimli oyuncunun ten rengini de�i�tirdi.", RPIsim(playerid), RPIsim(hedefid), hedefid);
			Sunucu(hedefid, "%s isimli y�netici ten renginizi g�ncelledi.", RPIsim(playerid));
		}
		else if(!strcmp(secenek, "koken", true))
		{
			new koken;
			if(sscanf(ekstra, "d", koken)) return Sunucu(playerid, "/oyuncuduzenle [id/isim] [koken] [yeni de�er]");
			if(koken < 0 || koken > 6) return Sunucu(playerid, "Ge�ersiz k�ken girdiniz.");

			switch(koken)
			{
				case 0: Karakter[hedefid][Koken] = koken;
				case 1: Karakter[hedefid][Koken] = koken;
				case 2: Karakter[hedefid][Koken] = koken;
				case 3: Karakter[hedefid][Koken] = koken;
				case 4: Karakter[hedefid][Koken] = koken;
				case 5: Karakter[hedefid][Koken] = koken;
				case 6: Karakter[hedefid][Koken] = koken;
			}

			AdminGonder(RENK_ADMIN, "[YETK�L�] %s isimli y�netici %s(%d) isimli oyuncunun k�kenini de�i�tirdi.", RPIsim(playerid), RPIsim(hedefid), hedefid);
			Sunucu(hedefid, "%s isimli y�netici k�keninizi g�ncelledi.", RPIsim(playerid));
		}
		else if(!strcmp(secenek, "saat", true))
		{
			new saat;
			if(sscanf(ekstra, "d", saat)) return Sunucu(playerid, "/oyuncuduzenle [id/isim] [saat] [yeni saat]");
			if(saat < 0) return Sunucu(playerid, "Ge�ersiz ya� de�eri girdiniz.");

			Karakter[hedefid][Saat] = saat;
			SetPlayerScore(hedefid, Karakter[hedefid][Saat]);

			AdminGonder(RENK_ADMIN, "[YETK�L�] %s isimli y�netici %s(%d) isimli ki�inin oynama saatini de�i�tirdi.", RPIsim(playerid), RPIsim(hedefid), hedefid);
			Sunucu(hedefid, "%s isimli y�netici oynama saatinizi de�i�tirdi.", RPIsim(playerid));
		}
	}
	return true;
}

CMD:aparaver(playerid, params[])
{
	if(Hesap[playerid][Yonetici] < 7) return YetersizYetki(playerid);

	new hedefid, miktar;
	if(sscanf(params, "ud", hedefid, miktar)) return Kullanim(playerid, "/aparaver [id/isim] [miktar]");
	if(!IsPlayerConnected(hedefid)) return Sunucu(playerid, "Bu ki�i giri� yapmam��.");
	if(!Karakter[hedefid][Giris]) return Sunucu(playerid, "Bu ki�i giri� yapmam��.");

	ParaVer(hedefid, miktar);
	KarakterVeriKaydet(hedefid);

	AdminGonder(RENK_ADMIN, "[YETK�L�] %s isimli y�netici %s(%d) isimli ki�iye $%d miktar para verdi.", RPIsim(playerid), RPIsim(hedefid), hedefid, miktar);
	Log_Kaydet("loglar/y_aparaver_loglari.txt", "[%s] %s adli yetkili %s adli kisiye %s verdi.", TarihCek(), RPIsim(playerid), RPIsim(hedefid), NumaraFormati(miktar));
	Sunucu(hedefid, "%s adl� y�netici size admin komutu ile %s para verdi.", RPIsim(playerid), NumaraFormati(miktar));
	return true;
}

CMD:posgit(playerid, params[])
{
	if(Hesap[playerid][Yonetici] < 1) return YetersizYetki(playerid);

	new Float:x, Float:y, Float:z, interior;
	if(sscanf(params, "p<,>fffd", x, y, z, interior)) return Kullanim(playerid, "/posgit [x] [y] [z] [int]");

	SetPlayerPos(playerid, x, y, z);
	Sunucu(playerid, "Girdi�in konuma ���nland�n.");
	return true;
}

CMD:tp(playerid, params[])
{
	if(Hesap[playerid][Yonetici] < 1) return YetersizYetki(playerid);
	new secenek[32], ekstra[40];
	if(sscanf(params, "s[32]S()[40]", secenek, ekstra)) 
	{
		Kullanim(playerid, "/tp [se�enek]");
		GenelMesajGonder(playerid, "arac, ev, isyeri, bina");
		return true;
	}
	if(!strcmp(secenek, "arac", true))
	{
		new aracid;
		if(sscanf(ekstra, "d", aracid)) return Kullanim(playerid, "/tp arac [id]");
		if(!Araclar[aracid][Gecerli]) return Sunucu(playerid, "Ge�ersiz ara�.");
		new Float:x, Float:y, Float:z;
		GetVehiclePos(aracid, Float:x, Float:y, Float:z);
		SetPlayerPos(playerid, x, y, z + 2.0);
		SetPlayerInterior(playerid, Araclar[aracid][Interior]);
		SetPlayerVirtualWorld(playerid, Araclar[aracid][World]);
		Sunucu(playerid, "%d ID'li araca ���nland�n.", aracid);
	}
	else if(!strcmp(secenek, "ev", true))
	{
		new evid;
		if(sscanf(ekstra, "d", evid)) return Kullanim(playerid, "/tp ev [id]");
		if(!Evler[evid][Gecerli]) return Sunucu(playerid, "Ge�ersiz ev.");
		SetPlayerPos(playerid, Evler[evid][Ext][0], Evler[evid][Ext][1], Evler[evid][Ext][2]);
		SetPlayerVirtualWorld(playerid, Evler[evid][World]);
		SetPlayerInterior(playerid, Evler[evid][Interior]);
		Sunucu(playerid, "%d ID'li eve ���nland�n.", evid);
	}
	else if(!strcmp(secenek, "isyeri", true))
	{
		new isyeriid;
		if(sscanf(ekstra, "d", isyeriid)) return Kullanim(playerid, "/tp isyeri [id]");
		if(!Isyeri[isyeriid][Gecerli]) return Sunucu(playerid, "Ge�ersiz i�yeri.");
		SetPlayerPos(playerid, Isyeri[isyeriid][Ext][0], Isyeri[isyeriid][Ext][1], Isyeri[isyeriid][Ext][2]);
		SetPlayerVirtualWorld(playerid, Isyeri[isyeriid][World]);
		SetPlayerInterior(playerid, Isyeri[isyeriid][Interior]);
		Sunucu(playerid, "%d ID'li i�yerine ���nland�n.", isyeriid);
	}
	else if(!strcmp(secenek, "bina", true))
	{
		new binaid;
		if(sscanf(ekstra, "d", binaid)) return Kullanim(playerid, "/tp bina [id]");
		if(!Binalar[binaid][Gecerli]) return Sunucu(playerid, "Ge�ersiz bina.");
		SetPlayerPos(playerid, Binalar[binaid][Ext][0], Binalar[binaid][Ext][1], Binalar[binaid][Ext][2]);
		SetPlayerVirtualWorld(playerid, Binalar[binaid][World]);
		SetPlayerInterior(playerid, Binalar[binaid][Interior]);
	}
	else Sunucu(playerid, "Ge�ersiz parametre girdin.");
	return true;
}
CMD:teleport(playerid, params[])
{
	if(Hesap[playerid][Yonetici] < 1) return YetersizYetki(playerid);
	new yer[16];
	if(sscanf(params, "s[16]", yer)) return Kullanim(playerid, "/teleport [ls/sf/lv]");
	if(!strcmp(yer, "ls", true))
	{
		if(IsPlayerInAnyVehicle(playerid)) 
		{
			SetVehiclePos(GetPlayerVehicleID(playerid), 1529.6327, -1683.8873, 13.3828);
		}
		else SetPlayerPos(playerid, 1529.6327, -1683.8873, 13.3828);
		SetPlayerInterior(playerid, 0);
		SetPlayerVirtualWorld(playerid, 0);
		Sunucu(playerid, "Los Santos'a ���nland�n.");
		return 1;
	}
	else if(!strcmp(yer, "sf", true))
	{
		if(IsPlayerInAnyVehicle(playerid)) 
		{
			SetVehiclePos(GetPlayerVehicleID(playerid), -1986.4033, 137.6835, 27.6875);
		}
		else 
		{
			SetPlayerPos(playerid, -1986.4033, 137.6835, 27.6875);
		}
		SetPlayerInterior(playerid, 0);
		SetPlayerVirtualWorld(playerid, 0);
		Sunucu(playerid, "San Fierro'ya ���nland�n.");
		return 1;
	}
	else if(!strcmp(yer, "lv", true))
	{
		if(IsPlayerInAnyVehicle(playerid)) 
		{
			SetVehiclePos(GetPlayerVehicleID(playerid), 2029.8564, 1009.2123, 10.8203);
		}
		else 
		{
			SetPlayerPos(playerid, 2029.8564,1009.2123,10.8203);
		}
		SetPlayerInterior(playerid, 0);
		SetPlayerVirtualWorld(playerid, 0);
		Sunucu(playerid, "Las Venturas'a ���nland�n.");
		return 1;
	}
	else Sunucu(playerid, "Ge�ersiz b�lge ismi girdin.");
	return 1;
}

CMD:canlandir(playerid, params[])
{
	if(Hesap[playerid][Yonetici] < 1) return YetersizYetki(playerid);
	new hedef;
	if(sscanf(params, "u", hedef)) return Kullanim(playerid, "/canlandir [id/isim]");
	if(!IsPlayerConnected(hedef)) return Sunucu(playerid, "Oyuncu bulunamad�.");
	if(!Karakter[hedef][Giris]) return Sunucu(playerid, "Ki�i giri� yapmam��.");
	if(!Karakter[hedef][Yarali]) return Sunucu(playerid, "Ki�i yaral� de�il.");
	YaraliBitir(hedef);
	Sunucu(hedef, "Yetkili %s taraf�ndan yaral� durumunuz sonland�r�ld�.", RPIsim(playerid));
	Sunucu(playerid, "%s adl� oyuncunun yaral� durumunu sonland�rd�n.", RPIsim(hedef));
	Log_Kaydet("loglar/y_canlandir_loglari.txt", "[%s] %s adli yetkili %s adli kisiyi canlandirdi.", TarihCek(), RPIsim(playerid), RPIsim(hedef));
	return true;
}

CMD:paydaytest(playerid, params[])
{
	if(Hesap[playerid][Yonetici] < 5) return YetersizYetki(playerid);
	for(new i; i < 10; i++)
	{
		SaatTimer();
	}
	return 1;
}

CMD:nsahipbul(playerid, params[])
{
	if(Hesap[playerid][Yonetici] < 2) return YetersizYetki(playerid);
	new numara;
	if(sscanf(params, "d", numara)) return Kullanim(playerid, "/nsahipbul [tel numara]");
	if(numara < 1) return Sunucu(playerid, "Hatal� telefon numaras�.");
	new query[144], Cache:VeriCek, rows;
	mysql_format(conn, query, sizeof(query), "SELECT * FROM karakterler WHERE TelefonNumarasi = %i", numara);
	VeriCek = mysql_query(conn, query);
	cache_get_row_count(rows);
	if(rows)
	{
		new isim[32], sqlid;
		cache_get_value_name(0, "isim", isim, 32);
		cache_get_value_name_int(0, "id", sqlid);
		Sunucu(playerid, "%d numaras� %s(SQL: %d) adl� ki�iye ait.", numara, isim, sqlid);
	}
	else 
	{
		Sunucu(playerid, "Telefon numaras� ge�ersiz.");
	}
	cache_delete(VeriCek);
	return true;
}