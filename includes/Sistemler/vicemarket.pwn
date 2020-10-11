CMD:vicemarket(playerid, params[])
{
	if(!Karakter[playerid][Giris]) return GirisYapmadi(playerid);
	new string[1150];
	format(string, sizeof(string), "%s{3C5DA5}Isim Deðiþtirme{FFFFFF}\tKullan\t%d\n", string,Hesap[playerid][IsimDegisimHakki]);
	format(string, sizeof(string), "%s{3C5DA5}Plaka Deðiþtirme{FFFFFF}\tKullan\t%d\n", string,Hesap[playerid][PlakaDegisimHakki]);
	format(string, sizeof(string), "%s{3C5DA5}Telefon Numarasý Deðiþimi{FFFFFF}\tKullan\t%d\n", string,Hesap[playerid][TelefonDegisimHakki]);
	format(string, sizeof(string), "%s{3C5DA5}Bisiklet Alýmý{FFFFFF}\tKullan\t%d\n", string,Hesap[playerid][BisikletHakki]);
	format(string, sizeof(string), "%s{3C5DA5}4 Yetenek Puaný{FFFFFF}\tKullan\t%d\n", string,Hesap[playerid][BesYetenekPuani]);
	format(string, sizeof(string), "%s{3C5DA5}8 Yetenek Puaný{FFFFFF}\tKullan\t%d\n", string,Hesap[playerid][OnYetenekPuani]);
	format(string, sizeof(string), "%s{3C5DA5}15 Yetenek Puaný{FFFFFF}\tKullan\t%d\n", string,Hesap[playerid][OnBesYetenekPuani]);
	format(string, sizeof(string), "%s{3C5DA5}Yetenek Sýfýrlama{FFFFFF}\tKullan\t%d\n", string,Hesap[playerid][YetenekSifirlamaHakki]);
	format(string, sizeof(string), "%s{3C5DA5}Özel Banka Hesap Numarasý{FFFFFF}\tKullan\t%d\n", string,Hesap[playerid][BankaHesapDegisimHakki]);
	format(string, sizeof(string), "%s{3C5DA5}Üçüncü Dil Hakký{FFFFFF}\tKullan\t%d\n", string, Hesap[playerid][UcuncuDilHakki]);
	format(string, sizeof(string), "%s{3C5DA5}vCoin\tBiriken\t%d\n", string,Hesap[playerid][ViceCoin]);
	Dialog_Show(playerid, DIALOG_VICE_MARKET, DIALOG_STYLE_TABLIST, ">> {99C794}Vice Market", string, "Seç", "Ýptal");
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
				if(Hesap[playerid][IsimDegisimHakki] < 1) return Sunucu(playerid, "Ýsim deðiþim hakkýn yok.");
				Dialog_Show(playerid, DIALOG_ISIM_DEGISIM, DIALOG_STYLE_INPUT, ">> {99C794}Ýsim Deðiþimi", "Almak istediðiniz ismi kutucuða girin.", "Onayla", "Ýptal");
			}
			case 1:
			{
				if(Hesap[playerid][PlakaDegisimHakki] < 1) return Sunucu(playerid, "Plaka deðiþim hakkýn yok.");
				if(!IsPlayerInAnyVehicle(playerid)) return Sunucu(playerid, "Plaka deðiþimi yapmak için bir araçta olmalýsýn.");
				Dialog_Show(playerid, DIALOG_PLAKA_DEGISIM, DIALOG_STYLE_INPUT, ">> {99C794}Plaka Deðiþimi", "Almak istediðiniz yeni araç plakasýný girin.", "Onayla", "Ýptal");
			}
			case 2:
			{
				if(Hesap[playerid][TelefonDegisimHakki] < 1) return Sunucu(playerid, "Telefon numarasý deðiþim hakkýn yok.");
				Dialog_Show(playerid, DIALOG_TELEFON_DEGISIM, DIALOG_STYLE_INPUT, ">> {99C794}Telefon Numarasý Deðiþimi", "Almak istediðiniz yeni telefon numarasýný girin.", "Onayla", "Ýptal");
			}
			case 3:
			{
				if(Hesap[playerid][BisikletHakki] < 1) return Sunucu(playerid, "Bisiklet açma hakkýn yok.");
				if(!IsPlayerInRangeOfPoint(playerid, 3.0, 957.7657,-1704.1384,13.6137)) return Sunucu(playerid, "Bisiklet almak için Sunshine Autos'daki bisiklet alma noktasýnda olmalýsýn.");
				Dialog_Show(playerid, DIALOG_BISIKLET_ACIMI, DIALOG_STYLE_MSGBOX, ">> {99C794}Bisiklet Açma", "Bisiklet seçim ekranýna gitmek için bu sayfayý onaylayýn.", "Onayla", "Ýptal");
			}
			case 4:
			{
				if(Hesap[playerid][BesYetenekPuani] < 1) return Sunucu(playerid, "Dört yetenek puaný hakkýn yok.");
				Dialog_Show(playerid, DIALOG_BES_YETENEK_ONAY, DIALOG_STYLE_MSGBOX, ">> {99C794}Dört Yetenek Puaný", "Dört yetenek puaný hakkýný kullanmak istediðine emin misin?", "Onayla", "Ýptal");
			}
			case 5:
			{
				if(Hesap[playerid][OnYetenekPuani] < 1) return Sunucu(playerid, "Sekiz yetenek puaný hakkýn yok.");
				Dialog_Show(playerid, DIALOG_ON_YETENEK_ONAY, DIALOG_STYLE_MSGBOX, ">> {99C794}Sekiz Yetenek Puaný", "Sekiz yetenek puaný hakkýný kullanmak istediðine emin misin?", "Onayla", "Ýptal");
			}
			case 6:
			{
				if(Hesap[playerid][OnBesYetenekPuani] < 1) return Sunucu(playerid, "On beþ yetenek puaný hakkýn yok.");
				Dialog_Show(playerid, DIALOG_ONBES_YETENEK_ONAY, DIALOG_STYLE_MSGBOX, ">> {99C794}On Beþ Yetenek Puaný", "On beþ yetenek puaný hakkýný kullanmak istediðine emin misin?", "Onayla", "Ýptal");
			}
			case 7:
			{
				if(Hesap[playerid][YetenekSifirlamaHakki] < 1) return Sunucu(playerid, "Yetenek sýfýrlama hakkýn yok.");
				Dialog_Show(playerid, DIALOG_YETENEK_SIFIRLA_ONAY, DIALOG_STYLE_MSGBOX, ">> {99C794}Yetenek Sýfýrlama", "Yeteneklerinizi sýfýrlayýp yetenek puaný almak istediðinize emin misiniz?", "Onayla", "Ýptal");
			}
			case 8:
			{
				if(Hesap[playerid][BankaHesapDegisimHakki] < 1) return Sunucu(playerid, "Banka hesap deðiþimi hakkýn yok.");
				Dialog_Show(playerid, DIALOG_BANKA_HESAP_DEGISIM_ONAY, DIALOG_STYLE_INPUT, ">> {99C794}Banka Hesap No Deðiþimi", "Almak istediðiniz banka hesap numarasýný girin.", "Onayla", "Ýptal");
			}
			case 9:
			{
				if(Hesap[playerid][UcuncuDilHakki] < 1) return Sunucu(playerid, "Üçüncü dil deðiþimi hakkýn yok.");
				new icerik[384];
				icerik[0] = 0;
				for(new x; x < sizeof(kokendilleri); x++)
				{
					format(icerik, sizeof(icerik), "%s%s\n", icerik, kokendilleri[x][kokendili]);
				}
				Dialog_Show(playerid, DIALOG_UCUNCU_DIL_DEGISIM, DIALOG_STYLE_LIST, ">> {99C794}Üçüncü Dil Seçimi", icerik, "Seç", "Ýptal");
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
			Sunucu(playerid, "Karakter ismi uzunluðu 3 karakter ile 24 karakter arasýnda olmalýdýr.");
			Dialog_Show(playerid, DIALOG_ISIM_DEGISIM, DIALOG_STYLE_INPUT, ">> {99C794}Ýsim Deðiþimi", "Almak istediðiniz ismi kutucuða girin.", "Onayla", "Ýptal");
			return 1;
		}
		switch(RPIsimKontrol(inputtext))
		{
			case Roleplay_Isim_Kontrol_Degil:
			{
				Sunucu(playerid, "Karakter adýnýz 'Anthony_Flaviano' formatýnda olmalýdýr.");
				Dialog_Show(playerid, DIALOG_ISIM_DEGISIM, DIALOG_STYLE_INPUT, ">> {99C794}Ýsim Deðiþimi", "Almak istediðiniz ismi kutucuða girin.", "Onayla", "Ýptal");				return 1;
			}
			case Roleplay_Isim_Kontrol_Sapkali:
			{
				Sunucu(playerid, "Karakter adýnýz 'Anthony_Flaviano' formatýnda olmalýdýr.");
				Dialog_Show(playerid, DIALOG_ISIM_DEGISIM, DIALOG_STYLE_INPUT, ">> {99C794}Ýsim Deðiþimi", "Almak istediðiniz ismi kutucuða girin.", "Onayla", "Ýptal");
				return 1;
			}
			case Roleplay_Isim_Kontrol_Rakamli:
			{
				Sunucu(playerid, "Karakter adýnýz 'Anthony_Flaviano' formatýnda olmalýdýr.");
				Dialog_Show(playerid, DIALOG_ISIM_DEGISIM, DIALOG_STYLE_INPUT, ">> {99C794}Ýsim Deðiþimi", "Almak istediðiniz ismi kutucuða girin.", "Onayla", "Ýptal");
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
		Sunucu(playerid, "Bu isim kullanýlýyor. Lütfen baþka bir isim girin.");
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
		Sunucu(playerid, "Ýsminiz %s olarak deðiþtirildi, oyundan çýkartýlýyorsunuz... Lütfen tekrar giriþ yapýn.", isim);
		KickEx(playerid);
	}	
	return true;
}

