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
				strcat(dialogstr, "�r�n\t�cret\n");
				strcat(dialogstr, "Telefon\t$250\n");
				strcat(dialogstr, "Sim Kart\t$50\n");
				strcat(dialogstr, "Sigara Paketi\t$20\n");
				Dialog_Show(playerid, DIALOG_MARKET_SATINAL, DIALOG_STYLE_TABLIST_HEADERS, "{99C794}Market", dialogstr, "Sat�n Al", "�ptal");
			}
		}
	}
	else Sunucu(playerid, "Bir i�yerinde de�ilsin.");
	return true;
}

Dialog:DIALOG_MARKET_SATINAL(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		if(IsyeriIcinde(playerid) == -1) return Sunucu(playerid, "Bir i�yerinde de�ilsiniz.");
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
				Sunucu(playerid, "$250 kar��l���nda telefon sat�n ald�n�z.");
			}
			case 1:
			{
				if(Karakter[playerid][Para] < 50) return YetersizPara(playerid);
				if(Karakter[playerid][TelefonNumarasi] != 0) return Sunucu(playerid, "Zaten bir sim kart�n�z bulunuyor. Yenisini alamazs�n�z.");
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
				Sunucu(playerid, "Bir sigara paketi sat�n ald�n�z. ��inde 20 dal sigara var.");
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
		Sunucu(playerid, "Sim kart sat�n ald�n�z. Yeni telefon numaran�z %d olarak belirlendi.", telno);
	}
	return true;
}
// Y�NET�C�

CMD:isyeriyarat(playerid, params[])
{
	if(Hesap[playerid][Yonetici] < 5) return YetersizYetki(playerid);

	new isyerifiyati, isyeriadresi[32], Float:x, Float:y, Float:z, interior = GetPlayerInterior(playerid), world = GetPlayerVirtualWorld(playerid);
	if(sscanf(params, "ds[32]", isyerifiyati, isyeriadresi)) return Kullanim(playerid, "/isyeriyarat [fiyat] [adres]");
	if(strlen(isyeriadresi) < 1 || strlen(isyeriadresi) > 32) return Sunucu(playerid, "Girdi�in adres 1-32 karakter aras�nda olmal�.");

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
		Kullanim(playerid, "/isyeriduzenle [id] [se�enek]");
		GenelMesajGonder(playerid, "isim, adres, fiyat, tur, sahip, dispos, icpos, kasa");
		return true;
	}

	if(!Isyeri[isyeriid][Gecerli]) return Sunucu(playerid, "Ge�ersiz id girdiniz.");
	if(!strcmp(secenek, "isim", true))
	{
		new isim[32];
		if(sscanf(ekstra, "s[32]", isim)) return Sunucu(playerid, "/isyeriduzenle [id] isim [yeni isim(32)]");
		if(strlen(isim) < 1 || strlen(isim) > 32) return Sunucu(playerid, "Minimum 1-32 karakter aras� bir isim girmelisiniz.");

		new isyeriismi[32];
		format(isyeriismi, 32, "%s", isim);
		Isyeri[isyeriid][IsyeriAd] = isyeriismi;
		IsyeriVeriKaydet(isyeriid);
		IsyeriTextYenile(isyeriid);
		Sunucu(playerid, "%d id'li i�yerinin ismini %s olarak de�i�tirdiniz.", isyeriid, Isyeri[isyeriid][IsyeriAd]);
	}
	else if(!strcmp(secenek, "kasa", true))
	{
		new yenideger;
		if(sscanf(ekstra, "d", yenideger)) return Kullanim(playerid, "/isyeriduzenle [id] kasa [yeni para de�eri]");
		if(yenideger < 0) return Sunucu(playerid, "Kasadaki para en az 0 olmal�d�r.");

		Isyeri[isyeriid][Kasa] = yenideger;
		IsyeriVeriKaydet(isyeriid);
		Sunucu(playerid, "%d id'li i�yerinin kasas�ndaki paray� %s olarak de�i�tirdiniz.", isyeriid, NumaraFormati(yenideger));
	}
	else if(!strcmp(secenek, "tur", true))
	{
		new tur;
		if(sscanf(ekstra, "d", tur)) 
		{
			Sunucu(playerid, "/isyeriduzenle [id] tur [yeni t�r]");
			GenelMesajGonder(playerid, "T�rler: 1 - Market | 2 - Restoran | 3 - Di�er");
			return true;
		}
		if(tur < 1 || tur > 3) return Sunucu(playerid, "Ge�ersiz t�r.");
		Isyeri[isyeriid][Tur] = tur;
		IsyeriVeriKaydet(isyeriid);
		IsyeriTextYenile(isyeriid);
		Sunucu(playerid, "%d id'li i�yerinin t�r�n� %s olarak de�i�tirdiniz.", isyeriid, IsyeriTurIsim(isyeriid));
	}
	else if(!strcmp(secenek, "adres", true))
	{
		new adres[32];
		if(sscanf(ekstra, "s[32]", adres)) return Sunucu(playerid, "/isyeriduzenle [id] adres [yeni adres(32)]");
		if(strlen(adres) < 1 || strlen(adres) > 32) return Sunucu(playerid, "Minimum 1-32 karakter aras� bir adres girmelisiniz.");

		new isyeriadresi[32];
		format(isyeriadresi, 32, "%s", adres);
		Isyeri[isyeriid][Adres] = isyeriadresi;
		IsyeriVeriKaydet(isyeriid);
		IsyeriTextYenile(isyeriid);
		Sunucu(playerid, "%d id'li i�yerinin adresini %s olarak de�i�tirdiniz.", isyeriid, Isyeri[isyeriid][Adres]);
	}
	else if(!strcmp(secenek, "fiyat", true))
	{
		new fiyat;
		if(sscanf(ekstra, "d", fiyat)) return Kullanim(playerid, "/isyeriduzenle [id] fiyat [yeni fiyat]");
		if(fiyat < 1) return Kullanim(playerid, "1'den b�y�k bir fiyat girmelisin.");
		Isyeri[isyeriid][Fiyat] = fiyat;
		IsyeriVeriKaydet(isyeriid);
		IsyeriTextYenile(isyeriid);
		Sunucu(playerid, "%d id'li i�yerinin fiyat�n� $%d olarak de�i�tirdiniz.", isyeriid, Isyeri[isyeriid][Fiyat]);
	}
	else if(!strcmp(secenek, "sahip", true))
	{
		new sahip;
		if(sscanf(ekstra, "d", sahip))
		{
			Kullanim(playerid, "/isyeriduzenle [id] sahip [sahip id]");
			GenelMesajGonder(playerid, "Sahibi kald�rmak i�in -1 girebilirsin.");
			return true;
		}
		if(sahip != -1)
		{
			if(!IsPlayerConnected(sahip)) return Sunucu(playerid, "Ki�i oyunda bulunamad�.");
			if(Karakter[sahip][Giris] == false) return Sunucu(playerid, "Ki�i hen�z giri� yapmam��.");
			Isyeri[isyeriid][Sahip] = Karakter[sahip][id];
			format(Isyeri[isyeriid][SahipIsim], MAX_PLAYER_NAME+1, "%s", IsyeriSahipIsimCek(isyeriid));
			IsyeriTextYenile(isyeriid);
			IsyeriVeriKaydet(isyeriid);
			Sunucu(playerid, "%d id'li i�yerinin sahibini %s olarak de�i�tirdiniz.", isyeriid, RPIsim(sahip));
		}
		else
		{
			Isyeri[isyeriid][Sahip] = 0;
			format(Isyeri[isyeriid][SahipIsim], MAX_PLAYER_NAME+1, "Yok");
			IsyeriTextYenile(isyeriid);
			IsyeriVeriKaydet(isyeriid);
			Sunucu(playerid, "%d id'li i�yerinin sahibini kald�rd�n�z. ��yeri sisteme sat�l�k.", isyeriid);
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
		Sunucu(playerid, "%d id'li i�yerinin d�� konumunu de�i�tirdin.(World: %d | Interior: %d)", world, interior);
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
		Sunucu(playerid, "%d id'li i�yerinin i� konumunu de�i�tirdin.(World: %d | Interior: %d)", isyeriid, world, interior);
	}
	else if(!strcmp(secenek, "durum", true))
	{
		new durum;
		if(sscanf(ekstra, "d", durum))
		{
			Kullanim(playerid, "/isyeriduzenle [id] durum [yeni durum]");
			GenelMesajGonder(playerid, "Durumlar: 1 - Kilitsiz | 2 - Kilitli | 3 - M�h�rl�");
			return true;
		}
		if(durum < 1 || durum > 3) return Sunucu(playerid, "Hatal� durum girdin.");
		Isyeri[isyeriid][Durum] = durum;
		IsyeriTextYenile(isyeriid);
		Sunucu(playerid, "%d id'li i�yerinin giri� durumunu %d olarak de�i�tirdin.");
	}
	else Sunucu(playerid, "Hatal� parametre girdin.");

	return true;
}

