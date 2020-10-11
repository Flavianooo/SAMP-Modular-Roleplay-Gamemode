// LABELS
Vice:PiyasaNoktalariYarat()
{
	new piyasa[75];
	for(new o; o != sizeof(piyasaveri); o++)
	{
		format(piyasa, sizeof(piyasa), "[{99C794}%s{FFFFFF}]\n{FFFFFF}[/ekin sat]", piyasaveri[o][piyasaisim]);
		CreateDynamic3DTextLabel(piyasa, RENK_GRI, piyasaveri[o][piyasax], piyasaveri[o][piyasay], piyasaveri[o][piyasaz] + 0.8, 2.5, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0,-1);
		CreateDynamicPickup(1318, 23, piyasaveri[o][piyasax], piyasaveri[o][piyasay], piyasaveri[o][piyasaz]);
	}
}
////////////

CMD:aciftlik(playerid, params[])
{
	if(!Karakter[playerid][Giris]) return Sunucu(playerid, "Giri� yapmadan bu komutu kullanamazs�n.");
	if(Hesap[playerid][Yonetici] < 5) return YetersizYetki(playerid);
	new idx[20];
	if(sscanf(params, "s[20]", idx))
	{
		Kullanim(playerid, "/aciftlik [se�enek]");
		GenelMesajGonder(playerid, "ilkpos, ikincipos, yarat, sil");
	}
	else
	{
		if(strcmp(idx, "ilkpos", true) == 0)
		{
			if(IsPlayerInAnyVehicle(playerid)) return Sunucu(playerid, "Bu komut ara� i�erisinde kullan�lamaz.");
			new Float:X,Float:Y,Float:Z;
			GetPlayerPos(playerid, X,Y,Z);
			SetPVarFloat(playerid, "ciftlikminX", X);
			SetPVarFloat(playerid, "ciftlikminY", Y);
			SetPVarInt(playerid, "ctelportayarladi", 1);
			Sunucu(playerid, "�lk posun verilerini ald�n�z, �imdi ikinci posa giderek '/aciftlik ikincipos' yaz�n.");
		}
		else if(strcmp(idx, "ikincipos", true) == 0)
		{
			if(IsPlayerInAnyVehicle(playerid)) return Sunucu(playerid, "Bu komut ara� i�erisinde kullan�lamaz.");
			new Float:X, Float:Y, Float:Z;
			GetPlayerPos(playerid, X,Y,Z);
			SetPVarFloat(playerid, "ciftlikmaxX", X);
			SetPVarFloat(playerid, "ciftlikmaxY", Y);
			SetPVarInt(playerid, "ctelportdestayarladi", 1);
			Sunucu(playerid, "�kinci posun verilerini ald�n�z, �imdi '/aciftlik yarat' yazarak arsay� yaratabilirsiniz.");
		}
		else if(strcmp(idx, "yarat", true) == 0)
		{
			if(GetPVarInt(playerid, "ctelportayarladi") != 1 || GetPVarInt(playerid, "ctelportdestayarladi") != 1) return Sunucu(playerid, "Verilerde eksiklik var; l�tfen ilk pos ve ikinci posu ayarlay�n.");
			Dialog_Show(playerid, arsa_yarat, DIALOG_STYLE_INPUT, "Arsa Yaratma", "L�tfen arsan�n �cret �arpan�n� girin(�arpan x d�n�m)\n�arpan� 6666 girmeniz �nerilir:", "Yarat", "Iptal");
		}
		/*else if(strcmp(idx, "sil", true) == 0)
		{
		}*/
	}
	return 1;
}

CMD:piyasa(playerid, params[])
{
	if(!Karakter[playerid][Giris]) return false;
	for(new i = 0; i < 9; i++) 
	{
		TextDrawShowForPlayer(playerid, tarim[i]);
	}
	PlayerTextDrawShow(playerid, tarim9[playerid]); 
	SelectTextDraw(playerid, 0xFF0000FF);
	return 1;
}

Dialog:DIALOG_CIFTLIK_EKIM(playerid, response, listitem, inputtext[])
{
	if(!response) return false;
	new cid = Karakter[playerid][Ciftlik];
	if(cid == -1) return Sunucu(playerid, "L�tfen tarlan�za girip tekrar deneyin.");
	if(CiftlikInfo[cid][cIslem]) return Sunucu(playerid, "Tarla �uan zaten birisi taraf�ndan ekilip & bi�iliyor.");
	if(Karakter[playerid][Para] < ekinlerveri[listitem + 1][ekinfiyat] * floatround(floatdiv(CiftlikInfo[cid][cDonum], 5.0), floatround_ceil)) return Sunucu(playerid, "Tohum masraf�n� kar��layam�yorsunuz.");
	ciftlikprog[playerid] = CreatePlayerProgressBar(playerid,228.00, 28.00, 201.50, 7.19, -8582401, 100.0);
	ShowPlayerProgressBar(playerid, ciftlikprog[playerid]);
	SetPlayerProgressBarMaxValue(playerid, ciftlikprog[playerid], CiftlikInfo[cid][cDonum]);
	ciftlikUpdater[playerid] = SetTimerEx("CiftlikBar", 2000, true, "iii", playerid, cid, listitem + 1);
	CiftlikInfo[cid][cIslem] = true;
	SetPVarInt(playerid, "oncekiciftlik", cid);
	TextDrawShowForPlayer(playerid, ciftlik_0);
	TextDrawShowForPlayer(playerid, ciftlik_1);
	ParaVer(playerid, -(ekinlerveri[listitem + 1][ekinfiyat] * floatround(floatdiv(CiftlikInfo[cid][cDonum], 5.0),floatround_ceil)));
	CiftlikInfo[cid][cUrun] = listitem + 1;
	CiftlikInfo[cid][cOlgunlasma] = ekinlerveri[listitem + 1][ekinzaman];
	Sunucu(playerid, "Tarlaya %s bitkisini ekmeye ba�lad�n�z, tarlan�n toplam d�n�m�: %.2f", ekinlerveri[listitem + 1][ekinisim], CiftlikInfo[cid][cDonum]);
	Ciftlik_Kaydet(cid);
	SetPVarInt(playerid, "CiftlikEkimIslem", 1);

	return true;
}