Dialog:DIALOG_PLAKA_DEGISIM(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		if(!IsPlayerInAnyVehicle(playerid)) return Sunucu(playerid, "Plaka deðiþimi yapmak için bir araçta olmalýsýn.");
		new aracid = GetPlayerVehicleID(playerid);
		if(!AracSahipKontrol(playerid, aracid)) return Sunucu(playerid, "Bu aracýn sahibi deðilsin.");
		if(isnull(inputtext) || strlen(inputtext) > 12) return Dialog_Show(playerid, DIALOG_PLAKA_DEGISIM, DIALOG_STYLE_INPUT, ">> {99C794}Plaka Deðiþimi", "Plaka kýsmý boþ veya 12 karakterden büyük olamaz.\nAlmak istediðiniz yeni araç plakasýný girin.", "Onayla", "Ýptal");
		SetPVarString(playerid, "ViceMarketPlaka", inputtext);
		Dialog_Show(playerid, DIALOG_PLAKA_ONAY, DIALOG_STYLE_MSGBOX, ">> {99C794}Plaka Deðiþim - Onay", "Aracýnýn plakasý {3C5DA5}%s{FFFFFF} olarak deðiþtirilecek, onaylýyor musun?\n{3C5DA5}NOT:{FFFFFF} Altýnýzdaki araç plaka deðiþimi nedeniyle park alanýna dönecek.", "Onayla", "Ýptal", inputtext);
	}
	return true;
}

Dialog:DIALOG_PLAKA_ONAY(playerid, response, listitem, inputtext[])
{	
	if(response)
	{
		if(!IsPlayerInAnyVehicle(playerid)) return Sunucu(playerid, "Plaka deðiþimi yapmak için bir araçta olmalýsýn."), DeletePVar(playerid, "ViceMarketPlaka");
		new aracid = GetPlayerVehicleID(playerid);
		if(!AracSahipKontrol(playerid, aracid)) return Sunucu(playerid, "Bu aracýn sahibi deðilsin."), DeletePVar(playerid, "ViceMarketPlaka");
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