CMD:isyerlerim(playerid, params[])
{
	new dialogstr[1024], isyerisayi = 0;
	strcat(dialogstr, "��yeri �smi\tKap� Numaras�\n");
	for(new i = 0; i < MAKSIMUM_ISYERI; i++)
	{
		if(!Isyeri[i][Gecerli]) continue;
		if(Isyeri[i][Sahip] == Karakter[playerid][id])
		{
			Karakter[playerid][IsyeriIsaretID][isyerisayi] = Isyeri[i][id];
			format(dialogstr, sizeof(dialogstr), "%s{FFFFFF}�sim: {3C5DA5}%s{FFFFFF}\tKap� Numaras�: {3C5DA5}%d\n", dialogstr, Isyeri[i][IsyeriAd], Isyeri[i][id]);
			isyerisayi++;
		}
	}
	if(isyerisayi == 0) return Sunucu(playerid, "�st�n�ze kay�tl� i�yeri bulunamad�.");
	Dialog_Show(playerid, DIALOG_ISYERLERIM, DIALOG_STYLE_TABLIST_HEADERS, "{99C794}��yeri Listesi", dialogstr, "��aretle", "�ptal");
	return true;
}

Dialog:DIALOG_ISYERLERIM(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		DisablePlayerCheckpoint(playerid);
		new isyeriid = Karakter[playerid][IsyeriIsaretID][listitem];
		SetPlayerCheckpoint(playerid, Isyeri[isyeriid][Ext][0], Isyeri[isyeriid][Ext][1], Isyeri[isyeriid][Ext][2], 5.0);
		Sunucu(playerid, "%d kap� numaral� i�yerinizi i�aretlediniz.", Isyeri[isyeriid][id]);
	}
	return true;
}

CMD:isyerisil(playerid, params[])
{
	if(Hesap[playerid][Yonetici] < 5) return YetersizYetki(playerid);
	new isyeriid;
	if(sscanf(params, "d", isyeriid)) return Kullanim(playerid, "/isyerisil [isyeriid]");
	if(!Isyeri[isyeriid][Gecerli]) return Sunucu(playerid, "Ge�ersiz id girdiniz.");
	IsyeriSil(playerid, isyeriid);
	return true;
}

CMD:isyerial(playerid, params[])
{
	if(IsyeriYakin(playerid) != -1)
	{
		new isyeriid = IsyeriYakin(playerid);
		if(Isyeri[isyeriid][Sahip] != 0) return Sunucu(playerid, "Bu i�yeri sat�l�k de�il.");
		if(Karakter[playerid][Para] < Isyeri[isyeriid][Fiyat]) return Sunucu(playerid, "Bu i�yerini almak i�in yeterli paran yok.");
		Dialog_Show(playerid, DIALOG_IS_SATIN_AL, DIALOG_STYLE_MSGBOX, "{99C794}��yeri Sat�n Al", "{3C5DA5}%s{FFFFFF} kar��l���nda bu i�yerini sat�n almak istedi�ine emin misin?", "Onayla", "�ptal", NumaraFormati(Isyeri[isyeriid][Fiyat]));
	}
	else
	{
		Sunucu(playerid, "Bir i�yerinin yak�n�nda de�ilsin.");
	}
	return true;
}

