// Y�NET�C� KOMUTLARI
CMD:binayarat(playerid, params[])
{
	if(Hesap[playerid][Yonetici] < 5) return YetersizYetki(playerid);

	new binaadi[24], Float: x, Float: y, Float: z, interior = GetPlayerInterior(playerid), world = GetPlayerVirtualWorld(playerid), tur;
	if(sscanf(params, "ds[24]", tur, binaadi)) return Sunucu(playerid, "/binayarat [tur] [bina ad�]"), GenelMesajGonder(playerid, "T�rler: 1-Banka, 2-Polis");
	if(strlen(binaadi) < 1 || strlen(binaadi) > 24) return Sunucu(playerid, "Minimum 1-24 karakter aras� bir isim girmelisiniz.");

	GetPlayerPos(playerid, x, y, z);

	new binaisim[24];
	format(binaisim, 124, "%s", binaadi);
	BinaYarat(playerid, binaisim, x, y, z, interior, world, tur);
	return true;
}

CMD:binaduzenle(playerid, params[])
{
	if(Hesap[playerid][Yonetici] < 5) return YetersizYetki(playerid);

	new binaid, secenek[64], ekstra[128];
	if(sscanf(params, "ds[64]S()[128]", binaid, secenek, ekstra))
	{
		Sunucu(playerid, "/binaduzenle [binaid]");
		GenelMesajGonder(playerid, "binaisim, diskapi, ickapi, durum");
	}
	else
	{
		if(!Binalar[binaid][Gecerli]) return Sunucu(playerid, "Ge�ersiz id girdiniz.");

		if(!strcmp(secenek, "binaisim", true))
		{
			new binaadi[24];
			if(sscanf(ekstra, "s[24]", binaadi)) return Sunucu(playerid, "/binaduzenle [binaid] [binaisim] [yeni isim(24)]");
			if(strlen(binaadi) < 1 || strlen(binaadi) > 24) return Sunucu(playerid, "Minimum 1-24 karakter aras� bir isim girmelisiniz.");

			new binaisim[24];
			format(binaisim, 24, "%s", binaadi);
			Binalar[binaid][BinaAdi] = binaisim;
			BinaVeriKaydet(binaid);

			Sunucu(playerid, "%d id'li binan�n ismini %s olarak de�i�tirdiniz.", binaid, Binalar[binaid][BinaAdi]);
		}
		else if(!strcmp(secenek, "diskapi", true))
		{
			new Float: x, Float: y, Float: z, world = GetPlayerVirtualWorld(playerid), interior = GetPlayerInterior(playerid);

			GetPlayerPos(playerid, x, y, z);
			Binalar[binaid][Ext][0] = x;
			Binalar[binaid][Ext][1] = y;
			Binalar[binaid][Ext][2] = z;
			Binalar[binaid][World] = world;
			Binalar[binaid][Interior] = interior;
			BinaVeriKaydet(binaid);

			Sunucu(playerid, "%d id'li binan�n d�� kap� konumunu de�i�tirdiniz.", binaid);
		}
		else if(!strcmp(secenek, "ickapi", true))
		{
			new Float: x, Float: y, Float:z, interior = GetPlayerInterior(playerid), world = GetPlayerVirtualWorld(world);

			GetPlayerPos(playerid, x, y, z);
			Binalar[binaid][Int][0] = x;
			Binalar[binaid][Int][1] = y;
			Binalar[binaid][Int][2] = z;
			Binalar[binaid][IcInterior] = interior;
			Binalar[binaid][IcWorld] = world;
			BinaVeriKaydet(binaid);

			Sunucu(playerid, "%d id'li binan�n i� kap� konumunu de�i�tirdiniz.", binaid);
		}
		else if(!strcmp(secenek, "durum", true))
		{
			new durum;
			if(sscanf(ekstra, "d", durum))
			{
				Sunucu(playerid, "/binaduzenle [binaid] [durum] [de�er]");
				GenelMesajGonder(playerid, "A��k: 0 | Kilitli: 1 | M�h�rl�: 2");
			}
			else
			{
				if(durum < 0 || durum > 2) return Sunucu(playerid, "Ge�ersiz de�er girdiniz.");

				Binalar[binaid][Durum] = durum;
				BinaVeriKaydet(binaid);

				Sunucu(playerid, "%d id'li binan�n durumunu de�i�tirdiniz.", binaid);
			}
		}
		else Sunucu(playerid, "Hatal� parametre girdin.");
	}
	return true;
}

CMD:binasil(playerid, params[])
{
	if(Hesap[playerid][Yonetici] < 5) return YetersizYetki(playerid);

	new binaid;
	if(sscanf(params, "d", binaid)) return Sunucu(playerid, "/binasil [binaid]");
	if(!Binalar[binaid][Gecerli]) return Sunucu(playerid, "Ge�ersiz id girdiniz.");

	BinaSil(playerid, binaid);
	return true;
}