CMD:ciftlik(playerid, params[])
{
	if(Karakter[playerid][Giris] == false) return Sunucu(playerid, "Giri� yapmadan bu komutu kullanamazs�n.");
	if(!IsPlayerInAnyDynamicArea(playerid) || Karakter[playerid][Ciftlik] == -1) return Sunucu(playerid, "Bu komutu yanl�zca tarladayken kullanabilirsiniz.");
	new idx[20], cid = Karakter[playerid][Ciftlik];
	if(sscanf(params, "s[20]", idx))
	{
		SendClientMessage(playerid, RENK_GRI, "KULLANIM: /ciftlik [Parametre]");
		GenelMesajGonder(playerid, "ekim, bicim, ayar");
	}
	else
	{
		if(strcmp(idx, "ekim", true) == 0)
		{
			if(CiftlikInfo[cid][cSahipID] == Karakter[playerid][id] || TarlaIsciKontrol(playerid, cid))
			{
				if(CiftlikInfo[cid][cUrun] > 0 || CiftlikInfo[cid][cOlgunlasma] > 0) return Sunucu(playerid, "�iftlikte bi�ilmemi� �r�n var veya hen�z �r�nler olgunla�mam��.");
				if(!TarlaEkipmanKontrol(playerid, 0)) return Sunucu(playerid, "Tarlada ekim yapabilmek i�in trakt�re binip r�morku ba�lam�� olmal�s�n�z.");
				new subString[512];
				format(subString, sizeof(subString), "�r�n\tTohum Fiyat�\n");
				for (new i = 1; i != sizeof(ekinlerveri); i++)
				{
					format(subString, sizeof(subString), "%s{FFFFFF}%s\t{008104}(%s)\n", subString, ekinlerveri[i][ekinisim], NumaraFormati(ekinlerveri[i][ekinfiyat] * floatround(floatdiv(CiftlikInfo[cid][cDonum], 5.0), floatround_ceil)));
				}
				Dialog_Show(playerid, DIALOG_CIFTLIK_EKIM, DIALOG_STYLE_TABLIST_HEADERS, "Tarla Ekimi", subString, "Se�", "Iptal");
			}
			else Sunucu(playerid, "�iftlikte ekim sadece tarla sahibi taraf�ndan yap�labilir.");
		}
		else if(strcmp(idx, "ayar", true) == 0)
		{
			if(CiftlikInfo[cid][cSahipID] == Karakter[playerid][id])
			{
				Dialog_Show(playerid, ciftlik_ayar, DIALOG_STYLE_LIST, "�iftlik Ayarlar�", "�iftlik Ad� D�zenle\n���ileri G�r�nt�le\n���i Al\n�iftik Bilgileri\n�iftli�i Sat\n�iftli�i Ki�iye Sat", "Se�", "Iptal");
			}
			else Sunucu(playerid, "�iftli�in sahibi olmad���n�z i�in bu komutu kullanamazs�n�z.");
		}
		else if(strcmp(idx, "bicim", true) == 0)
		{
			if(CiftlikInfo[cid][cSahipID] == Karakter[playerid][id] || TarlaIsciKontrol(playerid, cid))
			{
				if(CiftlikInfo[cid][cUrun] == 0) return Sunucu(playerid, "�iftli�e herhangi bir �r�n ekilmemi�.");
				if(CiftlikInfo[cid][cIslem]) return Sunucu(playerid, "Tarla zaten birisi taraf�ndan ekilip & bi�iliyor.");
				if(CiftlikInfo[cid][cOlgunlasma] > 0) return Sunucu(playerid, "�iftlikteki �r�nler hen�z olgunla�mam��.");
				if(!TarlaEkipmanKontrol(playerid, 1)) return Sunucu(playerid, "Tarlay� bi�ebilmek i�in bi�erd�verde olmal�s�n�z.");
				bicimprog[playerid] = CreatePlayerProgressBar(playerid,228.00, 28.00, 201.50, 7.19, -8582401, 100.0);
				ShowPlayerProgressBar(playerid, bicimprog[playerid]);
				SetPlayerProgressBarMaxValue(playerid, bicimprog[playerid], EkinSayisiBul(cid));
				TextDrawShowForPlayer(playerid, ciftlik_0);
				TextDrawShowForPlayer(playerid, ciftlik_1);
				CiftlikInfo[cid][cIslem] = true;
				SetPVarInt(playerid, "oncekiciftlik", cid);
				SetPVarInt(playerid, "CiftlikBicimIslem", 1);
				SetPVarInt(playerid, "CiftlikEkinler", EkinSayisiBul(cid));
				Sunucu(playerid, "%s bitkisini bi�meye ba�lad�n�z, tarlan�n toplam d�n�m�: %.2f", ekinlerveri[CiftlikInfo[cid][cUrun]][ekinisim], CiftlikInfo[cid][cDonum]);
				Sunucu(playerid, "L�tfen �r�nleri bi�mek i�in bitkinin �zerine gidip '2' tu�una bas�n.");
			}
			else Sunucu(playerid, "�iftlikte bi�im sadece tarla sahibi taraf�ndan yap�labilir.");
		}
	}
	return 1;
}

CMD:romork(playerid, params[])
{
	static aid, type[24], string[128];
	if(sscanf(params, "ds[24]S()[128]", aid, type, string))
	{
		Kullanim(playerid, "/romork [rom�rk id] [se�enek]");
		GenelMesajGonder(playerid, "getir, tak, cikar, sistemesat");
		return 1;
	}
	if(!Araclar[aid][Gecerli]) return Sunucu(playerid, "Ge�ersiz ara�.");

	if(GetVehicleModel(aid) == 610 || GetVehicleModel(aid) == 611) 
	{
		if(!AracSahipKontrol(playerid, aid)) return Sunucu(playerid, "Belirtilen r�morkun sahibi siz de�ilsiniz.");

		if(!strcmp(type, "getir", true))
		{
		    if(IsPlayerInAnyVehicle(playerid)) return Sunucu(playerid, "Bu komutu ara� i�erisinde kullanamazs�n�z.");
		    if(!IsPlayerInAnyDynamicArea(playerid)) return Sunucu(playerid, "Bu komutu yanl�zca tarladayken kullanabilirsiniz.");
			GetPlayerPos(playerid, Araclar[aid][AracPos][0], Araclar[aid][AracPos][1], Araclar[aid][AracPos][2]);
			GetVehicleZAngle(aid, Araclar[aid][AracPos][3]);
			SetVehiclePos(aid, Araclar[aid][AracPos][0], Araclar[aid][AracPos][1], Araclar[aid][AracPos][2]);
			Sunucu(playerid, "%s model romorkunu park ettin.", GetVehicleNameByModel(Araclar[aid][Model]));
			AracVeriKaydet(aid);	
		}
		else if(!strcmp(type, "tak", true))
		{
			if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return Sunucu(playerid, "Herhangi bir arac�n s�r�c� koltu�unda de�ilsiniz.");
			new aracid = GetPlayerVehicleID(playerid);
			if(GetVehicleModel(aracid) == 531 || GetVehicleModel(aracid) == 485) 
			{
				if(!IsVehicleStreamedIn(aid, playerid)) return Sunucu(playerid, "R�morke yeterince yak�n de�ilsiniz.");
				AttachTrailerToVehicle(aid, aracid);
				Sunucu(playerid, "R�mork ba�ar�yla arac�n�za tak�ld�.");
			}
			else Sunucu(playerid, "R�morkler sadece trakt�re tak�labilir.");
		}
		else if(!strcmp(type, "sistemesat", true))
		{
			AracSil(aid);
			ParaVer(playerid, 2500);
			Sunucu(playerid, "R�morku 2500 dolar kar��l���nda ba�ar�yla satt�n.");
		}
		else if(!strcmp(type, "cikar", true))
		{
			if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return Sunucu(playerid, "Herhangi bir arac�n s�r�c� koltu�unda de�ilsiniz.");
			new aracid = GetPlayerVehicleID(playerid);
			if(GetVehicleTrailer(aracid) == 0) return Sunucu(playerid, "Araca ba�lanm�� r�mork bulunmuyor.");
		    DetachTrailerFromVehicle(GetVehicleTrailer(aracid));
		    Sunucu(playerid, "R�mork ba�ar�yla ara�tan ��kar�ld�.");
		}
		else Sunucu(playerid, "Ge�ersiz opsiyonel.");
	}
	else Sunucu(playerid, "Belirtilen ID bir r�mork de�il.");
	return 1;
}

