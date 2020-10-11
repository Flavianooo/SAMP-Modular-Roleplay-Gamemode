CMD:birlik(playerid, params[])
{
	if(Karakter[playerid][Birlik] == -1) return Sunucu(playerid, "Bir birlikte deðilsiniz.");
	new dialogStr[2500], baslik[48];
	strcat(dialogStr, "Seçenek\tAçýklama\n");
	strcat(dialogStr, "{3C5DA5}Birlik Bilgileri\t{FFFFFF}Birliðinize ait bilgilere buradan ulaþabilirsiniz.\n");
	strcat(dialogStr, "{3C5DA5}Birlik Üyeleri\t{FFFFFF}Birlikteki üyeleri buradan görebilirsiniz. Yetkisi olanlar iþlem yapabilir.\n");
	strcat(dialogStr, "{3C5DA5}Birlik OOC Kanalý\t{FFFFFF}/f konuþma kanalý lider tarafýndan aktif/pasif hale getirilebilir.\n");
	strcat(dialogStr, "{3C5DA5}Rütbe Adlarýný Düzenle\t{FFFFFF}Yalnýzca lider tarafýndan rütbe isimleri düzenlenebilir.\n");
	strcat(dialogStr, "{3C5DA5}Rütbe Yetkilendirmeleri\t{FFFFFF}Yalnýzca lider tarafýndan diðer rütbelerin yetkileri düzenlenebilir.\n");
	strcat(dialogStr, "{3C5DA5}Birliðe Davet Et\t{FFFFFF}Davet yetkisi olan kiþiler tarafýndan yeni üyeler davet edilebilir.\n");
	strcat(dialogStr, "{3C5DA5}Birlik Kasasý\t{FFFFFF}Yalnýzca lider tarafýndan kasadaki para kontrol edilip çekilebilir.\n");
	strcat(dialogStr, "{3C5DA5}Birlik Araçlarý\t{FFFFFF}Birliðinize ait araçlarý buradan görüntüleyebilirsiniz.\n");

	format(baslik, sizeof(baslik), "%s", Birlikler[Karakter[playerid][Birlik]][Isim]);
	Dialog_Show(playerid, DIALOG_BIRLIK_MENU, DIALOG_STYLE_TABLIST_HEADERS, baslik, dialogStr, "Seç", "Ýptal");
	return true;
}

Dialog:DIALOG_BIRLIK_MENU(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		if(Karakter[playerid][Birlik] == -1) return Sunucu(playerid, "Bir birlikte deðilsiniz.");
		new birlikid = Karakter[playerid][Birlik], query[256];
		switch(listitem)
		{
			case 0:
			{
				new str[144], uyeSayisi = 0, Cache:VeriCek;
				mysql_format(conn, query, sizeof(query), "SELECT * FROM karakterler WHERE Birlik = %i", Birlikler[birlikid][id]);
				VeriCek = mysql_query(conn, query);
				new rows;
				cache_get_row_count(rows);
				uyeSayisi = rows;
				cache_delete(VeriCek);
				format(str, sizeof(str), "Üye Sayýsý: %d\nBirlik Seviyesi: %d\nBirlik Türü: %s", uyeSayisi, Birlikler[birlikid][Seviye], BirlikTurIsim(Birlikler[birlikid][Tur]));
				Dialog_Show(playerid, DIALOG_BIRLIK_BILGILER, DIALOG_STYLE_MSGBOX, "Birlik Bilgileri", str, "Tamam", "");
			}
			case 1:
			{
				new rows, Cache:VeriCek;
				mysql_format(conn, query, sizeof(query), "SELECT * FROM karakterler WHERE Birlik = %i", Birlikler[birlikid][id]);
				VeriCek = mysql_query(conn, query);
				cache_get_row_count(rows);
				if(rows)
				{
					new isim[40], rankNo, str[96], dialogstr[1526];
					strcat(dialogstr, "Ýsim\tRütbe\n");
					for(new i = 0; i < rows; i++)
					{
						cache_get_value_name(i, "isim", isim, 40);
						cache_get_value_name_int(i, "BirlikRutbe", rankNo);
						format(str, sizeof(str), "%s\t%s\n", isim, RutbeAdiCek(birlikid, rankNo));
						strcat(dialogstr, str);
					}
					Dialog_Show(playerid, DIALOG_BIRLIK_UYELER, DIALOG_STYLE_TABLIST_HEADERS, "Birlik Üyeleri", dialogstr, "Seç", "Ýptal");
				}
				else
				{
					Sunucu(playerid, "Birliðinizde oyuncu bulunamadý.");
				}
				cache_delete(VeriCek);
			}

			case 4:
			{
				new  dialogStr[1526], str[90], uyeyetkidurum[16], lideryetkidurum[16];
				strcat(dialogStr, "Rütbe\tÜye Yönetim Yetkisi\tLiderlik\n");
				for(new i = 0; i < 20; i++)
				{
					if(i < 19)
					{
						if(Birlikler[birlikid][UyeYetkisi][i] != 0)
						{
							uyeyetkidurum = "{33AA33}Var";
						}
						else
						{
							uyeyetkidurum = "{B70000}Yok";
						}
						lideryetkidurum = "{B70000}Yok";
					}
					else
					{
						uyeyetkidurum = "{33AA33}Var";
						lideryetkidurum = "{33AA33}Var";
					}
					format(str, sizeof(str), "%s\t%s\t%s\n", RutbeAdiCek(birlikid, i + 1), uyeyetkidurum, lideryetkidurum);
					strcat(dialogStr, str);
				}			
				Dialog_Show(playerid, DIALOG_RUTBE_YETKILERI, DIALOG_STYLE_TABLIST_HEADERS, "{99C794}Rütbe Yetkileri", dialogStr, "Yetkilendir", "Ýptal");
			}
		}
	}
	return true;
}

