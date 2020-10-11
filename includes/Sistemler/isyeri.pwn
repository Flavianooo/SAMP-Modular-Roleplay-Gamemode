CMD:satinal(playerid, params[])
{
	if(IsyeriIcinde(playerid) != -1)
	{
		new isyeriid = IsyeriIcinde(playerid);
		new dialogstr[800];
		switch(Isyeri[isyeriid][Tur])
		{
			case 1:
			{
				strcat(dialogstr, "Ürün\tÜcret\n");
				strcat(dialogstr, "Telefon\t$250\n");
				strcat(dialogstr, "Sim Kart\t$50\n");
				strcat(dialogstr, "Sigara Paketi\t$20\n");
				Dialog_Show(playerid, DIALOG_MARKET_SATINAL, DIALOG_STYLE_TABLIST_HEADERS, "{99C794}Market", dialogstr, "Satýn Al", "Ýptal");
			}
		}
	}
	else Sunucu(playerid, "Bir iþyerinde deðilsin.");
	return true;
}

Dialog:DIALOG_MARKET_SATINAL(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		if(IsyeriIcinde(playerid) == -1) return Sunucu(playerid, "Bir iþyerinde deðilsiniz.");
		new isyeriid = IsyeriIcinde(playerid);
		switch(listitem)
		{
			case 0:
			{
				if(Karakter[playerid][Para] < 250) return YetersizPara(playerid);
				if(Karakter[playerid][Telefon] != 0) return Sunucu(playerid, "Zaten telefonunuz bulunuyor.");
				ParaVer(playerid, -250);
				Isyeri[isyeriid][Kasa] += 250;
				IsyeriVeriKaydet(isyeriid);
				Karakter[playerid][Telefon] = 1;
				KarakterVeriKaydet(playerid);
				Sunucu(playerid, "$250 karþýlýðýnda telefon satýn aldýnýz.");
			}
			case 1:
			{
				if(Karakter[playerid][Para] < 50) return YetersizPara(playerid);
				if(Karakter[playerid][TelefonNumarasi] != 0) return Sunucu(playerid, "Zaten bir sim kartýnýz bulunuyor. Yenisini alamazsýnýz.");
				new query[144], telno = randomEx(1000000, 9999999);
				mysql_format(conn, query, sizeof(query), "SELECT * FROM karakterler WHERE TelefonNumarasi = %i", telno);
				mysql_tquery(conn, query, "TelefonNumaraVer", "ii", playerid, telno);
				ParaVer(playerid, -50);
				Isyeri[isyeriid][Kasa] += 50;
				IsyeriVeriKaydet(isyeriid);
			}
			case 2:
			{
				if(Karakter[playerid][Para] < 20) return YetersizPara(playerid);
				Karakter[playerid][Sigara] += 20;
				ParaVer(playerid, -20);
				Isyeri[isyeriid][Kasa] += 20;
				IsyeriVeriKaydet(isyeriid);
				Sunucu(playerid, "Bir sigara paketi satýn aldýnýz. Ýçinde 20 dal sigara var.");
				KarakterVeriKaydet(playerid);
			}
		}
	}
	return true;
}

Vice:TelefonNumaraVer(playerid, telno)
{
	new rows;
	cache_get_row_count(rows);
	if(rows)
	{
		new query[144], yenino = randomEx(1000000, 9999999);
		mysql_format(conn, query, sizeof(query), "SELECT * FROM karakterler WHERE TelefonNumarasi = %i", yenino);
		mysql_tquery(conn, query, "TelefonNumaraVer", "ii", playerid, yenino);
	}
	else
	{
		Karakter[playerid][TelefonNumarasi] = telno;
		KarakterVeriKaydet(playerid);
		Sunucu(playerid, "Sim kart satýn aldýnýz. Yeni telefon numaranýz %d olarak belirlendi.", telno);
	}
	return true;
}
// YÖNETÝCÝ

CMD:isyeriyarat(playerid, params[])
{
	if(Hesap[playerid][Yonetici] < 5) return YetersizYetki(playerid);

	new isyerifiyati, isyeriadresi[32], Float:x, Float:y, Float:z, interior = GetPlayerInterior(playerid), world = GetPlayerVirtualWorld(playerid);
	if(sscanf(params, "ds[32]", isyerifiyati, isyeriadresi)) return Kullanim(playerid, "/isyeriyarat [fiyat] [adres]");
	if(strlen(isyeriadresi) < 1 || strlen(isyeriadresi) > 32) return Sunucu(playerid, "Girdiðin adres 1-32 karakter arasýnda olmalý.");

	GetPlayerPos(playerid, x, y, z);
	IsyeriYarat(playerid, isyeriadresi, x, y, z, world, interior, isyerifiyati);
	return true;
}

