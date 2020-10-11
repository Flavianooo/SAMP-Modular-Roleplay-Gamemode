CMD:evyarat(playerid, params[])
{
	if(Hesap[playerid][Yonetici] < 5) return YetersizYetki(playerid);

	new evfiyati, evadresi[32], Float:x, Float:y, Float:z, interior = GetPlayerInterior(playerid), world = GetPlayerVirtualWorld(playerid);
	if(sscanf(params, "ds[32]", evfiyati, evadresi)) return Kullanim(playerid, "/evyarat [fiyat] [adres]");
	if(strlen(evadresi) < 1 || strlen(evadresi) > 32) return Sunucu(playerid, "Girdi�in adres 1-32 karakter aras�nda olmal�.");

	GetPlayerPos(playerid, x, y, z);
	EvYarat(playerid, evadresi, x, y, z, world, interior, evfiyati);
	return true;
}

CMD:evduzenle(playerid, params[])
{
	if(Hesap[playerid][Yonetici] < 5) return YetersizYetki(playerid);
	new evid, secenek[16], ekstra[64];
	if(sscanf(params, "ds[16]S()[64]", evid, secenek, ekstra))
	{
		Kullanim(playerid, "/evduzenle [id] [se�enek]");
		GenelMesajGonder(playerid, "adres, fiyat, sahip, dispos, icpos");
		return true;
	}

	if(!Evler[evid][Gecerli]) return Sunucu(playerid, "Ge�ersiz id girdiniz.");

	if(!strcmp(secenek, "adres", true))
	{
		new adres[32];
		if(sscanf(ekstra, "s[32]", adres)) return Sunucu(playerid, "/evduzenle [id] adres [yeni adres(32)]");
		if(strlen(adres) < 1 || strlen(adres) > 32) return Sunucu(playerid, "Minimum 1-32 karakter aras� bir adres girmelisiniz.");

		new evadresi[32];
		format(evadresi, 32, "%s", adres);
		Evler[evid][Adres] = evadresi;
		EvVeriKaydet(evid);
		Sunucu(playerid, "%d id'li evin adresini %s olarak de�i�tirdiniz.", evid, Evler[evid][Adres]);
	}
	else if(!strcmp(secenek, "fiyat", true))
	{
		new fiyat;
		if(sscanf(ekstra, "d", fiyat)) return Kullanim(playerid, "/evduzenle [id] fiyat [yeni fiyat]");
		if(fiyat < 1) return Kullanim(playerid, "1'den b�y�k bir fiyat girmelisin.");
		Evler[evid][Fiyat] = fiyat;
		EvVeriKaydet(evid);
		Sunucu(playerid, "%d id'li evin fiyat�n� $%d olarak de�i�tirdiniz.", evid, Evler[evid][Fiyat]);
	}
	else if(!strcmp(secenek, "sahip", true))
	{
		new sahip;
		if(sscanf(ekstra, "d", sahip))
		{
			Kullanim(playerid, "/evduzenle [id] sahip [sahip id]");
			GenelMesajGonder(playerid, "Sahibi kald�rmak i�in -1 girebilirsin.");
			return true;
		}
		if(sahip != -1)
		{
			if(!IsPlayerConnected(sahip)) return Sunucu(playerid, "Ki�i oyunda bulunamad�.");
			if(Karakter[sahip][Giris] == false) return Sunucu(playerid, "Ki�i hen�z giri� yapmam��.");
			Evler[evid][Sahip] = Karakter[sahip][id];
			format(Evler[evid][SahipIsim], MAX_PLAYER_NAME+1, "%s", EvSahipIsimCek(evid));
			EvTextYenile(evid);
			EvVeriKaydet(evid);
			Sunucu(playerid, "%d id'li evin sahibini %s olarak de�i�tirdiniz.", evid, RPIsim(sahip));
		}
		else
		{
			Evler[evid][Sahip] = 0;
			format(Evler[evid][SahipIsim], MAX_PLAYER_NAME+1, "Yok");
			EvTextYenile(evid);
			EvVeriKaydet(evid);
			Sunucu(playerid, "%d id'li evin sahibini kald�rd�n�z. Ev sisteme sat�l�k.", evid);
		}
	}
	else if(!strcmp(secenek, "dispos", true))
	{
		new Float:x, Float:y, Float:z, interior = GetPlayerInterior(playerid), world = GetPlayerVirtualWorld(playerid);
		GetPlayerPos(playerid, x, y, z);
		Evler[evid][Ext][0] = x;
		Evler[evid][Ext][1] = y;
		Evler[evid][Ext][2] = z;
		Evler[evid][World] = world;
		Evler[evid][Interior] = interior;
		EvVeriKaydet(evid);
		Sunucu(playerid, "%d id'li evin d�� konumunu de�i�tirdin.(World: %d | Interior: %d)", world, interior);
	}
	else if(!strcmp(secenek, "icpos", true))
	{
		new Float:x, Float:y, Float:z, interior = GetPlayerInterior(playerid), world = GetPlayerVirtualWorld(playerid);
		GetPlayerPos(playerid, x, y, z);
		Evler[evid][Int][0] = x;
		Evler[evid][Int][1] = y;
		Evler[evid][Int][2] = z;
		Evler[evid][IcWorld] = world;
		Evler[evid][IcInterior] = interior;
		EvVeriKaydet(evid);
		Sunucu(playerid, "%d id'li evin i� konumunu de�i�tirdin.(World: %d | Interior: %d)", evid, world, interior);
	}
	else if(!strcmp(secenek, "durum", true))
	{
		new durum;
		if(sscanf(ekstra, "d", durum))
		{
			Kullanim(playerid, "/evduzenle [id] durum [yeni durum]");
			GenelMesajGonder(playerid, "Durumlar: 1 - Kilitsiz | 2 - Kilitli | 3 - M�h�rl�");
			return true;
		}
		if(durum < 1 || durum > 3) return Sunucu(playerid, "Hatal� durum girdin.");
		Evler[evid][Durum] = durum;
		Sunucu(playerid, "%d id'li evin giri� durumunu %d olarak de�i�tirdin.");
	}
	else Sunucu(playerid, "Hatal� parametre girdin.");

	return true;
}

CMD:evlerim(playerid, params[])
{
	new dialogstr[1024], evsayi = 0;
	strcat(dialogstr, "Ev Adresi\tKap� Numaras�\n");
	for(new i = 0; i < MAKSIMUM_EV; i++)
	{
		if(!Evler[i][Gecerli]) continue;
		if(Evler[i][Sahip] == Karakter[playerid][id])
		{
			Karakter[playerid][EvIsaretID][evsayi] = Evler[i][id];
			format(dialogstr, sizeof(dialogstr), "%s{FFFFFF}Adres: {3C5DA5}%s{FFFFFF}\tKap� Numaras�: {3C5DA5}%d\n", dialogstr, Evler[i][Adres], Evler[i][id]);
			evsayi++;
		}
	}
	if(evsayi == 0) return Sunucu(playerid, "�st�n�ze kay�tl� ev bulunamad�.");
	Dialog_Show(playerid, DIALOG_EVLERIM, DIALOG_STYLE_TABLIST_HEADERS, "{99C794}Ev Listesi", dialogstr, "��aretle", "�ptal");
	return true;
}

Dialog:DIALOG_EVLERIM(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		DisablePlayerCheckpoint(playerid);
		new evid = Karakter[playerid][EvIsaretID][listitem];
		SetPlayerCheckpoint(playerid, Evler[evid][Ext][0], Evler[evid][Ext][1], Evler[evid][Ext][2], 5.0);
		Sunucu(playerid, "%d kap� numaral� evinizi i�aretlediniz.", Evler[evid][id]);
	}
	return true;
}

CMD:evsil(playerid, params[])
{
	if(Hesap[playerid][Yonetici] < 5) return YetersizYetki(playerid);
	new evid;
	if(sscanf(params, "d", evid)) return Kullanim(playerid, "/evsil [evid]");
	if(!Evler[evid][Gecerli]) return Sunucu(playerid, "Ge�ersiz id girdiniz.");
	EvSil(playerid, evid);
	return true;
}