CMD:binaid(playerid, params[])
{
	if(Hesap[playerid][Yonetici] < 5) return YetersizYetki(playerid);

	if(BinaYakin(playerid) == -1) return Sunucu(playerid, "Yak�n�n�zda bina bulunmamaktad�r.");

	Sunucu(playerid, "%d id'li binan�n yak�n�ndas�n�z.", BinaYakin(playerid));
	return true;
}

// BANKA

CMD:banka(playerid, params[])
{
	if(BinaIcinde(playerid) != -1)
	{
		new binaid = BinaIcinde(playerid);
		if(Binalar[binaid][Tur] != 1) return Sunucu(playerid, "Bir bankada de�ilsin.");
		new bankastr[900];
		strcat(bankastr, "Se�enek\tA��klama\n");
		strcat(bankastr, "{3C5DA5}Hesap Bilgileri\t{FFFFFF}Banka hesap numaran�z� ve hesab�n�zdaki para miktar�n� g�r�nt�leyebilirsiniz.\n");
		strcat(bankastr, "{3C5DA5}Para �ek\t{FFFFFF}Banka hesab�n�zdan para �ekimi yapabilirsiniz.\n");
		strcat(bankastr, "{3C5DA5}Para Yat�r\t{FFFFFF}Banka hesab�n�za �st�n�zdeki paradan istedi�iniz kadar yat�rabilirsiniz.\n");
		strcat(bankastr, "{3C5DA5}Para Transferi\t{FFFFFF}Ba�ka bir banka hesap numaras�na banka hesab�n�zda bulunan paray� transfer edebilirsiniz.\n");
		strcat(bankastr, "{3C5DA5}Mevduat Hesab�\t{FFFFFF}Banka hesab�n�zdan bir miktar paray� yat�rarak her saat paran�z�n faizlenmesini sa�layabilirsiniz.");
		Dialog_Show(playerid, DIALOG_BANKA, DIALOG_STYLE_TABLIST_HEADERS, "{99C794}Banka", bankastr, "Se�", "�ptal");
	}
	else Sunucu(playerid, "Bir bankada de�ilsin.");
	return true;
}

Dialog:DIALOG_BANKA(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		switch(listitem)
		{
			case 0:
			{
				Dialog_Show(playerid, DIALOG_BANKA_BILGILER, DIALOG_STYLE_MSGBOX, "{99C794}Hesap Bilgileri", "Hesap Sahibi: %s\nHesap Numaras�: %d\nHesapta Bulunan Para: %s\nMevduat Hesab�nda Bulunan Para: %s", "��k��", "", RPIsim(playerid), Karakter[playerid][BankaNo], NumaraFormati(Karakter[playerid][BankaPara]), NumaraFormati(Karakter[playerid][Mevduat]));
			}
			case 1:
			{
				Dialog_Show(playerid, DIALOG_BANKA_PARACEK, DIALOG_STYLE_INPUT, "{99C794}Para �ek", "Banka hesab�n�zda %s para bulunuyor.\n�ekmek istedi�iniz miktar� a�a��ya girebilirsiniz.", "�ek", "�ptal", NumaraFormati(Karakter[playerid][BankaPara]));
			}
			case 2:
			{
				Dialog_Show(playerid, DIALOG_BANKA_PARAYATIR, DIALOG_STYLE_INPUT, "{99C794}Para Yat�r", "Banka hesab�n�zda %s para bulunuyor.\nBu paran�n �st�ne ne kadar para yat�rmak istersiniz?", "Yat�r", "�ptal", NumaraFormati(Karakter[playerid][BankaPara]));
			}
			case 3:
			{
				Dialog_Show(playerid, DIALOG_BANKA_TRANSFER, DIALOG_STYLE_INPUT, "{99C794}Para Transferi", "Para transferi yapmak istedi�iniz banka hesap numaras�n� girin.", "Devam", "�ptal");
			}
			case 4:
			{
				if(Karakter[playerid][Mevduat] < 1)
				{
					Dialog_Show(playerid, DIALOG_MEVDUAT_YATIR, DIALOG_STYLE_INPUT, "{99C794}Mevduat Hesab�", "Banka hesab�n�zda bulunan paradan buraya yat�r�m yapabilirsiniz.\
					\nEn az $50.000, en fazla $100.000 para yat�r�labilir.\n{3C5DA5}NOT:{FFFFFF}Yat�rd�ktan sonra para geri �ekilene kadar kullan�lamaz.\nBanka hesab�n�zda %s bulunuyor.\nYat�rmak istedi�iniz para miktar�n� girin.", "Onayla", "�ptal", NumaraFormati(Karakter[playerid][BankaPara]));
				}
				else
				{
					Dialog_Show(playerid, DIALOG_MEVDUAT_CEK, DIALOG_STYLE_MSGBOX, "{99C794}Mevduat Hesab�", "Mevduat hesab�n�zda %s birikmi� g�r�n�yor.\nParan�n tamam�n� �ekmek istedi�inize emin misiniz?", "Onayla", "�ptal", NumaraFormati(Karakter[playerid][Mevduat]));
				}
			}
		}
	}
	return true;
}

