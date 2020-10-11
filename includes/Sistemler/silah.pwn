public OnPlayerWeaponShot(playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ)
{
	new slot;
	for(new i = 0; i < MAX_OYUNCU_SILAH; i++)
	{
		if(Karakter[playerid][Silah][i] == weaponid)
		{
			slot = i;
			break;
		}
	}
	Karakter[playerid][Mermi][slot]--;
	if(Karakter[playerid][Mermi][slot] < 1)
	{
		Karakter[playerid][Mermi][slot] = 0;
		SilahSil(playerid, Karakter[playerid][Silah][slot]);
		Sunucu(playerid, "Silahýnýzýn mermisi bitti.");
		new query[144];
		mysql_format(conn, query, sizeof(query), "UPDATE silahlar SET SilahMermi = 0 WHERE SilahSeri = %i", Karakter[playerid][SilahSeri][slot]);
		mysql_tquery(conn, query);
	}
	return true;
}

// YÖNETÝCÝ KOMUTLARI

CMD:asilahver(playerid, params[])
{
	if(Hesap[playerid][Yonetici] < 5) return YetersizYetki(playerid);
	new oyuncu, silah, mermi;
	if(sscanf(params, "udI(100)", oyuncu, silah, mermi)) return Sunucu(playerid, "/asilahver [id/isim]");
	if(!IsPlayerConnected(oyuncu) || !Karakter[oyuncu][Giris]) return Sunucu(playerid, "Geçersiz oyuncu.");
	new Cache:VeriCek, rows, query[144];
	mysql_format(conn, query, sizeof(query), "SELECT * FROM silahlar WHERE Sahip = %i", Karakter[playerid][id]);
	VeriCek = mysql_query(conn, query);
	cache_get_row_count(rows);
	cache_delete(VeriCek);
	if(rows >= 15) return Sunucu(playerid, "Bu kiþi sahip olabileceði silah sýnýrýna ulaþmýþ.");
	if(!SilahSlotKontrol(oyuncu, silah)) return Sunucu(playerid, "Bu kiþi zaten bu türde bir silah taþýyor. Öncelikle onu býrakmalý.");
	SilahVer(oyuncu, silah, mermi);
	Sunucu(playerid, "%s adlý kiþiye %s model silahý %d mermiyle verdin.", RPIsim(oyuncu), SilahIsim(silah), mermi);
	return true;
}

CMD:silahbirak(playerid, params[])
{
	new silahserisi;
	if(sscanf(params, "d", silahserisi)) return Kullanim(playerid, "/silahbirak [seri numarasý]");
	new silahmodel, silahslot, query[144];
	for(new i = 0; i < MAX_OYUNCU_SILAH; i++)
	{
		if(Karakter[playerid][SilahSeri][i] == silahserisi)
		{
			silahmodel = Karakter[playerid][Silah][i];
			silahslot = i;
		}
	}
	if(IsPlayerInAnyVehicle(playerid))
	{
		new aracid = GetPlayerVehicleID(playerid);
		if(!AracSahipKontrol(playerid, aracid)) return Sunucu(playerid, "Silah býrakabilmek için aracýn sahibi olmalýsýnýz.");
		new aracslot = -1;
		for(new i = 0; i < MAX_OYUNCU_SILAH; i++)
		{
			if(Araclar[aracid][AracSilah][i] == 0)
			{
				aracslot = i;
			}
		}
		if(aracslot == -1) return Sunucu(playerid, "Bu araca daha fazla silah býrakýlamaz.");
		SilahSil(playerid, silahmodel);
		Karakter[playerid][Silah][silahslot] = 0;
		Karakter[playerid][Mermi][silahslot] = 0,
		Karakter[playerid][SilahSeri][silahslot] = 0;

		Araclar[aracid][AracSilah][aracslot] = Karakter[playerid][Silah][silahslot];
		Araclar[aracid][AracSilahMermi][aracslot] = Karakter[playerid][Mermi][silahslot];
		Araclar[aracid][AracSilahSeri][aracslot] = Karakter[playerid][SilahSeri][silahslot];
		mysql_format(conn, query, sizeof(query), "UPDATE silahlar SET SilahDurum = %i, SilahArac = %i WHERE SilahSeri = %i", SILAH_ARACTA, Araclar[aracid][id], silahserisi);
		mysql_tquery(conn, query);
		Sunucu(playerid, "%s model silahý %s(%d) model aracýnýza býraktýnýz.", SilahIsim(silahmodel), AracModelCek(aracid), aracid);
		Sunucu(playerid, "Silahý geri almak için '/silahtut' komutunu kullanabilirsiniz.");
	}
	else
	{
		/*if(EvIcinde(playerid) != -1)
		{
			new evid = EvIcinde(playerid);
		}
		else if(IsyeriIcinde(playerid) != -1)
		{
			new isyeriid = IsyeriIcinde(playerid);
		}
		else */
		Sunucu(playerid, "Buraya silah býrakamazsýnýz.");
	}
	return true;
}