CMD:eval(playerid, params[])
{
	if(EvYakin(playerid) != -1)
	{
		new evid = EvYakin(playerid);
		if(Evler[evid][Sahip] != 0) return Sunucu(playerid, "Bu ev sat�l�k de�il.");
		if(Karakter[playerid][Para] < Evler[evid][Fiyat]) return Sunucu(playerid, "Bu evi almak i�in yeterli paran yok.");
		Dialog_Show(playerid, DIALOG_EV_SATIN_AL, DIALOG_STYLE_MSGBOX, "{99C794}Ev Sat�n Al", "{3C5DA5}%s{FFFFFF} kar��l���nda bu evi sat�n almak istedi�ine emin misin?", "Onayla", "�ptal", NumaraFormati(Evler[evid][Fiyat]));
	}
	else
	{
		Sunucu(playerid, "Bir evin yak�n�nda de�ilsin.");
	}
	return true;
}

CMD:ev(playerid, params[])
{
	if(EvYakin(playerid) != -1)
	{
		new evid = EvYakin(playerid);
		if(!EvSahipKontrol(playerid, evid)) return Sunucu(playerid, "Bu ev size ait de�il.");
		new str[1024];
		strcat(str, "Se�enek\tA��klama\n");
		strcat(str, "{3C5DA5}Kap� Kilidi\t{FFFFFF}Kap�n�n kilidini a�mak/kapatmak i�in kullanabilirsiniz.\n");
		strcat(str, "{3C5DA5}Evi Oyuncuya Sat\t{FFFFFF}Evi ba�ka bir oyuncuya belli bir fiyat kar��l��� satabilirsiniz.\n");
		strcat(str, "{3C5DA5}Evi Sisteme Sat\t{FFFFFF}Evi sisteme satmak i�in kullanabilirsiniz.\n");
		strcat(str, "{3C5DA5}Evi Kiral�k Yap\t{FFFFFF}Evin kira fiyat�n� 0'dan y�kselterek kiralamaya a��k hale getirebilirsiniz.\n");
		strcat(str, "{3C5DA5}Kirac�lar� Listele\t{FFFFFF}Evinizde kirada oturan ki�ilerin bir listesini g�rebilirsiniz.\n");
		strcat(str, "{3C5DA5}Ev Anahtar� Ver\t{FFFFFF}Evinizin anahtar�n� yaln�zca bir ki�iye verebilirsiniz.\n");
		strcat(str, "{3C5DA5}Dekor De�i�tir\t{FFFFFF}Vice Roleplay taraf�ndan sizlere sa�lanan haz�r dekorlardan yararlanabilirsiniz.\n");
		Dialog_Show(playerid, DIALOG_EV_MENU, DIALOG_STYLE_TABLIST_HEADERS, "{99C794}Ev Men�s�", str, "Se�", "�ptal");
	}
	else Sunucu(playerid, "Bir evin yak�n�nda de�ilsin.");
	return true;
}

Dialog:DIALOG_EV_MENU(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		new evid = EvYakin(playerid);
		if(evid == -1) return Sunucu(playerid, "Bir evin yak�n�nda de�ilsin.");
		if(!EvSahipKontrol(playerid, evid)) return Sunucu(playerid, "Bu ev size ait de�il.");
		switch(listitem)
		{
			case 0:
			{
				switch(Evler[evid][Durum])
				{
					case 0:
					{
						Evler[evid][Durum] = 1;
						Sunucu(playerid, "Evin kap�s�n� kilitlediniz.");
						EvTextYenile(evid);
					}
					case 1:
					{
						Evler[evid][Durum] = 0;
						Sunucu(playerid, "Evin kap�s�n�n kilidini a�t�n�z.");
						EvTextYenile(evid);
					}
					default:
					{
						Sunucu(playerid, "Bu evin kap�s�na m�dahale edemezsiniz.");
					}
				}
			}
			case 1:
			{
				Dialog_Show(playerid, DIALOG_EV_OYUNCUYA_SAT, DIALOG_STYLE_INPUT, "{99C794}Evi Oyuncuya Sat", "{FFFFFF}Evinizi satmak istedi�iniz oyuncunun {3C5DA5}ID{FFFFFF} bilgisini girin.", "Onayla", "�ptal");
			}
			case 2:
			{
				if(GetPVarInt(playerid, "EvSatiyor") == 1) return Sunucu(playerid, "Ev sat�� i�lemi s�ras�nda bunu yapamazs�n�z.");
				Dialog_Show(playerid, DIALOG_EV_SISTEME_SAT, DIALOG_STYLE_MSGBOX, "{99C794}Evi Sisteme Sat", "{FFFFFF}Evinizi {3C5DA5}%s{FFFFFF} kar��l���nda sisteme satmak istedi�inize emin misiniz?", "Onayla", "�ptal", NumaraFormati(Evler[evid][Fiyat]/2));
			}
			case 3:
			{
				Dialog_Show(playerid, DIALOG_EV_KIRALIK_YAP, DIALOG_STYLE_INPUT, "{99C794}Evi Kiral�k Yap", "{FFFFFF}Evinizin �u anki kira fiyat�: %s(E�er 0 ise kiralanamaz haldedir)\nYeni kira fiyat�n� a�a��ya girebilirsiniz.", "Onayla", "�ptal", Evler[evid][KiraFiyat]);
			}
			case 4:
			{
				new kiracilar[800], Cache:VeriCek, rows, query[128];
				strcat(kiracilar, "Kirac� �smi\t�dedi�i Toplam Kira\tAktiflik\n");
				mysql_format(conn, query, sizeof(query), "SELECT * FROM karakterler WHERE KiralananEv = %i", Evler[evid][id]);
				VeriCek = mysql_query(conn, query);
				cache_get_row_count(rows);
				if(rows)
				{
					for(new i; i < rows; i++)
					{
						new kiraodemesi, odemestr[12], isim[MAX_PLAYER_NAME+1], isimstr[MAX_PLAYER_NAME+3], aktiflikstr[20];
						cache_get_value_name(i, "isim", isim);
						format(isimstr, sizeof(isimstr), "%s\t", isim);
						strcat(kiracilar, isimstr);
						cache_get_value_name_int(i, "KiraOdeme", kiraodemesi);
						format(odemestr, sizeof(odemestr), "%s\t", NumaraFormati(kiraodemesi));
						strcat(kiracilar, odemestr);
						format(aktiflikstr, sizeof(aktiflikstr), "{FFFFFF}Oyunda De�il\n");
						foreach(new a : Player)
						{
							new depoisim[MAX_PLAYER_NAME+1];
							GetPlayerName(a, depoisim, MAX_PLAYER_NAME+1);
							if(!strcmp(depoisim, isim, true))
							{
								format(aktiflikstr, sizeof(aktiflikstr), "{99C794}Oyunda\n");
							}
						}
						strcat(kiracilar, aktiflikstr);
					}
					cache_delete(VeriCek);
				}
				else format(kiracilar, sizeof(kiracilar), "{FFFFFF}Kirac� bulunamad�!"), cache_delete(VeriCek);
				Dialog_Show(playerid, DIALOG_EV_KIRACILAR, DIALOG_STYLE_TABLIST_HEADERS, "{99C794}Kirac� Listesi", kiracilar, "Onayla", "�ptal");
			}
			case 5:
			{
				Dialog_Show(playerid, DIALOG_EV_ANAHTAR_VER, DIALOG_STYLE_INPUT, "{99C794}Ev Anahtar Ver", "{FFFFFF}Anahtar vermek istedi�iniz ki�inin {3C5DA5}ID{FFFFFF} bilgisini girin.", "Onayla", "�ptal");	
			}
			case 6:
			{
				new dialogstr[2048], icerikstr[128];
				strcat(dialogstr, "Dekor Numaras�\tDekor Tipi\tDekor �creti\n");
				for(new i = 0; i < sizeof(EvDekorlar); i++)
				{
					format(icerikstr, sizeof(icerikstr), "{99C794}%d\t{FFFFFF}%s\t{3C5DA5}%s\n", EvDekorlar[i][EvDekorId], EvDekorlar[i][EvDekorTip], NumaraFormati(EvDekorlar[i][EvDekorFiyat]));
					strcat(dialogstr, icerikstr);
				}
				Dialog_Show(playerid, DIALOG_EV_HAZIRDEKOR, DIALOG_STYLE_TABLIST_HEADERS, "{99C794}Haz�r Dekorlar", dialogstr, "Sat�n Al", "�ptal");
			}
		}
	}
	return true;
}