CMD:isyeriduzenle(playerid, params[])
{
	if(Hesap[playerid][Yonetici] < 5) return YetersizYetki(playerid);
	new isyeriid, secenek[16], ekstra[64];
	if(sscanf(params, "ds[16]S()[64]", isyeriid, secenek, ekstra))
	{
		Kullanim(playerid, "/isyeriduzenle [id] [seçenek]");
		GenelMesajGonder(playerid, "isim, adres, fiyat, tur, sahip, dispos, icpos, kasa");
		return true;
	}

	if(!Isyeri[isyeriid][Gecerli]) return Sunucu(playerid, "Geçersiz id girdiniz.");
	if(!strcmp(secenek, "isim", true))
	{
		new isim[32];
		if(sscanf(ekstra, "s[32]", isim)) return Sunucu(playerid, "/isyeriduzenle [id] isim [yeni isim(32)]");
		if(strlen(isim) < 1 || strlen(isim) > 32) return Sunucu(playerid, "Minimum 1-32 karakter arasý bir isim girmelisiniz.");

		new isyeriismi[32];
		format(isyeriismi, 32, "%s", isim);
		Isyeri[isyeriid][IsyeriAd] = isyeriismi;
		IsyeriVeriKaydet(isyeriid);
		IsyeriTextYenile(isyeriid);
		Sunucu(playerid, "%d id'li iþyerinin ismini %s olarak deðiþtirdiniz.", isyeriid, Isyeri[isyeriid][IsyeriAd]);
	}
	else if(!strcmp(secenek, "kasa", true))
	{
		new yenideger;
		if(sscanf(ekstra, "d", yenideger)) return Kullanim(playerid, "/isyeriduzenle [id] kasa [yeni para deðeri]");
		if(yenideger < 0) return Sunucu(playerid, "Kasadaki para en az 0 olmalýdýr.");

		Isyeri[isyeriid][Kasa] = yenideger;
		IsyeriVeriKaydet(isyeriid);
		Sunucu(playerid, "%d id'li iþyerinin kasasýndaki parayý %s olarak deðiþtirdiniz.", isyeriid, NumaraFormati(yenideger));
	}
	else if(!strcmp(secenek, "tur", true))
	{
		new tur;
		if(sscanf(ekstra, "d", tur)) 
		{
			Sunucu(playerid, "/isyeriduzenle [id] tur [yeni tür]");
			GenelMesajGonder(playerid, "Türler: 1 - Market | 2 - Restoran | 3 - Diðer");
			return true;
		}
		if(tur < 1 || tur > 3) return Sunucu(playerid, "Geçersiz tür.");
		Isyeri[isyeriid][Tur] = tur;
		IsyeriVeriKaydet(isyeriid);
		IsyeriTextYenile(isyeriid);
		Sunucu(playerid, "%d id'li iþyerinin türünü %s olarak deðiþtirdiniz.", isyeriid, IsyeriTurIsim(isyeriid));
	}
	else if(!strcmp(secenek, "adres", true))
	{
		new adres[32];
		if(sscanf(ekstra, "s[32]", adres)) return Sunucu(playerid, "/isyeriduzenle [id] adres [yeni adres(32)]");
		if(strlen(adres) < 1 || strlen(adres) > 32) return Sunucu(playerid, "Minimum 1-32 karakter arasý bir adres girmelisiniz.");

		new isyeriadresi[32];
		format(isyeriadresi, 32, "%s", adres);
		Isyeri[isyeriid][Adres] = isyeriadresi;
		IsyeriVeriKaydet(isyeriid);
		IsyeriTextYenile(isyeriid);
		Sunucu(playerid, "%d id'li iþyerinin adresini %s olarak deðiþtirdiniz.", isyeriid, Isyeri[isyeriid][Adres]);
	}
	else if(!strcmp(secenek, "fiyat", true))
	{
		new fiyat;
		if(sscanf(ekstra, "d", fiyat)) return Kullanim(playerid, "/isyeriduzenle [id] fiyat [yeni fiyat]");
		if(fiyat < 1) return Kullanim(playerid, "1'den büyük bir fiyat girmelisin.");
		Isyeri[isyeriid][Fiyat] = fiyat;
		IsyeriVeriKaydet(isyeriid);
		IsyeriTextYenile(isyeriid);
		Sunucu(playerid, "%d id'li iþyerinin fiyatýný $%d olarak deðiþtirdiniz.", isyeriid, Isyeri[isyeriid][Fiyat]);
	}
	else if(!strcmp(secenek, "sahip", true))
	{
		new sahip;
		if(sscanf(ekstra, "d", sahip))
		{
			Kullanim(playerid, "/isyeriduzenle [id] sahip [sahip id]");
			GenelMesajGonder(playerid, "Sahibi kaldýrmak için -1 girebilirsin.");
			return true;
		}
		if(sahip != -1)
		{
			if(!IsPlayerConnected(sahip)) return Sunucu(playerid, "Kiþi oyunda bulunamadý.");
			if(Karakter[sahip][Giris] == false) return Sunucu(playerid, "Kiþi henüz giriþ yapmamýþ.");
			Isyeri[isyeriid][Sahip] = Karakter[sahip][id];
			format(Isyeri[isyeriid][SahipIsim], MAX_PLAYER_NAME+1, "%s", IsyeriSahipIsimCek(isyeriid));
			IsyeriTextYenile(isyeriid);
			IsyeriVeriKaydet(isyeriid);
			Sunucu(playerid, "%d id'li iþyerinin sahibini %s olarak deðiþtirdiniz.", isyeriid, RPIsim(sahip));
		}
		else
		{
			Isyeri[isyeriid][Sahip] = 0;
			format(Isyeri[isyeriid][SahipIsim], MAX_PLAYER_NAME+1, "Yok");
			IsyeriTextYenile(isyeriid);
			IsyeriVeriKaydet(isyeriid);
			Sunucu(playerid, "%d id'li iþyerinin sahibini kaldýrdýnýz. Ýþyeri sisteme satýlýk.", isyeriid);
		}
	}
	else if(!strcmp(secenek, "dispos", true))
	{
		new Float:x, Float:y, Float:z, interior = GetPlayerInterior(playerid), world = GetPlayerVirtualWorld(playerid);
		GetPlayerPos(playerid, x, y, z);
		Isyeri[isyeriid][Ext][0] = x;
		Isyeri[isyeriid][Ext][1] = y;
		Isyeri[isyeriid][Ext][2] = z;
		Isyeri[isyeriid][World] = world;
		Isyeri[isyeriid][Interior] = interior;
		IsyeriVeriKaydet(isyeriid);
		IsyeriTextYenile(isyeriid);
		Sunucu(playerid, "%d id'li iþyerinin dýþ konumunu deðiþtirdin.(World: %d | Interior: %d)", world, interior);
	}
	else if(!strcmp(secenek, "icpos", true))
	{
		new Float:x, Float:y, Float:z, interior = GetPlayerInterior(playerid), world = GetPlayerVirtualWorld(playerid);
		GetPlayerPos(playerid, x, y, z);
		Isyeri[isyeriid][Int][0] = x;
		Isyeri[isyeriid][Int][1] = y;
		Isyeri[isyeriid][Int][2] = z;
		Isyeri[isyeriid][IcWorld] = world;
		Isyeri[isyeriid][IcInterior] = interior;
		IsyeriVeriKaydet(isyeriid);
		Sunucu(playerid, "%d id'li iþyerinin iç konumunu deðiþtirdin.(World: %d | Interior: %d)", isyeriid, world, interior);
	}
	else if(!strcmp(secenek, "durum", true))
	{
		new durum;
		if(sscanf(ekstra, "d", durum))
		{
			Kullanim(playerid, "/isyeriduzenle [id] durum [yeni durum]");
			GenelMesajGonder(playerid, "Durumlar: 1 - Kilitsiz | 2 - Kilitli | 3 - Mühürlü");
			return true;
		}
		if(durum < 1 || durum > 3) return Sunucu(playerid, "Hatalý durum girdin.");
		Isyeri[isyeriid][Durum] = durum;
		IsyeriTextYenile(isyeriid);
		Sunucu(playerid, "%d id'li iþyerinin giriþ durumunu %d olarak deðiþtirdin.");
	}
	else Sunucu(playerid, "Hatalý parametre girdin.");

	return true;
}

CMD:isyerlerim(playerid, params[])
{
	new dialogstr[1024], isyerisayi = 0;
	strcat(dialogstr, "Ýþyeri Ýsmi\tKapý Numarasý\n");
	for(new i = 0; i < MAKSIMUM_ISYERI; i++)
	{
		if(!Isyeri[i][Gecerli]) continue;
		if(Isyeri[i][Sahip] == Karakter[playerid][id])
		{
			Karakter[playerid][IsyeriIsaretID][isyerisayi] = Isyeri[i][id];
			format(dialogstr, sizeof(dialogstr), "%s{FFFFFF}Ýsim: {3C5DA5}%s{FFFFFF}\tKapý Numarasý: {3C5DA5}%d\n", dialogstr, Isyeri[i][IsyeriAd], Isyeri[i][id]);
			isyerisayi++;
		}
	}
	if(isyerisayi == 0) return Sunucu(playerid, "Üstünüze kayýtlý iþyeri bulunamadý.");
	Dialog_Show(playerid, DIALOG_ISYERLERIM, DIALOG_STYLE_TABLIST_HEADERS, "{99C794}Ýþyeri Listesi", dialogstr, "Ýþaretle", "Ýptal");
	return true;
}

Dialog:DIALOG_ISYERLERIM(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		DisablePlayerCheckpoint(playerid);
		new isyeriid = Karakter[playerid][IsyeriIsaretID][listitem];
		SetPlayerCheckpoint(playerid, Isyeri[isyeriid][Ext][0], Isyeri[isyeriid][Ext][1], Isyeri[isyeriid][Ext][2], 5.0);
		Sunucu(playerid, "%d kapý numaralý iþyerinizi iþaretlediniz.", Isyeri[isyeriid][id]);
	}
	return true;
}

CMD:isyerisil(playerid, params[])
{
	if(Hesap[playerid][Yonetici] < 5) return YetersizYetki(playerid);
	new isyeriid;
	if(sscanf(params, "d", isyeriid)) return Kullanim(playerid, "/isyerisil [isyeriid]");
	if(!Isyeri[isyeriid][Gecerli]) return Sunucu(playerid, "Geçersiz id girdiniz.");
	IsyeriSil(playerid, isyeriid);
	return true;
}

CMD:isyerial(playerid, params[])
{
	if(IsyeriYakin(playerid) != -1)
	{
		new isyeriid = IsyeriYakin(playerid);
		if(Isyeri[isyeriid][Sahip] != 0) return Sunucu(playerid, "Bu iþyeri satýlýk deðil.");
		if(Karakter[playerid][Para] < Isyeri[isyeriid][Fiyat]) return Sunucu(playerid, "Bu iþyerini almak için yeterli paran yok.");
		Dialog_Show(playerid, DIALOG_IS_SATIN_AL, DIALOG_STYLE_MSGBOX, "{99C794}Ýþyeri Satýn Al", "{3C5DA5}%s{FFFFFF} karþýlýðýnda bu iþyerini satýn almak istediðine emin misin?", "Onayla", "Ýptal", NumaraFormati(Isyeri[isyeriid][Fiyat]));
	}
	else
	{
		Sunucu(playerid, "Bir iþyerinin yakýnýnda deðilsin.");
	}
	return true;
}

