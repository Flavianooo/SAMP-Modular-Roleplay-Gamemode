CMD:yardim(playerid, params[])
{
	if(!Karakter[playerid][Giris]) return GirisYapmadi(playerid);

	GenelMesajGonder(playerid, "--------------------------------------------------------------");
	GenelMesajGonder(playerid, "{E2E2E2}/karakter, /me, /do, /ame, /ado, /l, /w, /s, /pm, /pmdurum, /paraver, /maaskalan");
	GenelMesajGonder(playerid, "{E2E2E2}/admins, /supports, /rapor, /sorusor, /soruiptal, /yetenekler");
	GenelMesajGonder(playerid, "{E2E2E2}/balikyardim");
	GenelMesajGonder(playerid, "--------------------------------------------------------------");
	return true;
}

CMD:karakter(playerid, params[])
{
	if(!Karakter[playerid][Giris]) return GirisYapmadi(playerid);

	KarakterGoster(playerid, playerid);
	return true;
}

CMD:me(playerid, params[])
{
	if(!Karakter[playerid][Giris]) return GirisYapmadi(playerid);

	if(isnull(params)) return Kullanim(playerid, "/me [emote]");

	if(strlen(params) > 84)
	{
		SendNearbyMessage(playerid, 20.0, RENK_MOR, "* %s %.84s", RPIsim(playerid), params);
		SendNearbyMessage(playerid, 20.0, RENK_MOR, "* ... %s", params[84]);
	}
	else
	{
		SendNearbyMessage(playerid, 20.0, RENK_MOR, "* %s %s", RPIsim(playerid), params);
	}
	return true;
}

CMD:do(playerid, params[])
{
	if(!Karakter[playerid][Giris]) return GirisYapmadi(playerid);

	if(isnull(params)) return Kullanim(playerid, "/do [emote]");

	if(strlen(params) > 84)
	{
		SendNearbyMessage(playerid, 20.0, 0x80CAADFF, "* %.84s", params);
		SendNearbyMessage(playerid, 20.0, 0x80CAADFF, "* ... %s (( %s ))", params[84], RPIsim(playerid));
	}
	else
	{
		SendNearbyMessage(playerid, 20.0, 0x80CAADFF, "* %s (( %s ))", params, RPIsim(playerid));
	}
	return true;
}

CMD:ame(playerid, params[])
{
	if(!Karakter[playerid][Giris]) return GirisYapmadi(playerid);

	if(isnull(params)) return Kullanim(playerid, "/ame [emote]");

	new str[128];
	format(str, sizeof(str), "* %s %s", RPIsim(playerid), params);
	SetPlayerChatBubble(playerid, str, RENK_MOR, 20.0, 5000);
	SendClientMessage(playerid, RENK_MOR, str);
	return true;
}

CMD:ado(playerid, params[])
{
	if(!Karakter[playerid][Giris]) return GirisYapmadi(playerid);

	if(isnull(params)) return Kullanim(playerid, "/ado [emote]");

	new str[128];
	format(str, sizeof(str), "* %s (( %s ))", params, RPIsim(playerid));
	SetPlayerChatBubble(playerid, str, RENK_MOR, 20.0, 5000);
	SendClientMessage(playerid, RENK_MOR, str);
	return true;
}

CMD:fisilda(playerid, params[])
{
	if(!Karakter[playerid][Giris]) return GirisYapmadi(playerid);

	new mesaj[256], hedefid;
	if(sscanf(params, "us[256]", hedefid, mesaj)) return Kullanim(playerid, "/fisilda [id/isim] [metin]");
	if(hedefid == playerid) return Sunucu(playerid, "Kendinize f�s�ldayamazs�n�z.");
	if(!IsPlayerConnected(hedefid)) return Sunucu(playerid, "Bu ki�i giri� yapmam��.");
	if(!Karakter[hedefid][Giris]) return Sunucu(playerid, "Bu ki�i giri� yapmam��.");
	if(!IsPlayerNearPlayer(playerid, hedefid, 3.0)) return Sunucu(playerid, "Bu ki�i yak�n�n�zda de�il.");

	SendClientMessageEx(hedefid, RENK_SARI, ">> %s (f�s�ld�yor): %s", RPIsim(playerid), mesaj);
	SendClientMessageEx(playerid, RENK_SARI, "<< %s (f�s�ld�yor): %s", RPIsim(hedefid), mesaj);

	SendNearbyMessage(playerid, 20.0, RENK_MOR, "* %s, %s adl� ki�iye f�s�ldar.", RPIsim(playerid), RPIsim(hedefid));
	return true;
}
alias:fisilda("w");