CMD:isyeri(playerid, params[])
{
	if(IsyeriYakin(playerid) != -1)
	{
		new isyeriid = IsyeriYakin(playerid);
		if(!IsyeriSahipKontrol(playerid, isyeriid)) return Sunucu(playerid, "Bu i�yeri size ait de�il.");
		new str[1024];
		strcat(str, "Se�enek\tA��klama\n");
		strcat(str, "{3C5DA5}Kap� Kilidi\t{FFFFFF}Kap�n�n kilidini a�mak/kapatmak i�in kullanabilirsiniz.\n");
		strcat(str, "{3C5DA5}��yeri Oyuncuya Sat\t{FFFFFF}��yerini ba�ka bir oyuncuya belli bir fiyat kar��l��� satabilirsiniz.\n");
		strcat(str, "{3C5DA5}��yeri Sisteme Sat\t{FFFFFF}��yerini sisteme satmak i�in kullanabilirsiniz.\n");
		strcat(str, "{3C5DA5}��yeri Anahtar� Ver\t{FFFFFF}��yeri anahtar�na sahip ki�iler kap� kilidini kontrol edebilir.\n");
		strcat(str, "{3C5DA5}Ortak Ekle\t{FFFFFF}��yerinize yaln�zca bir ortak ekleyebilirsiniz.\n");
		strcat(str, "{3C5DA5}��yeri �sim De�i�tir\t{FFFFFF}��yerinizin ismini 32 karaktere kadar bir isimle de�i�tirebilirsiniz.\n");
		strcat(str, "{3C5DA5}Kasadan Para �ek\t{FFFFFF}Kasada bulunan paran�n t�m�n� �ekmek i�in kullanabilirsiniz.\n");
		Dialog_Show(playerid, DIALOG_IS_MENU, DIALOG_STYLE_TABLIST_HEADERS, "{99C794}��yeri Men�s�", str, "Se�", "�ptal");
	}
	else Sunucu(playerid, "Bir i�yerinin yak�n�nda de�ilsin.");
	return true;
}

Dialog:DIALOG_IS_MENU(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		new isyeriid = IsyeriYakin(playerid);
		if(isyeriid == -1) return Sunucu(playerid, "Bir i�yerinin yak�n�nda de�ilsin.");
		if(!IsyeriSahipKontrol(playerid, isyeriid)) return Sunucu(playerid, "Bu i�yeri size ait de�il.");
		switch(listitem)
		{
			case 0:
			{
				switch(Isyeri[isyeriid][Durum])
				{
					case 0:
					{
						Isyeri[isyeriid][Durum] = 1;
						Sunucu(playerid, "��yeri kap�s�n� kilitlediniz.");
						IsyeriTextYenile(isyeriid);
					}
					case 1:
					{
						Isyeri[isyeriid][Durum] = 0;
						Sunucu(playerid, "��yeri kap�s�n�n kilidini a�t�n�z.");
						IsyeriTextYenile(isyeriid);
					}
					default:
					{
						Sunucu(playerid, "Bu i�yerinin kap�s�na m�dahale edemezsiniz.");
					}
				}
			}
			case 1:
			{
				Dialog_Show(playerid, DIALOG_IS_OYUNCUYA_SAT, DIALOG_STYLE_INPUT, "{99C794}��yeri Oyuncuya Sat", "{FFFFFF}��yerinizi satmak istedi�iniz oyuncunun {3C5DA5}ID{FFFFFF} bilgisini girin.", "Onayla", "�ptal");
			}
			case 2:
			{
				if(GetPVarInt(playerid, "IsyeriSatiyor") == 1) return Sunucu(playerid, "��yeri sat�� i�lemi s�ras�nda bunu yapamazs�n�z.");
				Dialog_Show(playerid, DIALOG_IS_SISTEME_SAT, DIALOG_STYLE_MSGBOX, "{99C794}��yeri Sisteme Sat", "{FFFFFF}��yerinizi {3C5DA5}%s{FFFFFF} kar��l���nda sisteme satmak istedi�inize emin misiniz?", "Onayla", "�ptal", NumaraFormati(Isyeri[isyeriid][Fiyat]/2));
			}
			case 3:
			{
				Dialog_Show(playerid, DIALOG_IS_ANAHTAR_VER, DIALOG_STYLE_INPUT, "{99C794}��yeri Anahtar Ver", "{FFFFFF}Anahtar vermek istedi�iniz ki�inin {3C5DA5}ID{FFFFFF} bilgisini girin.", "Onayla", "�ptal");	
			}
			case 4:
			{
				Dialog_Show(playerid, DIALOG_IS_ORTAK_EKLE, DIALOG_STYLE_INPUT, "{99C794}��yeri Ortak Ekle", "{FFFFFF}Ortak eklemek istedi�iniz ki�inin {3C5DA5}ID{FFFFFF} bilgisini girin.", "Onayla", "�ptal");
			}
			case 5:
			{
				Dialog_Show(playerid, DIALOG_IS_ISIM_DEGISTIR, DIALOG_STYLE_INPUT, "{99C794}��yeri �sim De�i�tir", "{FFFFFF}��yerinizin olmas�n� istedi�iniz yeni ismini girin.\nMaksimum 32, minimum 1 karakter girmelisiniz.", "Onayla", "�ptal");
			}
			case 6:
			{
				Dialog_Show(playerid, DIALOG_IS_KASACEK, DIALOG_STYLE_INPUT, "{99C794}Kasadan Para �ek", "{FFFFFF}��yerinizin kasas�nda %s bulunuyor.\n�ekmek istedi�iniz para miktar�n� girin.", "�ek", "�ptal", NumaraFormati(Isyeri[isyeriid][Kasa]));
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
		if(isyeriid == -1) return Sunucu(playerid, "Bir i�yerinin yak�n�nda de�ilsin.");
		if(!IsyeriSahipKontrol(playerid, isyeriid)) return Sunucu(playerid, "Bu i�yeri size ait de�il.");
		if(strval(inputtext) < 1) return Sunucu(playerid, "Ge�ersiz para miktar� girdiniz.");
		if(strval(inputtext) > Isyeri[isyeriid][Kasa]) return Sunucu(playerid, "��yeri kasas�nda bu kadar para bulunmuyor.");
		Isyeri[isyeriid][Kasa] -= strval(inputtext);
		IsyeriVeriKaydet(isyeriid);
		ParaVer(playerid, strval(inputtext));
		Sunucu(playerid, "��yeri kasas�ndan %s �ektiniz. Kasada %s kald�.", NumaraFormati(strval(inputtext)), Isyeri[isyeriid][Kasa]);
	}
	return true;
}

Dialog:DIALOG_IS_ISIM_DEGISTIR(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		new isyeriid = IsyeriYakin(playerid);
		if(isyeriid == -1) return Sunucu(playerid, "Bir i�yerinin yak�n�nda de�ilsin.");
		if(!IsyeriSahipKontrol(playerid, isyeriid)) return Sunucu(playerid, "Bu i�yeri size ait de�il.");
		if(strlen(inputtext) < 1 || strlen(inputtext) > 32 || isnull(inputtext)) return Dialog_Show(playerid, DIALOG_IS_ISIM_DEGISTIR, DIALOG_STYLE_INPUT, "{99C794}��yeri �sim De�i�tir", "{FFFFFF}Hatal� isim.\n{FFFFFF}��yerinizin olmas�n� istedi�iniz yeni ismini girin.\nMaksimum 32, minimum 1 karakter girmelisiniz.", "Onayla", "�ptal");
		format(Isyeri[isyeriid][IsyeriAd], 32, "%s", inputtext);
		IsyeriVeriKaydet(isyeriid);
		IsyeriTextYenile(isyeriid);
		Sunucu(playerid, "��yeri ismi '%s' olarak de�i�tirildi.", Isyeri[isyeriid][IsyeriAd]);
	}
	return true;
}