Dialog:DIALOG_EV_HAZIRDEKOR(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		new evid = EvYakin(playerid);
		if(evid == -1) return Sunucu(playerid, "Bir evin yak�n�nda de�ilsin.");
		if(!EvSahipKontrol(playerid, evid)) return Sunucu(playerid, "Bu ev size ait de�il.");
		new dekorid = listitem;
		if(Evler[evid][EvDekor] == dekorid) return Sunucu(playerid, "Bu ev zaten bu haz�r dekora sahip.");
		EvDekorDegistir(playerid, evid, dekorid);
	}
	return true;
}

Dialog:DIALOG_EV_ANAHTAR_VER(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		new evid = EvYakin(playerid);
		if(evid == -1) return Sunucu(playerid, "Bir evin yak�n�nda de�ilsin.");
		if(!EvSahipKontrol(playerid, evid)) return Sunucu(playerid, "Bu ev size ait de�il.");
		new oid = strval(inputtext);
		if(playerid == oid) return Dialog_Show(playerid, DIALOG_EV_ANAHTAR_VER, DIALOG_STYLE_INPUT, "{99C794}Ev Anahtar Ver", "{FFFFFF}Kendinize anahtar veremezsiniz.{FFFFFF}Anahtar vermek istedi�iniz ki�inin {3C5DA5}ID{FFFFFF} bilgisini girin.", "Onayla", "�ptal");	
		if(!IsPlayerConnected(oid) || !Karakter[oid][Giris]) return Dialog_Show(playerid, DIALOG_EV_ANAHTAR_VER, DIALOG_STYLE_INPUT, "{99C794}Ev Anahtar Ver", "{FFFFFF}Oyuncu bulunamad�.{FFFFFF}Anahtar vermek istedi�iniz ki�inin {3C5DA5}ID{FFFFFF} bilgisini girin.", "Onayla", "�ptal");	
		if(!OyuncuYakin(playerid, oid, 5.0)) return  Dialog_Show(playerid, DIALOG_EV_ANAHTAR_VER, DIALOG_STYLE_INPUT, "{99C794}Ev Anahtar Ver", "{FFFFFF}Ki�iye yak�n de�ilsin.{FFFFFF}Anahtar vermek istedi�iniz ki�inin {3C5DA5}ID{FFFFFF} bilgisini girin.", "Onayla", "�ptal");		
		if(Karakter[oid][EvAnahtar] != -1) return Sunucu(playerid, "Girdi�iniz ki�inin zaten bir ev anahtar� bulunuyor. ��lem iptal edildi.");
		Karakter[oid][EvAnahtar] = Evler[evid][id];
		Sunucu(playerid, "%s adl� ki�iye %d kap� numaral� evin anahtarlar�n� verdin.", RPIsim(oid), Evler[evid][id]);
		Sunucu(oid, "%s adl� ki�iden %d kap� numaral� evin anahtarlar�n� ald�n.", RPIsim(playerid), Evler[evid][id]);
		GenelMesajGonder(oid, "Art�k bu evin kilit ve dekorasyon �zelliklerini kullanabilirsin.");
	}
	return true;
}

CMD:evanahtarsifirla(playerid, params[])
{
	if(Karakter[playerid][EvAnahtar] == -1) return Sunucu(playerid, "Bir evin anahtar�na sahip de�ilsin. Anahtarlar�n� s�f�rlayamazs�n.");
	Karakter[playerid][EvAnahtar] = -1;
	Sunucu(playerid, "Sahip oldu�un ev anahtar�n� s�f�rlad�n.");
	return true;
}

CMD:evkirala(playerid, params[])
{
	if(Karakter[playerid][KiralananEv] != -1) return Sunucu(playerid, "Zaten bir evi kiralam��s�n.");
	if(EvYakin(playerid) != -1)
	{
		new evid = EvYakin(playerid);
		if(EvSahipKontrol(playerid, evid)) return Sunucu(playerid, "Bu ev sana ait. Kiralayamazs�n.");
		if(Evler[evid][KiraFiyat] == 0) return Sunucu(playerid, "Bu ev kiral�k de�il.");
		Karakter[playerid][KiralananEv] = Evler[evid][id];
		KarakterVeriKaydet(playerid);
		Sunucu(playerid, "%d kap� numaral� evi kiralad�n. Oyunda oldu�un her saat ba�� para �st�nden kesilecek...", Evler[evid][id]);
		Sunucu(playerid, "E�er paran yetersizse kiradan otomatik olarak ��kart�l�rs�n.");
	}
	else Sunucu(playerid, "Bir evin yak�n�nda de�ilsin.");
	return true;
}

Dialog:DIALOG_EV_KIRALIK_YAP(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		new evid = EvYakin(playerid);
		if(evid == -1) return Sunucu(playerid, "Bir evin yak�n�nda de�ilsin.");
		if(!EvSahipKontrol(playerid, evid)) return Sunucu(playerid, "Bu ev size ait de�il.");
		if(strval(inputtext) < 0 || strval(inputtext) > 1000 || isnull(inputtext)) return Dialog_Show(playerid, DIALOG_EV_KIRALIK_YAP, DIALOG_STYLE_INPUT, "{99C794}Evi Kiral�k Yap", "{FFFFFF}Kira fiyat� 0'�n alt�nda veya 1000'in �st�nde olamaz.\n{FFFFFF}Evinizin �u anki kira fiyat�: %s(E�er 0 ise kiralanamaz haldedir)\nYeni kira fiyat�n� a�a��ya girebilirsiniz.", "Onayla", "�ptal", NumaraFormati(Evler[evid][KiraFiyat]));
		Evler[evid][KiraFiyat] = strval(inputtext);
		Sunucu(playerid, "Evin kira fiyat� %s olarak ayarland�.", NumaraFormati(Evler[evid][KiraFiyat]));
		EvVeriKaydet(evid);
	}
	return true;
}

Dialog:DIALOG_EV_OYUNCUYA_SAT(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		new evid = EvYakin(playerid);
		if(evid == -1) return Sunucu(playerid, "Bir evin yak�n�nda de�ilsin.");
		if(!EvSahipKontrol(playerid, evid)) return Sunucu(playerid, "Bu ev size ait de�il.");
		if(GetPVarInt(playerid, "EvSatiyor") == 1) return Sunucu(playerid, "�u anda evi zaten sat�yorsunuz.");
		if(strval(inputtext) < 0 || strval(inputtext) > MAX_PLAYERS || !IsPlayerConnected(strval(inputtext)) || playerid == strval(inputtext)) return Dialog_Show(playerid, DIALOG_EV_OYUNCUYA_SAT, DIALOG_STYLE_INPUT, "{99C794}Evi Oyuncuya Sat", "{FFFFFF}Hatal� ID girdiniz!\n{FFFFFF}Evinizi satmak istedi�iniz oyuncunun {3C5DA5}ID{FFFFFF} bilgisini girin.", "Onayla", "�ptal");
		if(!Karakter[strval(inputtext)][Giris]) return Dialog_Show(playerid, DIALOG_EV_OYUNCUYA_SAT, DIALOG_STYLE_INPUT, "{99C794}Evi Oyuncuya Sat", "{FFFFFF}Oyuncu giri� yapmam��.\n{FFFFFF}Evinizi satmak istedi�iniz oyuncunun {3C5DA5}ID{FFFFFF} bilgisini girin.", "Onayla", "�ptal");
		if(!OyuncuYakin(playerid, strval(inputtext), 6.0)) return Dialog_Show(playerid, DIALOG_EV_OYUNCUYA_SAT, DIALOG_STYLE_INPUT, "{99C794}Evi Oyuncuya Sat", "{FFFFFF}Oyuncuya yak�n de�ilsin.\n{FFFFFF}Evinizi satmak istedi�iniz oyuncunun {3C5DA5}ID{FFFFFF} bilgisini girin.", "Onayla", "�ptal");
		SetPVarInt(playerid, "EvSatilacakID", strval(inputtext));
		Dialog_Show(playerid, DIALOG_EV_SAT_FIYAT, DIALOG_STYLE_INPUT, "{99C794}Evi Oyuncuya Sat", "{FFFFFF}Evinizi %s(%d) adl� ki�iye satmaya karar verdiniz.\n{FFFFFF}Evinizi satmak istedi�iniz fiyat� girin.", "Onayla", "�ptal", RPIsim(GetPVarInt(playerid, "EvSatilacakID")), GetPVarInt(playerid, "EvSatilacakID"));
	}
	else Sunucu(playerid, "Evi oyuncuya satmaktan vazge�tiniz.");
	return true;
}