Dialog:DIALOG_BIRLIK_UYELER(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		if(Karakter[playerid][Birlik] == -1) return Sunucu(playerid, "Bir birlikte deðilsiniz.");
		new birlikid = Karakter[playerid][Birlik];
		if(Karakter[playerid][BirlikRutbe] < 20 && !UyeYetkiKontrol(birlikid, Karakter[playerid][BirlikRutbe])) return Sunucu(playerid, "Üye kontrol yetkiniz bulunmuyor. Ýþlem yapamazsýnýz.");
		SetPVarString(playerid, "BirlikUyeSecim", inputtext);
		Dialog_Show(playerid, DIALOG_BIRLIK_UYEISLEM, DIALOG_STYLE_LIST, inputtext, "Rütbe Deðiþtir\nBirlikten At", "Seç", "Ýptal");
	}
	return true;
}

CMD:liderayarla(playerid, params[])
{
	if(Hesap[playerid][Yonetici] < 6) return YetersizYetki(playerid);
	new oyuncu, birlikid;
	if(sscanf(params, "ud", oyuncu, birlikid)) return Kullanim(playerid, "/liderayarla [id/isim]");
	if(oyuncu < 0 || oyuncu > MAX_PLAYERS) return Sunucu(playerid, "Hatalý ID.");
	if(!IsPlayerConnected(oyuncu) || !Karakter[oyuncu][Giris]) return Sunucu(playerid, "Geçersiz oyuncu.");
	if(birlikid < 0 || birlikid > MAX_BIRLIK) return Sunucu(playerid, "Geçersiz birlik");
	if(Birlikler[birlikid][Gecerli] == false) return Sunucu(playerid, "Geçersiz birlik.");
	Karakter[oyuncu][Birlik] = birlikid;
	Karakter[oyuncu][BirlikRutbe] = 20;
	KarakterVeriKaydet(oyuncu);
	Sunucu(oyuncu, "%s(%s) adlý yönetici tarafýndan %s adlý birliðin lideri olarak ayarlandýnýz.", RPIsim(playerid), Hesap[playerid][YoneticiIsim], Birlikler[birlikid][Isim]);
	Sunucu(playerid, "%s adlý oyuncuyu %s adlý birliðin lideri yaptýnýz.", RPIsim(oyuncu), Birlikler[birlikid][Isim]);
	return true;
}