// OYUNCU KOMUTLARI

CMD:silahliste(playerid, params[])
{
	new Cache:VeriCek, query[144], rows, count = 0;
	mysql_format(conn, query, sizeof(query), "SELECT * FROM silahlar WHERE Sahip = %i", Karakter[playerid][id]);
	VeriCek = mysql_query(conn, query);
	cache_get_row_count(rows);
	if(rows)
	{
		new serino, silahmodel, silahmermi, silahdurum;
		for(new i = 0; i < 15 && i < rows; i++)
		{
			cache_get_value_name_int(i, "SilahSeri", serino);
			cache_get_value_name_int(i, "SilahModel", silahmodel);
			cache_get_value_name_int(i, "SilahMermi", silahmermi);
			cache_get_value_name_int(i, "SilahDurum", silahdurum);
			SunucuEx(playerid, "Silah: %s | Mermi: %d | Seri Numarasý: %d | Durum: %s", SilahIsim(silahmodel), silahmermi, serino, SilahDurumu(silahdurum));
		}
		count++;
	}
	cache_delete(VeriCek);
	if(count == 0) return Sunucu(playerid, "Bir silaha sahip deðilsiniz.");
	return true;
}

CMD:silahver(playerid, params[])
{
	new oyuncu, serino;
	if(sscanf(params, "ud", oyuncu, serino)) return Sunucu(playerid, "/silahver [id/isim] [silah seri numarasý]");
	if(!IsPlayerConnected(oyuncu) || !Karakter[oyuncu][Giris]) return Sunucu(playerid, "Geçersiz oyuncu.");
	if(!OyuncuYakin(playerid, oyuncu, 5.0)) return Sunucu(playerid, "Kiþiye yakýn deðilsin.");
	new slot = -1, silah;
	for(new i = 0; i < MAX_OYUNCU_SILAH; i++)
	{
		if(Karakter[playerid][SilahSeri][i] == serino)
		{
			slot = i;
			silah = Karakter[playerid][Silah][i];
			break;
		}
	}
	if(slot == -1) return Sunucu(playerid, "Bu seri numarasýna sahip olan bir silahýnýz bulunmuyor.");
	new Cache:VeriCek, rows, query[144];
	mysql_format(conn, query, sizeof(query), "SELECT * FROM silahlar WHERE Sahip = %i", Karakter[oyuncu][id]);
	VeriCek = mysql_query(conn, query);
	cache_get_row_count(rows);
	cache_delete(VeriCek);
	if(rows >= 15) return Sunucu(playerid, "Bu kiþi sahip olabileceði silah sýnýrýna ulaþmýþ.");
	if(SilahSlotKontrol(oyuncu, silah)) return Sunucu(playerid, "Bu kiþi zaten bu türde bir silah taþýyor. Öncelikle onu býrakmalý.");
	new karsislot = -1;
	for(new i = 0; i < MAX_OYUNCU_SILAH; i++)
	{
		if(Karakter[playerid][Silah][i] != 0) continue;
		karsislot = i;
		break;
	}
	if(karsislot == -1) return Sunucu(playerid, "Bu kiþi sahip olabileceði silah sýnýrýna ulaþmýþ.");
	new silahid = Karakter[playerid][Silah][slot], mermisayi = Karakter[playerid][Mermi][slot];
	SilahSil(playerid, silahid);
	Karakter[playerid][SilahSeri][slot] = 0;
	Karakter[playerid][Silah][slot] = 0;
	Karakter[playerid][Mermi][slot] = 0;

	Karakter[oyuncu][Silah][karsislot] = silahid;
	Karakter[oyuncu][Mermi][karsislot] = mermisayi;
	Karakter[oyuncu][SilahSeri][karsislot] = serino;
	GivePlayerWeapon(oyuncu, silahid, mermisayi);
	Sunucu(playerid, "%d seri numaralý %s model silahýný %s adlý kiþiye verdin.", serino, SilahIsim(silahid), RPIsim(oyuncu));
	Sunucu(oyuncu, "%s adlý kiþi sana %d seri numaralý %s model silahýný verdi.", RPIsim(playerid), serino, SilahIsim(silahid));
	return true;
}

