CMD:vicemarket(playerid, params[])
{
	if(!Karakter[playerid][Giris]) return GirisYapmadi(playerid);
	new string[1150];
	format(string, sizeof(string), "%s{3C5DA5}Isim De�i�tirme{FFFFFF}\tKullan\t%d\n", string,Hesap[playerid][IsimDegisimHakki]);
	format(string, sizeof(string), "%s{3C5DA5}Plaka De�i�tirme{FFFFFF}\tKullan\t%d\n", string,Hesap[playerid][PlakaDegisimHakki]);
	format(string, sizeof(string), "%s{3C5DA5}Telefon Numaras� De�i�imi{FFFFFF}\tKullan\t%d\n", string,Hesap[playerid][TelefonDegisimHakki]);
	format(string, sizeof(string), "%s{3C5DA5}Bisiklet Al�m�{FFFFFF}\tKullan\t%d\n", string,Hesap[playerid][BisikletHakki]);
	format(string, sizeof(string), "%s{3C5DA5}4 Yetenek Puan�{FFFFFF}\tKullan\t%d\n", string,Hesap[playerid][BesYetenekPuani]);
	format(string, sizeof(string), "%s{3C5DA5}8 Yetenek Puan�{FFFFFF}\tKullan\t%d\n", string,Hesap[playerid][OnYetenekPuani]);
	format(string, sizeof(string), "%s{3C5DA5}15 Yetenek Puan�{FFFFFF}\tKullan\t%d\n", string,Hesap[playerid][OnBesYetenekPuani]);
	format(string, sizeof(string), "%s{3C5DA5}Yetenek S�f�rlama{FFFFFF}\tKullan\t%d\n", string,Hesap[playerid][YetenekSifirlamaHakki]);
	format(string, sizeof(string), "%s{3C5DA5}�zel Banka Hesap Numaras�{FFFFFF}\tKullan\t%d\n", string,Hesap[playerid][BankaHesapDegisimHakki]);
	format(string, sizeof(string), "%s{3C5DA5}���nc� Dil Hakk�{FFFFFF}\tKullan\t%d\n", string, Hesap[playerid][UcuncuDilHakki]);
	format(string, sizeof(string), "%s{3C5DA5}vCoin\tBiriken\t%d\n", string,Hesap[playerid][ViceCoin]);
	Dialog_Show(playerid, DIALOG_VICE_MARKET, DIALOG_STYLE_TABLIST, ">> {99C794}Vice Market", string, "Se�", "�ptal");
	return true;
}