Dialog:DIALOG_MEVDUAT_YATIR(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		new miktar = strval(inputtext);
		if(isnull(inputtext) || miktar < 50000 || miktar > 100000) 
			return Dialog_Show(playerid, DIALOG_MEVDUAT_YATIR, DIALOG_STYLE_INPUT, "{99C794}Mevduat Hesab�", "Hatal� para miktar�.\nBanka hesab�n�zda bulunan paradan buraya yat�r�m yapabilirsiniz.\
			\nEn az $50.000, en fazla $100.000 para yat�r�labilir.\n{3C5DA5}NOT:{FFFFFF}Yat�rd�ktan sonra para geri �ekilene kadar kullan�lamaz.\nBanka hesab�n�zda %s bulunuyor.\nYat�rmak istedi�iniz para miktar�n� girin.", "Onayla", "�ptal", NumaraFormati(Karakter[playerid][BankaPara]));
		if(Karakter[playerid][BankaPara] < miktar) return Sunucu(playerid, "Banka hesab�n�zda yeterli miktarda para bulunmuyor, i�lem iptal edildi.");
		Karakter[playerid][BankaPara] -= miktar;
		Karakter[playerid][Mevduat] = miktar;
		Sunucu(playerid, "Mevduat hesab�n�za %s yat�rd�n�z. Paran�z her saat faizlenecek.(yaln�zca oyundayken)", NumaraFormati(miktar));
		Log_Kaydet("loglar/banka_mevduat_yatirma.txt", "[%s] %s adli kisi %s miktarinda parayi mevduat hesabina yatirdi.", TarihCek(), RPIsim(playerid), NumaraFormati(miktar));
	}
	return true;
}

Dialog:DIALOG_MEVDUAT_CEK(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		new miktar = Karakter[playerid][Mevduat];
		Karakter[playerid][Mevduat] = 0;
		ParaVer(playerid, miktar);
		Sunucu(playerid, "Mevduat hesab�n�zda bulunan %s paray� �ektiniz. Mevduat hesab� s�f�rland�.", NumaraFormati(miktar));
		Log_Kaydet("loglar/banka_mevduat_cekme.txt", "[%s] %s adli kisi %s miktarinda parayi mevduat hesabindan cekti.", TarihCek(), RPIsim(playerid), NumaraFormati(miktar));
	}
}

Dialog:DIALOG_BANKA_TRANSFER(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		new hesap = strval(inputtext);
		if(isnull(inputtext) || hesap < 1) return Dialog_Show(playerid, DIALOG_BANKA_TRANSFER, DIALOG_STYLE_INPUT, "{99C794}Para Transferi", "Ge�ersiz hesap numaras� girdiniz.\nPara transferi yapmak istedi�iniz banka hesap numaras�n� girin.", "Devam", "�ptal"); 
		new oid = -1, isim[MAX_PLAYER_NAME+1];
		// Oyunda aktiflik kontrol
		foreach(new i : Player)
		{
			if(Karakter[i][BankaNo] == hesap)
			{
				oid = i;
				format(isim, sizeof(isim), "%s", Karakter[i][Isim]);
			}
		}
		// Hesap numaras� kontrol(e�er oyunda de�ilse)
		if(oid == -1)
		{
			new query[144];
			mysql_format(conn, query, sizeof(query), "SELECT * FROM karakterler WHERE BankaNo = %i", hesap);
			mysql_tquery(conn, query, "BankaNoArat", "ii", playerid, hesap);
		}
		// Transfer yeni diyalog(e�er oyundaysa)
		else
		{
			SetPVarInt(playerid, "TransferHesapNo", hesap);
			Dialog_Show(playerid, DIALOG_BANKA_TRANSFER2, DIALOG_STYLE_INPUT, "{99C794}Para Transferi", "%s adl� ki�inin %d hesap numaras�na transfer yap�yorsunuz.\nTransfer etmek istedi�iniz para miktar�n� girin.", "Onayla", "�ptal", isim, hesap);
		}
	}
	return true;
}

Vice:BankaNoArat(playerid, hesap)
{
	new rows;
	cache_get_row_count(rows);
	if(rows)
	{
		SetPVarInt(playerid, "TransferHesapNo", hesap);
		new isim[32];
		cache_get_value_name(0, "isim", isim, 32);
		Dialog_Show(playerid, DIALOG_BANKA_TRANSFER2, DIALOG_STYLE_INPUT, "{99C794}Para Transferi", "%s adl� ki�inin %d hesap numaras�na transfer yap�yorsunuz.\nTransfer etmek istedi�iniz para miktar�n� girin.", "Onayla", "�ptal", isim, hesap);
	}
	else Dialog_Show(playerid, DIALOG_BANKA_TRANSFER, DIALOG_STYLE_INPUT, "{99C794}Para Transferi", "Hesap numaras� bulunamad�.\nPara transferi yapmak istedi�iniz banka hesap numaras�n� girin.", "Devam", "�ptal");
	return true;
}