CMD:kisikses(playerid, params[])
{
	if(!Karakter[playerid][Giris]) return GirisYapmadi(playerid);

	if(isnull(params)) return Kullanim(playerid, "/kisikses [metin]");

	if(strlen(params) > 84)
	{
		SendNearbyMessage(playerid, 5.0, RENK_KARA3, "%s (k�s�k ses): %84.s", RPIsim(playerid), params);
		SendNearbyMessage(playerid, 5.0, RENK_KARA3, "%s (k�s�k ses): ... %s", RPIsim(playerid), params[84]);
	}
	else
	{
		SendNearbyMessage(playerid, 5.0, RENK_KARA3, "%s (k�s�k ses): %s", RPIsim(playerid), params);
	}
	return true;
}
alias:kisikses("l", "c");

CMD:bagir(playerid, params[])
{
	if(!Karakter[playerid][Giris]) return GirisYapmadi(playerid);

	if(isnull(params)) return Kullanim(playerid, "/bagir [metin]");

	if(strlen(params) > 84)
	{
		SendNearbyMessage(playerid, 30.0, -1, "%s (ba��r�r): %.84s", RPIsim(playerid), params);
		SendNearbyMessage(playerid, 30.0, -1, "%s (ba��r�r): ... %s", RPIsim(playerid), params[84]);
	}
	else
	{
		SendNearbyMessage(playerid, 30.0, -1, "%s (ba��r�r): %s", RPIsim(playerid), params);
	}
	return true;
}
alias:bagir("s");

CMD:b(playerid, params[])
{
	if(!Karakter[playerid][Giris]) return GirisYapmadi(playerid);

	if(isnull(params)) return Kullanim(playerid, "/b [metin]");

	new str[128];
	if(!Hesap[playerid][Yonetici])
	{
		if(strlen(params) > 84)
		{
			format(str, sizeof(str), "(( [OOC] %s[%d]: %.84s ))", RPIsim(playerid), playerid, params);
		    LocalChat(playerid, 20.0, str, RENK_KARA1, RENK_KARA2, RENK_KARA3, RENK_KARA4);

   			format(str, sizeof(str), "(( [OOC] %s[%d]: ... %s ))", RPIsim(playerid), playerid, params[84]);
		    LocalChat(playerid, 20.0, str, RENK_KARA1, RENK_KARA2, RENK_KARA3, RENK_KARA4);
		}
		else
		{
			format(str, sizeof(str), "(( [OOC] %s[%d]: %.84s ))", RPIsim(playerid), playerid, params);
		    LocalChat(playerid, 20.0, str, RENK_KARA1, RENK_KARA2, RENK_KARA3, RENK_KARA4);
		}
	}
	else
	{
		if(strlen(params) > 84)
		{
			SendNearbyMessage(playerid, 20.0, -1, "(( [OOC] {DAD9DD}%s{FFFFFF}[%d]: %.84s ))", RPIsim(playerid), playerid, params);
			SendNearbyMessage(playerid, 20.0, -1, "(( [OOC] {DAD9DD}%s{FFFFFF}[%d]: ... %s ))", RPIsim(playerid), playerid, params[84]);
		}
		else
		{
			SendNearbyMessage(playerid, 20.0, -1, "(( [OOC] {DAD9DD}%s{FFFFFF} [%d]: %s ))", RPIsim(playerid), playerid, params);
		}
	}
	return true;
}