CMD:ciftlikal(playerid, params[])
{
	if(IsPlayerInAnyDynamicArea(playerid) && Karakter[playerid][Ciftlik] != -1)
	{
		new cid = Karakter[playerid][Ciftlik];
		if(CiftlikInfo[cid][cSahipID] == 0)
		{
			if(Karakter[playerid][Para] < CiftlikInfo[cid][cPara]) return Sunucu(playerid, "Bu �iftli�i sat�n alabilmek i�in yeterli paran yok!");
			if(!TarlaUygunlukKontrol(playerid)) return Sunucu(playerid, "Daha fazla tarla sat�n alamazs�n�z.");
			CiftlikInfo[cid][cSahipID] = Karakter[playerid][id];
			ParaVer(playerid, -CiftlikInfo[cid][cPara]);
			Sunucu(playerid, "%s adl� �iftli�i %s kar��l���nda sat�n ald�n.", CiftlikInfo[cid][cIsim], NumaraFormati(CiftlikInfo[cid][cPara]));
			Ciftlik_Kaydet(cid);
			GangZoneHideForAll(CiftlikInfo[cid][cZone]);
			GangZoneShowForAll(CiftlikInfo[cid][cZone], 0x812600AA);
		}
		else
		{
			Sunucu(playerid, "Bu �iftli�in zaten bir sahibi bulunuyor, sat�n alamazs�n.");
		}
	}
	else Sunucu(playerid, "Bir �iftlikte de�ilsin.");	
	return true;
}


// EK�N KOMUTLARI