CMD:isyeri(playerid, params[])
{
	if(IsyeriYakin(playerid) != -1)
	{
		new isyeriid = IsyeriYakin(playerid);
		if(!IsyeriSahipKontrol(playerid, isyeriid)) return Sunucu(playerid, "Bu iþyeri size ait deðil.");
		new str[1024];
		strcat(str, "Seçenek\tAçýklama\n");
		strcat(str, "{3C5DA5}Kapý Kilidi\t{FFFFFF}Kapýnýn kilidini açmak/kapatmak için kullanabilirsiniz.\n");
		strcat(str, "{3C5DA5}Ýþyeri Oyuncuya Sat\t{FFFFFF}Ýþyerini baþka bir oyuncuya belli bir fiyat karþýlýðý satabilirsiniz.\n");
		strcat(str, "{3C5DA5}Ýþyeri Sisteme Sat\t{FFFFFF}Ýþyerini sisteme satmak için kullanabilirsiniz.\n");
		strcat(str, "{3C5DA5}Ýþyeri Anahtarý Ver\t{FFFFFF}Ýþyeri anahtarýna sahip kiþiler kapý kilidini kontrol edebilir.\n");
		strcat(str, "{3C5DA5}Ortak Ekle\t{FFFFFF}Ýþyerinize yalnýzca bir ortak ekleyebilirsiniz.\n");
		strcat(str, "{3C5DA5}Ýþyeri Ýsim Deðiþtir\t{FFFFFF}Ýþyerinizin ismini 32 karaktere kadar bir isimle deðiþtirebilirsiniz.\n");
		strcat(str, "{3C5DA5}Kasadan Para Çek\t{FFFFFF}Kasada bulunan paranýn tümünü çekmek için kullanabilirsiniz.\n");
		Dialog_Show(playerid, DIALOG_IS_MENU, DIALOG_STYLE_TABLIST_HEADERS, "{99C794}Ýþyeri Menüsü", str, "Seç", "Ýptal");
	}
	else Sunucu(playerid, "Bir iþyerinin yakýnýnda deðilsin.");
	return true;
}

Dialog:DIALOG_IS_MENU(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		new isyeriid = IsyeriYakin(playerid);
		if(isyeriid == -1) return Sunucu(playerid, "Bir iþyerinin yakýnýnda deðilsin.");
		if(!IsyeriSahipKontrol(playerid, isyeriid)) return Sunucu(playerid, "Bu iþyeri size ait deðil.");
		switch(listitem)
		{
			case 0:
			{
				switch(Isyeri[isyeriid][Durum])
				{
					case 0:
					{
						Isyeri[isyeriid][Durum] = 1;
						Sunucu(playerid, "Ýþyeri kapýsýný kilitlediniz.");
						IsyeriTextYenile(isyeriid);
					}
					case 1:
					{
						Isyeri[isyeriid][Durum] = 0;
						Sunucu(playerid, "Ýþyeri kapýsýnýn kilidini açtýnýz.");
						IsyeriTextYenile(isyeriid);
					}
					default:
					{
						Sunucu(playerid, "Bu iþyerinin kapýsýna müdahale edemezsiniz.");
					}
				}
			}
			case 1:
			{
				Dialog_Show(playerid, DIALOG_IS_OYUNCUYA_SAT, DIALOG_STYLE_INPUT, "{99C794}Ýþyeri Oyuncuya Sat", "{FFFFFF}Ýþyerinizi satmak istediðiniz oyuncunun {3C5DA5}ID{FFFFFF} bilgisini girin.", "Onayla", "Ýptal");
			}
			case 2:
			{
				if(GetPVarInt(playerid, "IsyeriSatiyor") == 1) return Sunucu(playerid, "Ýþyeri satýþ iþlemi sýrasýnda bunu yapamazsýnýz.");
				Dialog_Show(playerid, DIALOG_IS_SISTEME_SAT, DIALOG_STYLE_MSGBOX, "{99C794}Ýþyeri Sisteme Sat", "{FFFFFF}Ýþyerinizi {3C5DA5}%s{FFFFFF} karþýlýðýnda sisteme satmak istediðinize emin misiniz?", "Onayla", "Ýptal", NumaraFormati(Isyeri[isyeriid][Fiyat]/2));
			}
			case 3:
			{
				Dialog_Show(playerid, DIALOG_IS_ANAHTAR_VER, DIALOG_STYLE_INPUT, "{99C794}Ýþyeri Anahtar Ver", "{FFFFFF}Anahtar vermek istediðiniz kiþinin {3C5DA5}ID{FFFFFF} bilgisini girin.", "Onayla", "Ýptal");	
			}
			case 4:
			{
				Dialog_Show(playerid, DIALOG_IS_ORTAK_EKLE, DIALOG_STYLE_INPUT, "{99C794}Ýþyeri Ortak Ekle", "{FFFFFF}Ortak eklemek istediðiniz kiþinin {3C5DA5}ID{FFFFFF} bilgisini girin.", "Onayla", "Ýptal");
			}
			case 5:
			{
				Dialog_Show(playerid, DIALOG_IS_ISIM_DEGISTIR, DIALOG_STYLE_INPUT, "{99C794}Ýþyeri Ýsim Deðiþtir", "{FFFFFF}Ýþyerinizin olmasýný istediðiniz yeni ismini girin.\nMaksimum 32, minimum 1 karakter girmelisiniz.", "Onayla", "Ýptal");
			}
			case 6:
			{
				Dialog_Show(playerid, DIALOG_IS_KASACEK, DIALOG_STYLE_INPUT, "{99C794}Kasadan Para Çek", "{FFFFFF}Ýþyerinizin kasasýnda %s bulunuyor.\nÇekmek istediðiniz para miktarýný girin.", "Çek", "Ýptal", NumaraFormati(Isyeri[isyeriid][Kasa]));
			}
		}
	}
	return true;
}

Dialog:DIALOG_IS_KASACEK(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		new isyeriid = IsyeriYakin(playerid);
		if(isyeriid == -1) return Sunucu(playerid, "Bir iþyerinin yakýnýnda deðilsin.");
		if(!IsyeriSahipKontrol(playerid, isyeriid)) return Sunucu(playerid, "Bu iþyeri size ait deðil.");
		if(strval(inputtext) < 1) return Sunucu(playerid, "Geçersiz para miktarý girdiniz.");
		if(strval(inputtext) > Isyeri[isyeriid][Kasa]) return Sunucu(playerid, "Ýþyeri kasasýnda bu kadar para bulunmuyor.");
		Isyeri[isyeriid][Kasa] -= strval(inputtext);
		IsyeriVeriKaydet(isyeriid);
		ParaVer(playerid, strval(inputtext));
		Sunucu(playerid, "Ýþyeri kasasýndan %s çektiniz. Kasada %s kaldý.", NumaraFormati(strval(inputtext)), Isyeri[isyeriid][Kasa]);
	}
	return true;
}

Dialog:DIALOG_IS_ISIM_DEGISTIR(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		new isyeriid = IsyeriYakin(playerid);
		if(isyeriid == -1) return Sunucu(playerid, "Bir iþyerinin yakýnýnda deðilsin.");
		if(!IsyeriSahipKontrol(playerid, isyeriid)) return Sunucu(playerid, "Bu iþyeri size ait deðil.");
		if(strlen(inputtext) < 1 || strlen(inputtext) > 32 || isnull(inputtext)) return Dialog_Show(playerid, DIALOG_IS_ISIM_DEGISTIR, DIALOG_STYLE_INPUT, "{99C794}Ýþyeri Ýsim Deðiþtir", "{FFFFFF}Hatalý isim.\n{FFFFFF}Ýþyerinizin olmasýný istediðiniz yeni ismini girin.\nMaksimum 32, minimum 1 karakter girmelisiniz.", "Onayla", "Ýptal");
		format(Isyeri[isyeriid][IsyeriAd], 32, "%s", inputtext);
		IsyeriVeriKaydet(isyeriid);
		IsyeriTextYenile(isyeriid);
		Sunucu(playerid, "Ýþyeri ismi '%s' olarak deðiþtirildi.", Isyeri[isyeriid][IsyeriAd]);
	}
	return true;
}