Dialog:DIALOG_BANKA_TRANSFER2(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		new miktar = strval(inputtext);
		if(isnull(inputtext) || miktar < 1) return Sunucu(playerid, "Ge�ersiz para de�eri, i�lem iptal edildi.");
		if(Karakter[playerid][BankaPara] < miktar) return Sunucu(playerid, "Banka hesab�n�zdaki para yetersiz, i�lem iptal edildi.");
		new hesap = GetPVarInt(playerid, "TransferHesapNo"), oid = -1, isim[32];
		foreach(new i : Player)
		{
			if(Karakter[i][BankaNo] == hesap)
			{
				oid = i;
				format(isim, sizeof(isim), "%s", Karakter[i][Isim]);
			}
		}
		if(oid == -1)
		{
			SetPVarInt(playerid, "TransferMiktar", miktar);
			new query[144];
			mysql_format(conn, query, sizeof(query), "SELECT * FROM karakterler WHERE BankaNo = %i", hesap);
			mysql_tquery(conn, query, "BankaParaTransfer", "ii", playerid, miktar);
		}
		else
		{
			Karakter[playerid][BankaPara] -= miktar;
			Karakter[oid][BankaPara] += miktar;
			Sunucu(playerid, "%s adl� ki�inin %d numaral� banka hesab�na %s para g�nderdiniz.", Karakter[oid][Isim], hesap, NumaraFormati(miktar));
			Sunucu(oid, "%s adl� ki�inin %d numaral� banka hesab�ndan %s hesab�n�za transfer edildi.", Karakter[playerid][Isim], Karakter[playerid][BankaNo], NumaraFormati(miktar));
			Log_Kaydet("loglar/banka_online_transfer.txt", "[%s] %s adli kisi %s adli kisinin banka hesabina %s para yatirdi.", TarihCek(), RPIsim(playerid), RPIsim(oid), NumaraFormati(miktar));
		}
	}
	else
	{
		DeletePVar(playerid, "TransferHesapNo");
	}
	return true;
}

Vice:BankaParaTransfer(playerid, miktar)
{
	new rows;
	cache_get_row_count(rows);
	if(rows)
	{
		new mevcutpara, query[144], oid, isim[32];
		cache_get_value_name_int(0, "BankaPara", mevcutpara);
		cache_get_value_name_int(0, "id", oid);
		cache_get_value_name(0, "isim", isim, 32);
		mevcutpara += miktar;
		mysql_format(conn, query, sizeof(query), "UPDATE karakterler SET BankaPara = %i WHERE id = %i", mevcutpara, oid);
		mysql_query(conn, query);
		Sunucu(playerid, "%s adl� ki�inin banka hesab�na %s para transfer ettiniz.", isim, NumaraFormati(miktar));
		Log_Kaydet("loglar/banka_offline_transfer.txt", "[%s] %s adli kisi %s adli kisinin banka hesabina %s para yatirdi.", TarihCek(), RPIsim(playerid), isim, NumaraFormati(miktar));
	}
	else 
	{
		Sunucu(playerid, "Hesap numaras�na ula��rken bir hata olu�tu. Daha sonra tekrar deneyin.");
		DeletePVar(playerid, "TransferHesapNo");
		DeletePVar(playerid, "TransferMiktar");
	}
	return true;
}

Dialog:DIALOG_BANKA_PARACEK(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		new miktar = strval(inputtext);
		if(isnull(inputtext) || miktar < 1) return Dialog_Show(playerid, DIALOG_BANKA_PARACEK, DIALOG_STYLE_INPUT, "{99C794}Para �ek", "Hatal� miktar girdiniz.\nBanka hesab�n�zda %s para bulunuyor.\n�ekmek istedi�iniz miktar� a�a��ya girebilirsiniz.", "�ek", "�ptal", NumaraFormati(Karakter[playerid][BankaPara]));
		if(Karakter[playerid][BankaPara] < miktar) return Dialog_Show(playerid, DIALOG_BANKA_PARACEK, DIALOG_STYLE_INPUT, "{99C794}Para �ek", "Banka hesab�n�zda bu kadar para bulunmuyor.\nBanka hesab�n�zda %s para bulunuyor.\n�ekmek istedi�iniz miktar� a�a��ya girebilirsiniz.", "�ek", "�ptal", NumaraFormati(Karakter[playerid][BankaPara]));
		Karakter[playerid][BankaPara] -= miktar;
		ParaVer(playerid, miktar);
		Sunucu(playerid, "Banka hesab�n�zdan %s para �ektiniz. Hesab�n�zda %s para kald�.", NumaraFormati(miktar), NumaraFormati(Karakter[playerid][BankaPara]));
		Log_Kaydet("loglar/banka_para_cekme.txt", "[%s] %s adli kisi banka hesabindan %s para cekti. Kalan Para: %s", TarihCek(), RPIsim(playerid), NumaraFormati(miktar), NumaraFormati(Karakter[playerid][BankaPara]));
	}
	return true;
}