CMD:birlikyarat(playerid, params[])
{
	if(Hesap[playerid][Yonetici] < 6) return YetersizYetki(playerid);
	new birlikIsim[40], birlikid, birlikTur;
	if(sscanf(params, "ds[40]", birlikTur, birlikIsim))
	{
		Kullanim(playerid, "/birlikyarat [tür] [isim]");
		GenelMesajGonder(playerid, "Türler: 1 - Polis | 2 - Hastane | 3 - Mafya | 4 - Çete | 5 - Yarýþçý | 6 - Diðer");
		return true;
	}
	if(strlen(birlikIsim) > 40) return Sunucu(playerid, "40 karakterden kýsa bir birlik ismi girmelisiniz.");
	if(birlikTur < 1 || birlikTur > 6) return Sunucu(playerid, "Geçersiz tür girdiniz.");
	birlikid = BirlikYarat(birlikIsim, birlikTur);
	if(birlikid == -1) return Sunucu(playerid, "Sunucudaki birlik limitine ulaþýldý. Lütfen üst yöneticilere ulaþýn/ticket gönderin.");
	Sunucu(playerid, "%s ismindeki birlik yaratýldý. Tür: %s", birlikIsim, BirlikTurIsim(birlikTur));
	return true;
}

CMD:birlikduzenle(playerid, params[])
{
	if(Hesap[playerid][Yonetici] < 6) return YetersizYetki(playerid);
	new birlikid, secenek[32], ekstra[64];
	if(sscanf(params, "ds[32]S()[64]", birlikid, secenek, ekstra))
	{
		Kullanim(playerid, "/birlikduzenle [id] [seçenek]");
		GenelMesajGonder(playerid, "Seçenekler: isim, tur");
		return true;
	}
	if(birlikid < 0 || birlikid > MAX_BIRLIK) return Sunucu(playerid, "Hatalý birlik ID'si girdiniz.");
	if(Birlikler[birlikid][Gecerli] == false) return Sunucu(playerid, "Geçersiz birlik.");
	if(!strcmp(secenek, "isim", true))
	{
		new isim[40];
		if(sscanf(ekstra, "s[40]", isim)) return Kullanim(playerid, "/birlikduzenle [id] isim [yeni isim]");
		if(strlen(isim) > 40) return Sunucu(playerid, "40 karakterden kýsa bir birlik ismi girmelisiniz.");
		format(Birlikler[birlikid][Isim], 40, "%s", isim);
		BirlikVeriKaydet(birlikid);
		Sunucu(playerid, "%d ID'li birliðin ismini %s olarak güncellediniz.", birlikid, isim);
	}
	else if(!strcmp(secenek, "tur", true))
	{
		return true;
	}
	return true;
}

CMD:birlikler(playerid, params[])
{
	if(Hesap[playerid][Yonetici] < 6) return YetersizYetki(playerid);
	new dialogStr[3400], str[144];
	strcat(dialogStr, "Oyun ID\tÝsim\tTür\n");
	for(new i = 0; i < MAX_BIRLIK; i++)
	{
		if(!Birlikler[i][Gecerli]) continue;
		format(str, sizeof(str), "%d\t%s\t%s\n", Birlikler[i][id], Birlikler[i][Isim], BirlikTurIsim(Birlikler[i][Tur]));
		strcat(dialogStr, str);
	}
	Dialog_Show(playerid, DIALOG_TUM_BIRLIKLER, DIALOG_STYLE_TABLIST_HEADERS, "{99C794}Tüm Birlikler", dialogStr, "Kapat", "");
	return true;
}

// FONKSÝYONLAR



Vice:BirlikYarat(isim[], tur)
{
	new birlikid;
	birlikid = BirlikBosSlot();
	if(birlikid == -1) return -1;
	Birlikler[birlikid][Gecerli] = true;
	format(Birlikler[birlikid][Isim], 40, "%s", isim);
	Birlikler[birlikid][id] = birlikid;
	Birlikler[birlikid][Tur] = tur;
	BirlikRutbeleriSifirla(birlikid);
	new query[218];
	mysql_format(conn, query, sizeof(query), "INSERT INTO birlikler (birlikid, Isim, Tur) VALUES(%i, '%e', %i)", birlikid, Birlikler[birlikid][Isim], tur);
	mysql_tquery(conn, query);
	BirlikRutbeleriSifirla(birlikid);
	BirlikRutbeKaydet(birlikid);
	BirlikRutbeYetkiSifirla(birlikid);
	BirlikRutbeYetkiKaydet(birlikid);
	return birlikid;
}