Dialog:DIALOG_EV_SAT_FIYAT(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		new evid = EvYakin(playerid);
		if(evid == -1) return Sunucu(playerid, "Bir evin yak�n�nda de�ilsin.");
		if(!EvSahipKontrol(playerid, evid)) return Sunucu(playerid, "Bu ev size ait de�il.");
		if(strval(inputtext) < 1 || strval(inputtext) < (Evler[evid][Fiyat] - 50000) || strval(inputtext) > (Evler[evid][Fiyat] + 50000)) return Dialog_Show(playerid, DIALOG_EV_SAT_FIYAT, DIALOG_STYLE_INPUT, "{99C794}Evi Oyuncuya Sat", "{FFFFFF}Fiyat ge�ersiz.\n{FFFFFF}Ev, emlak fiyat�n�n en fazla {3C5DA5}$50.000{FFFFFF} alt�na/�st�ne sat�labilir.\n{FFFFFF}Evinizi satmak istedi�iniz fiyat� girin.", "Onayla", "�ptal");
		if(!Karakter[GetPVarInt(playerid, "EvSatilacakID")][Giris] || !IsPlayerConnected(GetPVarInt(playerid, "EvSatilacakID"))) return Sunucu(playerid, "Evi satmaya �al��t���n�z ki�i oyundan ��km�� g�r�n�yor.");
		if(!OyuncuYakin(playerid, GetPVarInt(playerid, "EvSatilacakID"), 6.0)) return Sunucu(playerid, "Evi satmaya �al��t���n�z ki�i sizden uzakla�m��.");	
		SetPVarInt(playerid, "EvSatilacakFiyat", strval(inputtext));
		Dialog_Show(playerid, DIALOG_EV_SAT_ONAY, DIALOG_STYLE_MSGBOX, "{99C794}Evi Oyuncuya Sat - Onay", "{FFFFFF}Evinizi %s adl� ki�iye %s kar��l���nda satmak istedi�inize emin misiniz?", "Onayla", "�ptal", GetPVarInt(playerid, "EvSatilacakID"), NumaraFormati(GetPVarInt(playerid, "EvSatilacakFiyat")));
	}
	else
	{
		Sunucu(playerid, "Evi oyuncuya satmaktan vazge�tiniz.");
		DeletePVar(playerid, "EvSatilacakID");
	}
	return true;
}

Dialog:DIALOG_EV_SAT_ONAY(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		new evid = EvYakin(playerid);
		if(evid == -1) return Sunucu(playerid, "Bir evin yak�n�nda de�ilsin.");
		if(!EvSahipKontrol(playerid, evid)) return Sunucu(playerid, "Bu ev size ait de�il.");
		if(!Karakter[GetPVarInt(playerid, "EvSatilacakID")][Giris] || !IsPlayerConnected(GetPVarInt(playerid, "EvSatilacakID"))) return Sunucu(playerid, "Evi satmaya �al��t���n�z ki�i oyundan ��km�� g�r�n�yor.");
		if(!OyuncuYakin(playerid, GetPVarInt(playerid, "EvSatilacakID"), 6.0)) return Sunucu(playerid, "Evi satmaya �al��t���n�z ki�i sizden uzakla�m��.");
		new hedef = GetPVarInt(playerid, "EvSatilacakID"), fiyat = GetPVarInt(playerid, "EvSatilacakFiyat");
		if(Karakter[hedef][Para] < fiyat) return Sunucu(playerid, "Kar��daki oyuncunun yeterli paras� bulunmuyor.");
		Sunucu(playerid, "Kar��daki oyuncuya teklifiniz iletildi. Yan�t bekleniyor.");
		Evler[evid][SatisTimer] = SetTimerEx("EvSatisTimeri", 15000, false, "iii", evid, hedef, playerid);
		SetPVarInt(playerid, "EvSatiyor", 1);
		Sunucu(hedef, "Bir sat�� teklifi ald�n;");
		Sunucu(hedef, "%s adl� ki�i %d kap� numaral� evini %s kar��l���nda sana satmak istiyor.", RPIsim(playerid), Evler[evid][id], NumaraFormati(fiyat));
		Sunucu(hedef, "Kabul etmek i�in '/evkabul' yazabilirsiniz. Teklif 15 saniye i�inde kendili�inden sona erecek.");
		SetPVarInt(hedef, "EvAlinacakID", playerid);
		SetPVarInt(hedef, "EvAlinacakFiyat", fiyat);
		SetPVarInt(hedef, "EvAlinacakEvID", evid);
		SetPVarInt(hedef, "EvTeklifiVar", 1);
	}
	else
	{
		Sunucu(playerid, "Evi oyuncuya satmaktan vazge�tiniz.");
		DeletePVar(playerid, "EvSatilacakID");
		DeletePVar(playerid, "EvSatilacakFiyat");
	}
	return true;
}

CMD:evkabul(playerid, params[])
{
	if(GetPVarInt(playerid, "EvTeklifiVar") != 1) return Sunucu(playerid, "Bir ev sat�� teklifi almam��s�n.");
	new satan = GetPVarInt(playerid, "EvAlinacakID");
	if(GetPVarInt(satan, "EvSatiyor") != 1) return Sunucu(playerid, "Bu ki�i bir ev satm�yor. ��lem sonland�r�lacak."), EvSatisVeriSifirla(playerid, satan);
	new fiyat = GetPVarInt(playerid, "EvAlinacakFiyat"), evid = GetPVarInt(playerid, "EvAlinacakID");
	if(!OyuncuYakin(satan, playerid, 6.0)) return Sunucu(playerid, "Yeterince yak�n de�ilsiniz. L�tfen evi satan ki�iye yakla��n.");
	if(Karakter[playerid][Para] < fiyat) return Sunucu(playerid, "Yeterli paran�z yok. Teklif sona ermeden para �ekebilirsiniz.");
	if(!EvSahipKontrol(satan, evid)) return Sunucu(playerid, "Evi satan ki�i evin sahibi de�il. ��lem sonland�r�lacak.");

	ParaVer(playerid, -fiyat);
	ParaVer(satan, fiyat);
	Evler[evid][Sahip] = Karakter[playerid][id];
	format(Evler[evid][SahipIsim], MAX_PLAYER_NAME+1, "%s", EvSahipIsimCek(evid));
	EvTextYenile(evid);
	Sunucu(satan, "%s teklifi kabul etti. %d kap� numaral� ev %s kar��l���nda sat�ld�.", RPIsim(playerid), Evler[evid][id], NumaraFormati(fiyat));
	Sunucu(playerid, "%s adl� ki�iden, %d kap� numaral� evi %s kar��l���nda sat�n ald�n. Tebrikler!", RPIsim(satan), Evler[evid][id], NumaraFormati(fiyat));
	Log_Kaydet("loglar/ev_oyuncuya_satis.txt", "[%s] %s adli kisi %s adli kisiye %d kapi numarali evi %s karsiliginda satti.", TarihCek(), RPIsim(satan), RPIsim(playerid), evid, NumaraFormati(fiyat));
	EvSatisVeriSifirla(playerid, satan);
	KillTimer(Evler[evid][SatisTimer]);
	return true;
}

Vice:EvSatisTimeri(evid, alan, satan)
{

	if(IsPlayerConnected(satan) && Karakter[satan][Giris])
	{
		Sunucu(satan, "Ev sat�� teklifinize yan�t gelmedi. Otomatik olarak sona erdirildi.");
	}
	if(IsPlayerConnected(alan) && Karakter[alan][Giris])
	{
		Sunucu(alan, "Teklife yan�t vermedi�iniz i�in otomatik olarak sona erdi.");
	}
	EvSatisVeriSifirla(alan, satan);
	KillTimer(Evler[evid][SatisTimer]);
	return true;
}