Dialog:DIALOG_IS_ORTAK_EKLE(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		new isyeriid = IsyeriYakin(playerid);
		if(isyeriid == -1) return Sunucu(playerid, "Bir iþyerinin yakýnýnda deðilsin.");
		if(!IsyeriSahipKontrol(playerid, isyeriid)) return Sunucu(playerid, "Bu iþyeri size ait deðil.");
		new oid = strval(inputtext);
		if(Isyeri[isyeriid][OrtakDurum] == 1) return Sunucu(playerid, "Ýþyerinizin zaten bir ortaðý bulunuyor. Ayný anda bir ortak eklenebilir.");
		if(playerid == oid) return Sunucu(playerid, "Kendinizi ortak ekleyemezsiniz.");
		if(!IsPlayerConnected(oid) || !Karakter[oid][Giris]) return Dialog_Show(playerid, DIALOG_IS_ORTAK_EKLE, DIALOG_STYLE_INPUT, "{99C794}Ýþyeri Ortak Ekle", "{FFFFFF}Geçersiz ID girdiniz.\n{FFFFFF}Ortak eklemek istediðiniz kiþinin {3C5DA5}ID{FFFFFF} bilgisini girin.", "Onayla", "Ýptal");
		if(!OyuncuYakin(playerid, oid, 5.0)) return Dialog_Show(playerid, DIALOG_IS_ORTAK_EKLE, DIALOG_STYLE_INPUT, "{99C794}Ýþyeri Ortak Ekle", "{FFFFFF}Bu kiþiye yakýn deðilsin.\n{FFFFFF}Ortak eklemek istediðiniz kiþinin {3C5DA5}ID{FFFFFF} bilgisini girin.", "Onayla", "Ýptal");
		if(Karakter[oid][IsyeriOrtak] != -1) return Sunucu(playerid, "Girdiðiniz kiþi zaten bir iþyerinin ortaðý. Ýþlem iptal edildi.");
		Karakter[oid][IsyeriOrtak] = Isyeri[isyeriid][id];
		KarakterVeriKaydet(oid);
		Isyeri[isyeriid][OrtakDurum] = 1;
		IsyeriVeriKaydet(isyeriid);
		IsyeriTextYenile(isyeriid);
		Sunucu(playerid, "%s adlý kiþiyi %d kapý numaralý iþyerine ortak olarak ekledin.", RPIsim(oid), Isyeri[isyeriid][id]);
		Sunucu(oid, "%s adlý kiþi tarafýndan %d kapý numaralý iþyerine ortak olarak eklendin.", RPIsim(playerid), Isyeri[isyeriid][id]);
		GenelMesajGonder(oid, "Artýk bu iþyerinin kilit ve dekorasyon özelliklerini kullanabilirsin.");
	}
	return true;
}

Dialog:DIALOG_IS_ANAHTAR_VER(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		new isyeriid = IsyeriYakin(playerid);
		if(isyeriid == -1) return Sunucu(playerid, "Bir iþyerinin yakýnýnda deðilsin.");
		if(!IsyeriSahipKontrol(playerid, isyeriid)) return Sunucu(playerid, "Bu iþyeri size ait deðil.");
		new oid = strval(inputtext);
		if(playerid == oid) return Dialog_Show(playerid, DIALOG_IS_ANAHTAR_VER, DIALOG_STYLE_INPUT, "{99C794}Ýþyeri Anahtar Ver", "{FFFFFF}Kendinize anahtar veremezsiniz.{FFFFFF}Anahtar vermek istediðiniz kiþinin {3C5DA5}ID{FFFFFF} bilgisini girin.", "Onayla", "Ýptal");	
		if(!IsPlayerConnected(oid) || !Karakter[oid][Giris]) return Dialog_Show(playerid, DIALOG_IS_ANAHTAR_VER, DIALOG_STYLE_INPUT, "{99C794}Ýþyeri Anahtar Ver", "{FFFFFF}Oyuncu bulunamadý.{FFFFFF}Anahtar vermek istediðiniz kiþinin {3C5DA5}ID{FFFFFF} bilgisini girin.", "Onayla", "Ýptal");	
		if(!OyuncuYakin(playerid, oid, 5.0)) return  Dialog_Show(playerid, DIALOG_IS_ANAHTAR_VER, DIALOG_STYLE_INPUT, "{99C794}Ýþyeri Anahtar Ver", "{FFFFFF}Kiþiye yakýn deðilsin.{FFFFFF}Anahtar vermek istediðiniz kiþinin {3C5DA5}ID{FFFFFF} bilgisini girin.", "Onayla", "Ýptal");		
		if(Karakter[oid][IsyeriAnahtar] != -1) return Sunucu(playerid, "Girdiðiniz kiþinin zaten bir iþyeri anahtarý bulunuyor. Ýþlem iptal edildi.");
		Karakter[oid][IsyeriAnahtar] = Isyeri[isyeriid][id];
		Sunucu(playerid, "%s adlý kiþiye %d kapý numaralý iþyerinin anahtarlarýný verdin.", RPIsim(oid), Isyeri[isyeriid][id]);
		Sunucu(oid, "%s adlý kiþiden %d kapý numaralý iþyerinin anahtarlarýný aldýn.", RPIsim(playerid), Isyeri[isyeriid][id]);
		GenelMesajGonder(oid, "Artýk bu iþyerinin kilit özelliðini kullanabilirsin.");
	}
	return true;
}

CMD:isyerianahtarsifirla(playerid, params[])
{
	if(Karakter[playerid][IsyeriAnahtar] == -1) return Sunucu(playerid, "Bir iþyerinin anahtarýna sahip deðilsin. Anahtarlarýný sýfýrlayamazsýn.");
	Karakter[playerid][IsyeriAnahtar] = -1;
	Sunucu(playerid, "Sahip olduðun iþyeri anahtarýný sýfýrladýn.");
	return true;
}

Dialog:DIALOG_IS_OYUNCUYA_SAT(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		new isyeriid = IsyeriYakin(playerid);
		if(isyeriid == -1) return Sunucu(playerid, "Bir iþyerinin yakýnýnda deðilsin.");
		if(!IsyeriSahipKontrol(playerid, isyeriid)) return Sunucu(playerid, "Bu iþyeri size ait deðil.");
		if(GetPVarInt(playerid, "IsyeriSatiyor") == 1) return Sunucu(playerid, "Þu anda Ýþyerini zaten satýyorsunuz.");
		if(strval(inputtext) < 0 || strval(inputtext) > MAX_PLAYERS || !IsPlayerConnected(strval(inputtext)) || playerid == strval(inputtext)) return Dialog_Show(playerid, DIALOG_IS_OYUNCUYA_SAT, DIALOG_STYLE_INPUT, "{99C794}Ýþyeri Oyuncuya Sat", "{FFFFFF}Hatalý ID girdiniz!\n{FFFFFF}Ýþyerinizi satmak istediðiniz oyuncunun {3C5DA5}ID{FFFFFF} bilgisini girin.", "Onayla", "Ýptal");
		if(!Karakter[strval(inputtext)][Giris]) return Dialog_Show(playerid, DIALOG_IS_OYUNCUYA_SAT, DIALOG_STYLE_INPUT, "{99C794}Ýþyeri Oyuncuya Sat", "{FFFFFF}Oyuncu giriþ yapmamýþ.\n{FFFFFF}Ýþyerinizi satmak istediðiniz oyuncunun {3C5DA5}ID{FFFFFF} bilgisini girin.", "Onayla", "Ýptal");
		if(!OyuncuYakin(playerid, strval(inputtext), 6.0)) return Dialog_Show(playerid, DIALOG_IS_OYUNCUYA_SAT, DIALOG_STYLE_INPUT, "{99C794}Ýþyeri Oyuncuya Sat", "{FFFFFF}Oyuncuya yakýn deðilsin.\n{FFFFFF}Ýþyerinizi satmak istediðiniz oyuncunun {3C5DA5}ID{FFFFFF} bilgisini girin.", "Onayla", "Ýptal");
		SetPVarInt(playerid, "IsyeriSatilacakID", strval(inputtext));
		Dialog_Show(playerid, DIALOG_IS_SAT_FIYAT, DIALOG_STYLE_INPUT, "{99C794}Ýþyeri Oyuncuya Sat", "{FFFFFF}Ýþyerinizi %s(%d) adlý kiþiye satmaya karar verdiniz.\n{FFFFFF}Ýþyerinizi satmak istediðiniz fiyatý girin.", "Onayla", "Ýptal", RPIsim(GetPVarInt(playerid, "IsyeriSatilacakID")), GetPVarInt(playerid, "IsyeriSatilacakID"));
	}
	else Sunucu(playerid, "Ýþyerini oyuncuya satmaktan vazgeçtiniz.");
	return true;
}