CMD:pm(playerid, params[])
{
	if(!Karakter[playerid][Giris]) return GirisYapmadi(playerid);

	new hedefid, mesaj[128];
	if(sscanf(params, "us[128]", hedefid, mesaj)) return Kullanim(playerid, "/pm [id/isim] [mesaj]");
	if(Hesap[playerid][PMDurum] == true) return Sunucu(playerid, "�zel mesaj kanal�n�z kapal�.");
	if(!IsPlayerConnected(hedefid)) return Sunucu(playerid, "Bu ki�i giri� yapmam��.");
	if(!Karakter[hedefid][Giris]) return Sunucu(playerid, "Bu ki�i giri� yapmam��.");
	if(hedefid == playerid) return Sunucu(playerid, "Kendinize mesaj g�nderemezsiniz.");
	if(Hesap[hedefid][PMDurum] == true) return Sunucu(playerid, "Bu ki�inin �zel mesaj kanal� kapal�.");

	SendClientMessageEx(hedefid, RENK_SARI, "<< %s (%d): %s", RPIsim(playerid), playerid, mesaj);
	SendClientMessageEx(playerid, RENK_PM, ">> %s (%d): %s", RPIsim(hedefid), hedefid, mesaj);
	Log_Kaydet("loglar/pm_loglari.txt", "[%s] %s, %s adli kisiye pm atti. Mesaj: %s", TarihCek(), RPIsim(playerid), RPIsim(hedefid), mesaj);
	return true;
}

CMD:pmdurum(playerid, params[])
{
	if(!Karakter[playerid][Giris]) return GirisYapmadi(playerid);

	switch(Hesap[playerid][PMDurum])
	{
		case false:
		{
			Hesap[playerid][PMDurum] = true;
			Sunucu(playerid, "�zel mesaj kanal�n� kapatt�n�z.");
		}
		case true:
		{
			Hesap[playerid][PMDurum] = false;
			Sunucu(playerid, "�zel mesaj kanal�n� a�t�n�z.");
		}
	}
	return true;
}

CMD:paraver(playerid, params[])
{
	if(!Karakter[playerid][Giris]) return GirisYapmadi(playerid);

	new hedefid, miktar;
	if(sscanf(params, "ud", hedefid, miktar)) return Kullanim(playerid, "/paraver [id/isim] [miktar]");
	if(!Karakter[hedefid][Giris]) return Sunucu(playerid, "Bu ki�i giri� yapmam��.");
	if(!IsPlayerNearPlayer(playerid, hedefid, 3.0)) return Sunucu(playerid, "Bu ki�i yak�n�n�zda de�il.");
	if(miktar > Karakter[playerid][Para]) return YetersizPara(playerid);
	if(miktar <= 0) return Sunucu(playerid, "En d���k $1 verebilirsiniz.");

	ParaVer(playerid, -miktar);
	ParaVer(hedefid, miktar);
	Log_Kaydet("loglar/paraver_loglari.txt", "[%s] %s adli kisi %s adli kisiye %s verdi.", TarihCek(), RPIsim(playerid), RPIsim(hedefid), NumaraFormati(miktar));
	SendNearbyMessage(playerid, 20.0, RENK_MOR, "* %s, bir miktar para ��kart�p %s adl� ki�iye verir.", RPIsim(playerid), RPIsim(hedefid));
	return true;
}

CMD:admins(playerid, params[])
{
	if(!Karakter[playerid][Giris]) return GirisYapmadi(playerid);
	SendClientMessage(playerid, RENK_KARA4, "Aktif Yetkililer:");
	foreach(new i: Player)
	{
		if(Hesap[i][Yonetici] > 1)
		{
			if(Hesap[i][Awork] == true)
			{
				SendClientMessageEx(playerid, RENK_KOYUYESIL, "%s %s(%s) - Awork: Evet", YetkiIsim(i), RPIsim(i), Hesap[i][YoneticiIsim]);
			}
			else
			{
				SendClientMessageEx(playerid, RENK_KOYUYESIL, "%s %s(%s) - Awork: {C8C8C8}Hay�r", YetkiIsim(i), RPIsim(i), Hesap[i][YoneticiIsim]);
			}
		}
	}
	return true;
}

