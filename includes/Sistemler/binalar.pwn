// YÖNETÝCÝ KOMUTLARI
CMD:binayarat(playerid, params[])
{
	if(Hesap[playerid][Yonetici] < 5) return YetersizYetki(playerid);

	new binaadi[24], Float: x, Float: y, Float: z, interior = GetPlayerInterior(playerid), world = GetPlayerVirtualWorld(playerid), tur;
	if(sscanf(params, "ds[24]", tur, binaadi)) return Sunucu(playerid, "/binayarat [tur] [bina adý]"), GenelMesajGonder(playerid, "Türler: 1-Banka, 2-Polis");
	if(strlen(binaadi) < 1 || strlen(binaadi) > 24) return Sunucu(playerid, "Minimum 1-24 karakter arasý bir isim girmelisiniz.");

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
		if(!Binalar[binaid][Gecerli]) return Sunucu(playerid, "Geçersiz id girdiniz.");

		if(!strcmp(secenek, "binaisim", true))
		{
			new binaadi[24];
			if(sscanf(ekstra, "s[24]", binaadi)) return Sunucu(playerid, "/binaduzenle [binaid] [binaisim] [yeni isim(24)]");
			if(strlen(binaadi) < 1 || strlen(binaadi) > 24) return Sunucu(playerid, "Minimum 1-24 karakter arasý bir isim girmelisiniz.");

			new binaisim[24];
			format(binaisim, 24, "%s", binaadi);
			Binalar[binaid][BinaAdi] = binaisim;
			BinaVeriKaydet(binaid);

			Sunucu(playerid, "%d id'li binanýn ismini %s olarak deðiþtirdiniz.", binaid, Binalar[binaid][BinaAdi]);
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

			Sunucu(playerid, "%d id'li binanýn dýþ kapý konumunu deðiþtirdiniz.", binaid);
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

			Sunucu(playerid, "%d id'li binanýn iç kapý konumunu deðiþtirdiniz.", binaid);
		}
		else if(!strcmp(secenek, "durum", true))
		{
			new durum;
			if(sscanf(ekstra, "d", durum))
			{
				Sunucu(playerid, "/binaduzenle [binaid] [durum] [deðer]");
				GenelMesajGonder(playerid, "Açýk: 0 | Kilitli: 1 | Mühürlü: 2");
			}
			else
			{
				if(durum < 0 || durum > 2) return Sunucu(playerid, "Geçersiz deðer girdiniz.");

				Binalar[binaid][Durum] = durum;
				BinaVeriKaydet(binaid);

				Sunucu(playerid, "%d id'li binanýn durumunu deðiþtirdiniz.", binaid);
			}
		}
		else Sunucu(playerid, "Hatalý parametre girdin.");
	}
	return true;
}

CMD:binasil(playerid, params[])
{
	if(Hesap[playerid][Yonetici] < 5) return YetersizYetki(playerid);

	new binaid;
	if(sscanf(params, "d", binaid)) return Sunucu(playerid, "/binasil [binaid]");
	if(!Binalar[binaid][Gecerli]) return Sunucu(playerid, "Geçersiz id girdiniz.");

	BinaSil(playerid, binaid);
	return true;
}

CMD:binaid(playerid, params[])
{
	if(Hesap[playerid][Yonetici] < 5) return YetersizYetki(playerid);

	if(BinaYakin(playerid) == -1) return Sunucu(playerid, "Yakýnýnýzda bina bulunmamaktadýr.");

	Sunucu(playerid, "%d id'li binanýn yakýnýndasýnýz.", BinaYakin(playerid));
	return true;
}

// BANKA