Dialog:DIALOG_IS_SAT_FIYAT(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		new isyeriid = IsyeriYakin(playerid);
		if(isyeriid == -1) return Sunucu(playerid, "Bir iþyerinin yakýnýnda deðilsin.");
		if(!IsyeriSahipKontrol(playerid, isyeriid)) return Sunucu(playerid, "Bu iþyeri size ait deðil.");
		if(strval(inputtext) < 1 || strval(inputtext) < (Isyeri[isyeriid][Fiyat] - 50000) || strval(inputtext) > (Isyeri[isyeriid][Fiyat] + 50000)) return Dialog_Show(playerid, DIALOG_IS_SAT_FIYAT, DIALOG_STYLE_INPUT, "{99C794}Ýþyerini Oyuncuya Sat", "{FFFFFF}Fiyat geçersiz.\n{FFFFFF}Ýþyeri, emlak fiyatýnýn en fazla {3C5DA5}$50.000{FFFFFF} altýna/üstüne satýlabilir.\n{FFFFFF}Ýþyerinizi satmak istediðiniz fiyatý girin.", "Onayla", "Ýptal");
		if(!Karakter[GetPVarInt(playerid, "IsyeriSatilacakID")][Giris] || !IsPlayerConnected(GetPVarInt(playerid, "IsyeriSatilacakID"))) return Sunucu(playerid, "Ýþyerini satmaya çalýþtýðýnýz kiþi oyundan çýkmýþ görünüyor.");
		if(!OyuncuYakin(playerid, GetPVarInt(playerid, "IsyeriSatilacakID"), 6.0)) return Sunucu(playerid, "Ýþyerini satmaya çalýþtýðýnýz kiþi sizden uzaklaþmýþ.");	
		SetPVarInt(playerid, "IsyeriSatilacakFiyat", strval(inputtext));
		Dialog_Show(playerid, DIALOG_IS_SAT_ONAY, DIALOG_STYLE_MSGBOX, "{99C794}Ýþyerini Oyuncuya Sat - Onay", "{FFFFFF}Ýþyerinizi %s adlý kiþiye %s karþýlýðýnda satmak istediðinize emin misiniz?", "Onayla", "Ýptal", GetPVarInt(playerid, "IsyeriSatilacakID"), NumaraFormati(GetPVarInt(playerid, "IsyeriSatilacakFiyat")));
	}
	else
	{
		Sunucu(playerid, "Ýþyerini oyuncuya satmaktan vazgeçtiniz.");
		DeletePVar(playerid, "IsyeriSatilacakID");
	}
	return true;
}

Dialog:DIALOG_IS_SAT_ONAY(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		new isyeriid = IsyeriYakin(playerid);
		if(isyeriid == -1) return Sunucu(playerid, "Bir iþyerinin yakýnýnda deðilsin.");
		if(!IsyeriSahipKontrol(playerid, isyeriid)) return Sunucu(playerid, "Bu iþyeri size ait deðil.");
		if(!Karakter[GetPVarInt(playerid, "IsyeriSatilacakID")][Giris] || !IsPlayerConnected(GetPVarInt(playerid, "IsyeriSatilacakID"))) return Sunucu(playerid, "Ýþyerini satmaya çalýþtýðýnýz kiþi oyundan çýkmýþ görünüyor.");
		if(!OyuncuYakin(playerid, GetPVarInt(playerid, "IsyeriSatilacakID"), 6.0)) return Sunucu(playerid, "Ýþyerini satmaya çalýþtýðýnýz kiþi sizden uzaklaþmýþ.");
		new hedef = GetPVarInt(playerid, "IsyeriSatilacakID"), fiyat = GetPVarInt(playerid, "IsyeriSatilacakFiyat");
		if(Karakter[hedef][Para] < fiyat) return Sunucu(playerid, "Karþýdaki oyuncunun yeterli parasý bulunmuyor.");
		Sunucu(playerid, "Karþýdaki oyuncuya teklifiniz iletildi. Yanýt bekleniyor.");
		Isyeri[isyeriid][SatisTimer] = SetTimerEx("IsyeriSatisTimeri", 15000, false, "iii", isyeriid, hedef, playerid);
		SetPVarInt(playerid, "IsyeriSatiyor", 1);
		Sunucu(hedef, "Bir satýþ teklifi aldýn;");
		Sunucu(hedef, "%s adlý kiþi %d kapý numaralý iþyerini %s karþýlýðýnda sana satmak istiyor.", RPIsim(playerid), Isyeri[isyeriid][id], NumaraFormati(fiyat));
		Sunucu(hedef, "Kabul etmek için '/isyerikabul' yazabilirsiniz. Teklif 15 saniye içinde kendiliðinden sona erecek.");
		SetPVarInt(hedef, "IsyeriAlinacakID", playerid);
		SetPVarInt(hedef, "IsyeriAlinacakFiyat", fiyat);
		SetPVarInt(hedef, "IsyeriAlinacakisyeriid", isyeriid);
		SetPVarInt(hedef, "IsyeriTeklifiVar", 1);
	}
	else
	{
		Sunucu(playerid, "Ýþyerini oyuncuya satmaktan vazgeçtiniz.");
		DeletePVar(playerid, "IsyeriSatilacakID");
		DeletePVar(playerid, "IsyeriSatilacakFiyat");
	}
	return true;
}

CMD:isyerikabul(playerid, params[])
{
	if(GetPVarInt(playerid, "IsyeriTeklifiVar") != 1) return Sunucu(playerid, "Bir iþyeri satýþ teklifi almamýþsýn.");
	new satan = GetPVarInt(playerid, "IsyeriAlinacakID");
	if(GetPVarInt(satan, "IsyeriSatiyor") != 1) return Sunucu(playerid, "Bu kiþi bir iþyeri satmýyor. Ýþlem sonlandýrýlacak."), IsyeriSatisVeriSifirla(playerid, satan);
	new fiyat = GetPVarInt(playerid, "IsyeriAlinacakFiyat"), isyeriid = GetPVarInt(playerid, "IsyeriAlinacakID");
	if(!OyuncuYakin(satan, playerid, 6.0)) return Sunucu(playerid, "Yeterince yakýn deðilsiniz. Lütfen iþyerini satan kiþiye yaklaþýn.");
	if(Karakter[playerid][Para] < fiyat) return Sunucu(playerid, "Yeterli paranýz yok. Teklif sona ermeden para çekebilirsiniz.");
	if(!IsyeriSahipKontrol(satan, isyeriid)) return Sunucu(playerid, "Ýþyerini satan kiþi iþyerinin sahibi deðil. Ýþlem sonlandýrýlacak.");

	ParaVer(playerid, -fiyat);
	ParaVer(satan, fiyat);
	Isyeri[isyeriid][Sahip] = Karakter[playerid][id];
	format(Isyeri[isyeriid][SahipIsim], MAX_PLAYER_NAME+1, "%s", IsyeriSahipIsimCek(isyeriid));
	IsyeriTextYenile(isyeriid);
	Sunucu(satan, "%s teklifi kabul etti. %d kapý numaralý iþyeri %s karþýlýðýnda satýldý.", RPIsim(playerid), Isyeri[isyeriid][id], NumaraFormati(fiyat));
	Sunucu(playerid, "%s adlý kiþiden, %d kapý numaralý iþyerini %s karþýlýðýnda satýn aldýn. Tebrikler!", RPIsim(satan), Isyeri[isyeriid][id], NumaraFormati(fiyat));
	Log_Kaydet("loglar/isyeri_oyuncuya_satis.txt", "[%s] %s adli kisi %s adli kisiye %d kapi numarali isyerini %s karsiliginda satti.", TarihCek(), RPIsim(satan), RPIsim(playerid), isyeriid, NumaraFormati(fiyat));
	IsyeriSatisVeriSifirla(playerid, satan);
	KillTimer(Isyeri[isyeriid][SatisTimer]);
	return true;
}

Vice:IsyeriSatisTimeri(isyeriid, alan, satan)
{

	if(IsPlayerConnected(satan) && Karakter[satan][Giris])
	{
		Sunucu(satan, "Ýþyeri satýþ teklifinize yanýt gelmedi. Otomatik olarak sona erdirildi.");
	}
	if(IsPlayerConnected(alan) && Karakter[alan][Giris])
	{
		Sunucu(alan, "Teklife yanýt vermediðiniz için otomatik olarak sona erdi.");
	}
	IsyeriSatisVeriSifirla(alan, satan);
	KillTimer(Isyeri[isyeriid][SatisTimer]);
	return true;
}

Vice:IsyeriSatisVeriSifirla(alan, satan)
{
	if(IsPlayerConnected(alan) && Karakter[alan][Giris])
	{	
		DeletePVar(alan, "IsyeriAlinacakID");
		DeletePVar(alan, "IsyeriAlinacakFiyat");
		DeletePVar(alan, "IsyeriTeklifiVar");
		DeletePVar(alan, "IsyeriAlinacakisyeriid");
	}
	if(IsPlayerConnected(satan) && Karakter[satan][Giris])
	{		
		DeletePVar(satan, "IsyeriSatilacakID");
		DeletePVar(satan, "IsyeriSatilacakFiyat");
		DeletePVar(satan, "IsyeriSatiyor");
	}
	return true;
}