CMD:ekin(playerid, params[])
{
	if(!Karakter[playerid][Giris]) return Sunucu(playerid, "Giri� yapmadan bu komutu kullanamazs�n.");
	new idx[20], cid = Karakter[playerid][Ciftlik], msg[95];
	if(sscanf(params, "s[20]", idx))
	{
		Kullanim(playerid, "/ekin [se�enek]");
		GenelMesajGonder(playerid, "al, koy, cikar, sat, gps, yoket");
	}
	else
	{
		if(strcmp(idx, "al", true) == 0)
		{
			if(IsPlayerInAnyVehicle(playerid)) return Sunucu(playerid, "Ara� i�erisinde bu i�lem ger�ekle�emez.");
			if(!IsPlayerInAnyDynamicArea(playerid) || Karakter[playerid][Ciftlik] == -1) return Sunucu(playerid, "Bu komutu yanl�zca tarladayken kullanabilirsiniz.");
			if(CiftlikInfo[cid][cSahipID] == Karakter[playerid][id] || TarlaIsciKontrol(playerid, cid))
			{
				if(IsPlayerAttachedObjectSlotUsed(playerid, 6)) return Sunucu(playerid, "Eliniz doluyken yerdeki ekini alamazs�n�z.");
				new query[110], Cache:VeriCek, rows;
				mysql_format(conn, query, sizeof(query), "SELECT * FROM tarimurunleri WHERE ciftlikid = %i", Karakter[playerid][Ciftlik]);
				VeriCek = mysql_query(conn, query);
				rows = cache_num_rows();
				if(rows)
				{
					new Float:x, Float:y, Float:z;
					for (new i = 0; i < rows; i ++)
					{
						cache_get_value_name_float(i, "x", x);
						cache_get_value_name_float(i, "y", y);
						cache_get_value_name_float(i, "z", z);
						if(GetPlayerDistanceFromPoint(playerid, x, y, z) < 2.1)
						{
							new oid, urun;
							cache_get_value_name_int(i, "objeid", oid);
							cache_get_value_name_int(i, "urun", urun);
							cache_delete(VeriCek);
							DestroyDynamicObject(oid);
							Karakter[playerid][Ekin] = urun;
							ApplyAnimation(playerid, "CARRY", "liftup05", 4.1, 0, 1, 1, 0, 0, 1);
							SetPlayerAttachedObject(playerid, 6, 2901, 6, 0.116999, 0.076999, -0.251000, -3.499999, 76.900024, -20.800006);
							SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
							format(msg, sizeof(msg), "e�ilir ve %s adl� ekini yerden al�r.", ekinlerveri[urun][ekinisim]);
							cmd(playerid, 1, msg);
							mysql_format(conn, query, sizeof(query), "DELETE FROM tarimurunleri WHERE objeid = %i", oid);
							mysql_query(conn, query);
							break;
						}
					}	
				}
				else
				{
					cache_delete(VeriCek);
				}
			}
			else Sunucu(playerid, "Bu i�lem yanl�zca tarla sahibi taraf�ndan yap�labilir.");
		}
		else if(strcmp(idx, "gps", true) == 0)
		{
			Dialog_Show(playerid, DIALOG_EKIN_GPS, DIALOG_STYLE_LIST, "Ekin Sat�� Noktalar�", "{C9C936}Linton Mills\n{C9C936}Whitney Grain\n{C9C936}Greenwich Mill\n{C9C936}Carmell Corn\n{C9C936}Solarin Industries", "��aretle", "Iptal");
		}
		else if(strcmp(idx, "yoket", true) == 0)
		{
			if(IsPlayerInAnyVehicle(playerid)) return Sunucu(playerid, "Ara� i�erisinde bu i�lem ger�ekle�emez.");
			if(Karakter[playerid][Ekin] == 0 || !IsPlayerAttachedObjectSlotUsed(playerid, 6)) return Sunucu(playerid, "Elinizde herhangi bir ekin bulunmuyor.");
			SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
			Karakter[playerid][Ekin] = 0;
			RemovePlayerAttachedObject(playerid, 6);
			ClearAnimations(playerid);
			Sunucu(playerid, "Elinizdeki ekini ba�ar�yla yok ettiniz.");
		}
		else if(strcmp(idx, "sat", true) == 0)
		{
			if(IsPlayerInAnyVehicle(playerid)) return Sunucu(playerid, "Ara� i�erisinde bu i�lem ger�ekle�emez.");
			if(Karakter[playerid][Ekin] == 0 || !IsPlayerAttachedObjectSlotUsed(playerid, 6)) return Sunucu(playerid, "Elinizde herhangi bir ekin bulunmuyor.");

			new ekinfiyatdusur = 10;
			
			for(new i = 0; i < sizeof(piyasaveri); i++)
			{
				if(IsPlayerInRangeOfPoint(playerid, 2.0, piyasaveri[i][piyasax], piyasaveri[i][piyasay], piyasaveri[i][piyasaz]))
				{
					switch(Karakter[playerid][Ekin])
					{
						case 1: 
						{
							Sunucu(playerid, "%s adl� ekininizi %s fiyat�na satt�n�z.", ekinlerveri[1][ekinisim], NumaraFormati(piyasaveri[i][urun1]));
							ParaVer(playerid, piyasaveri[i][urun1]-ekinfiyatdusur);
							ApplyAnimation(playerid, "CARRY", "putdwn", 4.1, 0, 1, 1, 0, 0, 1);
							SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
							Karakter[playerid][Ekin] = 0;
							RemovePlayerAttachedObject(playerid, 6);
						}
						case 2: 
						{
							Sunucu(playerid, "%s adl� ekininizi %s fiyat�na satt�n�z.", ekinlerveri[2][ekinisim], NumaraFormati(piyasaveri[i][urun2]));
							ParaVer(playerid, piyasaveri[i][urun2]-ekinfiyatdusur);
							ApplyAnimation(playerid, "CARRY", "putdwn", 4.1, 0, 1, 1, 0, 0, 1);
							SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
							Karakter[playerid][Ekin] = 0;
							RemovePlayerAttachedObject(playerid, 6);
						}
						case 3: 
						{
							Sunucu(playerid, "%s adl� ekininizi %s fiyat�na satt�n�z.", ekinlerveri[3][ekinisim], NumaraFormati(piyasaveri[i][urun3]));
							ParaVer(playerid, piyasaveri[i][urun3]-ekinfiyatdusur);
							ApplyAnimation(playerid, "CARRY", "putdwn", 4.1, 0, 1, 1, 0, 0, 1);
							SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
							Karakter[playerid][Ekin] = 0;
							RemovePlayerAttachedObject(playerid, 6);
						}
						case 4: 
						{
							Sunucu(playerid, "%s adl� ekininizi %s fiyat�na satt�n�z.", ekinlerveri[4][ekinisim], NumaraFormati(piyasaveri[i][urun4]));
							ParaVer(playerid, piyasaveri[i][urun4]-ekinfiyatdusur);
							ApplyAnimation(playerid, "CARRY", "putdwn", 4.1, 0, 1, 1, 0, 0, 1);
							SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
							Karakter[playerid][Ekin] = 0;
							RemovePlayerAttachedObject(playerid, 6);
						}
						case 5: 
						{
							Sunucu(playerid, "%s adl� ekininizi %s fiyat�na satt�n�z.", ekinlerveri[5][ekinisim], NumaraFormati(piyasaveri[i][urun5]));
							ParaVer(playerid, piyasaveri[i][urun5]-ekinfiyatdusur);
							ApplyAnimation(playerid, "CARRY", "putdwn", 4.1, 0, 1, 1, 0, 0, 1);
							SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
							Karakter[playerid][Ekin] = 0;
							RemovePlayerAttachedObject(playerid, 6);
						}
						case 6: 
						{
							Sunucu(playerid, "%s adl� ekininizi %s fiyat�na satt�n�z.", ekinlerveri[6][ekinisim], NumaraFormati(piyasaveri[i][urun6]));
							ParaVer(playerid, piyasaveri[i][urun6]-ekinfiyatdusur);
							ApplyAnimation(playerid, "CARRY", "putdwn", 4.1, 0, 1, 1, 0, 0, 1);
							SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
							Karakter[playerid][Ekin] = 0;
							RemovePlayerAttachedObject(playerid, 6);
						}
						case 7: 
						{
							Sunucu(playerid, "%s adl� ekininizi %s fiyat�na satt�n�z.", ekinlerveri[7][ekinisim], NumaraFormati(piyasaveri[i][urun7]));
							ParaVer(playerid, piyasaveri[i][urun7]-ekinfiyatdusur);
							ApplyAnimation(playerid, "CARRY", "putdwn", 4.1, 0, 1, 1, 0, 0, 1);
							SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
							Karakter[playerid][Ekin] = 0;
							RemovePlayerAttachedObject(playerid, 6);
						}
					}
				}
			}
		}
		else if(strcmp(idx, "cikar", true) == 0)
		{
			if(IsPlayerInAnyVehicle(playerid)) return Sunucu(playerid, "Ara� i�erisinde bu i�lem ger�ekle�emez.");
			if(Karakter[playerid][Ekin] != 0) return Sunucu(playerid, "Ara�tan ekin ��karabilmek i�in �nce elinizdekini b�rakmal�n�z.");
			new gid = -1,
			putID = -1,
			model;

			if((gid = AracYakin(playerid)) != 0)
			{
				model = GetVehicleModel(gid);
				if(model == 482 || model == 498 || model == 499) 
				{
					if(putID == -1)
					{
						putID = gid;
					}
				}
			}
			if(putID != -1)
			{
					if(!AracSahipKontrol(playerid, putID) && !AracAnahtarKontrol(playerid, putID)) return Sunucu(playerid, "Bu arac�n anahtar�na sahip de�ilsiniz.");
					if(Araclar[putID][AracKilit]) return Sunucu(playerid, "Bu ara� kilitli oldu�u i�in ekin ��karamazs�n�z.");
					new query[144];
					mysql_format(conn, query, sizeof(query), "SELECT `ekintur` FROM `aracekinler` WHERE `id` = '%d'", Araclar[putID][id]);
					mysql_tquery(conn, query, "AracEkinGoster", "dd", playerid, putID);
					putID = -1;
			}
		}	
		else if(strcmp(idx, "koy", true) == 0)
		{
			if(Karakter[playerid][Ekin] == 0) return Sunucu(playerid, "Elinizde ekin bulunmuyor.");
			if(IsPlayerInAnyVehicle(playerid)) return Sunucu(playerid, "Ara� i�erisinde bu i�lem ger�ekle�emez.");
			new kapasite,
			model,
			gid = -1,
			putID = -1;

			if((gid = AracYakin(playerid)) != -1)
			{
				model = GetVehicleModel(gid);
				if(model == 482 || model == 498 || model == 499) {
					if(putID == -1)
					{
						putID = gid;
					}
				}
			}
			if(putID != -1)
			{
				for(new i = 0; i < sizeof(faracveri) ; i++)
				{
					if(GetVehicleModel(putID) == faracveri[i][0]) kapasite = faracveri[i][2];
				}

				if(EkinKapasiteKontrol(Araclar[putID][id]) == kapasite) return Sunucu(playerid, "Bu araca %d ekinden fazla koyamazs�n�z.", kapasite);
				new me[90],query[95];
				format(me, sizeof(me), "** %s arac�n i�erisine elindeki ekini yerle�tirir.", RPIsim(playerid));
				SetPlayerChatBubble(playerid, me, RENK_PEMBE, 12.0, 10000);
				strins(me, "> ", 3);
				SendClientMessage(playerid, RENK_PEMBE, me);
				ApplyAnimation(playerid, "CARRY", "putdwn", 4.1, 0, 1, 1, 0, 0, 1);
				SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
				mysql_format(conn, query, sizeof(query), "INSERT INTO `aracekinler` (`id`, `ekintur`) VALUES('%d', '%d')", Araclar[putID][id], Karakter[playerid][Ekin]);
				mysql_query(conn, query);
				Karakter[playerid][Ekin] = 0;
				RemovePlayerAttachedObject(playerid, 6);
				putID = -1;
			}
		}
	}
	return 1;
}