Dialog:DIALOG_VICE_MARKET(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		switch(listitem)
		{
			case 0:
			{
				if(Hesap[playerid][IsimDegisimHakki] < 1) return Sunucu(playerid, "�sim de�i�im hakk�n yok.");
				Dialog_Show(playerid, DIALOG_ISIM_DEGISIM, DIALOG_STYLE_INPUT, ">> {99C794}�sim De�i�imi", "Almak istedi�iniz ismi kutucu�a girin.", "Onayla", "�ptal");
			}
			case 1:
			{
				if(Hesap[playerid][PlakaDegisimHakki] < 1) return Sunucu(playerid, "Plaka de�i�im hakk�n yok.");
				if(!IsPlayerInAnyVehicle(playerid)) return Sunucu(playerid, "Plaka de�i�imi yapmak i�in bir ara�ta olmal�s�n.");
				Dialog_Show(playerid, DIALOG_PLAKA_DEGISIM, DIALOG_STYLE_INPUT, ">> {99C794}Plaka De�i�imi", "Almak istedi�iniz yeni ara� plakas�n� girin.", "Onayla", "�ptal");
			}
			case 2:
			{
				if(Hesap[playerid][TelefonDegisimHakki] < 1) return Sunucu(playerid, "Telefon numaras� de�i�im hakk�n yok.");
				Dialog_Show(playerid, DIALOG_TELEFON_DEGISIM, DIALOG_STYLE_INPUT, ">> {99C794}Telefon Numaras� De�i�imi", "Almak istedi�iniz yeni telefon numaras�n� girin.", "Onayla", "�ptal");
			}
			case 3:
			{
				if(Hesap[playerid][BisikletHakki] < 1) return Sunucu(playerid, "Bisiklet a�ma hakk�n yok.");
				if(!IsPlayerInRangeOfPoint(playerid, 3.0, 957.7657,-1704.1384,13.6137)) return Sunucu(playerid, "Bisiklet almak i�in Sunshine Autos'daki bisiklet alma noktas�nda olmal�s�n.");
				Dialog_Show(playerid, DIALOG_BISIKLET_ACIMI, DIALOG_STYLE_MSGBOX, ">> {99C794}Bisiklet A�ma", "Bisiklet se�im ekran�na gitmek i�in bu sayfay� onaylay�n.", "Onayla", "�ptal");
			}
			case 4:
			{
				if(Hesap[playerid][BesYetenekPuani] < 1) return Sunucu(playerid, "D�rt yetenek puan� hakk�n yok.");
				Dialog_Show(playerid, DIALOG_BES_YETENEK_ONAY, DIALOG_STYLE_MSGBOX, ">> {99C794}D�rt Yetenek Puan�", "D�rt yetenek puan� hakk�n� kullanmak istedi�ine emin misin?", "Onayla", "�ptal");
			}
			case 5:
			{
				if(Hesap[playerid][OnYetenekPuani] < 1) return Sunucu(playerid, "Sekiz yetenek puan� hakk�n yok.");
				Dialog_Show(playerid, DIALOG_ON_YETENEK_ONAY, DIALOG_STYLE_MSGBOX, ">> {99C794}Sekiz Yetenek Puan�", "Sekiz yetenek puan� hakk�n� kullanmak istedi�ine emin misin?", "Onayla", "�ptal");
			}
			case 6:
			{
				if(Hesap[playerid][OnBesYetenekPuani] < 1) return Sunucu(playerid, "On be� yetenek puan� hakk�n yok.");
				Dialog_Show(playerid, DIALOG_ONBES_YETENEK_ONAY, DIALOG_STYLE_MSGBOX, ">> {99C794}On Be� Yetenek Puan�", "On be� yetenek puan� hakk�n� kullanmak istedi�ine emin misin?", "Onayla", "�ptal");
			}
			case 7:
			{
				if(Hesap[playerid][YetenekSifirlamaHakki] < 1) return Sunucu(playerid, "Yetenek s�f�rlama hakk�n yok.");
				Dialog_Show(playerid, DIALOG_YETENEK_SIFIRLA_ONAY, DIALOG_STYLE_MSGBOX, ">> {99C794}Yetenek S�f�rlama", "Yeteneklerinizi s�f�rlay�p yetenek puan� almak istedi�inize emin misiniz?", "Onayla", "�ptal");
			}
			case 8:
			{
				if(Hesap[playerid][BankaHesapDegisimHakki] < 1) return Sunucu(playerid, "Banka hesap de�i�imi hakk�n yok.");
				Dialog_Show(playerid, DIALOG_BANKA_HESAP_DEGISIM_ONAY, DIALOG_STYLE_INPUT, ">> {99C794}Banka Hesap No De�i�imi", "Almak istedi�iniz banka hesap numaras�n� girin.", "Onayla", "�ptal");
			}
			case 9:
			{
				if(Hesap[playerid][UcuncuDilHakki] < 1) return Sunucu(playerid, "���nc� dil de�i�imi hakk�n yok.");
				new icerik[384];
				icerik[0] = 0;
				for(new x; x < sizeof(kokendilleri); x++)
				{
					format(icerik, sizeof(icerik), "%s%s\n", icerik, kokendilleri[x][kokendili]);
				}
				Dialog_Show(playerid, DIALOG_UCUNCU_DIL_DEGISIM, DIALOG_STYLE_LIST, ">> {99C794}���nc� Dil Se�imi", icerik, "Se�", "�ptal");
			}
		}
	}
	return true;
}

Dialog:DIALOG_ISIM_DEGISIM(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		if(isnull(inputtext) || strlen(inputtext) > 24 || strlen(inputtext) < 3)
		{
			Sunucu(playerid, "Karakter ismi uzunlu�u 3 karakter ile 24 karakter aras�nda olmal�d�r.");
			Dialog_Show(playerid, DIALOG_ISIM_DEGISIM, DIALOG_STYLE_INPUT, ">> {99C794}�sim De�i�imi", "Almak istedi�iniz ismi kutucu�a girin.", "Onayla", "�ptal");
			return 1;
		}
		switch(RPIsimKontrol(inputtext))
		{
			case Roleplay_Isim_Kontrol_Degil:
			{
				Sunucu(playerid, "Karakter ad�n�z 'Anthony_Flaviano' format�nda olmal�d�r.");
				Dialog_Show(playerid, DIALOG_ISIM_DEGISIM, DIALOG_STYLE_INPUT, ">> {99C794}�sim De�i�imi", "Almak istedi�iniz ismi kutucu�a girin.", "Onayla", "�ptal");				return 1;
			}
			case Roleplay_Isim_Kontrol_Sapkali:
			{
				Sunucu(playerid, "Karakter ad�n�z 'Anthony_Flaviano' format�nda olmal�d�r.");
				Dialog_Show(playerid, DIALOG_ISIM_DEGISIM, DIALOG_STYLE_INPUT, ">> {99C794}�sim De�i�imi", "Almak istedi�iniz ismi kutucu�a girin.", "Onayla", "�ptal");
				return 1;
			}
			case Roleplay_Isim_Kontrol_Rakamli:
			{
				Sunucu(playerid, "Karakter ad�n�z 'Anthony_Flaviano' format�nda olmal�d�r.");
				Dialog_Show(playerid, DIALOG_ISIM_DEGISIM, DIALOG_STYLE_INPUT, ">> {99C794}�sim De�i�imi", "Almak istedi�iniz ismi kutucu�a girin.", "Onayla", "�ptal");
				return 1;
			}
		}
		new query[128];
		mysql_format(conn, query, sizeof(query), "SELECT * FROM karakterler WHERE isim = '%e'", inputtext);
		mysql_tquery(conn, query, "IsimDegisimKontrol", "is", playerid, inputtext);
	}
	return true;
}