Dialog:DIALOG_BANKA_PARAYATIR(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		new miktar = strval(inputtext);
		if(isnull(inputtext) || miktar < 1) return Dialog_Show(playerid, DIALOG_BANKA_PARAYATIR, DIALOG_STYLE_INPUT, "{99C794}Para Yat�r", "Hatal� miktar girdiniz.\nBanka hesab�n�zda %s para bulunuyor.\nBu paran�n �st�ne ne kadar para yat�rmak istersiniz?", "Yat�r", "�ptal", NumaraFormati(Karakter[playerid][BankaPara]));
		if(Karakter[playerid][Para] < miktar) return Dialog_Show(playerid, DIALOG_BANKA_PARAYATIR, DIALOG_STYLE_INPUT, "{99C794}Para Yat�r", "�st�n�zde bu kadar para bulunmuyor.\nBanka hesab�n�zda %s para bulunuyor.\nBu paran�n �st�ne ne kadar para yat�rmak istersiniz?", "Yat�r", "�ptal", NumaraFormati(Karakter[playerid][BankaPara]));
		ParaVer(playerid, -miktar);
		Karakter[playerid][BankaPara] += miktar;
		Sunucu(playerid, "Banka hesab�n�za %s para yat�rd�n�z. Hesab�n�zda %s para oldu.", NumaraFormati(miktar), NumaraFormati(Karakter[playerid][BankaPara]));
		Log_Kaydet("loglar/banka_para_yatirma.txt", "[%s] %s adli kisi banka hesabina %s para yatirdi. Yeni Para: %s", TarihCek(), RPIsim(playerid), NumaraFormati(miktar), NumaraFormati(Karakter[playerid][BankaPara]));
	}
	return true;
}

// G�Y�M D�KKANLARI

CMD:kiyafetal(playerid, params[])
{
	if(BinaIcinde(playerid) != -1)
	{
		new binaid = BinaIcinde(playerid);
		if(Binalar[binaid][Tur] != 3) return Sunucu(playerid, "Bir giyim d�kkan�nda de�ilsin.");
		switch(Karakter[playerid][Cinsiyet])
		{
			case 1:
			{
				switch(Karakter[playerid][Ten])
				{
					case 1:
					{
						new dialogstr[1540];
						for(new i; i < sizeof(ErkekBeyazSkinler); i++)
						{
							format(dialogstr, sizeof(dialogstr), "%s%d\nID: %d\n", dialogstr, ErkekBeyazSkinler[i], ErkekBeyazSkinler[i]);
						}
						ShowPlayerDialog(playerid, 23300, DIALOG_STYLE_PREVMODEL, "Beyaz Erkek Skinleri", dialogstr, "Sec", "Iptal");
					}
					case 2:
					{
						new dialogstr[1540];
						for(new i; i < sizeof(ErkekSiyahSkinler); i++)
						{
							format(dialogstr, sizeof(dialogstr), "%s%d\nID: %d\n", dialogstr, ErkekSiyahSkinler[i], ErkekSiyahSkinler[i]);
						}
						ShowPlayerDialog(playerid, 23300, DIALOG_STYLE_PREVMODEL, "Siyah Erkek Skinleri", dialogstr, "Sec", "Iptal");
					}
				}
			}
			case 2:
			{
				switch(Karakter[playerid][Ten])
				{
					case 1:
					{
						new dialogstr[1540];
						for(new i; i < sizeof(KadinBeyazSkinler); i++)
						{
							format(dialogstr, sizeof(dialogstr), "%s%d\nID: %d\n", dialogstr, KadinBeyazSkinler[i], KadinBeyazSkinler[i]);
						}
						ShowPlayerDialog(playerid, 23300, DIALOG_STYLE_PREVMODEL, "Beyaz Kad�n Skinleri", dialogstr, "Sec", "Iptal");
					}
					case 2:
					{
						new dialogstr[1540];
						for(new i; i < sizeof(KadinSiyahSkinler); i++)
						{
							format(dialogstr, sizeof(dialogstr), "%s%d\nID: %d\n", dialogstr, KadinSiyahSkinler[i], KadinSiyahSkinler[i]);
						}
						ShowPlayerDialog(playerid, 23300, DIALOG_STYLE_PREVMODEL, "Siyah Kad�n Skinleri", dialogstr, "Sec", "Iptal");
					}
				}
			}
		}
	}
	else Sunucu(playerid, "Bir giyim d�kkan�nda de�ilsin.");
	return true;
}