Dialog:arsa_yarat(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		if(strval(inputtext) < 1) return Dialog_Show(playerid, arsa_yarat, DIALOG_STYLE_INPUT, "Arsa Yaratma", "L�tfen ge�erli bir �cret girin (0'dan b�y�k ve numerik de�er):", "Yarat", "Iptal");
		new i = GetArsaID(),Float:minpos[2],Float:maxpos[3],query[300];
		if(i == MAX_CIFTLIK) return Sunucu(playerid, "�iftlik yaratma limiti doldu, developere ba�vurun.");
				
		minpos[0] = GetPVarFloat(playerid, "ciftlikminX");
		minpos[1] = GetPVarFloat(playerid, "ciftlikminY");
		maxpos[0] = GetPVarFloat(playerid, "ciftlikmaxX");
		maxpos[1] = GetPVarFloat(playerid, "ciftlikmaxY");
				
		CiftlikInfo[i][cID] = i;
		CiftlikInfo[i][cArsa] = CreateDynamicRectangle(minpos[0], minpos[1], maxpos[0], maxpos[1], -1, -1, -1);
		CiftlikInfo[i][cminX] = minpos[0];
		CiftlikInfo[i][cminY] = minpos[1];
		CiftlikInfo[i][cmaxX] = maxpos[0];
		CiftlikInfo[i][cmaxY] = maxpos[1];
		CiftlikInfo[i][cAktif] = 1;
		CiftlikInfo[i][cIslem] = false;
		CiftlikInfo[i][cKasa] = 0;
		CiftlikInfo[i][cUrun] = 0;
		CiftlikInfo[i][cOlgunlasma] = 0;
		format(CiftlikInfo[i][cIsim], 50, "Florida Eyalet �iftlikleri");
		CiftlikInfo[i][cSahipID] = 0;
		CiftlikInfo[i][cZone] = GangZoneCreate(minpos[0], minpos[1], maxpos[0], maxpos[1]);
		GangZoneShowForAll(CiftlikInfo[i][cZone], 0x00812EAA);
		Sunucu(playerid, "Yeni bir arsa yaratt�n�z. (Benzersiz ID: %d, Arsa ID: %d)", CiftlikInfo[i][cID], CiftlikInfo[i][cArsa]);
	    mysql_format(conn, query, sizeof(query), "INSERT INTO `arsalar` (`id`, `minx`, `miny`, `maxx`, `maxy`, `isim`, `para`, `SahipID`) VALUES(%i, %f, %f, %f, %f, '%e', %i, %i)", CiftlikInfo[i][cID], CiftlikInfo[i][cminX], CiftlikInfo[i][cminY], CiftlikInfo[i][cmaxX], CiftlikInfo[i][cmaxY], CiftlikInfo[i][cIsim], CiftlikInfo[i][cPara], CiftlikInfo[i][cSahipID]);
		mysql_query(conn, query);
		ArsaIkiNoktaArasiUzaklik(CiftlikInfo[i][cDonum], CiftlikInfo[i][cminX], CiftlikInfo[i][cminY], CiftlikInfo[i][cmaxX], CiftlikInfo[i][cmaxY]);
		CiftlikInfo[i][cPara] = strval(inputtext) * floatround(floatdiv(CiftlikInfo[i][cDonum], 5.0), floatround_ceil);
		DeletePVar(playerid, "ctelportayarladi");
		DeletePVar(playerid, "cteleportdestayarladi");
	}
	else 
	{
		DeletePVar(playerid, "ctelportayarladi");
		DeletePVar(playerid, "cteleportdestayarladi");
	}
	return 1;
}

Dialog:ciftliksatis(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		new oyuncu = GetPVarInt(playerid, "ciftlikoyuncu"), para = GetPVarInt(playerid, "ciftlikucreti"), cid = GetPVarInt(playerid, "ciftlikidsi");
		if(!IsPlayerConnected(oyuncu)) return Sunucu(playerid, "Sat�c� aktif de�il.");
		if(!Karakter[oyuncu][Giris]) return Sunucu(playerid, "Sat�c� giri� yapmam��.");
		if(Karakter[playerid][Para] < para) return Sunucu(playerid, "�zerinde yeterli miktarda para bulunmuyor.");

		CiftlikInfo[cid][cSahipID] = Karakter[playerid][id];
		Ciftlik_Kaydet(cid);

		ParaVer(oyuncu, para);
		ParaVer(playerid, -para);
		Sunucu(oyuncu, "�iftli�inizi ba�ar�yla %s adl� ki�iye satt�n�z.", RPIsim(playerid));
		Sunucu(playerid, "�iftli�i ba�ar�yla %s kar��l���nda sat�n ald�n�z.", NumaraFormati(para));
		DeletePVar(playerid, "ciftlikoyuncu"), DeletePVar(playerid, "ciftlikucreti"), DeletePVar(playerid, "ciftlikidsi");
	}
	return 1;
}

// DIALOGS

Dialog:ciftlik_isciler(playerid, response, listitem, inputtext[])
{
	if(!response) return 1;
	if(!IsPlayerInAnyDynamicArea(playerid) || Karakter[playerid][Ciftlik] == -1) return Sunucu(playerid, "Bu komutu yanl�zca tarladayken kullanabilirsiniz.");
	new cid = Karakter[playerid][Ciftlik], query[130];
	mysql_format(conn, query, sizeof(query), "DELETE FROM tarimiscileri WHERE ciftlikid = %i AND oisim = '%e'", cid, inputtext);
	mysql_query(conn, query);
	Sunucu(playerid, "%s adl� ki�iyi i��iler aras�ndan ��kard�n�z.", inputtext);
	return 1;
}	

Dialog:ciftlik_ayar(playerid, response, listitem, inputtext[])
{
	if(!response) return 1;
	if(!IsPlayerInAnyDynamicArea(playerid) || Karakter[playerid][Ciftlik] == -1) return Sunucu(playerid, "Bu komutu yanl�zca tarladayken kullanabilirsiniz.");
	new cid = Karakter[playerid][Ciftlik];
	switch(listitem)
	{
		case 0: 
		{
			Dialog_Show(playerid, ciftlik_isim, DIALOG_STYLE_INPUT, "�iftlik �smi D�zenleme", "L�tfen �iftli�inizin yeni ad�n� girin (Max: 50 Karakter):", "Tamam", "Iptal");
		}
		case 1: 
		{
			new query[90], Cache:VeriCek, rows, subString[250];
			mysql_format(conn, query, sizeof(query), "SELECT * FROM tarimiscileri WHERE ciftlikid = '%d'", cid);
			VeriCek = mysql_query(conn, query);
			rows = cache_num_rows();
			if(rows)
			{
				for (new i = 0; i < rows; i++)
				{
					new oisim[64];
					cache_get_value_name(i, "oisim", oisim, 64);
					format(subString, sizeof(subString), "%s%s\n", subString, oisim);
				}
				Dialog_Show(playerid, ciftlik_isciler, DIALOG_STYLE_LIST, "�iftlik ���ileri", subString, "Se�", "Iptal");
				Sunucu(playerid, "���i atmak i�in atmak istedi�iniz ki�inin isminin �zerine t�klay�n.");
			}
			else Sunucu(playerid, "�iftli�inizde herhangi bir i��i bulunmuyor");
			cache_delete(VeriCek);
		}
		case 2: 
		{
			Dialog_Show(playerid, ciftlik_isci, DIALOG_STYLE_INPUT, "�iftlik ���i Al�m�", "L�tfen �iftli�inize almak istedi�iniz ki�inin oyuncu ID'sini girin:", "Tamam", "Iptal");
		}
		case 3: 
		{
		new string[450];
		format(string, sizeof(string), "I�levler\t#\n�iftlik ID:\t{C9C936}%d\n�iftlik Ad�:\t{C9C936}%s\n�iftlik �creti:\t{C9C936}%s\nEkili �r�n:\t{C9C936}%s\nKalan saat:\t{C9C936}%d",cid, CiftlikInfo[cid][cIsim],NumaraFormati(CiftlikInfo[cid][cPara]),ekinlerveri[CiftlikInfo[cid][cUrun]][ekinisim],CiftlikInfo[cid][cOlgunlasma]);	
		Dialog_Show(playerid, BOS_MESAJ, DIALOG_STYLE_TABLIST_HEADERS, "�iftlik Bilgileri", string, "Tamam", "Iptal");
		}
		/*case 4: 
		{
		new String[72];
		if(Hesap[playerid][oEkonomiPaketi] < 1)
		{
		format(String, sizeof(String), "%d$ kar��l���nda �iftli�inizi sisteme satmak istiyor musunuz?", YuzdeHesapla(CiftlikInfo[cid][cPara], SERVER_YUZDE));
		}
		else
		{
		format(String, sizeof(String), "%d$ kar��l���nda �iftli�inizi sisteme satmak istiyor musunuz?", YuzdeHesapla(CiftlikInfo[cid][cPara], VIP_YUZDE));
		}
		Dialog_Show(playerid, ciftlik_sat, DIALOG_STYLE_MSGBOX, "�iftlik Sat�m�", String, "Tamam", "Iptal");
		}*/
		case 5: 
		{
		Sunucu(playerid, "Bu i�lem '/ciftliksat' komutu �zerinden yap�lmaktad�r.");
		}
	}
	return 1;
}