Vice:IsimDegisimKontrol(playerid, isim[])
{
	new rows = cache_num_rows();
	if(rows != 0)
	{
		Sunucu(playerid, "Bu isim kullan�l�yor. L�tfen ba�ka bir isim girin.");
	}
	else
	{
		new query[192];
		mysql_format(conn, query, sizeof(query), "INSERT INTO ncler (EskiIsim, Forumid, Tarih, EskiSkin, EskiUyruk) VALUES ('%e', %i, '%e', %i, %i)", Karakter[playerid][Isim], Hesap[playerid][Forumid], TarihCek(), Karakter[playerid][Skin], Karakter[playerid][Koken]);
		mysql_query(conn, query);
		mysql_format(conn, query, sizeof(query), "UPDATE karakterler SET Olusturuldu = 0 WHERE id = %i", Karakter[playerid][id]);
		mysql_query(conn, query);
		SetPlayerName(playerid, isim);
		format(Karakter[playerid][Isim], MAX_PLAYER_NAME, "%s", isim);
		Hesap[playerid][IsimDegisimHakki]--;
		HesapVeriKaydet(playerid);
		KarakterVeriKaydet(playerid);
		Sunucu(playerid, "�sminiz %s olarak de�i�tirildi, oyundan ��kart�l�yorsunuz... L�tfen tekrar giri� yap�n.", isim);
		KickEx(playerid);
	}	
	return true;
}

Dialog:DIALOG_PLAKA_DEGISIM(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		if(!IsPlayerInAnyVehicle(playerid)) return Sunucu(playerid, "Plaka de�i�imi yapmak i�in bir ara�ta olmal�s�n.");
		new aracid = GetPlayerVehicleID(playerid);
		if(!AracSahipKontrol(playerid, aracid)) return Sunucu(playerid, "Bu arac�n sahibi de�ilsin.");
		if(isnull(inputtext) || strlen(inputtext) > 12) return Dialog_Show(playerid, DIALOG_PLAKA_DEGISIM, DIALOG_STYLE_INPUT, ">> {99C794}Plaka De�i�imi", "Plaka k�sm� bo� veya 12 karakterden b�y�k olamaz.\nAlmak istedi�iniz yeni ara� plakas�n� girin.", "Onayla", "�ptal");
		SetPVarString(playerid, "ViceMarketPlaka", inputtext);
		Dialog_Show(playerid, DIALOG_PLAKA_ONAY, DIALOG_STYLE_MSGBOX, ">> {99C794}Plaka De�i�im - Onay", "Arac�n�n plakas� {3C5DA5}%s{FFFFFF} olarak de�i�tirilecek, onayl�yor musun?\n{3C5DA5}NOT:{FFFFFF} Alt�n�zdaki ara� plaka de�i�imi nedeniyle park alan�na d�necek.", "Onayla", "�ptal", inputtext);
	}
	return true;
}

Dialog:DIALOG_PLAKA_ONAY(playerid, response, listitem, inputtext[])
{	
	if(response)
	{
		if(!IsPlayerInAnyVehicle(playerid)) return Sunucu(playerid, "Plaka de�i�imi yapmak i�in bir ara�ta olmal�s�n."), DeletePVar(playerid, "ViceMarketPlaka");
		new aracid = GetPlayerVehicleID(playerid);
		if(!AracSahipKontrol(playerid, aracid)) return Sunucu(playerid, "Bu arac�n sahibi de�ilsin."), DeletePVar(playerid, "ViceMarketPlaka");
		new plaka[12];
		GetPVarString(playerid, "ViceMarketPlaka", plaka, 12);
		format(Araclar[aracid][Plaka], 32, "%s", plaka);
		SetVehicleNumberPlate(aracid, Araclar[aracid][Plaka]);
		AracSpawnla(aracid);
		DeletePVar(playerid, "ViceMarketPlaka");
	}
	else 
	{
		DeletePVar(playerid, "ViceMarketPlaka");
	}
	return true;
}