Dialog:DIALOG_KIYAFET_ONAY(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		if(Karakter[playerid][Para] < KIYAFET_UCRET) return Sunucu(playerid, "Bu k�yafeti almak i�in yeterli paran yok."), DeletePVar(playerid, "AlinacakSkin");
		new skinid = GetPVarInt(playerid, "AlinacakSkin");
		Karakter[playerid][Skin] = skinid;
		SetPlayerSkin(playerid, Karakter[playerid][Skin]);
		Sunucu(playerid, "Yeni bir k�yafet ald�n, g�le g�le kullan.");
		ParaVer(playerid, -300);
		DeletePVar(playerid, "AlinacakSkin");
	}
	else
	{
		DeletePVar(playerid, "AlinacakSkin");
	}
	return true;
}

// FONKS�YONLAR
Vice:BinaYarat(playerid, binaadi[], Float: x, Float: y, Float: z, interior, world, tur)
{
	new binaid = BinaSlot();
	if(binaid == -1) return Sunucu(playerid, "Sunucu bina limitine ula��ld�.");
	new query[512];
	mysql_format(conn, query, sizeof(query), "INSERT INTO binalar (BinaId, BinaAdi, ExtX, ExtY, ExtZ, IntX, IntY, IntZ, Interior, World, Durum, Tur, IcWorld, IcInterior) VALUES (%i, '%e', %.4f, %.4f, %.4f, 0.0, 0.0, 0.0, %i, %i, 0, %i, %i, 1)", binaid, binaadi, x, y, z, interior, world, tur, binaid + 17000);
	mysql_query(conn, query);
	Binalar[binaid][Gecerli] = true;
	Binalar[binaid][id] = binaid;
	format(Binalar[binaid][BinaAdi], 24, "%s", binaadi);
	Binalar[binaid][Ext][0] = x;
	Binalar[binaid][Ext][1] = y;
	Binalar[binaid][Ext][2] = z;
	Binalar[binaid][Int][0] = 0.0;
	Binalar[binaid][Int][1] = 0.0;
	Binalar[binaid][Int][2] = 0.0;
	Binalar[binaid][Interior] = interior;
	Binalar[binaid][World] = world;
	Binalar[binaid][IcWorld] = Binalar[binaid][id] + 17000;
	Binalar[binaid][IcInterior] = 1;
	Binalar[binaid][Durum] = 0;
	Binalar[binaid][Tur] = tur;

	switch(Binalar[binaid][Tur])
	{
		case 3:
		{
			Binalar[binaid][Pickup] = CreateDynamicPickup(1275, 23, Binalar[binaid][Ext][0], Binalar[binaid][Ext][1], Binalar[binaid][Ext][2], world, interior);
		}
		default:
		{
			Binalar[binaid][Pickup] = CreateDynamicPickup(1239, 23, Binalar[binaid][Ext][0], Binalar[binaid][Ext][1], Binalar[binaid][Ext][2], world, interior);
		}
	
	}
	new str[124];
	format(str, sizeof(str), "{99C794}%s\n{99C794}T�r: {E2E2E2}%s\n{99C794}Durum: {FFFFFF}A��k", Binalar[binaid][BinaAdi], BinaTurIsim(Binalar[binaid][Tur]));
	Binalar[binaid][Label] = CreateDynamic3DTextLabel(str, 0xE2B960FF, Binalar[binaid][Ext][0], Binalar[binaid][Ext][1], Binalar[binaid][Ext][2] + 0.2, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, Binalar[binaid][World], Binalar[binaid][Interior]);

	Sunucu(playerid, "Bina bulundu�unuz noktada yarat�ld�. (( ID: %d ))", binaid);
	Sunucu(playerid, "Binan�n giri� ve ��k�� noktalar�n� d�zenlemek i�in /binaduzenle komutunu kullan.");
	return true;
}