CMD:banka(playerid, params[])
{
	if(BinaIcinde(playerid) != -1)
	{
		new binaid = BinaIcinde(playerid);
		if(Binalar[binaid][Tur] != 1) return Sunucu(playerid, "Bir bankada deðilsin.");
		new bankastr[900];
		strcat(bankastr, "Seçenek\tAçýklama\n");
		strcat(bankastr, "{3C5DA5}Hesap Bilgileri\t{FFFFFF}Banka hesap numaranýzý ve hesabýnýzdaki para miktarýný görüntüleyebilirsiniz.\n");
		strcat(bankastr, "{3C5DA5}Para Çek\t{FFFFFF}Banka hesabýnýzdan para çekimi yapabilirsiniz.\n");
		strcat(bankastr, "{3C5DA5}Para Yatýr\t{FFFFFF}Banka hesabýnýza üstünüzdeki paradan istediðiniz kadar yatýrabilirsiniz.\n");
		strcat(bankastr, "{3C5DA5}Para Transferi\t{FFFFFF}Baþka bir banka hesap numarasýna banka hesabýnýzda bulunan parayý transfer edebilirsiniz.\n");
		strcat(bankastr, "{3C5DA5}Mevduat Hesabý\t{FFFFFF}Banka hesabýnýzdan bir miktar parayý yatýrarak her saat paranýzýn faizlenmesini saðlayabilirsiniz.");
		Dialog_Show(playerid, DIALOG_BANKA, DIALOG_STYLE_TABLIST_HEADERS, "{99C794}Banka", bankastr, "Seç", "Ýptal");
	}
	else Sunucu(playerid, "Bir bankada deðilsin.");
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
				Dialog_Show(playerid, DIALOG_BANKA_BILGILER, DIALOG_STYLE_MSGBOX, "{99C794}Hesap Bilgileri", "Hesap Sahibi: %s\nHesap Numarasý: %d\nHesapta Bulunan Para: %s\nMevduat Hesabýnda Bulunan Para: %s", "Çýkýþ", "", RPIsim(playerid), Karakter[playerid][BankaNo], NumaraFormati(Karakter[playerid][BankaPara]), NumaraFormati(Karakter[playerid][Mevduat]));
			}
			case 1:
			{
				Dialog_Show(playerid, DIALOG_BANKA_PARACEK, DIALOG_STYLE_INPUT, "{99C794}Para Çek", "Banka hesabýnýzda %s para bulunuyor.\nÇekmek istediðiniz miktarý aþaðýya girebilirsiniz.", "Çek", "Ýptal", NumaraFormati(Karakter[playerid][BankaPara]));
			}
			case 2:
			{
				Dialog_Show(playerid, DIALOG_BANKA_PARAYATIR, DIALOG_STYLE_INPUT, "{99C794}Para Yatýr", "Banka hesabýnýzda %s para bulunuyor.\nBu paranýn üstüne ne kadar para yatýrmak istersiniz?", "Yatýr", "Ýptal", NumaraFormati(Karakter[playerid][BankaPara]));
			}
			case 3:
			{
				Dialog_Show(playerid, DIALOG_BANKA_TRANSFER, DIALOG_STYLE_INPUT, "{99C794}Para Transferi", "Para transferi yapmak istediðiniz banka hesap numarasýný girin.", "Devam", "Ýptal");
			}
			case 4:
			{
				if(Karakter[playerid][Mevduat] < 1)
				{
					Dialog_Show(playerid, DIALOG_MEVDUAT_YATIR, DIALOG_STYLE_INPUT, "{99C794}Mevduat Hesabý", "Banka hesabýnýzda bulunan paradan buraya yatýrým yapabilirsiniz.\
					\nEn az $50.000, en fazla $100.000 para yatýrýlabilir.\n{3C5DA5}NOT:{FFFFFF}Yatýrdýktan sonra para geri çekilene kadar kullanýlamaz.\nBanka hesabýnýzda %s bulunuyor.\nYatýrmak istediðiniz para miktarýný girin.", "Onayla", "Ýptal", NumaraFormati(Karakter[playerid][BankaPara]));
				}
				else
				{
					Dialog_Show(playerid, DIALOG_MEVDUAT_CEK, DIALOG_STYLE_MSGBOX, "{99C794}Mevduat Hesabý", "Mevduat hesabýnýzda %s birikmiþ görünüyor.\nParanýn tamamýný çekmek istediðinize emin misiniz?", "Onayla", "Ýptal", NumaraFormati(Karakter[playerid][Mevduat]));
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
			return Dialog_Show(playerid, DIALOG_MEVDUAT_YATIR, DIALOG_STYLE_INPUT, "{99C794}Mevduat Hesabý", "Hatalý para miktarý.\nBanka hesabýnýzda bulunan paradan buraya yatýrým yapabilirsiniz.\
			\nEn az $50.000, en fazla $100.000 para yatýrýlabilir.\n{3C5DA5}NOT:{FFFFFF}Yatýrdýktan sonra para geri çekilene kadar kullanýlamaz.\nBanka hesabýnýzda %s bulunuyor.\nYatýrmak istediðiniz para miktarýný girin.", "Onayla", "Ýptal", NumaraFormati(Karakter[playerid][BankaPara]));
		if(Karakter[playerid][BankaPara] < miktar) return Sunucu(playerid, "Banka hesabýnýzda yeterli miktarda para bulunmuyor, iþlem iptal edildi.");
		Karakter[playerid][BankaPara] -= miktar;
		Karakter[playerid][Mevduat] = miktar;
		Sunucu(playerid, "Mevduat hesabýnýza %s yatýrdýnýz. Paranýz her saat faizlenecek.(yalnýzca oyundayken)", NumaraFormati(miktar));
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
		Sunucu(playerid, "Mevduat hesabýnýzda bulunan %s parayý çektiniz. Mevduat hesabý sýfýrlandý.", NumaraFormati(miktar));
		Log_Kaydet("loglar/banka_mevduat_cekme.txt", "[%s] %s adli kisi %s miktarinda parayi mevduat hesabindan cekti.", TarihCek(), RPIsim(playerid), NumaraFormati(miktar));
	}
}