Vice:BirlikVeriKaydet(birlikid)
{
	new query[1024];
	mysql_format(conn, query, sizeof(query), "UPDATE birlikler SET Isim = '%e', Tur = %i, Seviye = %i WHERE birlikid = %i",
		Birlikler[birlikid][Isim],
		Birlikler[birlikid][Tur],
		Birlikler[birlikid][Seviye],
	Birlikler[birlikid][id]);
	mysql_tquery(conn, query);
	return true;
}

Vice:BirlikRutbeYetkiSifirla(birlikid)
{
	Birlikler[birlikid][UyeYetkisi][0] = 0;
	Birlikler[birlikid][UyeYetkisi][1] = 0;
	Birlikler[birlikid][UyeYetkisi][2] = 0;
	Birlikler[birlikid][UyeYetkisi][3] = 0;
	Birlikler[birlikid][UyeYetkisi][4] = 0;
	Birlikler[birlikid][UyeYetkisi][5] = 0;
	Birlikler[birlikid][UyeYetkisi][6] = 0;
	Birlikler[birlikid][UyeYetkisi][7] = 0;
	Birlikler[birlikid][UyeYetkisi][8] = 0;
	Birlikler[birlikid][UyeYetkisi][9] = 0;
	Birlikler[birlikid][UyeYetkisi][10] = 0;
	Birlikler[birlikid][UyeYetkisi][11] = 0;
	Birlikler[birlikid][UyeYetkisi][12] = 0;
	Birlikler[birlikid][UyeYetkisi][13] = 0;
	Birlikler[birlikid][UyeYetkisi][14] = 0;
	Birlikler[birlikid][UyeYetkisi][15] = 0;
	Birlikler[birlikid][UyeYetkisi][16] = 0;
	Birlikler[birlikid][UyeYetkisi][17] = 0;
	Birlikler[birlikid][UyeYetkisi][18] = 0;
	Birlikler[birlikid][UyeYetkisi][19] = 0;
	return true;
}

Vice:BirlikRutbeYetkiKaydet(birlikid)
{
	new query[1800];
	mysql_format(conn, query, sizeof(query), "UPDATE birlikler SET UYR1 = %i, UYR2 = %i, UYR3 = %i, UYR4 = %i, UYR5 = %i, UYR6 = %i, UYR7 = %i, UYR8 = %i, UYR9 = %i WHERE birlikid = %i",
		Birlikler[birlikid][UyeYetkisi][0],
		Birlikler[birlikid][UyeYetkisi][1],
		Birlikler[birlikid][UyeYetkisi][2],
		Birlikler[birlikid][UyeYetkisi][3],
		Birlikler[birlikid][UyeYetkisi][4],
		Birlikler[birlikid][UyeYetkisi][5],
		Birlikler[birlikid][UyeYetkisi][6],
		Birlikler[birlikid][UyeYetkisi][7],
		Birlikler[birlikid][UyeYetkisi][8],
	Birlikler[birlikid][id]);
	mysql_tquery(conn, query);

	mysql_format(conn, query, sizeof(query), "UPDATE birlikler SET UYR10 = %i, UYR11 = %i, UYR12 = %i, UYR13 = %i, UYR14 = %i, UYR15 = %i, UYR16 = %i, UYR17 = %i, UYR18 = %i WHERE birlikid = %i",
		Birlikler[birlikid][UyeYetkisi][9],
		Birlikler[birlikid][UyeYetkisi][10],
		Birlikler[birlikid][UyeYetkisi][11],
		Birlikler[birlikid][UyeYetkisi][12],
		Birlikler[birlikid][UyeYetkisi][13],
		Birlikler[birlikid][UyeYetkisi][14],
		Birlikler[birlikid][UyeYetkisi][15],
		Birlikler[birlikid][UyeYetkisi][16],
		Birlikler[birlikid][UyeYetkisi][17],
	Birlikler[birlikid][id]);
	mysql_tquery(conn, query);

	mysql_format(conn, query, sizeof(query), "UPDATE birlikler SET UYR19 = %i, UYR20 = %i WHERE birlikid = %i",
		Birlikler[birlikid][UyeYetkisi][18],
		Birlikler[birlikid][UyeYetkisi][19],
	Birlikler[birlikid][id]);
	mysql_tquery(conn, query);
	return true;
}