Dialog:DIALOG_IS_ORTAK_EKLE(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		new isyeriid = IsyeriYakin(playerid);
		if(isyeriid == -1) return Sunucu(playerid, "Bir i�yerinin yak�n�nda de�ilsin.");
		if(!IsyeriSahipKontrol(playerid, isyeriid)) return Sunucu(playerid, "Bu i�yeri size ait de�il.");
		new oid = strval(inputtext);
		if(Isyeri[isyeriid][OrtakDurum] == 1) return Sunucu(playerid, "��yerinizin zaten bir orta�� bulunuyor. Ayn� anda bir ortak eklenebilir.");
		if(playerid == oid) return Sunucu(playerid, "Kendinizi ortak ekleyemezsiniz.");
		if(!IsPlayerConnected(oid) || !Karakter[oid][Giris]) return Dialog_Show(playerid, DIALOG_IS_ORTAK_EKLE, DIALOG_STYLE_INPUT, "{99C794}��yeri Ortak Ekle", "{FFFFFF}Ge�ersiz ID girdiniz.\n{FFFFFF}Ortak eklemek istedi�iniz ki�inin {3C5DA5}ID{FFFFFF} bilgisini girin.", "Onayla", "�ptal");
		if(!OyuncuYakin(playerid, oid, 5.0)) return Dialog_Show(playerid, DIALOG_IS_ORTAK_EKLE, DIALOG_STYLE_INPUT, "{99C794}��yeri Ortak Ekle", "{FFFFFF}Bu ki�iye yak�n de�ilsin.\n{FFFFFF}Ortak eklemek istedi�iniz ki�inin {3C5DA5}ID{FFFFFF} bilgisini girin.", "Onayla", "�ptal");
		if(Karakter[oid][IsyeriOrtak] != -1) return Sunucu(playerid, "Girdi�iniz ki�i zaten bir i�yerinin orta��. ��lem iptal edildi.");
		Karakter[oid][IsyeriOrtak] = Isyeri[isyeriid][id];
		KarakterVeriKaydet(oid);
		Isyeri[isyeriid][OrtakDurum] = 1;
		IsyeriVeriKaydet(isyeriid);
		IsyeriTextYenile(isyeriid);
		Sunucu(playerid, "%s adl� ki�iyi %d kap� numaral� i�yerine ortak olarak ekledin.", RPIsim(oid), Isyeri[isyeriid][id]);
		Sunucu(oid, "%s adl� ki�i taraf�ndan %d kap� numaral� i�yerine ortak olarak eklendin.", RPIsim(playerid), Isyeri[isyeriid][id]);
		GenelMesajGonder(oid, "Art�k bu i�yerinin kilit ve dekorasyon �zelliklerini kullanabilirsin.");
	}
	return true;
}