// FONKSÝYONLAR

Vice:SilahVeriYukle(playerid)
{
	ResetPlayerWeapons(playerid);
	for(new i = 0; i < MAX_OYUNCU_SILAH; i++)
	{
		Karakter[playerid][Silah][i] = 0;
		Karakter[playerid][Mermi][i] = 0;
		Karakter[playerid][SilahSeri][i] = 0;
	}
	new rows;
	cache_get_row_count(rows);
	if(rows)
	{
		for(new i = 0; i < 15 && i < rows; i++)
		{
			cache_get_value_name_int(i, "SilahSeri", Karakter[playerid][SilahSeri][i]);
			cache_get_value_name_int(i, "SilahModel", Karakter[playerid][Silah][i]);
			cache_get_value_name_int(i, "SilahMermi", Karakter[playerid][Mermi][i]);
			GivePlayerWeapon(playerid, Karakter[playerid][Silah][i], Karakter[playerid][Mermi][i]);
		}
	}
	return true;
}

Vice:SilahVer(playerid, silah, mermi)
{
	new query[144], slot = -1;
	for(new i = 0; i < MAX_OYUNCU_SILAH; i++)
	{
		if(Karakter[playerid][Silah][i] != 0) continue;
		slot = i;
		break;
	}
	if(slot == -1) return false;
	Karakter[playerid][Silah][slot] = silah;
	Karakter[playerid][Mermi][slot] = mermi;
	GivePlayerWeapon(playerid, silah, mermi);
	mysql_format(conn, query, sizeof(query), "INSERT INTO silahlar (Sahip, SilahModel, SilahMermi, SilahDurum) VALUES(%i, %i, %i, %i)", Karakter[playerid][id], silah, mermi, SILAH_USTUNDE);
	mysql_tquery(conn, query, "SilahYaratildi", "ii", playerid, slot);
	return true;
}

Vice:SilahYaratildi(playerid, slot)
{
	new query[128], serino = cache_insert_id()+1000;
	Karakter[playerid][SilahSeri][slot] = serino;
	mysql_format(conn, query, sizeof(query), "UPDATE silahlar SET SilahSeri = %i WHERE SilahID = %i", serino, cache_insert_id());
	mysql_query(conn, query);
}

stock SilahIsim(silahid)
{
	new silahisim[32];
	GetWeaponName(silahid, silahisim, sizeof(silahisim));
	if(!silahid) silahisim = "Yok";
	else if(silahid == 18) silahisim = "Molotov Cocktail";
	else if(silahid == 44) silahisim = "Nightvision";
	else if(silahid == 45) silahisim = "Infrared";
	return silahisim;
}

stock SilahDurumu(durum)
{
	new durumstr[24];
	switch(durum)
	{
		case 0: durumstr = "Üstünde";
		case 1: durumstr = "Araçta";
		default: durumstr = "Bilinmiyor";
	}
	return durumstr;
}

Vice:SilahSlotKontrol(playerid, silahid)
{
	new durum = 1;
	for(new i = 0; i < MAX_OYUNCU_SILAH; i++)
	{
		if(SilahSlotu(silahid) == SilahSlotu(Karakter[playerid][Silah][i]))
		{
			durum = 0;
		}
	}
	return durum;
}

Vice:SilahSlotu(silahid)
{
new slot;
switch(silahid)
{
case 0,1: slot = 0;
case 2 .. 9: slot = 1;
case 10 .. 15: slot = 10;
case 16 .. 18, 39: slot = 8;
case 22 .. 24: slot =2;
case 25 .. 27: slot = 3;
case 28, 29, 32: slot = 4;
case 30, 31: slot = 5;
case 33, 34: slot = 6;
case 35 .. 38: slot = 7;
case 40: slot = 12;
case 41 .. 43: slot = 9;
case 44 .. 46: slot = 11;
}
return slot;
}

Vice:SilahSil(playerid, silahid)
{
	new silahkoru[13], mermikoru[13];
	for(new i = 0; i < 13; i++)
	{
		GetPlayerWeaponData(playerid, i, silahkoru[i], mermikoru[i]);
	}
	ResetPlayerWeapons(playerid);
	for(new i = 0; i < 13; i++)
	{
		if(silahkoru[i] == silahid || mermikoru[i] == 0) continue;
		GivePlayerWeapon(playerid, silahkoru[i], mermikoru[i]);
	}
	return true;
}