Vice:BirlikRutbeKaydet(birlikid)
{
	new query[1526];
	mysql_format(conn, query, sizeof(query), "UPDATE birlikler SET R1 = '%e', R2 = '%e', R3 = '%e', R4 = '%e', R5 = '%e', R6 = '%e', R7 = '%e' WHERE birlikid = %i",
		Birlikler[birlikid][R1],
		Birlikler[birlikid][R2],
		Birlikler[birlikid][R3],
		Birlikler[birlikid][R4],
		Birlikler[birlikid][R5],
		Birlikler[birlikid][R6],
		Birlikler[birlikid][R7],
	Birlikler[birlikid][id]);
	mysql_tquery(conn, query);

	mysql_format(conn, query, sizeof(query), "UPDATE birlikler SET R8 = '%e', R9 = '%e', R10 = '%e', R11 = '%e', R12 = '%e', R13 = '%e', R14 = '%e', R15 = '%e' WHERE birlikid = %i",
		Birlikler[birlikid][R8],
		Birlikler[birlikid][R9],
		Birlikler[birlikid][R10],
		Birlikler[birlikid][R11],
		Birlikler[birlikid][R12],
		Birlikler[birlikid][R13],
		Birlikler[birlikid][R14],
		Birlikler[birlikid][R15],
	Birlikler[birlikid][id]);
	mysql_tquery(conn, query);

	mysql_format(conn, query, sizeof(query), "UPDATE birlikler SET R16 = '%e', R17 = '%e', R18 = '%e', R19 = '%e', R20 = '%e' WHERE birlikid = %i", 
		Birlikler[birlikid][R16],
		Birlikler[birlikid][R17],
		Birlikler[birlikid][R18],
		Birlikler[birlikid][R19],
		Birlikler[birlikid][R20],
	Birlikler[birlikid][id]);
	mysql_tquery(conn, query);

	return true;
}

Vice:BirlikRutbeleriSifirla(birlikid)
{
	format(Birlikler[birlikid][R1], 32, "Yok");
	format(Birlikler[birlikid][R2], 32, "Yok");
	format(Birlikler[birlikid][R3], 32, "Yok");
	format(Birlikler[birlikid][R4], 32, "Yok");
	format(Birlikler[birlikid][R5], 32, "Yok");
	format(Birlikler[birlikid][R6], 32, "Yok");
	format(Birlikler[birlikid][R7], 32, "Yok");
	format(Birlikler[birlikid][R8], 32, "Yok");
	format(Birlikler[birlikid][R9], 32, "Yok");
	format(Birlikler[birlikid][R10], 32, "Yok");
	format(Birlikler[birlikid][R11], 32, "Yok");
	format(Birlikler[birlikid][R12], 32, "Yok");
	format(Birlikler[birlikid][R13], 32, "Yok");
	format(Birlikler[birlikid][R14], 32, "Yok");
	format(Birlikler[birlikid][R15], 32, "Yok");
	format(Birlikler[birlikid][R16], 32, "Yok");
	format(Birlikler[birlikid][R17], 32, "Yok");
	format(Birlikler[birlikid][R18], 32, "Yok");
	format(Birlikler[birlikid][R19], 32, "Yok");
	format(Birlikler[birlikid][R20], 32, "Yok");

	Birlikler[birlikid][UyeYetkisi][0] = 0;
	Birlikler[birlikid][UyeYetkisi][1] = 0;
	Birlikler[birlikid][UyeYetkisi][2] = 0;
	Birlikler[birlikid][UyeYetkisi][3] = 0;
	Birlikler[birlikid][UyeYetkisi][4] = 0;
	Birlikler[birlikid][UyeYetkisi][5] = 0;
	Birlikler[birlikid][UyeYetkisi][6] = 0;
	Birlikler[birlikid][UyeYetkisi][7] = 0;
	Birlikler[birlikid][UyeYetkisi][8] = 0;
	Birlikler[birlikid][UyeYetkisi][9] = 0;
	Birlikler[birlikid][UyeYetkisi][10] = 0;
	Birlikler[birlikid][UyeYetkisi][11] = 0;
	Birlikler[birlikid][UyeYetkisi][12] = 0;
	Birlikler[birlikid][UyeYetkisi][13] = 0;
	Birlikler[birlikid][UyeYetkisi][14] = 0;
	Birlikler[birlikid][UyeYetkisi][15] = 0;
	Birlikler[birlikid][UyeYetkisi][16] = 0;
	Birlikler[birlikid][UyeYetkisi][17] = 0;
	Birlikler[birlikid][UyeYetkisi][18] = 0;
	Birlikler[birlikid][UyeYetkisi][19] = 0;
	return true;
}