Dialog:DIALOG_IS_ANAHTAR_VER(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		new isyeriid = IsyeriYakin(playerid);
		if(isyeriid == -1) return Sunucu(playerid, "Bir i�yerinin yak�n�nda de�ilsin.");
		if(!IsyeriSahipKontrol(playerid, isyeriid)) return Sunucu(playerid, "Bu i�yeri size ait de�il.");
		new oid = strval(inputtext);
		if(playerid == oid) return Dialog_Show(playerid, DIALOG_IS_ANAHTAR_VER, DIALOG_STYLE_INPUT, "{99C794}��yeri Anahtar Ver", "{FFFFFF}Kendinize anahtar veremezsiniz.{FFFFFF}Anahtar vermek istedi�iniz ki�inin {3C5DA5}ID{FFFFFF} bilgisini girin.", "Onayla", "�ptal");	
		if(!IsPlayerConnected(oid) || !Karakter[oid][Giris]) return Dialog_Show(playerid, DIALOG_IS_ANAHTAR_VER, DIALOG_STYLE_INPUT, "{99C794}��yeri Anahtar Ver", "{FFFFFF}Oyuncu bulunamad�.{FFFFFF}Anahtar vermek istedi�iniz ki�inin {3C5DA5}ID{FFFFFF} bilgisini girin.", "Onayla", "�ptal");	
		if(!OyuncuYakin(playerid, oid, 5.0)) return  Dialog_Show(playerid, DIALOG_IS_ANAHTAR_VER, DIALOG_STYLE_INPUT, "{99C794}��yeri Anahtar Ver", "{FFFFFF}Ki�iye yak�n de�ilsin.{FFFFFF}Anahtar vermek istedi�iniz ki�inin {3C5DA5}ID{FFFFFF} bilgisini girin.", "Onayla", "�ptal");		
		if(Karakter[oid][IsyeriAnahtar] != -1) return Sunucu(playerid, "Girdi�iniz ki�inin zaten bir i�yeri anahtar� bulunuyor. ��lem iptal edildi.");
		Karakter[oid][IsyeriAnahtar] = Isyeri[isyeriid][id];
		Sunucu(playerid, "%s adl� ki�iye %d kap� numaral� i�yerinin anahtarlar�n� verdin.", RPIsim(oid), Isyeri[isyeriid][id]);
		Sunucu(oid, "%s adl� ki�iden %d kap� numaral� i�yerinin anahtarlar�n� ald�n.", RPIsim(playerid), Isyeri[isyeriid][id]);
		GenelMesajGonder(oid, "Art�k bu i�yerinin kilit �zelli�ini kullanabilirsin.");
	}
	return true;
}

CMD:isyerianahtarsifirla(playerid, params[])
{
	if(Karakter[playerid][IsyeriAnahtar] == -1) return Sunucu(playerid, "Bir i�yerinin anahtar�na sahip de�ilsin. Anahtarlar�n� s�f�rlayamazs�n.");
	Karakter[playerid][IsyeriAnahtar] = -1;
	Sunucu(playerid, "Sahip oldu�un i�yeri anahtar�n� s�f�rlad�n.");
	return true;
}

Dialog:DIALOG_IS_OYUNCUYA_SAT(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		new isyeriid = IsyeriYakin(playerid);
		if(isyeriid == -1) return Sunucu(playerid, "Bir i�yerinin yak�n�nda de�ilsin.");
		if(!IsyeriSahipKontrol(playerid, isyeriid)) return Sunucu(playerid, "Bu i�yeri size ait de�il.");
		if(GetPVarInt(playerid, "IsyeriSatiyor") == 1) return Sunucu(playerid, "�u anda ��yerini zaten sat�yorsunuz.");
		if(strval(inputtext) < 0 || strval(inputtext) > MAX_PLAYERS || !IsPlayerConnected(strval(inputtext)) || playerid == strval(inputtext)) return Dialog_Show(playerid, DIALOG_IS_OYUNCUYA_SAT, DIALOG_STYLE_INPUT, "{99C794}��yeri Oyuncuya Sat", "{FFFFFF}Hatal� ID girdiniz!\n{FFFFFF}��yerinizi satmak istedi�iniz oyuncunun {3C5DA5}ID{FFFFFF} bilgisini girin.", "Onayla", "�ptal");
		if(!Karakter[strval(inputtext)][Giris]) return Dialog_Show(playerid, DIALOG_IS_OYUNCUYA_SAT, DIALOG_STYLE_INPUT, "{99C794}��yeri Oyuncuya Sat", "{FFFFFF}Oyuncu giri� yapmam��.\n{FFFFFF}��yerinizi satmak istedi�iniz oyuncunun {3C5DA5}ID{FFFFFF} bilgisini girin.", "Onayla", "�ptal");
		if(!OyuncuYakin(playerid, strval(inputtext), 6.0)) return Dialog_Show(playerid, DIALOG_IS_OYUNCUYA_SAT, DIALOG_STYLE_INPUT, "{99C794}��yeri Oyuncuya Sat", "{FFFFFF}Oyuncuya yak�n de�ilsin.\n{FFFFFF}��yerinizi satmak istedi�iniz oyuncunun {3C5DA5}ID{FFFFFF} bilgisini girin.", "Onayla", "�ptal");
		SetPVarInt(playerid, "IsyeriSatilacakID", strval(inputtext));
		Dialog_Show(playerid, DIALOG_IS_SAT_FIYAT, DIALOG_STYLE_INPUT, "{99C794}��yeri Oyuncuya Sat", "{FFFFFF}��yerinizi %s(%d) adl� ki�iye satmaya karar verdiniz.\n{FFFFFF}��yerinizi satmak istedi�iniz fiyat� girin.", "Onayla", "�ptal", RPIsim(GetPVarInt(playerid, "IsyeriSatilacakID")), GetPVarInt(playerid, "IsyeriSatilacakID"));
	}
	else Sunucu(playerid, "��yerini oyuncuya satmaktan vazge�tiniz.");
	return true;
}