Dialog:DIALOG_IS_SISTEME_SAT(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		new isyeriid = IsyeriYakin(playerid);
		if(isyeriid == -1) return Sunucu(playerid, "Bir iþyerinin yakýnýnda deðilsin.");
		if(!IsyeriSahipKontrol(playerid, isyeriid)) return Sunucu(playerid, "Bu iþyeri size ait deðil.");
		new isyerifiyati = Isyeri[isyeriid][Fiyat]/2;
		ParaVer(playerid, isyerifiyati);
		Isyeri[isyeriid][Sahip] = 0;
		format(Isyeri[isyeriid][SahipIsim], MAX_PLAYER_NAME+1, "Yok");
		IsyeriTextYenile(isyeriid);
		IsyeriOrtakSifirla(isyeriid);
		Sunucu(playerid, "%s karþýlýðýnda, %d kapý numaralý iþyerini emlakçýya sattýn.", NumaraFormati(isyerifiyati), Isyeri[isyeriid][id]);
	}
	else
	{
		Sunucu(playerid, "Ýþyerini sisteme satmaktan vazgeçtiniz.");
	}
	return true;
}

Dialog:DIALOG_IS_SATIN_AL(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		new isyeriid = IsyeriYakin(playerid);
		if(isyeriid == -1) return Sunucu(playerid, "Bir iþyerinin yakýnýnda deðilsin.");
		if(Isyeri[isyeriid][Sahip] != 0) return Sunucu(playerid, "Bu iþyeri satýlýk deðil.");
		if(Karakter[playerid][Para] < Isyeri[isyeriid][Fiyat]) return Sunucu(playerid, "Bu iþyerini almak için yeterli paran yok.");
		ParaVer(playerid, -Isyeri[isyeriid][Fiyat]);
		Isyeri[isyeriid][Sahip] = Karakter[playerid][id];
		format(Isyeri[isyeriid][SahipIsim], MAX_PLAYER_NAME+1, "%s", IsyeriSahipIsimCek(isyeriid));
		Sunucu(playerid, "%s karþýlýðýnda %d kapý numaralý iþyerini satýn aldýn.", NumaraFormati(Isyeri[isyeriid][Fiyat]), Isyeri[isyeriid][id]);
		Log_Kaydet("loglar/isyeri_satin_alim.txt", "[%s] %s adli kisi %d idli isyerini %s karsiliginda satin aldi.", TarihCek(), RPIsim(playerid), isyeriid, NumaraFormati(Isyeri[isyeriid][Fiyat]));
		IsyeriTextYenile(isyeriid);
		IsyeriVeriKaydet(isyeriid);
	}
	else Sunucu(playerid, "Ýþyerini satýn almaktan vazgeçtin.");
	return true;
}

Vice:IsyeriTextYenile(isyeriid)
{
	if(IsValidDynamic3DTextLabel(Isyeri[isyeriid][Label])) DestroyDynamic3DTextLabel(Isyeri[isyeriid][Label]);
	new str[512];
	switch(Isyeri[isyeriid][Sahip])
	{
		case 0:
		{
			switch(Isyeri[isyeriid][Durum])
			{
				case 0:
				{
					format(str, sizeof(str), "{99C794}%s\n{99C794}Kapý Numarasý: {E2E2E2}%d\n{99C794}Fiyat: {E2E2E2}%d\n\n{99C794}Durum: {FFFFFF}Kilitsiz\n[/isyerial]", Isyeri[isyeriid][Adres], Isyeri[isyeriid][id], Isyeri[isyeriid][Fiyat]);
					Isyeri[isyeriid][Label] = CreateDynamic3DTextLabel(str, 0xE2B960FF, Isyeri[isyeriid][Ext][0], Isyeri[isyeriid][Ext][1], Isyeri[isyeriid][Ext][2] + 0.2, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0, 0);
				}
				case 1:
				{
					format(str, sizeof(str), "{99C794}%s\n{99C794}Kapý Numarasý: {E2E2E2}%d\n{99C794}Fiyat: {E2E2E2}%d\n\n{99C794}Durum: {E2E2E2}Kilitli\n[/isyerial]", Isyeri[isyeriid][Adres], Isyeri[isyeriid][id], Isyeri[isyeriid][Fiyat]);
					Isyeri[isyeriid][Label] = CreateDynamic3DTextLabel(str, 0xE2B960FF, Isyeri[isyeriid][Ext][0], Isyeri[isyeriid][Ext][1], Isyeri[isyeriid][Ext][2] + 0.2, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0, 0);
				}
				case 2:
				{
					format(str, sizeof(str), "{99C794}%s\n{99C794}Kapý Numarasý: {E2E2E2}%d\n{99C794}Fiyat: {E2E2E2}%d\n\n{99C794}Durum: {FF0000}Mühürlü\n[/isyerial]", Isyeri[isyeriid][Adres], Isyeri[isyeriid][id], Isyeri[isyeriid][Fiyat]);
					Isyeri[isyeriid][Label] = CreateDynamic3DTextLabel(str, 0xE2B960FF, Isyeri[isyeriid][Ext][0], Isyeri[isyeriid][Ext][1], Isyeri[isyeriid][Ext][2] + 0.2, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0, 0);
				}
				case 3:
				{
					format(str, sizeof(str), "{99C794}%s\n{99C794}Kapý Numarasý: {E2E2E2}%d\n{99C794}Fiyat: {E2E2E2}%d\n\n{99C794}Durum: {00CC00}Satýlýk\n[/isyerial]", Isyeri[isyeriid][Adres], Isyeri[isyeriid][id], Isyeri[isyeriid][Fiyat]);
					Isyeri[isyeriid][Label] = CreateDynamic3DTextLabel(str, 0xE2B960FF, Isyeri[isyeriid][Ext][0], Isyeri[isyeriid][Ext][1], Isyeri[isyeriid][Ext][2] + 0.2, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0, 0);
				}
			}
		}
		default:
		{
			format(Isyeri[isyeriid][SahipIsim], MAX_PLAYER_NAME+1, "%s", IsyeriSahipIsimCek(isyeriid));
			switch(Isyeri[isyeriid][Durum])
			{
				case 0:
				{
					format(str, sizeof(str), "{99C794}%s\n{99C794}Adres: %s\n{99C794}Kapý Numarasý: {E2E2E2}%d\n{99C794}Sahibi: {E2E2E2}%s\n{99C794}Ortak: {E2E2E2}%s\nTür: %s\n{99C794}Durum: {FFFFFF}Kilitsiz", Isyeri[isyeriid][IsyeriAd], Isyeri[isyeriid][Adres], Isyeri[isyeriid][id], Isyeri[isyeriid][SahipIsim], OrtakIsimCek(isyeriid), IsyeriTurIsim(isyeriid));
					Isyeri[isyeriid][Label] = CreateDynamic3DTextLabel(str, 0xE2B960FF, Isyeri[isyeriid][Ext][0], Isyeri[isyeriid][Ext][1], Isyeri[isyeriid][Ext][2] + 0.2, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0, 0);
				}
				case 1:
				{
					format(str, sizeof(str), "{99C794}%s\n{99C794}Adres: %s\n{99C794}Kapý Numarasý: {E2E2E2}%d\n{99C794}Sahibi: {E2E2E2}%s\n{99C794}Ortak: {E2E2E2}%s\nTür: %s\n{99C794}Durum: {E2E2E2}Kilitli", Isyeri[isyeriid][IsyeriAd], Isyeri[isyeriid][Adres], Isyeri[isyeriid][id], Isyeri[isyeriid][SahipIsim], OrtakIsimCek(isyeriid), IsyeriTurIsim(isyeriid));
					Isyeri[isyeriid][Label] = CreateDynamic3DTextLabel(str, 0xE2B960FF, Isyeri[isyeriid][Ext][0], Isyeri[isyeriid][Ext][1], Isyeri[isyeriid][Ext][2] + 0.2, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0, 0);
				}
				case 2:
				{
					format(str, sizeof(str), "{99C794}%s\n{99C794}Adres: %s\n{99C794}Kapý Numarasý: {E2E2E2}%d\n{99C794}Sahibi: {E2E2E2}%s\n{99C794}Ortak: {E2E2E2}%s\nTür: %s\n{99C794}Durum: {FF0000}Mühürlü", Isyeri[isyeriid][IsyeriAd], Isyeri[isyeriid][Adres], Isyeri[isyeriid][id], Isyeri[isyeriid][SahipIsim], OrtakIsimCek(isyeriid), IsyeriTurIsim(isyeriid));
					Isyeri[isyeriid][Label] = CreateDynamic3DTextLabel(str, 0xE2B960FF, Isyeri[isyeriid][Ext][0], Isyeri[isyeriid][Ext][1], Isyeri[isyeriid][Ext][2] + 0.2, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0, 0);
				}
				case 3:
				{
					format(str, sizeof(str), "{99C794}%s\n{99C794}Adres: %s\n{99C794}Kapý Numarasý: {E2E2E2}%d\n{99C794}Sahibi: {E2E2E2}%s\n{99C794}Ortak: {E2E2E2}%s\nTür: %s\n{99C794}Durum: {00CC00}Satýlýk", Isyeri[isyeriid][IsyeriAd], Isyeri[isyeriid][Adres], Isyeri[isyeriid][id], Isyeri[isyeriid][SahipIsim], OrtakIsimCek(isyeriid), IsyeriTurIsim(isyeriid));
					Isyeri[isyeriid][Label] = CreateDynamic3DTextLabel(str, 0xE2B960FF, Isyeri[isyeriid][Ext][0], Isyeri[isyeriid][Ext][1], Isyeri[isyeriid][Ext][2] + 0.2, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0, 0);
				}
			}
		}
	}
	return true;
}