Vice:EvSatisVeriSifirla(alan, satan)
{
	if(IsPlayerConnected(alan) && Karakter[alan][Giris])
	{	
		DeletePVar(alan, "EvAlinacakID");
		DeletePVar(alan, "EvAlinacakFiyat");
		DeletePVar(alan, "EvTeklifiVar");
		DeletePVar(alan, "EvAlinacakEvID");
	}
	if(IsPlayerConnected(satan) && Karakter[satan][Giris])
	{		
		DeletePVar(satan, "EvSatilacakID");
		DeletePVar(satan, "EvSatilacakFiyat");
		DeletePVar(satan, "EvSatiyor");
	}
	return true;
}

Dialog:DIALOG_EV_SISTEME_SAT(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		new evid = EvYakin(playerid);
		if(evid == -1) return Sunucu(playerid, "Bir evin yak�n�nda de�ilsin.");
		if(!EvSahipKontrol(playerid, evid)) return Sunucu(playerid, "Bu ev size ait de�il.");
		new evfiyati = Evler[evid][Fiyat]/2;
		ParaVer(playerid, evfiyati);
		Evler[evid][Sahip] = 0;
		format(Evler[evid][SahipIsim], MAX_PLAYER_NAME+1, "Yok");
		EvTextYenile(evid);
		EvKiraciSifirla(evid);
		Sunucu(playerid, "%s kar��l���nda, %d kap� numaral� evi emlak��ya satt�n.", NumaraFormati(evfiyati), Evler[evid][id]);
	}
	else
	{
		Sunucu(playerid, "Evi sisteme satmaktan vazge�tiniz.");
	}
	return true;
}

Dialog:DIALOG_EV_SATIN_AL(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		new evid = EvYakin(playerid);
		if(evid == -1) return Sunucu(playerid, "Bir evin yak�n�nda de�ilsin.");
		if(Evler[evid][Sahip] != 0) return Sunucu(playerid, "Bu ev sat�l�k de�il.");
		if(Karakter[playerid][Para] < Evler[evid][Fiyat]) return Sunucu(playerid, "Bu evi almak i�in yeterli paran yok.");
		ParaVer(playerid, -Evler[evid][Fiyat]);
		Evler[evid][Sahip] = Karakter[playerid][id];
		format(Evler[evid][SahipIsim], MAX_PLAYER_NAME+1, "%s", EvSahipIsimCek(evid));
		Sunucu(playerid, "%s kar��l���nda %d kap� numaral� evi sat�n ald�n.", NumaraFormati(Evler[evid][Fiyat]), Evler[evid][id]);
		Log_Kaydet("loglar/ev_satin_alim.txt", "[%s] %s adli kisi %d idli isyerini %s karsiliginda satin aldi.", TarihCek(), RPIsim(playerid), evid, NumaraFormati(Evler[evid][Fiyat]));
		EvTextYenile(evid);
		EvVeriKaydet(evid);
	}
	else Sunucu(playerid, "Evi sat�n almaktan vazge�tin.");
	return true;
}

Vice:EvTextYenile(evid)
{
	if(IsValidDynamic3DTextLabel(Evler[evid][Label])) DestroyDynamic3DTextLabel(Evler[evid][Label]);
	new str[192];
	switch(Evler[evid][Sahip])
	{
		case 0:
		{
			switch(Evler[evid][Durum])
			{
				case 0:
				{
					format(str, sizeof(str), "{99C794}%s\n{99C794}Kap� Numaras�: {E2E2E2}%d\n{99C794}Fiyat: {E2E2E2}%d\n\n{99C794}Durum: {FFFFFF}Kilitsiz", Evler[evid][Adres], Evler[evid][id], Evler[evid][Fiyat]);
					Evler[evid][Label] = CreateDynamic3DTextLabel(str, 0xE2B960FF, Evler[evid][Ext][0], Evler[evid][Ext][1], Evler[evid][Ext][2] + 0.2, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0, 0);
				}
				case 1:
				{
					format(str, sizeof(str), "{99C794}%s\n{99C794}Kap� Numaras�: {E2E2E2}%d\n{99C794}Fiyat: {E2E2E2}%d\n\n{99C794}Durum: {E2E2E2}Kilitli", Evler[evid][Adres], Evler[evid][id], Evler[evid][Fiyat]);
					Evler[evid][Label] = CreateDynamic3DTextLabel(str, 0xE2B960FF, Evler[evid][Ext][0], Evler[evid][Ext][1], Evler[evid][Ext][2] + 0.2, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0, 0);
				}
				case 2:
				{
					format(str, sizeof(str), "{99C794}%s\n{99C794}Kap� Numaras�: {E2E2E2}%d\n{99C794}Fiyat: {E2E2E2}%d\n\n{99C794}Durum: {FF0000}M�h�rl�", Evler[evid][Adres], Evler[evid][id], Evler[evid][Fiyat]);
					Evler[evid][Label] = CreateDynamic3DTextLabel(str, 0xE2B960FF, Evler[evid][Ext][0], Evler[evid][Ext][1], Evler[evid][Ext][2] + 0.2, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0, 0);
				}
				case 3:
				{
					format(str, sizeof(str), "{99C794}%s\n{99C794}Kap� Numaras�: {E2E2E2}%d\n{99C794}Fiyat: {E2E2E2}%d\n\n{99C794}Durum: {00CC00}Sat�l�k", Evler[evid][Adres], Evler[evid][id], Evler[evid][Fiyat]);
					Evler[evid][Label] = CreateDynamic3DTextLabel(str, 0xE2B960FF, Evler[evid][Ext][0], Evler[evid][Ext][1], Evler[evid][Ext][2] + 0.2, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0, 0);
				}
			}
		}
		default:
		{
			format(Evler[evid][SahipIsim], MAX_PLAYER_NAME+1, "%s", EvSahipIsimCek(evid));
			switch(Evler[evid][Durum])
			{
				case 0:
				{
					format(str, sizeof(str), "{99C794}%s\n{99C794}Kap� Numaras�: {E2E2E2}%d\n{99C794}Sahibi: {E2E2E2}%s\n\n{99C794}Durum: {FFFFFF}Kilitsiz", Evler[evid][Adres], Evler[evid][id], Evler[evid][SahipIsim]);
					Evler[evid][Label] = CreateDynamic3DTextLabel(str, 0xE2B960FF, Evler[evid][Ext][0], Evler[evid][Ext][1], Evler[evid][Ext][2] + 0.2, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0, 0);
				}
				case 1:
				{
					format(str, sizeof(str), "{99C794}%s\n{99C794}Kap� Numaras�: {E2E2E2}%d\n{99C794}Sahibi: {E2E2E2}%s\n\n{99C794}Durum: {E2E2E2}Kilitli", Evler[evid][Adres], Evler[evid][id], Evler[evid][SahipIsim]);
					Evler[evid][Label] = CreateDynamic3DTextLabel(str, 0xE2B960FF, Evler[evid][Ext][0], Evler[evid][Ext][1], Evler[evid][Ext][2] + 0.2, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0, 0);
				}
				case 2:
				{
					format(str, sizeof(str), "{99C794}%s\n{99C794}Kap� Numaras�: {E2E2E2}%d\n{99C794}Sahibi: {E2E2E2}%s\n\n{99C794}Durum: {FF0000}M�h�rl�", Evler[evid][Adres], Evler[evid][id], Evler[evid][SahipIsim]);
					Evler[evid][Label] = CreateDynamic3DTextLabel(str, 0xE2B960FF, Evler[evid][Ext][0], Evler[evid][Ext][1], Evler[evid][Ext][2] + 0.2, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0, 0);
				}
				case 3:
				{
					format(str, sizeof(str), "{99C794}%s\n{99C794}Kap� Numaras�: {E2E2E2}%d\n{99C794}Sahibi: {E2E2E2}%s\n\n{99C794}Durum: {00CC00}Sat�l�k", Evler[evid][Adres], Evler[evid][id], Evler[evid][SahipIsim]);
					Evler[evid][Label] = CreateDynamic3DTextLabel(str, 0xE2B960FF, Evler[evid][Ext][0], Evler[evid][Ext][1], Evler[evid][Ext][2] + 0.2, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0, 0);
				}
			}
		}
	}
	return true;
}