Dialog:DIALOG_IS_SAT_FIYAT(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		new isyeriid = IsyeriYakin(playerid);
		if(isyeriid == -1) return Sunucu(playerid, "Bir i�yerinin yak�n�nda de�ilsin.");
		if(!IsyeriSahipKontrol(playerid, isyeriid)) return Sunucu(playerid, "Bu i�yeri size ait de�il.");
		if(strval(inputtext) < 1 || strval(inputtext) < (Isyeri[isyeriid][Fiyat] - 50000) || strval(inputtext) > (Isyeri[isyeriid][Fiyat] + 50000)) return Dialog_Show(playerid, DIALOG_IS_SAT_FIYAT, DIALOG_STYLE_INPUT, "{99C794}��yerini Oyuncuya Sat", "{FFFFFF}Fiyat ge�ersiz.\n{FFFFFF}��yeri, emlak fiyat�n�n en fazla {3C5DA5}$50.000{FFFFFF} alt�na/�st�ne sat�labilir.\n{FFFFFF}��yerinizi satmak istedi�iniz fiyat� girin.", "Onayla", "�ptal");
		if(!Karakter[GetPVarInt(playerid, "IsyeriSatilacakID")][Giris] || !IsPlayerConnected(GetPVarInt(playerid, "IsyeriSatilacakID"))) return Sunucu(playerid, "��yerini satmaya �al��t���n�z ki�i oyundan ��km�� g�r�n�yor.");
		if(!OyuncuYakin(playerid, GetPVarInt(playerid, "IsyeriSatilacakID"), 6.0)) return Sunucu(playerid, "��yerini satmaya �al��t���n�z ki�i sizden uzakla�m��.");	
		SetPVarInt(playerid, "IsyeriSatilacakFiyat", strval(inputtext));
		Dialog_Show(playerid, DIALOG_IS_SAT_ONAY, DIALOG_STYLE_MSGBOX, "{99C794}��yerini Oyuncuya Sat - Onay", "{FFFFFF}��yerinizi %s adl� ki�iye %s kar��l���nda satmak istedi�inize emin misiniz?", "Onayla", "�ptal", GetPVarInt(playerid, "IsyeriSatilacakID"), NumaraFormati(GetPVarInt(playerid, "IsyeriSatilacakFiyat")));
	}
	else
	{
		Sunucu(playerid, "��yerini oyuncuya satmaktan vazge�tiniz.");
		DeletePVar(playerid, "IsyeriSatilacakID");
	}
	return true;
}

Dialog:DIALOG_IS_SAT_ONAY(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		new isyeriid = IsyeriYakin(playerid);
		if(isyeriid == -1) return Sunucu(playerid, "Bir i�yerinin yak�n�nda de�ilsin.");
		if(!IsyeriSahipKontrol(playerid, isyeriid)) return Sunucu(playerid, "Bu i�yeri size ait de�il.");
		if(!Karakter[GetPVarInt(playerid, "IsyeriSatilacakID")][Giris] || !IsPlayerConnected(GetPVarInt(playerid, "IsyeriSatilacakID"))) return Sunucu(playerid, "��yerini satmaya �al��t���n�z ki�i oyundan ��km�� g�r�n�yor.");
		if(!OyuncuYakin(playerid, GetPVarInt(playerid, "IsyeriSatilacakID"), 6.0)) return Sunucu(playerid, "��yerini satmaya �al��t���n�z ki�i sizden uzakla�m��.");
		new hedef = GetPVarInt(playerid, "IsyeriSatilacakID"), fiyat = GetPVarInt(playerid, "IsyeriSatilacakFiyat");
		if(Karakter[hedef][Para] < fiyat) return Sunucu(playerid, "Kar��daki oyuncunun yeterli paras� bulunmuyor.");
		Sunucu(playerid, "Kar��daki oyuncuya teklifiniz iletildi. Yan�t bekleniyor.");
		Isyeri[isyeriid][SatisTimer] = SetTimerEx("IsyeriSatisTimeri", 15000, false, "iii", isyeriid, hedef, playerid);
		SetPVarInt(playerid, "IsyeriSatiyor", 1);
		Sunucu(hedef, "Bir sat�� teklifi ald�n;");
		Sunucu(hedef, "%s adl� ki�i %d kap� numaral� i�yerini %s kar��l���nda sana satmak istiyor.", RPIsim(playerid), Isyeri[isyeriid][id], NumaraFormati(fiyat));
		Sunucu(hedef, "Kabul etmek i�in '/isyerikabul' yazabilirsiniz. Teklif 15 saniye i�inde kendili�inden sona erecek.");
		SetPVarInt(hedef, "IsyeriAlinacakID", playerid);
		SetPVarInt(hedef, "IsyeriAlinacakFiyat", fiyat);
		SetPVarInt(hedef, "IsyeriAlinacakisyeriid", isyeriid);
		SetPVarInt(hedef, "IsyeriTeklifiVar", 1);
	}
	else
	{
		Sunucu(playerid, "��yerini oyuncuya satmaktan vazge�tiniz.");
		DeletePVar(playerid, "IsyeriSatilacakID");
		DeletePVar(playerid, "IsyeriSatilacakFiyat");
	}
	return true;
}

CMD:isyerikabul(playerid, params[])
{
	if(GetPVarInt(playerid, "IsyeriTeklifiVar") != 1) return Sunucu(playerid, "Bir i�yeri sat�� teklifi almam��s�n.");
	new satan = GetPVarInt(playerid, "IsyeriAlinacakID");
	if(GetPVarInt(satan, "IsyeriSatiyor") != 1) return Sunucu(playerid, "Bu ki�i bir i�yeri satm�yor. ��lem sonland�r�lacak."), IsyeriSatisVeriSifirla(playerid, satan);
	new fiyat = GetPVarInt(playerid, "IsyeriAlinacakFiyat"), isyeriid = GetPVarInt(playerid, "IsyeriAlinacakID");
	if(!OyuncuYakin(satan, playerid, 6.0)) return Sunucu(playerid, "Yeterince yak�n de�ilsiniz. L�tfen i�yerini satan ki�iye yakla��n.");
	if(Karakter[playerid][Para] < fiyat) return Sunucu(playerid, "Yeterli paran�z yok. Teklif sona ermeden para �ekebilirsiniz.");
	if(!IsyeriSahipKontrol(satan, isyeriid)) return Sunucu(playerid, "��yerini satan ki�i i�yerinin sahibi de�il. ��lem sonland�r�lacak.");

	ParaVer(playerid, -fiyat);
	ParaVer(satan, fiyat);
	Isyeri[isyeriid][Sahip] = Karakter[playerid][id];
	format(Isyeri[isyeriid][SahipIsim], MAX_PLAYER_NAME+1, "%s", IsyeriSahipIsimCek(isyeriid));
	IsyeriTextYenile(isyeriid);
	Sunucu(satan, "%s teklifi kabul etti. %d kap� numaral� i�yeri %s kar��l���nda sat�ld�.", RPIsim(playerid), Isyeri[isyeriid][id], NumaraFormati(fiyat));
	Sunucu(playerid, "%s adl� ki�iden, %d kap� numaral� i�yerini %s kar��l���nda sat�n ald�n. Tebrikler!", RPIsim(satan), Isyeri[isyeriid][id], NumaraFormati(fiyat));
	Log_Kaydet("loglar/isyeri_oyuncuya_satis.txt", "[%s] %s adli kisi %s adli kisiye %d kapi numarali isyerini %s karsiliginda satti.", TarihCek(), RPIsim(satan), RPIsim(playerid), isyeriid, NumaraFormati(fiyat));
	IsyeriSatisVeriSifirla(playerid, satan);
	KillTimer(Isyeri[isyeriid][SatisTimer]);
	return true;
}