CMD:support(playerid, params[])
{
	if(!Karakter[playerid][Giris]) return GirisYapmadi(playerid);

	SendClientMessage(playerid, RENK_KARA4, "Aktif Support:");
	foreach(new i: Player)
	{
		if(Hesap[i][Yonetici] == 1)
		{
			if(Hesap[i][Swork] == true)
			{
				SendClientMessageEx(playerid, RENK_VICE, "%s - M�sait: {FFFFFF}Evet", RPIsim(i));
			}
			else
			{
				SendClientMessageEx(playerid, RENK_VICE, "%s - M�sait: {FF6347}Hay�r", RPIsim(i));
			}
		}
	}
	return true;
}

CMD:kilit(playerid, params[])
{
	if(EvYakin(playerid) != -1)
	{
		new evid = EvYakin(playerid);
		if(!EvSahipKontrol(playerid, evid) && Karakter[playerid][KiralananEv] != Evler[evid][id] && Karakter[playerid][EvAnahtar] != Evler[evid][id]) return Sunucu(playerid, "Bu evin sahibi veya kirac�s� de�ilsin.");
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
	else if(IsyeriYakin(playerid) != -1)
	{
		new isyeriid = IsyeriYakin(playerid);
		if(!IsyeriSahipKontrol(playerid, isyeriid) && Karakter[playerid][IsyeriOrtak] != Isyeri[isyeriid][id] && Karakter[playerid][IsyeriAnahtar] != Isyeri[isyeriid][id])
			return Sunucu(playerid, "Bu i�yerinin kilit yetkisine sahip de�ilsin.");
		switch(Isyeri[isyeriid][Durum])
		{
			case 0:
			{
				Isyeri[isyeriid][Durum] = 1;
				Sunucu(playerid, "��yerinin kap�s�n� kilitlediniz.");
				IsyeriTextYenile(isyeriid);
			}
			case 1:
			{
				Isyeri[isyeriid][Durum] = 0;
				Sunucu(playerid, "��yerinin kap�s�n�n kilidini a�t�n�z.");
				IsyeriTextYenile(isyeriid);
			}
			default:
			{
				Sunucu(playerid, "Bu i�yerinin kap�s�na m�dahale edemezsiniz.");
			}
		}
	}
	else Sunucu(playerid, "Kilidi kontrol edilebilecek bir yerin yak�n�nda de�ilsin.");
	return true;
}

CMD:sigara(playerid, params[])
{
	if(Karakter[playerid][Sigara] < 1) return Sunucu(playerid, "Sigaran�z bulunmuyor.");
	SetPlayerSpecialAction(playerid, SPECIAL_ACTION_SMOKE_CIGGY);
	cmd(playerid, 1, "sigara paketinden bir dal ��kart�p �akma��yla ate�ler.");
	Sunucu(playerid, "N tu�una basarak sigaray� atabilirsin.");	
	Karakter[playerid][Sigara]--; 
	return true;
}

CMD:lisansgoster(playerid, params[])
{
	new oyuncu;
	if(sscanf(params, "u", oyuncu)) return Kullanim(playerid, "/lisansgoster [id/isim]");
	if(!IsPlayerConnected(oyuncu)) return Sunucu(playerid, "Ge�ersiz oyuncu.");
	if(!Karakter[oyuncu][Giris]) return Sunucu(playerid, "Oyuncu hen�z giri� yapmam��.");
	if(!OyuncuYakin(playerid, oyuncu, 5.0)) return Sunucu(playerid, "Ki�iye yeterince yak�n de�ilsin.");
	new ehliyetdurum[6];
	switch(Karakter[playerid][Ehliyet])
	{
		case 0: ehliyetdurum = "Yok";
		default: ehliyetdurum = "Var";
	}
	SunucuEx(oyuncu, "-----[%s size lisanslar�n� g�steriyor]-----", RPIsim(playerid));
	SunucuEx(oyuncu, "Ehliyet: {99C794}%s", ehliyetdurum);
	new mestr[96];
	format(mestr, sizeof(mestr), "lisanslar�n� ��kart�p %s adl� ki�iye g�sterir.", RPIsim(oyuncu));
	cmd(playerid, 1, mestr);
	return true;
}