Vice:BinalariYukle()
{
	new rows, fields, rowcount = 0;
	cache_get_row_count(rows);
	cache_get_field_count(fields);

	for(new i = 0; i < rows && MAKSIMUM_BINA; i++)
	{
		Binalar[i][Gecerli] = true;

		cache_get_value_name_int(i, "BinaId", Binalar[i][id]);

		cache_get_value_name(i, "BinaAdi", Binalar[i][BinaAdi], 24);

		cache_get_value_name_float(i, "ExtX", Binalar[i][Ext][0]);
		cache_get_value_name_float(i, "ExtY", Binalar[i][Ext][1]);
		cache_get_value_name_float(i, "ExtZ", Binalar[i][Ext][2]);

		cache_get_value_name_float(i, "IntX", Binalar[i][Int][0]);
		cache_get_value_name_float(i, "IntY", Binalar[i][Int][1]);
		cache_get_value_name_float(i, "IntZ", Binalar[i][Int][2]);

		cache_get_value_name_int(i, "Interior", Binalar[i][Interior]);
		cache_get_value_name_int(i, "World", Binalar[i][World]);

		cache_get_value_name_int(i, "IcWorld", Binalar[i][IcWorld]);
		cache_get_value_name_int(i, "IcInterior", Binalar[i][IcInterior]);

		cache_get_value_name_int(i, "Durum", Binalar[i][Durum]);
		cache_get_value_name_int(i, "Tur", Binalar[i][Tur]);


		switch(Binalar[i][Tur])
		{
			case 3:
			{
				Binalar[i][Pickup] = CreateDynamicPickup(1275, 23, Binalar[i][Ext][0], Binalar[i][Ext][1], Binalar[i][Ext][2], Binalar[i][World], Binalar[i][Interior]);
			}
			default:
			{
				Binalar[i][Pickup] = CreateDynamicPickup(1239, 23, Binalar[i][Ext][0], Binalar[i][Ext][1], Binalar[i][Ext][2], Binalar[i][World], Binalar[i][Interior]);
			}
		}

		new str[124];
		switch(Binalar[i][Durum])
		{
			case 0:
			{
				format(str, sizeof(str), "{99C794}%s\n{99C794}T�r: {E2E2E2}%s\n{99C794}Durum: {FFFFFF}A��k", Binalar[i][BinaAdi], BinaTurIsim(Binalar[i][Tur]));
				Binalar[i][Label] = CreateDynamic3DTextLabel(str, 0xE2B960FF, Binalar[i][Ext][0], Binalar[i][Ext][1], Binalar[i][Ext][2] + 0.2, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, Binalar[i][World], Binalar[i][Interior]);
			}
			case 1:
			{
				format(str, sizeof(str), "{99C794}%s\n{99C794}T�r: {E2E2E2}%s\n{99C794}Durum: {E2E2E2}Kilitli", Binalar[i][BinaAdi], BinaTurIsim(Binalar[i][Tur]));
				Binalar[i][Label] = CreateDynamic3DTextLabel(str, 0xE2B960FF, Binalar[i][Ext][0], Binalar[i][Ext][1], Binalar[i][Ext][2] + 0.2, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, Binalar[i][World], Binalar[i][Interior]);
			}
			case 2:
			{
				format(str, sizeof(str), "{99C794}%s\n{99C794}T�r: {E2E2E2}%s\n{99C794}Durum: {FF0000}M�h�rl�", Binalar[i][BinaAdi], BinaTurIsim(Binalar[i][Tur]));
				Binalar[i][Label] = CreateDynamic3DTextLabel(str, 0xE2B960FF, Binalar[i][Ext][0], Binalar[i][Ext][1], Binalar[i][Ext][2] + 0.2, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, Binalar[i][World], Binalar[i][Interior]);
			}
		}
		rowcount++;
	}
	printf("[MySQL] Veritaban�ndan '%i' adet bina y�klendi.", rowcount);
	return true;
}

Vice:BinaVeriKaydet(binaid)
{
	if(IsValidDynamic3DTextLabel(Binalar[binaid][Label]))
		DestroyDynamic3DTextLabel(Binalar[binaid][Label]);

	if(IsValidDynamicPickup(Binalar[binaid][Pickup]))
		DestroyDynamicPickup(Binalar[binaid][Pickup]);

	switch(Binalar[binaid][Tur])
	{
		case 3:
		{
			Binalar[binaid][Pickup] = CreateDynamicPickup(1275, 23, Binalar[binaid][Ext][0], Binalar[binaid][Ext][1], Binalar[binaid][Ext][2], Binalar[binaid][World], Binalar[binaid][Interior]);
		}
		default:
		{
			Binalar[binaid][Pickup] = CreateDynamicPickup(1239, 23, Binalar[binaid][Ext][0], Binalar[binaid][Ext][1], Binalar[binaid][Ext][2], Binalar[binaid][World], Binalar[binaid][Interior]);
		}	
	}

	new str[124];
	switch(Binalar[binaid][Durum])
	{
		case 0:
		{
			format(str, sizeof(str), "{99C794}%s\n{99C794}T�r: {E2E2E2}%s\n{99C794}Durum: {FFFFFF}A��k", Binalar[binaid][BinaAdi], BinaTurIsim(Binalar[binaid][Tur]));
			Binalar[binaid][Label] = CreateDynamic3DTextLabel(str, 0xE2B960FF, Binalar[binaid][Ext][0], Binalar[binaid][Ext][1], Binalar[binaid][Ext][2] + 0.2, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, Binalar[binaid][World], Binalar[binaid][Interior]);
		}
		case 1:
		{
			format(str, sizeof(str), "{99C794}%s\n{99C794}T�r: {E2E2E2}%s\n{99C794}Durum: {E2E2E2}Kilitli", Binalar[binaid][BinaAdi], BinaTurIsim(Binalar[binaid][Tur]));
			Binalar[binaid][Label] = CreateDynamic3DTextLabel(str, 0xE2B960FF, Binalar[binaid][Ext][0], Binalar[binaid][Ext][1], Binalar[binaid][Ext][2] + 0.2, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, Binalar[binaid][World], Binalar[binaid][Interior]);
		}
		case 2:
		{
			format(str, sizeof(str), "{99C794}%s\n{99C794}T�r: {E2E2E2}%s\n{99C794}Durum: {FF0000}M�h�rl�", Binalar[binaid][BinaAdi], BinaTurIsim(Binalar[binaid][Tur]));
			Binalar[binaid][Label] = CreateDynamic3DTextLabel(str, 0xE2B960FF, Binalar[binaid][Ext][0], Binalar[binaid][Ext][1], Binalar[binaid][Ext][2] + 0.2, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, Binalar[binaid][World], Binalar[binaid][Interior]);
		}
	}

	new query[1280];
	mysql_format(conn, query, sizeof(query), "UPDATE binalar SET BinaAdi = '%e', ExtX = %.4f, ExtY = %.4f, ExtZ = %.4f, IntX = %.4f, IntY = %.4f, IntZ = %.4f, Interior = %i, World = %i, Durum = %i, Tur = %i WHERE BinaId = '%i'",
		Binalar[binaid][BinaAdi],
		Binalar[binaid][Ext][0],
		Binalar[binaid][Ext][1],
		Binalar[binaid][Ext][2],
		Binalar[binaid][Int][0],
		Binalar[binaid][Int][1],
		Binalar[binaid][Int][2],
		Binalar[binaid][Interior],
		Binalar[binaid][World],
		Binalar[binaid][Durum],
		Binalar[binaid][Tur],
	Binalar[binaid][id]);
	mysql_tquery(conn, query);
	mysql_format(conn, query, sizeof(query), "UPDATE binalar SET IcWorld = %i, IcInterior = %i WHERE BinaId = %i",
		Binalar[binaid][IcWorld],
		Binalar[binaid][IcInterior],
	Binalar[binaid][id]);
	mysql_tquery(conn, query);
	return true;
}