Dialog:ciftlik_sat(playerid, response, listitem, inputtext[])
{
	if(!response) return 1;
	if(!IsPlayerInAnyDynamicArea(playerid) || Karakter[playerid][Ciftlik] == -1) return Sunucu(playerid, "Bu komutu yanl�zca tarladayken kullanabilirsiniz.");
	new cid = Karakter[playerid][Ciftlik];
	CiftlikInfo[cid][cSahipID] = 0;
	/*if(Karakter[playerid][oEkonomiPaketi] < 1)
	{
	ParaVer(playerid, YuzdeHesapla(CiftlikInfo[cid][cPara], SERVER_YUZDE));
	}
	else
	{
	ParaVer(playerid, YuzdeHesapla(CiftlikInfo[cid][cPara], VIP_YUZDE));
	}*/
	Ciftlik_Kaydet(cid);
	Sunucu(playerid, "�iftli�i ba�ar�yla sisteme satt�n�z.");
	return 1;
}	

Dialog:ciftlik_isci(playerid, response, listitem, inputtext[])
{
	if(!response) return 1;
	if(!IsPlayerInAnyDynamicArea(playerid) || Karakter[playerid][Ciftlik] == -1) return Sunucu(playerid, "Bu komutu yanl�zca tarladayken kullanabilirsiniz.");
	new oid = strval(inputtext), cid = Karakter[playerid][Ciftlik], sonuc = 0;
	if(oid == INVALID_PLAYER_ID) return Sunucu(playerid, "Hatal� oyuncu ID'si girdiniz.");
	if(!IsPlayerConnected(oid)) return Sunucu(playerid, "ID'sini girdi�iniz ki�i oyunda de�il.");
	if(oid == playerid) return Sunucu(playerid, "Kendinizi i��i olarak ekleyemezsiniz.");
	if(OyuncuYakin(playerid, oid, 2.0))
	{
		new query[128],Cache:VeriCek, rows;
		mysql_format(conn, query, sizeof(query), "SELECT * FROM tarimiscileri WHERE oisim = '%e' AND ciftlikid = %i", Karakter[oid][Isim], cid);
		VeriCek = mysql_query(conn, query);	
		rows = cache_num_rows();
		if(rows)
		{
			sonuc = 1;
			Sunucu(playerid, "Bu ki�i zaten i��ileriniz aras�nda.");
		}
		cache_delete(VeriCek);
		if(sonuc == 0)
		{
			mysql_format(conn, query, sizeof(query), "INSERT INTO tarimiscileri (ciftlikid, oisim) VALUES (%i, '%e')", cid, Karakter[oid][Isim]);
			mysql_query(conn, query);	
			Sunucu(playerid, "%s adl� ki�iyi tarlan�za i��i olarak ald�n�z.", RPIsim(oid));
		}
	}
	else Sunucu(playerid, "ID'sini girdi�iniz ki�i sizin tarlan�zda ve size yak�n olmal�d�r.");
	return 1;
}	

Dialog:ciftlik_isim(playerid, response, listitem, inputtext[])
{
	if(!response) return 1;
	if(!IsPlayerInAnyDynamicArea(playerid) || Karakter[playerid][Ciftlik] == -1) return Sunucu(playerid, "Bu komutu yanl�zca tarladayken kullanabilirsiniz.");
	if(strlen(inputtext) < 1 || strlen(inputtext) > 50) return Sunucu(playerid, "�iftlik ismi 1 karakterden az ve 50 karakterden fazla olamaz.");
	new cid = Karakter[playerid][Ciftlik];
	format(CiftlikInfo[cid][cIsim], 50, inputtext);
	Ciftlik_Kaydet(cid);
	Sunucu(playerid, "Ba�ar�yla �iftli�inizin ismini '%s' olarak de�i�tirdiniz.", CiftlikInfo[cid][cIsim]);
	return 1;
}

Dialog:DIALOG_EKIN_GPS(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		SetPlayerCheckpoint(playerid, piyasaveri[listitem][piyasax], piyasaveri[listitem][piyasay], piyasaveri[listitem][piyasaz], 3.0);
		Sunucu(playerid, "%s adl� yer GPS �zerinde i�aretlendi.", piyasaveri[listitem][piyasaisim]);
	}
	return 1;
}


// FONKS�YONLAR

Vice:ArsalariYukle()
{
	new rows;
	cache_get_row_count(rows);

	new cid, query[100];
	for(new i = 0; i < rows; i++)
	{
		new idx = GetArsaID();
		cache_get_value_name_int(i, "id", cid);
		cache_get_value_name_float(i, "minx", CiftlikInfo[idx][cminX]);
		cache_get_value_name_float(i, "miny", CiftlikInfo[idx][cminY]);
		cache_get_value_name_float(i, "maxx", CiftlikInfo[idx][cmaxX]);
		cache_get_value_name_float(i, "maxy", CiftlikInfo[idx][cmaxY]);
		cache_get_value_name_int(i, "para", CiftlikInfo[idx][cPara]);
		cache_get_value_name_int(i, "kasa", CiftlikInfo[idx][cKasa]);
		cache_get_value_name_int(i, "urun", CiftlikInfo[idx][cUrun]);
		cache_get_value_name_int(i, "olgunlasma", CiftlikInfo[idx][cOlgunlasma]);
		cache_get_value_name_int(i, "SahipID", CiftlikInfo[idx][cSahipID]);
		cache_get_value_name(i, "isim", CiftlikInfo[idx][cIsim], 50);
		CiftlikInfo[idx][cAktif] = 1;
		CiftlikInfo[idx][cIslem] = false;
		CiftlikInfo[idx][cID] = idx;
		
		CiftlikInfo[idx][cArsa] = CreateDynamicRectangle(CiftlikInfo[idx][cminX], CiftlikInfo[idx][cminY], CiftlikInfo[idx][cmaxX], CiftlikInfo[idx][cmaxY], -1, -1, -1);
		CiftlikInfo[idx][cZone] = GangZoneCreate(CiftlikInfo[idx][cminX], CiftlikInfo[idx][cminY], CiftlikInfo[idx][cmaxX], CiftlikInfo[idx][cmaxY]);
		
		if(CiftlikInfo[i][cSahipID] == 0)
		{
			GangZoneShowForAll(CiftlikInfo[idx][cZone], 0x00812EAA);
		}
		else
		{
			GangZoneShowForAll(CiftlikInfo[idx][cZone], 0x812600AA);
		}		
		mysql_format(conn, query, sizeof(query), "UPDATE arsalar SET id = %i WHERE id = %i", idx, cid);
		mysql_tquery(conn, query);
		ArsaIkiNoktaArasiUzaklik(CiftlikInfo[idx][cDonum], CiftlikInfo[idx][cminX], CiftlikInfo[idx][cminY], CiftlikInfo[idx][cmaxX], CiftlikInfo[idx][cmaxY]);
	}
	printf("[MySQL] Veritaban�ndan '%i' adet arsa y�klendi.", rows);
	return 1;
}