Vice:BirlikleriYukle()
{
	new rows, rowcount = 0;
	cache_get_row_count(rows);
	if(rows)
	{
		new birlikid;
		for(new i = 0; i < rows; i++)
		{
			cache_get_value_name_int(i, "birlikid", birlikid);
			Birlikler[birlikid][id] = birlikid;
			Birlikler[birlikid][Gecerli] = true;
			cache_get_value_name_int(i, "Tur", Birlikler[birlikid][Tur]);
			cache_get_value_name(i, "Isim", Birlikler[birlikid][Isim], 40);
			cache_get_value_name_int(i, "Seviye", Birlikler[birlikid][Seviye]);

			cache_get_value_name(i, "R1", Birlikler[birlikid][R1], 32);
			cache_get_value_name(i, "R2", Birlikler[birlikid][R2], 32);
			cache_get_value_name(i, "R3", Birlikler[birlikid][R3], 32);
			cache_get_value_name(i, "R4", Birlikler[birlikid][R4], 32);
			cache_get_value_name(i, "R5", Birlikler[birlikid][R5], 32);
			cache_get_value_name(i, "R6", Birlikler[birlikid][R6], 32);
			cache_get_value_name(i, "R7", Birlikler[birlikid][R7], 32);
			cache_get_value_name(i, "R8", Birlikler[birlikid][R8], 32);
			cache_get_value_name(i, "R9", Birlikler[birlikid][R9], 32);
			cache_get_value_name(i, "R10", Birlikler[birlikid][R10], 32);
			cache_get_value_name(i, "R11", Birlikler[birlikid][R11], 32);
			cache_get_value_name(i, "R12", Birlikler[birlikid][R12], 32);
			cache_get_value_name(i, "R13", Birlikler[birlikid][R13], 32);
			cache_get_value_name(i, "R14", Birlikler[birlikid][R14], 32);
			cache_get_value_name(i, "R15", Birlikler[birlikid][R15], 32);
			cache_get_value_name(i, "R16", Birlikler[birlikid][R16], 32);
			cache_get_value_name(i, "R17", Birlikler[birlikid][R17], 32);
			cache_get_value_name(i, "R18", Birlikler[birlikid][R18], 32);
			cache_get_value_name(i, "R19", Birlikler[birlikid][R19], 32);
			cache_get_value_name(i, "R20", Birlikler[birlikid][R20], 32);

			cache_get_value_name_int(i, "UYR1", Birlikler[birlikid][UyeYetkisi][0]);
			cache_get_value_name_int(i, "UYR2", Birlikler[birlikid][UyeYetkisi][1]);
			cache_get_value_name_int(i, "UYR3", Birlikler[birlikid][UyeYetkisi][2]);
			cache_get_value_name_int(i, "UYR4", Birlikler[birlikid][UyeYetkisi][3]);
			cache_get_value_name_int(i, "UYR5", Birlikler[birlikid][UyeYetkisi][4]);
			cache_get_value_name_int(i, "UYR6", Birlikler[birlikid][UyeYetkisi][5]);
			cache_get_value_name_int(i, "UYR7", Birlikler[birlikid][UyeYetkisi][6]);
			cache_get_value_name_int(i, "UYR8", Birlikler[birlikid][UyeYetkisi][7]);
			cache_get_value_name_int(i, "UYR9", Birlikler[birlikid][UyeYetkisi][8]);
			cache_get_value_name_int(i, "UYR10", Birlikler[birlikid][UyeYetkisi][9]);
			cache_get_value_name_int(i, "UYR11", Birlikler[birlikid][UyeYetkisi][10]);
			cache_get_value_name_int(i, "UYR12", Birlikler[birlikid][UyeYetkisi][11]);
			cache_get_value_name_int(i, "UYR13", Birlikler[birlikid][UyeYetkisi][12]);
			cache_get_value_name_int(i, "UYR14", Birlikler[birlikid][UyeYetkisi][13]);
			cache_get_value_name_int(i, "UYR15", Birlikler[birlikid][UyeYetkisi][14]);
			cache_get_value_name_int(i, "UYR16", Birlikler[birlikid][UyeYetkisi][15]);
			cache_get_value_name_int(i, "UYR17", Birlikler[birlikid][UyeYetkisi][16]);
			cache_get_value_name_int(i, "UYR18", Birlikler[birlikid][UyeYetkisi][17]);
			cache_get_value_name_int(i, "UYR19", Birlikler[birlikid][UyeYetkisi][18]);
			cache_get_value_name_int(i, "UYR20", Birlikler[birlikid][UyeYetkisi][19]);

			rowcount++;
		}
	}

	printf("[MySQL] Veritabanýndan '%i' adet birlik yüklendi.", rowcount);
	return true;
}