Vice:IsyeriSatisTimeri(isyeriid, alan, satan)
{

	if(IsPlayerConnected(satan) && Karakter[satan][Giris])
	{
		Sunucu(satan, "��yeri sat�� teklifinize yan�t gelmedi. Otomatik olarak sona erdirildi.");
	}
	if(IsPlayerConnected(alan) && Karakter[alan][Giris])
	{
		Sunucu(alan, "Teklife yan�t vermedi�iniz i�in otomatik olarak sona erdi.");
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
		if(isyeriid == -1) return Sunucu(playerid, "Bir i�yerinin yak�n�nda de�ilsin.");
		if(!IsyeriSahipKontrol(playerid, isyeriid)) return Sunucu(playerid, "Bu i�yeri size ait de�il.");
		new isyerifiyati = Isyeri[isyeriid][Fiyat]/2;
		ParaVer(playerid, isyerifiyati);
		Isyeri[isyeriid][Sahip] = 0;
		format(Isyeri[isyeriid][SahipIsim], MAX_PLAYER_NAME+1, "Yok");
		IsyeriTextYenile(isyeriid);
		IsyeriOrtakSifirla(isyeriid);
		Sunucu(playerid, "%s kar��l���nda, %d kap� numaral� i�yerini emlak��ya satt�n.", NumaraFormati(isyerifiyati), Isyeri[isyeriid][id]);
	}
	else
	{
		Sunucu(playerid, "��yerini sisteme satmaktan vazge�tiniz.");
	}
	return true;
}