Vice:EkinleriYukle()
{
	new rows;
	cache_get_row_count(rows);

	new cid, objectid, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz, query[120];
	for(new i = 0; i < rows; i++)
	{
		cache_get_value_name_int(i, "objeid", cid);
		cache_get_value_name_float(i, "x", x);
		cache_get_value_name_float(i, "y", y);
		cache_get_value_name_float(i, "z", z);
		cache_get_value_name_float(i, "rx", rx);
		cache_get_value_name_float(i, "ry", ry);
		cache_get_value_name_float(i, "rz", rz);

		objectid = CreateDynamicObject(3409, x, y, z, rx, ry, rz, 0,0);
		mysql_format(conn, query, sizeof(query), "UPDATE ekinler SET objeid = '%d' WHERE objeid = '%d'", objectid, cid);
		mysql_tquery(conn, query);
	}
	printf("[MySQL] Veritaban�ndan '%i' adet ekin y�klendi.", rows);
	return 1;
}

Vice:TarimUrunleriYukle()
{
	new rows;
	cache_get_row_count(rows);

	new cid, objectid, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz, query[120];
	for(new i = 0; i < rows; i++)
	{
		cache_get_value_name_int(i, "objeid", cid);
		cache_get_value_name_float(i, "x", x);
		cache_get_value_name_float(i, "y", y);
		cache_get_value_name_float(i, "z", z);
		cache_get_value_name_float(i, "rx", rx);
		cache_get_value_name_float(i, "ry", ry);
		cache_get_value_name_float(i, "rz", rz);

		objectid = CreateDynamicObject(-3004, x, y, z, rx, ry, rz, 0,0);
		mysql_format(conn, query, sizeof(query), "UPDATE tarimurunleri SET objeid = %i WHERE objeid = %i", objectid, cid);
		mysql_tquery(conn, query);
	}
	printf("[MySQL] Veritaban�ndan '%i' adet tar�m �r�n� y�klendi.", rows);
	return 1;
}

Vice:Ciftlik_Kaydet(ciftlikid)
{
	static query[550];
	mysql_format(conn, query, sizeof(query), "UPDATE arsalar SET minx = %f, miny = %f, maxx = %f, maxy = %f, isim = '%e' WHERE id = %i",
		CiftlikInfo[ciftlikid][cminX],
		CiftlikInfo[ciftlikid][cminY],
		CiftlikInfo[ciftlikid][cmaxX],
		CiftlikInfo[ciftlikid][cmaxY],
		CiftlikInfo[ciftlikid][cIsim],
	ciftlikid);
	mysql_tquery(conn, query);
	mysql_format(conn, query, sizeof(query), "UPDATE arsalar SET para = %i, kasa = %i, urun = %i, olgunlasma = %i, SahipID = %i WHERE id = %i",
		CiftlikInfo[ciftlikid][cPara],
		CiftlikInfo[ciftlikid][cKasa],
		CiftlikInfo[ciftlikid][cUrun],
		CiftlikInfo[ciftlikid][cOlgunlasma],
		CiftlikInfo[ciftlikid][cSahipID],
	ciftlikid);
	mysql_tquery(conn, query);
	return 1;
}

Vice:UrunYarat(playerid, ciftlikid) 
{
	new objeid, vehid = GetPlayerVehicleID(playerid), Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz, Float:zz, query[300];
	GetPosBehindVehicle(vehid, x, y, z, 0.1);
	GetVehicleRotation(vehid, rx, ry, rz);
	MapAndreas_FindZ_For2DCoord(x,y, zz);
	objeid = CreateDynamicObject(-3004, x, y, (zz+0.70), rx, ry, rz, 0, 0);
	mysql_format(conn, query, sizeof(query), "INSERT INTO tarimurunleri (ciftlikid, objeid, urun, x, y, z, rx, ry, rz) VALUES(%i, %i , %i, %f, %f, %f, %f, %f, %f)", 
	ciftlikid, 
	objeid,
	CiftlikInfo[ciftlikid][cUrun], x,y,(zz+0.70),rx,ry,rz);
	mysql_tquery(conn, query);
}

Vice:TarlaUygunlukKontrol(playerid)
{
	new Cache:VeriCek, query[165], bool:sonuc = true;
	mysql_format(conn, query, sizeof(query), "SELECT * FROM arsalar WHERE sahip = '%e'", Karakter[playerid][Isim]);
	VeriCek = mysql_query(conn, query);
	new rows = cache_num_rows();
	switch(Hesap[playerid][VIP])
	{
		case 0:
		{
		if(rows > 0) sonuc = false;
		}
		default:
		{
		if(rows >= 2) sonuc = false;
		}
	}
	cache_delete(VeriCek);
	return sonuc;
}	

stock GetArsaID()
{
	for (new i = 0; i < MAX_CIFTLIK; i++)
	{
		if (!CiftlikInfo[i][cAktif]) return i;
	}
	return MAX_CIFTLIK;
}

Vice:CiftlikZoneYukle(playerid)
{
	for( new i = 0; i < MAX_CIFTLIK; i ++ ) if(CiftlikInfo[i][cAktif]) 
	{
		if(CiftlikInfo[i][cSahipID] == 0)
		{
		GangZoneShowForPlayer(playerid, CiftlikInfo[i][cZone], 0x00812EAA);
		}
		else
		{
		GangZoneShowForPlayer(playerid, CiftlikInfo[i][cZone], 0x812600AA);
		}		
	}
	return true;
}