Dialog:DIALOG_BANKA_TRANSFER(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		new hesap = strval(inputtext);
		if(isnull(inputtext) || hesap < 1) return Dialog_Show(playerid, DIALOG_BANKA_TRANSFER, DIALOG_STYLE_INPUT, "{99C794}Para Transferi", "Geçersiz hesap numarasý girdiniz.\nPara transferi yapmak istediðiniz banka hesap numarasýný girin.", "Devam", "Ýptal"); 
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
		// Hesap numarasý kontrol(eðer oyunda deðilse)
		if(oid == -1)
		{
			new query[144];
			mysql_format(conn, query, sizeof(query), "SELECT * FROM karakterler WHERE BankaNo = %i", hesap);
			mysql_tquery(conn, query, "BankaNoArat", "ii", playerid, hesap);
		}
		// Transfer yeni diyalog(eðer oyundaysa)
		else
		{
			SetPVarInt(playerid, "TransferHesapNo", hesap);
			Dialog_Show(playerid, DIALOG_BANKA_TRANSFER2, DIALOG_STYLE_INPUT, "{99C794}Para Transferi", "%s adlý kiþinin %d hesap numarasýna transfer yapýyorsunuz.\nTransfer etmek istediðiniz para miktarýný girin.", "Onayla", "Ýptal", isim, hesap);
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
		Dialog_Show(playerid, DIALOG_BANKA_TRANSFER2, DIALOG_STYLE_INPUT, "{99C794}Para Transferi", "%s adlý kiþinin %d hesap numarasýna transfer yapýyorsunuz.\nTransfer etmek istediðiniz para miktarýný girin.", "Onayla", "Ýptal", isim, hesap);
	}
	else Dialog_Show(playerid, DIALOG_BANKA_TRANSFER, DIALOG_STYLE_INPUT, "{99C794}Para Transferi", "Hesap numarasý bulunamadý.\nPara transferi yapmak istediðiniz banka hesap numarasýný girin.", "Devam", "Ýptal");
	return true;
}

Dialog:DIALOG_BANKA_TRANSFER2(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		new miktar = strval(inputtext);
		if(isnull(inputtext) || miktar < 1) return Sunucu(playerid, "Geçersiz para deðeri, iþlem iptal edildi.");
		if(Karakter[playerid][BankaPara] < miktar) return Sunucu(playerid, "Banka hesabýnýzdaki para yetersiz, iþlem iptal edildi.");
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
			Sunucu(playerid, "%s adlý kiþinin %d numaralý banka hesabýna %s para gönderdiniz.", Karakter[oid][Isim], hesap, NumaraFormati(miktar));
			Sunucu(oid, "%s adlý kiþinin %d numaralý banka hesabýndan %s hesabýnýza transfer edildi.", Karakter[playerid][Isim], Karakter[playerid][BankaNo], NumaraFormati(miktar));
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
		Sunucu(playerid, "%s adlý kiþinin banka hesabýna %s para transfer ettiniz.", isim, NumaraFormati(miktar));
		Log_Kaydet("loglar/banka_offline_transfer.txt", "[%s] %s adli kisi %s adli kisinin banka hesabina %s para yatirdi.", TarihCek(), RPIsim(playerid), isim, NumaraFormati(miktar));
	}
	else 
	{
		Sunucu(playerid, "Hesap numarasýna ulaþýrken bir hata oluþtu. Daha sonra tekrar deneyin.");
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
		if(isnull(inputtext) || miktar < 1) return Dialog_Show(playerid, DIALOG_BANKA_PARACEK, DIALOG_STYLE_INPUT, "{99C794}Para Çek", "Hatalý miktar girdiniz.\nBanka hesabýnýzda %s para bulunuyor.\nÇekmek istediðiniz miktarý aþaðýya girebilirsiniz.", "Çek", "Ýptal", NumaraFormati(Karakter[playerid][BankaPara]));
		if(Karakter[playerid][BankaPara] < miktar) return Dialog_Show(playerid, DIALOG_BANKA_PARACEK, DIALOG_STYLE_INPUT, "{99C794}Para Çek", "Banka hesabýnýzda bu kadar para bulunmuyor.\nBanka hesabýnýzda %s para bulunuyor.\nÇekmek istediðiniz miktarý aþaðýya girebilirsiniz.", "Çek", "Ýptal", NumaraFormati(Karakter[playerid][BankaPara]));
		Karakter[playerid][BankaPara] -= miktar;
		ParaVer(playerid, miktar);
		Sunucu(playerid, "Banka hesabýnýzdan %s para çektiniz. Hesabýnýzda %s para kaldý.", NumaraFormati(miktar), NumaraFormati(Karakter[playerid][BankaPara]));
		Log_Kaydet("loglar/banka_para_cekme.txt", "[%s] %s adli kisi banka hesabindan %s para cekti. Kalan Para: %s", TarihCek(), RPIsim(playerid), NumaraFormati(miktar), NumaraFormati(Karakter[playerid][BankaPara]));
	}
	return true;
}