Dialog:DIALOG_IS_SATIN_AL(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		new isyeriid = IsyeriYakin(playerid);
		if(isyeriid == -1) return Sunucu(playerid, "Bir i�yerinin yak�n�nda de�ilsin.");
		if(Isyeri[isyeriid][Sahip] != 0) return Sunucu(playerid, "Bu i�yeri sat�l�k de�il.");
		if(Karakter[playerid][Para] < Isyeri[isyeriid][Fiyat]) return Sunucu(playerid, "Bu i�yerini almak i�in yeterli paran yok.");
		ParaVer(playerid, -Isyeri[isyeriid][Fiyat]);
		Isyeri[isyeriid][Sahip] = Karakter[playerid][id];
		format(Isyeri[isyeriid][SahipIsim], MAX_PLAYER_NAME+1, "%s", IsyeriSahipIsimCek(isyeriid));
		Sunucu(playerid, "%s kar��l���nda %d kap� numaral� i�yerini sat�n ald�n.", NumaraFormati(Isyeri[isyeriid][Fiyat]), Isyeri[isyeriid][id]);
		Log_Kaydet("loglar/isyeri_satin_alim.txt", "[%s] %s adli kisi %d idli isyerini %s karsiliginda satin aldi.", TarihCek(), RPIsim(playerid), isyeriid, NumaraFormati(Isyeri[isyeriid][Fiyat]));
		IsyeriTextYenile(isyeriid);
		IsyeriVeriKaydet(isyeriid);
	}
	else Sunucu(playerid, "��yerini sat�n almaktan vazge�tin.");
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
					format(str, sizeof(str), "{99C794}%s\n{99C794}Kap� Numaras�: {E2E2E2}%d\n{99C794}Fiyat: {E2E2E2}%d\n\n{99C794}Durum: {FFFFFF}Kilitsiz\n[/isyerial]", Isyeri[isyeriid][Adres], Isyeri[isyeriid][id], Isyeri[isyeriid][Fiyat]);
					Isyeri[isyeriid][Label] = CreateDynamic3DTextLabel(str, 0xE2B960FF, Isyeri[isyeriid][Ext][0], Isyeri[isyeriid][Ext][1], Isyeri[isyeriid][Ext][2] + 0.2, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0, 0);
				}
				case 1:
				{
					format(str, sizeof(str), "{99C794}%s\n{99C794}Kap� Numaras�: {E2E2E2}%d\n{99C794}Fiyat: {E2E2E2}%d\n\n{99C794}Durum: {E2E2E2}Kilitli\n[/isyerial]", Isyeri[isyeriid][Adres], Isyeri[isyeriid][id], Isyeri[isyeriid][Fiyat]);
					Isyeri[isyeriid][Label] = CreateDynamic3DTextLabel(str, 0xE2B960FF, Isyeri[isyeriid][Ext][0], Isyeri[isyeriid][Ext][1], Isyeri[isyeriid][Ext][2] + 0.2, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0, 0);
				}
				case 2:
				{
					format(str, sizeof(str), "{99C794}%s\n{99C794}Kap� Numaras�: {E2E2E2}%d\n{99C794}Fiyat: {E2E2E2}%d\n\n{99C794}Durum: {FF0000}M�h�rl�\n[/isyerial]", Isyeri[isyeriid][Adres], Isyeri[isyeriid][id], Isyeri[isyeriid][Fiyat]);
					Isyeri[isyeriid][Label] = CreateDynamic3DTextLabel(str, 0xE2B960FF, Isyeri[isyeriid][Ext][0], Isyeri[isyeriid][Ext][1], Isyeri[isyeriid][Ext][2] + 0.2, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0, 0);
				}
				case 3:
				{
					format(str, sizeof(str), "{99C794}%s\n{99C794}Kap� Numaras�: {E2E2E2}%d\n{99C794}Fiyat: {E2E2E2}%d\n\n{99C794}Durum: {00CC00}Sat�l�k\n[/isyerial]", Isyeri[isyeriid][Adres], Isyeri[isyeriid][id], Isyeri[isyeriid][Fiyat]);
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
					format(str, sizeof(str), "{99C794}%s\n{99C794}Adres: %s\n{99C794}Kap� Numaras�: {E2E2E2}%d\n{99C794}Sahibi: {E2E2E2}%s\n{99C794}Ortak: {E2E2E2}%s\nT�r: %s\n{99C794}Durum: {FFFFFF}Kilitsiz", Isyeri[isyeriid][IsyeriAd], Isyeri[isyeriid][Adres], Isyeri[isyeriid][id], Isyeri[isyeriid][SahipIsim], OrtakIsimCek(isyeriid), IsyeriTurIsim(isyeriid));
					Isyeri[isyeriid][Label] = CreateDynamic3DTextLabel(str, 0xE2B960FF, Isyeri[isyeriid][Ext][0], Isyeri[isyeriid][Ext][1], Isyeri[isyeriid][Ext][2] + 0.2, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0, 0);
				}
				case 1:
				{
					format(str, sizeof(str), "{99C794}%s\n{99C794}Adres: %s\n{99C794}Kap� Numaras�: {E2E2E2}%d\n{99C794}Sahibi: {E2E2E2}%s\n{99C794}Ortak: {E2E2E2}%s\nT�r: %s\n{99C794}Durum: {E2E2E2}Kilitli", Isyeri[isyeriid][IsyeriAd], Isyeri[isyeriid][Adres], Isyeri[isyeriid][id], Isyeri[isyeriid][SahipIsim], OrtakIsimCek(isyeriid), IsyeriTurIsim(isyeriid));
					Isyeri[isyeriid][Label] = CreateDynamic3DTextLabel(str, 0xE2B960FF, Isyeri[isyeriid][Ext][0], Isyeri[isyeriid][Ext][1], Isyeri[isyeriid][Ext][2] + 0.2, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0, 0);
				}
				case 2:
				{
					format(str, sizeof(str), "{99C794}%s\n{99C794}Adres: %s\n{99C794}Kap� Numaras�: {E2E2E2}%d\n{99C794}Sahibi: {E2E2E2}%s\n{99C794}Ortak: {E2E2E2}%s\nT�r: %s\n{99C794}Durum: {FF0000}M�h�rl�", Isyeri[isyeriid][IsyeriAd], Isyeri[isyeriid][Adres], Isyeri[isyeriid][id], Isyeri[isyeriid][SahipIsim], OrtakIsimCek(isyeriid), IsyeriTurIsim(isyeriid));
					Isyeri[isyeriid][Label] = CreateDynamic3DTextLabel(str, 0xE2B960FF, Isyeri[isyeriid][Ext][0], Isyeri[isyeriid][Ext][1], Isyeri[isyeriid][Ext][2] + 0.2, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0, 0);
				}
				case 3:
				{
					format(str, sizeof(str), "{99C794}%s\n{99C794}Adres: %s\n{99C794}Kap� Numaras�: {E2E2E2}%d\n{99C794}Sahibi: {E2E2E2}%s\n{99C794}Ortak: {E2E2E2}%s\nT�r: %s\n{99C794}Durum: {00CC00}Sat�l�k", Isyeri[isyeriid][IsyeriAd], Isyeri[isyeriid][Adres], Isyeri[isyeriid][id], Isyeri[isyeriid][SahipIsim], OrtakIsimCek(isyeriid), IsyeriTurIsim(isyeriid));
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
	if(isyeriid == -1) return Sunucu(playerid, "Sunucu i�yeri limitine ula��ld�.");
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
	format(str, sizeof(str), "{99C794}%s\n{99C794}Kap� Numaras�: {E2E2E2}%d\n{99C794}Fiyat: {E2E2E2}%d\n\n{99C794}Durum: {FFFFFF}Kilitsiz\n[/isyerial]", Isyeri[isyeriid][Adres], Isyeri[isyeriid][id], Isyeri[isyeriid][Fiyat]);
	Isyeri[isyeriid][Label] = CreateDynamic3DTextLabel(str, 0xE2B960FF, Isyeri[isyeriid][Ext][0], Isyeri[isyeriid][Ext][1], Isyeri[isyeriid][Ext][2] + 0.2, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0, 0);
	
	Sunucu(playerid, "��yeri bulundu�un noktada yarat�ld�.(Adres: %s | Fiyat: %d | ID: %d)", Isyeri[isyeriid][Adres], Isyeri[isyeriid][Fiyat], Isyeri[isyeriid][id]);
	Sunucu(playerid, "��yeri giri� ve ��k�� noktalar�n� d�zenlemek i�in /isyeriduzenle komutunu kullan.");
	return true;
}

stock IsyeriTurIsim(isyeriid)
{
	new turisim[32];
	switch(Isyeri[isyeriid][Tur])
	{
		case 1: turisim = "Market";
		case 2: turisim = "Restoran";
		case 3: turisim = "Di�er";
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
	printf("[MySQL] Veritaban�ndan '%i' adet i�yeri y�klendi.", rowcount);
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

	Sunucu(playerid, "Bir i�yeri sildiniz.");
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