stock OrtakIsimCek(isyeriid)
{
	new isim[MAX_PLAYER_NAME+1];
	
	new Cache:VeriCek, query[192], rows;
	mysql_format(conn, query, sizeof(query), "SELECT * FROM karakterler WHERE IsyeriOrtak = %i", Isyeri[isyeriid][id]);
	VeriCek = mysql_query(conn, query);
	cache_get_row_count(rows);
	if(rows)
	{
		new oyuncuisim[MAX_PLAYER_NAME+1];
		cache_get_value_name(0, "isim", oyuncuisim);
		format(isim, sizeof(isim), "%s", oyuncuisim);
	}
	else
	{
		format(isim, sizeof(isim), "Yok");
	}
	cache_delete(VeriCek);
	return isim;
}

stock IsyeriSahipIsimCek(isyeriid)
{
	new isim[MAX_PLAYER_NAME+1];
	switch(Isyeri[isyeriid][Sahip])
	{
		case 0: format(isim, sizeof(isim), "Yok");
		default:
		{
			new Cache:VeriCek, query[192], rows;
			mysql_format(conn, query, sizeof(query), "SELECT * FROM karakterler WHERE id = %i", Isyeri[isyeriid][Sahip]);
			VeriCek = mysql_query(conn, query);
			cache_get_row_count(rows);
			if(rows)
			{
				new oyuncuisim[MAX_PLAYER_NAME+1];
				cache_get_value_name(0, "isim", oyuncuisim);
				format(isim, sizeof(isim), "%s", oyuncuisim);
			}
			else
			{
				format(isim, sizeof(isim), "Bilinmiyor");
			}
			cache_delete(VeriCek);
		}
	}
	return isim;
}

Vice:IsyeriYarat(playerid, adres[], Float:x, Float:y, Float:z, world, interior, fiyat)
{	
	new isyeriid = IsyeriSlot();
	if(isyeriid == -1) return Sunucu(playerid, "Sunucu iþyeri limitine ulaþýldý.");
	new query[512];
	mysql_format(conn, query, sizeof(query), "INSERT INTO isyeri (isyeriid, Adres, ExtX, ExtY, ExtZ, IntX, IntY, IntZ, Interior, World, Durum, Fiyat, IcWorld, IcInterior, Sahip) VALUES (%i, '%e', %.4f, %.4f, %.4f, 0.0, 0.0, 0.0, %i, %i, 0, %i, %i, 0, 0)", isyeriid, adres, x, y, z, interior, world, fiyat, isyeriid+13000);
	mysql_query(conn, query);

	Isyeri[isyeriid][id] = isyeriid;
	Isyeri[isyeriid][Gecerli] = true;
	format(Isyeri[isyeriid][Adres], 32, "%s", adres);
	format(Isyeri[isyeriid][IsyeriAd], 32, "SATILIK");
	Isyeri[isyeriid][Ext][0] = x;
	Isyeri[isyeriid][Ext][1] = y;
	Isyeri[isyeriid][Ext][2] = z;
	Isyeri[isyeriid][World] = world;
	Isyeri[isyeriid][Interior] = interior;
	Isyeri[isyeriid][Int][0] = 0.0;
	Isyeri[isyeriid][Int][1] = 0.0;
	Isyeri[isyeriid][Int][2] = 0.0;
	Isyeri[isyeriid][Fiyat] = fiyat;
	Isyeri[isyeriid][IcWorld] = Isyeri[isyeriid][id] + 13000;
	Isyeri[isyeriid][IcInterior] = 1;
	Isyeri[isyeriid][Durum] = 0;
	Isyeri[isyeriid][Tur] = 0;
	Isyeri[isyeriid][Kasa] = 0;
	Isyeri[isyeriid][Sahip] = 0;
	Isyeri[isyeriid][OrtakDurum] = 0;
	format(Isyeri[isyeriid][SahipIsim], MAX_PLAYER_NAME+1, "Yok");

	Isyeri[isyeriid][Pickup] = CreateDynamicPickup(1239, 23, Isyeri[isyeriid][Ext][0], Isyeri[isyeriid][Ext][1], Isyeri[isyeriid][Ext][2], world, interior);
	new str[144];
	format(str, sizeof(str), "{99C794}%s\n{99C794}Kapý Numarasý: {E2E2E2}%d\n{99C794}Fiyat: {E2E2E2}%d\n\n{99C794}Durum: {FFFFFF}Kilitsiz\n[/isyerial]", Isyeri[isyeriid][Adres], Isyeri[isyeriid][id], Isyeri[isyeriid][Fiyat]);
	Isyeri[isyeriid][Label] = CreateDynamic3DTextLabel(str, 0xE2B960FF, Isyeri[isyeriid][Ext][0], Isyeri[isyeriid][Ext][1], Isyeri[isyeriid][Ext][2] + 0.2, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0, 0);
	
	Sunucu(playerid, "Ýþyeri bulunduðun noktada yaratýldý.(Adres: %s | Fiyat: %d | ID: %d)", Isyeri[isyeriid][Adres], Isyeri[isyeriid][Fiyat], Isyeri[isyeriid][id]);
	Sunucu(playerid, "Ýþyeri giriþ ve çýkýþ noktalarýný düzenlemek için /isyeriduzenle komutunu kullan.");
	return true;
}

stock IsyeriTurIsim(isyeriid)
{
	new turisim[32];
	switch(Isyeri[isyeriid][Tur])
	{
		case 1: turisim = "Market";
		case 2: turisim = "Restoran";
		case 3: turisim = "Diðer";
		default: turisim = "Yok";
	}
	return turisim;
}

Vice:IsyeriVeriKaydet(isyeriid)
{
	if(IsValidDynamicPickup(Isyeri[isyeriid][Pickup]))
		DestroyDynamicPickup(Isyeri[isyeriid][Pickup]);

	Isyeri[isyeriid][Pickup] = CreateDynamicPickup(1239, 23, Isyeri[isyeriid][Ext][0], Isyeri[isyeriid][Ext][1], Isyeri[isyeriid][Ext][2], Isyeri[isyeriid][World], Isyeri[isyeriid][Interior]);

	IsyeriTextYenile(isyeriid);

	new query[1280];
	mysql_format(conn, query, sizeof(query), "UPDATE isyeri SET Adres = '%e', ExtX = %.4f, ExtY = %.4f, ExtZ = %.4f, IntX = %.4f, IntY = %.4f, IntZ = %.4f, Interior = %i, World = %i, Durum = %i, Fiyat = %i WHERE isyeriid = %i",
		Isyeri[isyeriid][Adres],
		Isyeri[isyeriid][Ext][0],
		Isyeri[isyeriid][Ext][1],
		Isyeri[isyeriid][Ext][2],
		Isyeri[isyeriid][Int][0],
		Isyeri[isyeriid][Int][1],
		Isyeri[isyeriid][Int][2],
		Isyeri[isyeriid][Interior],
		Isyeri[isyeriid][World],
		Isyeri[isyeriid][Durum],
		Isyeri[isyeriid][Fiyat],
	Isyeri[isyeriid][id]);
	mysql_tquery(conn, query);
	mysql_format(conn, query, sizeof(query), "UPDATE isyeri SET IcWorld = %i, IcInterior = %i, Sahip = %i, OrtakDurum = %i, IsyeriAd = '%e', Tur = %i, Kasa = %i WHERE isyeriid = %i",
		Isyeri[isyeriid][IcWorld],
		Isyeri[isyeriid][IcInterior],
		Isyeri[isyeriid][Sahip],
		Isyeri[isyeriid][OrtakDurum],
		Isyeri[isyeriid][IsyeriAd],
		Isyeri[isyeriid][Tur],
		Isyeri[isyeriid][Kasa],
	Isyeri[isyeriid][id]);
	mysql_tquery(conn, query);
	return true;
}