stock EvSahipIsimCek(evid)
{
	new isim[MAX_PLAYER_NAME+1];
	switch(Evler[evid][Sahip])
	{
		case 0: format(isim, sizeof(isim), "Yok");
		default:
		{
			new Cache:VeriCek, query[192], rows;
			mysql_format(conn, query, sizeof(query), "SELECT * FROM karakterler WHERE id = %i", Evler[evid][Sahip]);
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

Vice:EvYarat(playerid, adres[], Float:x, Float:y, Float:z, world, interior, fiyat)
{	
	new evid = EvSlot();
	if(evid == -1) return Sunucu(playerid, "Sunucu ev limitine ula��ld�.");
	new query[512];
	mysql_format(conn, query, sizeof(query), "INSERT INTO evler (EvId, Adres, ExtX, ExtY, ExtZ, IntX, IntY, IntZ, Interior, World, Durum, Fiyat, IcWorld, IcInterior, Sahip) VALUES (%i, '%e', %.4f, %.4f, %.4f, 0.0, 0.0, 0.0, %i, %i, 0, %i, %i, 0, 0)", evid, adres, x, y, z, interior, world, fiyat, evid+13000);
	mysql_query(conn, query);

	Evler[evid][id] = evid;
	Evler[evid][Gecerli] = true;
	format(Evler[evid][Adres], 32, "%s", adres);
	Evler[evid][Ext][0] = x;
	Evler[evid][Ext][1] = y;
	Evler[evid][Ext][2] = z;
	Evler[evid][World] = world;
	Evler[evid][Interior] = interior;
	Evler[evid][Int][0] = 0.0;
	Evler[evid][Int][1] = 0.0;
	Evler[evid][Int][2] = 0.0;
	Evler[evid][Fiyat] = fiyat;
	Evler[evid][IcWorld] = Evler[evid][id] + 13000;
	Evler[evid][IcInterior] = 1;
	Evler[evid][Durum] = 0;
	Evler[evid][Sahip] = 0;
	format(Evler[evid][SahipIsim], MAX_PLAYER_NAME+1, "Yok");

	Evler[evid][Pickup] = CreateDynamicPickup(1273, 23, Evler[evid][Ext][0], Evler[evid][Ext][1], Evler[evid][Ext][2], world, interior);
	new str[144];
	format(str, sizeof(str), "{99C794}%s\n{99C794}Kap� Numaras�: {E2E2E2}%d\n{99C794}Fiyat: {E2E2E2}%d", Evler[evid][Adres], Evler[evid][id], Evler[evid][Fiyat]);
	Evler[evid][Label] = CreateDynamic3DTextLabel(str, 0xE2B960FF, Evler[evid][Ext][0], Evler[evid][Ext][1], Evler[evid][Ext][2] + 0.2, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0, 0);
	
	Sunucu(playerid, "Ev bulundu�un noktada yarat�ld�.(Adres: %s | Fiyat:  %d | ID: %d)", Evler[evid][Adres], Evler[evid][Fiyat], Evler[evid][id]);
	Sunucu(playerid, "Ev giri� ve ��k�� noktalar�n� d�zenlemek i�in /evduzenle komutunu kullan.");
	return true;
}

Vice:EvVeriKaydet(evid)
{
	if(IsValidDynamicPickup(Evler[evid][Pickup]))
		DestroyDynamicPickup(Evler[evid][Pickup]);

	Evler[evid][Pickup] = CreateDynamicPickup(1273, 23, Evler[evid][Ext][0], Evler[evid][Ext][1], Evler[evid][Ext][2], Evler[evid][World], Evler[evid][Interior]);

	EvTextYenile(evid);

	new query[1280];
	mysql_format(conn, query, sizeof(query), "UPDATE evler SET Adres = '%e', ExtX = %.4f, ExtY = %.4f, ExtZ = %.4f, IntX = %.4f, IntY = %.4f, IntZ = %.4f, Interior = %i, World = %i, Durum = %i, Fiyat = %i WHERE EvId = %i",
		Evler[evid][Adres],
		Evler[evid][Ext][0],
		Evler[evid][Ext][1],
		Evler[evid][Ext][2],
		Evler[evid][Int][0],
		Evler[evid][Int][1],
		Evler[evid][Int][2],
		Evler[evid][Interior],
		Evler[evid][World],
		Evler[evid][Durum],
		Evler[evid][Fiyat],
	Evler[evid][id]);
	mysql_tquery(conn, query);
	mysql_format(conn, query, sizeof(query), "UPDATE evler SET IcWorld = %i, IcInterior = %i, Sahip = %i, KiraFiyat = %i WHERE EvId = %i",
		Evler[evid][IcWorld],
		Evler[evid][IcInterior],
		Evler[evid][Sahip],
		Evler[evid][KiraFiyat],
	Evler[evid][id]);
	mysql_tquery(conn, query);
	return true;
}

Vice:EvleriYukle()
{
	new rows, rowcount = 0;
	cache_get_row_count(rows);

	for(new i = 0; i < rows && MAKSIMUM_EV; i++)
	{
		Evler[i][Gecerli] = true;

		cache_get_value_name_int(i, "EvId", Evler[i][id]);

		cache_get_value_name(i, "Adres", Evler[i][Adres], 32);

		cache_get_value_name_float(i, "ExtX", Evler[i][Ext][0]);
		cache_get_value_name_float(i, "ExtY", Evler[i][Ext][1]);
		cache_get_value_name_float(i, "ExtZ", Evler[i][Ext][2]);

		cache_get_value_name_float(i, "IntX", Evler[i][Int][0]);
		cache_get_value_name_float(i, "IntY", Evler[i][Int][1]);
		cache_get_value_name_float(i, "IntZ", Evler[i][Int][2]);

		cache_get_value_name_int(i, "Interior", Evler[i][Interior]);
		cache_get_value_name_int(i, "World", Evler[i][World]);

		cache_get_value_name_int(i, "IcWorld", Evler[i][IcWorld]);
		cache_get_value_name_int(i, "IcInterior", Evler[i][IcInterior]);

		cache_get_value_name_int(i, "Durum", Evler[i][Durum]);
		cache_get_value_name_int(i, "Fiyat", Evler[i][Fiyat]);
		cache_get_value_name_int(i, "Sahip", Evler[i][Sahip]);

		cache_get_value_name_int(i, "KiraFiyat", Evler[i][KiraFiyat]);

		Evler[i][Pickup] = CreateDynamicPickup(1273, 23, Evler[i][Ext][0], Evler[i][Ext][1], Evler[i][Ext][2], Evler[i][World], Evler[i][Interior]);
		rowcount++;
	}
	for(new i = 0; i < rows && MAKSIMUM_EV; i++)
	{
		EvTextYenile(i);
	}
	printf("[MySQL] Veritaban�ndan '%i' adet ev y�klendi.", rowcount);
	return true;
}

Vice:EvSil(playerid, evid)
{
	if(IsValidDynamicPickup(Evler[evid][Pickup])) DestroyDynamicPickup(Evler[evid][Pickup]);
	if(IsValidDynamic3DTextLabel(Evler[evid][Label])) DestroyDynamic3DTextLabel(Evler[evid][Label]);
	Evler[evid][Gecerli] = false;

	new query[128];
	mysql_format(conn, query, sizeof(query), "DELETE FROM evler WHERE EvId = '%i'", Evler[evid][id]);
	mysql_tquery(conn, query);
	EvKiraciSifirla(evid);

	Sunucu(playerid, "Bir ev sildiniz.");
	return true;
}

Vice:EvKiraciSifirla(evid)
{
	new Cache:VeriCek, rows, query[144];
	mysql_format(conn, query, sizeof(query), "SELECT * FROM karakterler WHERE KiralananEv = %i", Evler[evid][id]);
	VeriCek = mysql_query(conn, query);
	cache_get_row_count(rows);
	if(rows)
	{
		new charid;
		cache_get_value_name_int(0, "id", charid);
		cache_delete(VeriCek);
		mysql_format(conn, query, sizeof(query), "UPDATE karakterler SET KiralananEv = '-1' WHERE id = %i", charid);
		mysql_query(conn, query);
		foreach(new i : Player)
		{
			if(Karakter[i][KiralananEv] == Evler[evid][id])
			{
				Karakter[i][KiralananEv] = -1;
			}
		}
	}
	else cache_delete(VeriCek);
	return true;
}

Vice:EvSlot()
{
	new evid = -1;
	for(new i = 0; i < MAKSIMUM_EV; i++)
	{
		if(Evler[i][Gecerli] == true) continue;
		evid = i; break;
	}
	return evid;
}

Vice:EvYakin(playerid)
{
	new deger = -1;
	for(new i = 0; i < MAKSIMUM_EV; i++)
	{
		if(Evler[i][Gecerli] == true)
		{
			if(IsPlayerInRangeOfPoint(playerid, 2.0, Evler[i][Ext][0], Evler[i][Ext][1], Evler[i][Ext][2]) && GetPlayerVirtualWorld(playerid) == Evler[i][World] && GetPlayerInterior(playerid) == Evler[i][Interior])
			{
				deger = i;
				return deger;
			}
		}
	}
	return deger;
}

Vice:EvIcYakin(playerid)
{
	new deger = -1;
	for(new i = 0; i < MAKSIMUM_EV; i++)
	{
		if(Evler[i][Gecerli] == true)
		{
			if(IsPlayerInRangeOfPoint(playerid, 2.0, Evler[i][Int][0], Evler[i][Int][1], Evler[i][Int][2]) && GetPlayerVirtualWorld(playerid) == Evler[i][IcWorld] && GetPlayerInterior(playerid) == Evler[i][IcInterior])
			{
				deger = i;
				return deger;
			}
		}
	}
	return deger;
}

Vice:EvIcinde(playerid)
{
	new deger = -1;
	for(new i = 0; i < MAKSIMUM_EV; i++)
	{
		if(Evler[i][Gecerli] == true)
		{
			if(GetPlayerVirtualWorld(playerid) == Evler[i][IcWorld] || GetPlayerInterior(playerid) == Evler[i][IcInterior])
			{
				deger = i;
				return deger;
			}
		}
	}
	return deger;
}

Vice:EvSahipKontrol(playerid, evid)
{
	new onay = 0;
	if(Karakter[playerid][id] == Evler[evid][Sahip])
	{
		onay = 1;
	}
	return onay;
}

Vice:EvDekorDegistir(playerid, i, dekorid)
{
	switch(dekorid) 
	{
		case 0: 
		{
			if(Evler[i][EvDekor] == dekorid) return Sunucu(playerid, "Bu ev zaten bu dekora sahip.");
			Evler[i][Int][0] = 1412.639892;
			Evler[i][Int][1] = -1.787510;
			Evler[i][Int][2] = 1000.924377;
			Evler[i][IcInterior] = 1;
			Evler[i][EvDekor] = dekorid;
			EvVeriKaydet(i);
		}
		case 1: 
		{
			if(Karakter[playerid][Para] < 15000) return Sunucu(playerid, "Yeterli paran yok.($15000)");
			if(Evler[i][EvDekor] == dekorid) return Sunucu(playerid, "Bu ev zaten bu dekora sahip.");
			Evler[i][Int][0] = -2369.5337;
			Evler[i][Int][1] = 435.1958;
			Evler[i][Int][2] = 3453.1218;
			Evler[i][IcInterior] = 1;
			Evler[i][EvDekor] = dekorid;
			EvVeriKaydet(i);
			ParaVer(playerid, -15000);
		}
		case 2: 
		{
			if(Karakter[playerid][Para] < 10000) return Sunucu(playerid, "Yeterli paran yok.($10000)");

			if(Evler[i][EvDekor] == dekorid) return Sunucu(playerid, "Bu ev zaten bu dekora sahip.");
			Evler[i][Int][0] = 2439.1328;
			Evler[i][Int][1] = -95.9174;
			Evler[i][Int][2] = 1147.8845;
			Evler[i][IcInterior] = 1;
			Evler[i][EvDekor] = dekorid;
			EvVeriKaydet(i);
			ParaVer(playerid, -10000);
		}
		case 3: 
		{
			if(Karakter[playerid][Para] < 10000) return Sunucu(playerid, "Yeterli paran yok.($10000)");

			if(Evler[i][EvDekor] == dekorid) return Sunucu(playerid, "Bu ev zaten bu dekora sahip.");
			Evler[i][Int][0] = 857.8408;
			Evler[i][Int][1] = 31.3968;
			Evler[i][Int][2] = 582.6943;
			Evler[i][IcInterior] = 10;
			Evler[i][EvDekor] = dekorid;
			EvVeriKaydet(i);
			ParaVer(playerid, -10000);
		}
		case 4: 
		{
			if(Karakter[playerid][Para] < 60000) return Sunucu(playerid, "Yeterli paran yok.($60000)");

			if(Evler[i][EvDekor] == dekorid) return Sunucu(playerid, "Bu ev zaten bu dekora sahip.");
			Evler[i][Int][0] = -674.9788;
			Evler[i][Int][1] = -2166.0142;
			Evler[i][Int][2] = 1502.0964;
			Evler[i][IcInterior] = 10;
			Evler[i][EvDekor] = dekorid;
			EvVeriKaydet(i);
			ParaVer(playerid, -60000);
		}
		case 5: 
		{
			if(Karakter[playerid][Para] < 40000) return Sunucu(playerid, "Yeterli paran yok.($40000)");

			if(Evler[i][EvDekor] == dekorid) return Sunucu(playerid, "Bu ev zaten bu dekora sahip.");
			Evler[i][Int][0] = -2169.9768;
			Evler[i][Int][1] = -2135.8308;
			Evler[i][Int][2] = 1503.1005;
			Evler[i][IcInterior] = 10;
			Evler[i][EvDekor] = dekorid;
			EvVeriKaydet(i);
			ParaVer(playerid, -40000);
		}
		case 6: 
		{
			if(Karakter[playerid][Para] < 60000) return Sunucu(playerid, "Yeterli paran yok.($60000)");

			if(Evler[i][EvDekor] == dekorid) return Sunucu(playerid, "Bu ev zaten bu dekora sahip.");
			Evler[i][Int][0] = -1838.9821;
			Evler[i][Int][1] = 1227.9738;
			Evler[i][Int][2] = 1502.0082;
			Evler[i][IcInterior] = 10;
			Evler[i][EvDekor] = dekorid;
			EvVeriKaydet(i);
			ParaVer(playerid, -60000);
		}
		case 7: 
		{
			if(Karakter[playerid][Para] < 40000) return Sunucu(playerid, "Yeterli paran yok.($40000)");

			if(Evler[i][EvDekor] == dekorid) return Sunucu(playerid, "Bu ev zaten bu dekora sahip.");
			Evler[i][Int][0] = 2408.0198;
			Evler[i][Int][1] = -434.1076;
			Evler[i][Int][2] = 1503.0000;
			Evler[i][IcInterior] = 11;
			Evler[i][EvDekor] = dekorid;
			EvVeriKaydet(i);
			ParaVer(playerid, -40000);
		}
		case 8: 
		{
			if(Karakter[playerid][Para] < 30000) return Sunucu(playerid, "Yeterli paran yok.($5000)");

			if(Evler[i][EvDekor] == dekorid) return Sunucu(playerid, "Bu ev zaten bu dekora sahip.");
			Evler[i][Int][0] = 64.5504;
			Evler[i][Int][1] = -239.8190;
			Evler[i][Int][2] = 1201.7629;
			Evler[i][IcInterior] = 10;
			Evler[i][EvDekor] = dekorid;
			EvVeriKaydet(i);
			ParaVer(playerid, -30000);
		}
		case 9: 
		{
			if(Karakter[playerid][Para] < 60000) return Sunucu(playerid, "Yeterli paran yok.($60000)");

			if(Evler[i][EvDekor] == dekorid) return Sunucu(playerid, "Bu ev zaten bu dekora sahip.");
			Evler[i][Int][0] = 2778.0417;
			Evler[i][Int][1] = -65.6767;
			Evler[i][Int][2] = 1318.8390;
			Evler[i][IcInterior] = 13;
			Evler[i][EvDekor] = dekorid;
			EvVeriKaydet(i);
			ParaVer(playerid, -60000);
		}
		case 10: 
		{
			if(Karakter[playerid][Para] < 50000) return Sunucu(playerid, "Yeterli paran yok.($50000)");

			if(Evler[i][EvDekor] == dekorid) return Sunucu(playerid, "Bu ev zaten bu dekora sahip.");
			Evler[i][Int][0] = 438.9539;
			Evler[i][Int][1] = 1364.9796;
			Evler[i][Int][2] = 1118.8416;
			Evler[i][IcInterior] = 10;
			Evler[i][EvDekor] = dekorid;
			EvVeriKaydet(i);
			ParaVer(playerid, -50000);
		}
		case 11: 
		{
			if(Karakter[playerid][Para] < 15000) return Sunucu(playerid, "Yeterli paran yok.($15000)");

			if(Evler[i][EvDekor] == dekorid) return Sunucu(playerid, "Bu ev zaten bu dekora sahip.");
			Evler[i][Int][0] = -2158.7776;
			Evler[i][Int][1] = 643.1409;
			Evler[i][Int][2] = 1052.3750;
			Evler[i][IcInterior] = 1;
			Evler[i][EvDekor] = dekorid;
			EvVeriKaydet(i);
			ParaVer(playerid, -15000);
		}
		case 12: 
		{
			if(Karakter[playerid][Para] < 10000) return Sunucu(playerid, "Yeterli paran yok.($10000)");

			if(Evler[i][EvDekor] == dekorid) return Sunucu(playerid, "Bu ev zaten bu dekora sahip.");
			Evler[i][Int][0] = 2807.5481;
			Evler[i][Int][1] = -1174.4093;
			Evler[i][Int][2] = 1025.5703;
			Evler[i][IcInterior] = 8;
			Evler[i][EvDekor] = dekorid;
			EvVeriKaydet(i);
			ParaVer(playerid, -10000);
		}
		case 13: 
		{ 
			if(Karakter[playerid][Para] < 8000) return Sunucu(playerid, "Yeterli paran yok.($8000)");

			if(Evler[i][EvDekor] == dekorid) return Sunucu(playerid, "Bu ev zaten bu dekora sahip.");
			Evler[i][Int][0] = 318.564971;
			Evler[i][Int][1] = 1118.209960;
			Evler[i][Int][2] = 1083.882812;
			Evler[i][IcInterior] = 5;
			Evler[i][EvDekor] = dekorid;
			EvVeriKaydet(i);
			ParaVer(playerid, -8000);
		}
		case 14:
		{
			if(Karakter[playerid][Para] < 7000) return Sunucu(playerid, "Yeterli paran yok.($7000)");

			if(Evler[i][EvDekor] == dekorid) return Sunucu(playerid, "Bu ev zaten bu dekora sahip.");
			Evler[i][Int][0] = 2495.8567;
			Evler[i][Int][1] = -1692.2336;
			Evler[i][Int][2] = 1014.7422;
			Evler[i][IcInterior] = 3;
			Evler[i][EvDekor] = dekorid;
			EvVeriKaydet(i);
			ParaVer(playerid, -7000);
		}
		case 15: 
		{
			if(Karakter[playerid][Para] < 10000) return Sunucu(playerid, "Yeterli paran yok.($10000)");

			if(Evler[i][EvDekor] == dekorid) return Sunucu(playerid, "Bu ev zaten bu dekora sahip.");
			Evler[i][Int][0] = 2468.8259;
			Evler[i][Int][1] = -1698.3224;
			Evler[i][Int][2] = 1013.5078;
			Evler[i][IcInterior] = 2;
			Evler[i][EvDekor] = dekorid;
			EvVeriKaydet(i);
			ParaVer(playerid, -10000);
		}
		case 16: 
		{
			if(Karakter[playerid][Para] < 30000) return Sunucu(playerid, "Yeterli paran yok.($30000)");

			if(Evler[i][EvDekor] == dekorid) return Sunucu(playerid, "Bu ev zaten bu dekora sahip.");
			Evler[i][Int][0] = 2324.419921;
			Evler[i][Int][1] = -1145.568359;
			Evler[i][Int][2] = 1050.710083;
			Evler[i][IcInterior] = 12;
			Evler[i][EvDekor] = dekorid;
			EvVeriKaydet(i);
			ParaVer(playerid, -30000);
		}
		case 17: 
		{
			if(Karakter[playerid][Para] < 5000) return Sunucu(playerid, "Yeterli paran yok.($5000)");

			if(Evler[i][EvDekor] == dekorid) return Sunucu(playerid, "Bu ev zaten bu dekora sahip.");
			Evler[i][Int][0] = 266.5019;
			Evler[i][Int][1] = 304.8576;
			Evler[i][Int][2] = 999.1484;
			Evler[i][IcInterior] = 2;
			Evler[i][EvDekor] = dekorid;
			EvVeriKaydet(i);
			ParaVer(playerid, -5000);
		}
		case 18: 
		{
			if(Karakter[playerid][Para] < 40000) return Sunucu(playerid, "Yeterli paran yok.($40000)");

			if(Evler[i][EvDekor] == dekorid) return Sunucu(playerid, "Bu ev zaten bu dekora sahip.");
			Evler[i][Int][0] = 1236.8832;
			Evler[i][Int][1] = -667.2654;
			Evler[i][Int][2] = 2085.6919;
			Evler[i][IcInterior] = 10;
			Evler[i][EvDekor] = dekorid;
			EvVeriKaydet(i);
			ParaVer(playerid, -40000);
		}
		case 19: //masonplay evi
		{
			if(Karakter[playerid][Para] < 50000) return Sunucu(playerid, "Yeterli paran yok.($50000)");

			if(Evler[i][EvDekor] == dekorid) return Sunucu(playerid, "Bu ev zaten bu dekora sahip.");
			Evler[i][Int][0] = 244.5059;
			Evler[i][Int][1] = 1767.8184;
			Evler[i][Int][2] = 1000.6110;
			Evler[i][IcInterior] = 10;
			Evler[i][EvDekor] = dekorid;
			EvVeriKaydet(i);
			ParaVer(playerid, -50000);
		}
		case 20://g�zel malikane
		{
			if(Karakter[playerid][Para] < 60000) return Sunucu(playerid, "Yeterli paran yok.($60000)");

			if(Evler[i][EvDekor] == dekorid) return Sunucu(playerid, "Bu ev zaten bu dekora sahip.");
			Evler[i][Int][0] = 1568.5181;
			Evler[i][Int][1] = -4.3185;
			Evler[i][Int][2] = 1100.9153;
			Evler[i][IcInterior] = 10;
			Evler[i][EvDekor] = dekorid;
			EvVeriKaydet(i);
			ParaVer(playerid, -60000);
		}
		case 21: { //karavan interior
			if(Karakter[playerid][Para] < 5000) return Sunucu(playerid, "Yeterli paran yok.($5000)");

			if(Evler[i][EvDekor] == dekorid) return Sunucu(playerid, "Bu ev zaten bu dekora sahip.");
			Evler[i][Int][0] = 2513.3462;
			Evler[i][Int][1] = -1729.0845;
			Evler[i][Int][2] = 2778.6372;
			Evler[i][IcInterior] = 0;
			Evler[i][EvDekor] = dekorid;
			EvVeriKaydet(i);
			ParaVer(playerid, -5000);
		}
		case 22: { // l�ks otel odas�
			if(Karakter[playerid][Para] < 10000) return Sunucu(playerid, "Yeterli paran yok.($10000)");

			if(Evler[i][EvDekor] == dekorid) return Sunucu(playerid, "Bu ev zaten bu dekora sahip.");
			Evler[i][Int][0] = 444.6640;
			Evler[i][Int][1] = 510.0681;
			Evler[i][Int][2] = 1001.6638;
			Evler[i][IcInterior] = 0;
			Evler[i][EvDekor] = dekorid;
			EvVeriKaydet(i);
			ParaVer(playerid, -10000);
		}
		default:
		{
			Sunucu(playerid, "Bu ev dekoru devre d��� b�rak�lm��t�r.");
		}
	}
	return true;
}