Vice:BirlikBosSlot()
{
	new bId = -1;
	for(new i = 0; i < MAX_BIRLIK; i++)
	{
		if(Birlikler[i][Gecerli]) continue;
		bId = i;
		break;
	}
	return bId;
}

stock BirlikTurIsim(tur)
{
	new turisim[32];
	switch(tur)
	{
		case 1: turisim = "Polis";
		case 2: turisim = "Hastane";
		case 3: turisim = "Mafya";
		case 4: turisim = "Çete";
		case 5: turisim = "Yarýþçý";
		case 6: turisim = "Diðer";
		default: turisim = "Bilinmiyor";
	}
	return turisim;
}

Vice:UyeYetkiKontrol(birlikid, rutbe)
{
	new yetki = 0;
	if(Birlikler[birlikid][UyeYetkisi][rutbe - 1] != 0)
	{
		yetki = 1;
	}
	return yetki;
}

stock RutbeAdiCek(birlikid, rutbe)
{
	new rutbeadi[32];
	switch(rutbe)
	{
		case 1: format(rutbeadi, sizeof(rutbeadi), "%s", Birlikler[birlikid][R1]);
		case 2: format(rutbeadi, sizeof(rutbeadi), "%s", Birlikler[birlikid][R2]);
		case 3: format(rutbeadi, sizeof(rutbeadi), "%s", Birlikler[birlikid][R3]);
		case 4: format(rutbeadi, sizeof(rutbeadi), "%s", Birlikler[birlikid][R4]);
		case 5: format(rutbeadi, sizeof(rutbeadi), "%s", Birlikler[birlikid][R5]);
		case 6: format(rutbeadi, sizeof(rutbeadi), "%s", Birlikler[birlikid][R6]);
		case 7: format(rutbeadi, sizeof(rutbeadi), "%s", Birlikler[birlikid][R7]);
		case 8: format(rutbeadi, sizeof(rutbeadi), "%s", Birlikler[birlikid][R8]);
		case 9: format(rutbeadi, sizeof(rutbeadi), "%s", Birlikler[birlikid][R9]);
		case 10: format(rutbeadi, sizeof(rutbeadi), "%s", Birlikler[birlikid][R10]);
		case 11: format(rutbeadi, sizeof(rutbeadi), "%s", Birlikler[birlikid][R11]);
		case 12: format(rutbeadi, sizeof(rutbeadi), "%s", Birlikler[birlikid][R12]);
		case 13: format(rutbeadi, sizeof(rutbeadi), "%s", Birlikler[birlikid][R13]);
		case 14: format(rutbeadi, sizeof(rutbeadi), "%s", Birlikler[birlikid][R14]);
		case 15: format(rutbeadi, sizeof(rutbeadi), "%s", Birlikler[birlikid][R15]);
		case 16: format(rutbeadi, sizeof(rutbeadi), "%s", Birlikler[birlikid][R16]);
		case 17: format(rutbeadi, sizeof(rutbeadi), "%s", Birlikler[birlikid][R17]);
		case 18: format(rutbeadi, sizeof(rutbeadi), "%s", Birlikler[birlikid][R18]);
		case 19: format(rutbeadi, sizeof(rutbeadi), "%s", Birlikler[birlikid][R19]);
		case 20: format(rutbeadi, sizeof(rutbeadi), "%s", Birlikler[birlikid][R20]);
		default: format(rutbeadi, sizeof(rutbeadi), "Bilinmiyor");
	}

	return rutbeadi;
}