Dialog:DIALOG_BANKA_PARAYATIR(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		new miktar = strval(inputtext);
		if(isnull(inputtext) || miktar < 1) return Dialog_Show(playerid, DIALOG_BANKA_PARAYATIR, DIALOG_STYLE_INPUT, "{99C794}Para Yatýr", "Hatalý miktar girdiniz.\nBanka hesabýnýzda %s para bulunuyor.\nBu paranýn üstüne ne kadar para yatýrmak istersiniz?", "Yatýr", "Ýptal", NumaraFormati(Karakter[playerid][BankaPara]));
		if(Karakter[playerid][Para] < miktar) return Dialog_Show(playerid, DIALOG_BANKA_PARAYATIR, DIALOG_STYLE_INPUT, "{99C794}Para Yatýr", "Üstünüzde bu kadar para bulunmuyor.\nBanka hesabýnýzda %s para bulunuyor.\nBu paranýn üstüne ne kadar para yatýrmak istersiniz?", "Yatýr", "Ýptal", NumaraFormati(Karakter[playerid][BankaPara]));
		ParaVer(playerid, -miktar);
		Karakter[playerid][BankaPara] += miktar;
		Sunucu(playerid, "Banka hesabýnýza %s para yatýrdýnýz. Hesabýnýzda %s para oldu.", NumaraFormati(miktar), NumaraFormati(Karakter[playerid][BankaPara]));
		Log_Kaydet("loglar/banka_para_yatirma.txt", "[%s] %s adli kisi banka hesabina %s para yatirdi. Yeni Para: %s", TarihCek(), RPIsim(playerid), NumaraFormati(miktar), NumaraFormati(Karakter[playerid][BankaPara]));
	}
	return true;
}

// GÝYÝM DÜKKANLARI

CMD:kiyafetal(playerid, params[])
{
	if(BinaIcinde(playerid) != -1)
	{
		new binaid = BinaIcinde(playerid);
		if(Binalar[binaid][Tur] != 3) return Sunucu(playerid, "Bir giyim dükkanýnda deðilsin.");
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
						ShowPlayerDialog(playerid, 23300, DIALOG_STYLE_PREVMODEL, "Beyaz Kadýn Skinleri", dialogstr, "Sec", "Iptal");
					}
					case 2:
					{
						new dialogstr[1540];
						for(new i; i < sizeof(KadinSiyahSkinler); i++)
						{
							format(dialogstr, sizeof(dialogstr), "%s%d\nID: %d\n", dialogstr, KadinSiyahSkinler[i], KadinSiyahSkinler[i]);
						}
						ShowPlayerDialog(playerid, 23300, DIALOG_STYLE_PREVMODEL, "Siyah Kadýn Skinleri", dialogstr, "Sec", "Iptal");
					}
				}
			}
		}
	}
	else Sunucu(playerid, "Bir giyim dükkanýnda deðilsin.");
	return true;
}

Dialog:DIALOG_KIYAFET_ONAY(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		if(Karakter[playerid][Para] < KIYAFET_UCRET) return Sunucu(playerid, "Bu kýyafeti almak için yeterli paran yok."), DeletePVar(playerid, "AlinacakSkin");
		new skinid = GetPVarInt(playerid, "AlinacakSkin");
		Karakter[playerid][Skin] = skinid;
		SetPlayerSkin(playerid, Karakter[playerid][Skin]);
		Sunucu(playerid, "Yeni bir kýyafet aldýn, güle güle kullan.");
		ParaVer(playerid, -300);
		DeletePVar(playerid, "AlinacakSkin");
	}
	else
	{
		DeletePVar(playerid, "AlinacakSkin");
	}
	return true;
}