Vice:BinaSlot()
{
	new binaid = -1;
	for(new i = 0; i < MAKSIMUM_BINA; i++)
	{
		if(Binalar[i][Gecerli] == true) continue;
		binaid = i; break;
	}
	return binaid;
}

Vice:BinaSil(playerid, binaid)
{
	if(IsValidDynamicPickup(Binalar[binaid][Pickup])) DestroyDynamicPickup(Binalar[binaid][Pickup]);
	if(IsValidDynamic3DTextLabel(Binalar[binaid][Label])) DestroyDynamic3DTextLabel(Binalar[binaid][Label]);
	Binalar[binaid][Gecerli] = false;

	new query[128];
	mysql_format(conn, query, sizeof(query), "DELETE FROM binalar WHERE BinaId = '%i'", Binalar[binaid][id]);
	mysql_tquery(conn, query);

	Sunucu(playerid, "Bir bina sildiniz.");
	return true;
}

Vice:BinaYakin(playerid)
{
	new deger = -1;
	for(new i = 0; i < MAKSIMUM_BINA; i++)
	{
		if(Binalar[i][Gecerli] == true)
		{
			if(IsPlayerInRangeOfPoint(playerid, 2.0, Binalar[i][Ext][0], Binalar[i][Ext][1], Binalar[i][Ext][2]) && GetPlayerVirtualWorld(playerid) == Binalar[i][World] && GetPlayerInterior(playerid) == Binalar[i][Interior])
			{
				deger = i;
				return deger;
			}
		}
	}
	return deger;
}

Vice:BinaIcYakin(playerid)
{
	new deger = -1;
	for(new i = 0; i < MAKSIMUM_BINA; i++)
	{
		if(Binalar[i][Gecerli] == true)
		{
			if(IsPlayerInRangeOfPoint(playerid, 2.0, Binalar[i][Int][0], Binalar[i][Int][1], Binalar[i][Int][2]) && GetPlayerVirtualWorld(playerid) == Binalar[i][IcWorld] && GetPlayerInterior(playerid) == Binalar[i][IcInterior])
			{
				deger = i;
				return deger;
			}
		}
	}
	return deger;
}

Vice:BinaIcinde(playerid)
{
	new deger = -1;
	for(new i = 0; i < MAKSIMUM_BINA; i++)
	{
		if(Binalar[i][Gecerli] == true)
		{
			if(GetPlayerVirtualWorld(playerid) == Binalar[i][IcWorld] && GetPlayerInterior(playerid) == Binalar[i][IcInterior])
			{
				deger = i;
				return deger;
			}
		}
	}
	return deger;
}

stock BinaTurIsim(binatur)
{
	new isim[32];
	switch(binatur)
	{
		case 1: isim = "Banka";
		case 2: isim = "Polis Departman�";
		case 3: isim = "Giyim D�kkan�";
		default: isim = "Bina";
	}
	return isim;
}