Vice:IsyeriYukle()
{
	new rows, rowcount = 0;
	cache_get_row_count(rows);

	for(new i = 0; i < rows && MAKSIMUM_ISYERI; i++)
	{
		Isyeri[i][Gecerli] = true;

		cache_get_value_name_int(i, "isyeriid", Isyeri[i][id]);

		cache_get_value_name(i, "Adres", Isyeri[i][Adres], 32);
		cache_get_value_name(i, "IsyeriAd", Isyeri[i][IsyeriAd], 32);

		cache_get_value_name_float(i, "ExtX", Isyeri[i][Ext][0]);
		cache_get_value_name_float(i, "ExtY", Isyeri[i][Ext][1]);
		cache_get_value_name_float(i, "ExtZ", Isyeri[i][Ext][2]);

		cache_get_value_name_float(i, "IntX", Isyeri[i][Int][0]);
		cache_get_value_name_float(i, "IntY", Isyeri[i][Int][1]);
		cache_get_value_name_float(i, "IntZ", Isyeri[i][Int][2]);

		cache_get_value_name_int(i, "Interior", Isyeri[i][Interior]);
		cache_get_value_name_int(i, "World", Isyeri[i][World]);

		cache_get_value_name_int(i, "IcWorld", Isyeri[i][IcWorld]);
		cache_get_value_name_int(i, "IcInterior", Isyeri[i][IcInterior]);
		cache_get_value_name_int(i, "Tur", Isyeri[i][Tur]);
		cache_get_value_name_int(i, "Kasa", Isyeri[i][Kasa]);

		cache_get_value_name_int(i, "Durum", Isyeri[i][Durum]);
		cache_get_value_name_int(i, "Fiyat", Isyeri[i][Fiyat]);
		cache_get_value_name_int(i, "Sahip", Isyeri[i][Sahip]);

		cache_get_value_name_int(i, "OrtakDurum", Isyeri[i][OrtakDurum]);

		Isyeri[i][Pickup] = CreateDynamicPickup(1239, 23, Isyeri[i][Ext][0], Isyeri[i][Ext][1], Isyeri[i][Ext][2], Isyeri[i][World], Isyeri[i][Interior]);
		rowcount++;
	}
	for(new i = 0; i < rows && MAKSIMUM_ISYERI; i++)
	{
		IsyeriTextYenile(i);
	}
	printf("[MySQL] Veritabanýndan '%i' adet iþyeri yüklendi.", rowcount);
	return true;
}

Vice:IsyeriSil(playerid, isyeriid)
{
	if(IsValidDynamicPickup(Isyeri[isyeriid][Pickup])) DestroyDynamicPickup(Isyeri[isyeriid][Pickup]);
	if(IsValidDynamic3DTextLabel(Isyeri[isyeriid][Label])) DestroyDynamic3DTextLabel(Isyeri[isyeriid][Label]);
	Isyeri[isyeriid][Gecerli] = false;

	new query[128];
	mysql_format(conn, query, sizeof(query), "DELETE FROM isyeri WHERE isyeriid = '%i'", Isyeri[isyeriid][id]);
	mysql_tquery(conn, query);
	IsyeriOrtakSifirla(isyeriid);

	Sunucu(playerid, "Bir iþyeri sildiniz.");
	return true;
}

Vice:IsyeriAnahtarSifirla(isyeriid)
{
	new Cache:VeriCek, rows, query[144];
	mysql_format(conn, query, sizeof(query), "SELECT * FROM karakterler WHERE IsyeriAnahtar = %i", Isyeri[isyeriid][id]);
	VeriCek = mysql_query(conn, query);
	cache_get_row_count(rows);
	if(rows)
	{
		new charid;
		cache_get_value_name_int(0, "id", charid);
		cache_delete(VeriCek);
		mysql_format(conn, query, sizeof(query), "UPDATE karakterler SET IsyeriAnahtar = '-1' WHERE id = %i", charid);
		mysql_query(conn, query);
		foreach(new i : Player)
		{
			if(Karakter[i][IsyeriAnahtar] == Isyeri[isyeriid][id])
			{
				Karakter[i][IsyeriAnahtar] = -1;
			}
		}
	}
	else cache_delete(VeriCek);
}

Vice:IsyeriOrtakSifirla(isyeriid)
{
	new Cache:VeriCek, rows, query[144];
	Isyeri[isyeriid][OrtakDurum] = 0;
	IsyeriVeriKaydet(isyeriid);
	mysql_format(conn, query, sizeof(query), "SELECT * FROM karakterler WHERE IsyeriOrtak = %i", Isyeri[isyeriid][id]);
	VeriCek = mysql_query(conn, query);
	cache_get_row_count(rows);
	if(rows)
	{
		new charid;
		cache_get_value_name_int(0, "id", charid);
		cache_delete(VeriCek);
		mysql_format(conn, query, sizeof(query), "UPDATE karakterler SET IsyeriOrtak = '-1' WHERE id = %i", charid);
		mysql_query(conn, query);
		foreach(new i : Player)
		{
			if(Karakter[i][IsyeriOrtak] == Isyeri[isyeriid][id])
			{
				Karakter[i][IsyeriOrtak] = -1;
			}
		}
	}
	else cache_delete(VeriCek);
	return true;
}

Vice:IsyeriSlot()
{
	new isyeriid = -1;
	for(new i = 0; i < MAKSIMUM_ISYERI; i++)
	{
		if(Isyeri[i][Gecerli] == true) continue;
		isyeriid = i; break;
	}
	return isyeriid;
}

Vice:IsyeriYakin(playerid)
{
	new deger = -1;
	for(new i = 0; i < MAKSIMUM_ISYERI; i++)
	{
		if(Isyeri[i][Gecerli] == true)
		{
			if(IsPlayerInRangeOfPoint(playerid, 2.0, Isyeri[i][Ext][0], Isyeri[i][Ext][1], Isyeri[i][Ext][2]) && GetPlayerVirtualWorld(playerid) == Isyeri[i][World] && GetPlayerInterior(playerid) == Isyeri[i][Interior])
			{
				deger = i;
				return deger;
			}
		}
	}
	return deger;
}

Vice:IsyeriIcYakin(playerid)
{
	new deger = -1;
	for(new i = 0; i < MAKSIMUM_ISYERI; i++)
	{
		if(Isyeri[i][Gecerli] == true)
		{
			if(IsPlayerInRangeOfPoint(playerid, 2.0, Isyeri[i][Int][0], Isyeri[i][Int][1], Isyeri[i][Int][2]) && GetPlayerVirtualWorld(playerid) == Isyeri[i][IcWorld] && GetPlayerInterior(playerid) == Isyeri[i][IcInterior])
			{
				deger = i;
				return deger;
			}
		}
	}
	return deger;
}

Vice:IsyeriIcinde(playerid)
{
	new deger = -1;
	for(new i = 0; i < MAKSIMUM_ISYERI; i++)
	{
		if(Isyeri[i][Gecerli] == true)
		{
			if(GetPlayerVirtualWorld(playerid) == Isyeri[i][IcWorld] || GetPlayerInterior(playerid) == Isyeri[i][IcInterior])
			{
				deger = i;
				return deger;
			}
		}
	}
	return deger;
}

Vice:IsyeriSahipKontrol(playerid, isyeriid)
{
	new onay = 0;
	if(Karakter[playerid][id] == Isyeri[isyeriid][Sahip])
	{
		onay = 1;
	}
	return onay;
}