// FONKSÝYONLAR
Vice:BinaYarat(playerid, binaadi[], Float: x, Float: y, Float: z, interior, world, tur)
{
	new binaid = BinaSlot();
	if(binaid == -1) return Sunucu(playerid, "Sunucu bina limitine ulaþýldý.");
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
	format(str, sizeof(str), "{99C794}%s\n{99C794}Tür: {E2E2E2}%s\n{99C794}Durum: {FFFFFF}Açýk", Binalar[binaid][BinaAdi], BinaTurIsim(Binalar[binaid][Tur]));
	Binalar[binaid][Label] = CreateDynamic3DTextLabel(str, 0xE2B960FF, Binalar[binaid][Ext][0], Binalar[binaid][Ext][1], Binalar[binaid][Ext][2] + 0.2, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, Binalar[binaid][World], Binalar[binaid][Interior]);

	Sunucu(playerid, "Bina bulunduðunuz noktada yaratýldý. (( ID: %d ))", binaid);
	Sunucu(playerid, "Binanýn giriþ ve çýkýþ noktalarýný düzenlemek için /binaduzenle komutunu kullan.");
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
				format(str, sizeof(str), "{99C794}%s\n{99C794}Tür: {E2E2E2}%s\n{99C794}Durum: {FFFFFF}Açýk", Binalar[i][BinaAdi], BinaTurIsim(Binalar[i][Tur]));
				Binalar[i][Label] = CreateDynamic3DTextLabel(str, 0xE2B960FF, Binalar[i][Ext][0], Binalar[i][Ext][1], Binalar[i][Ext][2] + 0.2, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, Binalar[i][World], Binalar[i][Interior]);
			}
			case 1:
			{
				format(str, sizeof(str), "{99C794}%s\n{99C794}Tür: {E2E2E2}%s\n{99C794}Durum: {E2E2E2}Kilitli", Binalar[i][BinaAdi], BinaTurIsim(Binalar[i][Tur]));
				Binalar[i][Label] = CreateDynamic3DTextLabel(str, 0xE2B960FF, Binalar[i][Ext][0], Binalar[i][Ext][1], Binalar[i][Ext][2] + 0.2, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, Binalar[i][World], Binalar[i][Interior]);
			}
			case 2:
			{
				format(str, sizeof(str), "{99C794}%s\n{99C794}Tür: {E2E2E2}%s\n{99C794}Durum: {FF0000}Mühürlü", Binalar[i][BinaAdi], BinaTurIsim(Binalar[i][Tur]));
				Binalar[i][Label] = CreateDynamic3DTextLabel(str, 0xE2B960FF, Binalar[i][Ext][0], Binalar[i][Ext][1], Binalar[i][Ext][2] + 0.2, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, Binalar[i][World], Binalar[i][Interior]);
			}
		}
		rowcount++;
	}
	printf("[MySQL] Veritabanýndan '%i' adet bina yüklendi.", rowcount);
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
			format(str, sizeof(str), "{99C794}%s\n{99C794}Tür: {E2E2E2}%s\n{99C794}Durum: {FFFFFF}Açýk", Binalar[binaid][BinaAdi], BinaTurIsim(Binalar[binaid][Tur]));
			Binalar[binaid][Label] = CreateDynamic3DTextLabel(str, 0xE2B960FF, Binalar[binaid][Ext][0], Binalar[binaid][Ext][1], Binalar[binaid][Ext][2] + 0.2, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, Binalar[binaid][World], Binalar[binaid][Interior]);
		}
		case 1:
		{
			format(str, sizeof(str), "{99C794}%s\n{99C794}Tür: {E2E2E2}%s\n{99C794}Durum: {E2E2E2}Kilitli", Binalar[binaid][BinaAdi], BinaTurIsim(Binalar[binaid][Tur]));
			Binalar[binaid][Label] = CreateDynamic3DTextLabel(str, 0xE2B960FF, Binalar[binaid][Ext][0], Binalar[binaid][Ext][1], Binalar[binaid][Ext][2] + 0.2, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, Binalar[binaid][World], Binalar[binaid][Interior]);
		}
		case 2:
		{
			format(str, sizeof(str), "{99C794}%s\n{99C794}Tür: {E2E2E2}%s\n{99C794}Durum: {FF0000}Mühürlü", Binalar[binaid][BinaAdi], BinaTurIsim(Binalar[binaid][Tur]));
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
		case 2: isim = "Polis Departmaný";
		case 3: isim = "Giyim Dükkaný";
		default: isim = "Bina";
	}
	return isim;
}