Vice:CiftlikBar(playerid, cid, list)
{
	if(GetPlayerProgressBarValue(playerid, ciftlikprog[playerid]) >= CiftlikInfo[cid][cDonum])
	{
		Sunucu(playerid, "Ba�ar�yla �iftli�inize %s bitkisini ektiniz.", ekinlerveri[list][ekinisim]);
		Doluluk[playerid] = 0;
		CiftlikInfo[cid][cIslem] = false;
		HidePlayerProgressBar(playerid, ciftlikprog[playerid]);
		DestroyPlayerProgressBar(playerid, ciftlikprog[playerid]);
		TextDrawHideForPlayer(playerid, ciftlik_0);
		TextDrawHideForPlayer(playerid, ciftlik_1);
		KillTimer(ciftlikUpdater[playerid]);
		SetPVarInt(playerid, "CiftlikEkimIslem", 0);
		DeletePVar(playerid, "CiftlikEkimIslem");
		return 1;
	}

	if(Karakter[playerid][Ciftlik] != -1)
	{
		if(floatround(GetVehicleSpeed2(GetPlayerVehicleID(playerid), 0)) > 15) 
		{
		Doluluk[playerid] += 5;
		SetPlayerProgressBarValue(playerid, ciftlikprog[playerid], Doluluk[playerid]);
		EkinYarat(playerid, cid);
		}
	}
	else
	{
		Sunucu(playerid, "Tarla s�n�rlar� d���na ��kt���n�z i�in ekim i�lemi kesildi.");
		new cc = GetPVarInt(playerid,"oncekiciftlik");
		CiftlikInfo[cc][cIslem] = false;
		Doluluk[playerid] = 0;
		HidePlayerProgressBar(playerid, ciftlikprog[playerid]);
		TextDrawHideForPlayer(playerid, ciftlik_0);
		TextDrawHideForPlayer(playerid, ciftlik_1);
		KillTimer(ciftlikUpdater[playerid]);
		SetPVarInt(playerid, "CiftlikEkimIslem", 0);
		DeletePVar(playerid, "CiftlikEkimIslem");
		DeletePVar(playerid, "oncekiciftlik");
	}
	return 1;
}

Vice:TarlaIsciKontrol(playerid, ciftlikid) 
{
	new query[90], Cache:VeriCek, sonuc = 0;
	mysql_format(conn, query, sizeof(query), "SELECT * FROM tarimiscileri WHERE oisim = '%e' AND ciftlikid = %i", Karakter[playerid][Isim], ciftlikid);
	VeriCek = mysql_query(conn, query);
	if(cache_num_rows())
	{
		sonuc++;
	}
	cache_delete(VeriCek);	
	return sonuc;
}

Vice:TarlaEkipmanKontrol(playerid, ekipman) 
{
	if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	{
		new gid = GetPlayerVehicleID(playerid);
		if(ekipman == 0)
		{
			if(GetVehicleModel(gid) == 531 && GetVehicleModel(GetVehicleTrailer(gid)) == 610) return true;
		}
		else if(ekipman == 1)
		{
			if(GetVehicleModel(gid) == 532) return true;	
		}
	}
	return false;		
}

Vice:EkinSayisiBul(ciftlikid)
{
	new query[100], sonuc,Cache:VeriGetir;

	mysql_format(conn, query, sizeof(query), "SELECT * FROM `ekinler` WHERE `ciftlikid` = %i", ciftlikid);
	VeriGetir = mysql_query(conn, query);
	sonuc = cache_num_rows();
	cache_delete(VeriGetir);
	return sonuc;
}

Vice:EkinYarat(playerid,ciftlikid) 
{
	new objeid, vehid = GetPlayerVehicleID(playerid), Float:x,Float:y,Float:z,Float:rx,Float:ry,Float:rz, query[275];
	GetVehiclePos(vehid, x, y, z);
	GetVehicleRotation(vehid, rx,ry,rz);
	objeid = CreateDynamicObject(3409, x, y, z-1.2, rx, ry, rz, 0, 0);
	mysql_format(conn, query, sizeof(query), "INSERT INTO ekinler (ciftlikid, objeid, x, y, z, rx, ry, rz) VALUES(%i, %i, %f, %f, %f, %f, %f, %f)", ciftlikid, objeid, x,y,z-1.2,rx,ry,rz);
	mysql_query(conn, query);
}

Vice:ArsaIkiNoktaArasiUzaklik(&Float:sonuc, Float:minx, Float:miny, Float:maxx, Float:maxy)
{ 
	new Float:karekok[2],Float:islem[4];
	islem[0] = floatsub(maxx,minx);
	islem[1] = floatsub(maxy,miny);
	karekok[0] = floatmul(islem[0], islem[0]);
	karekok[1] = floatmul(islem[1], islem[1]);
	islem[3] = abs(floatadd(karekok[0], karekok[1]));
	sonuc = floatsqroot(islem[3]);
}

Vice:AracEkinGoster(playerid, aracid)
{
	static rows;
	cache_get_row_count(rows);
	if(rows > 0)
	{
		new i = 0, baslik[40], subString[370], ekintur;
		cache_get_value_name_int(i, "ekintur", ekintur);
		while(i != rows && i < rows)
		{
			format(subString, sizeof(subString), "%s{C9C936}%s\n", subString, ekinlerveri[ekintur][ekinisim]);
			i++;
		}
		format(baslik, sizeof(baslik), "%s - Ekinler: {C9C936}%d/%d", GetVehicleNameByModel(Araclar[aracid][Model]), EkinKapasiteKontrol(Araclar[aracid][id]), faracveri[GetAracKapasiteIndex(Araclar[aracid][Model])][2]);
		Dialog_Show(playerid, DIALOG_ARAC_EKINLER, DIALOG_STYLE_LIST, baslik, subString, "Se�", "Iptal");
		SetPVarInt(playerid, "ekinaracid", aracid);
		format(subString, sizeof(subString), "%s", EOS);
	} 
	else 
	{
		Sunucu(playerid, "Bu ara�ta ekin bulunmuyor.");
	}
	return 1;
}

Dialog:DIALOG_ARAC_EKINLER(playerid, response, listitem, inputtext[])
{
	if(!response)
	{
		DeletePVar(playerid, "ekinaracid");
		return false;
	}
	new query[128], Cache:VeriCek, rows , aracid;
	aracid = GetPVarInt(playerid, "ekinaracid");
	mysql_format(conn, query, sizeof(query), "SELECT * FROM aracekinler WHERE id = %i", Araclar[aracid][id]);
	VeriCek = mysql_query(conn, query);
	rows = cache_num_rows();
	DeletePVar(playerid, "ekinaracid");
	if(rows)
	{
		new urun,sqlid, msg[95];
		for(new i = 0; i < rows; i++ ) 
		{
			if(i == listitem) 
			{
				cache_get_value_name_int(i, "ekintur", urun);
				cache_get_value_name_int(i, "SQLID", sqlid);
				cache_delete(VeriCek);
				Karakter[playerid][Ekin] = urun;
				ApplyAnimation(playerid, "CARRY", "liftup05", 4.1, 0, 1, 1, 0, 0, 1);
				SetPlayerAttachedObject(playerid, 6, 2901, 6, 0.116999, 0.076999, -0.251000, -3.499999, 76.900024, -20.800006);
				SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
				format(msg, sizeof(msg), "arac�n bagaj�ndan %s adl� ekini ��kar�r.", ekinlerveri[urun][ekinisim]);
				cmd(playerid, 1, msg);
				mysql_format(conn, query, sizeof(query), "DELETE FROM aracekinler WHERE SQLID = %i", sqlid);
				mysql_query(conn, query);
				break;
			}
		}
	}
	return true;
}

Vice:GetAracKapasiteIndex(model) 
{
	new index;
	switch(model) 
	{
		case 482: { index = 0; }
		case 498: { index = 1; }
		case 499: { index = 2; }
	}
	return index;
}

Vice:EkinKapasiteKontrol(aracid) 
{
	new query[128], Cache:VeriCek, rows = 0;
	mysql_format(conn, query, sizeof(query), "SELECT * FROM aracekinler WHERE id = %i", aracid);
	VeriCek = mysql_query(conn, query);
	if(cache_num_rows())
	{
		rows = cache_num_rows();
	}
	cache_delete(VeriCek);
	return rows;		
}