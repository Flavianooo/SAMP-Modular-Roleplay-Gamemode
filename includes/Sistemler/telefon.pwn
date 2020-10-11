CMD:telefon(playerid, params[])
{
	if(Karakter[playerid][Telefon] == 0) return Sunucu(playerid, "Telefonunuz bulunmuyor.");
	if(Karakter[playerid][Yarali] == 1) return Sunucu(playerid, "Yaral�yken telefon kullanamazs�n�z.");
	
	return true;
}

CMD:imlec(playerid, params[])
{
	SelectTextDraw(playerid, 0xFF0000FF);
	return true;
}

CMD:ara(playerid, params[])
{
	if(Karakter[playerid][Telefon] == 0) return Sunucu(playerid, "Telefonunuz bulunmuyor.");
	if(Karakter[playerid][Yarali] == 1) return Sunucu(playerid, "Yaral�yken telefon kullanamazs�n�z.");
	if(Karakter[playerid][TelefonNumarasi] == 0) return Sunucu(playerid, "Arama yapmak i�in �ncelikle bir sim kart sat�n almal�s�n�z.");
	if(Karakter[playerid][Arama] != -1) return Sunucu(playerid, "�u anda zaten bir �a�r�das�n�z.");
	new telno;
	if(sscanf(params, "d", telno)) return Kullanim(playerid, "/ara [telefon numaras�]");
	if(telno < 1) return Sunucu(playerid, "Ge�ersiz telefon numaras� girdiniz.");
	new gecerlilik = 0, oyuncu;
	foreach(new i : Player)
	{
		if(Karakter[i][TelefonNumarasi] == telno && Karakter[i][Telefon] == 1)
		{
			gecerlilik++;
			oyuncu = i;
			break;
		}
	}
	if(gecerlilik == 0) return Sunucu(playerid, "Arad���n�z telefon numaras�na �u anda ula��lam�yor.");
	if(Karakter[oyuncu][Arama] != -1) return Sunucu(playerid, "Hat me�gul.");
	Karakter[playerid][Arama] = oyuncu;
	Karakter[oyuncu][Arama] = playerid;
	Karakter[oyuncu][Araniyor] = 1;
	Sunucu(oyuncu, "Telefonunuz �al�yor. Arayan numara: %d | Yan�tlamak i�in /cevapla, reddetmek i�in /tkapat.", Karakter[playerid][TelefonNumarasi]);
	Sunucu(playerid, "%d numaral� telefonu �ald�r�yorsunuz. �ptal etmek i�in /tkapat kullan�n.", telno);
	SetPlayerSpecialAction(playerid, SPECIAL_ACTION_USECELLPHONE);
	SetPlayerAttachedObject(playerid, 7, 18868, 6, 0.086043, 0.027719, 0.003817, 95.232246, 178.651031, 1.691840, 1.002077, 1.000000, 1.000000);
	return true;
}

CMD:cevapla(playerid, params[])
{
	if(Karakter[playerid][Arama] == -1 || Karakter[playerid][Araniyor] == 0) return Sunucu(playerid, "�u anda bir arama alm�yorsunuz.");
	new arayan = Karakter[playerid][Arama];
	if(!IsPlayerConnected(arayan) || !Karakter[arayan][Giris])
	{
		Sunucu(playerid, "Hat kesildi.");
		Karakter[playerid][Araniyor] = 0; 
		Karakter[playerid][Arama] = -1;
		Karakter[arayan][Arama] = -1;
		return true;
	}
	Karakter[playerid][Araniyor] = 0;
	Karakter[playerid][Aramada] = 1;
	Karakter[arayan][Aramada] = 1;
	Sunucu(playerid, "�a�r�y� yan�tlad�n�z, konu�maya ba�layabilirsiniz.");
	Sunucu(arayan, "�a�r�n�z yan�tland�, konu�maya ba�layabilirsiniz.");
	SetPlayerSpecialAction(playerid, SPECIAL_ACTION_USECELLPHONE);
	SetPlayerAttachedObject(playerid, 7, 18868, 6, 0.086043, 0.027719, 0.003817, 95.232246, 178.651031, 1.691840, 1.002077, 1.000000, 1.000000);
	return true;
}

CMD:tkapat(playerid, params[])
{
	if(Karakter[playerid][Araniyor] == 0 && Karakter[playerid][Aramada] == 0 && Karakter[playerid][Arama] == -1) return Sunucu(playerid, "Bir �a�r�ya dahil de�ilsin.");
	if(Karakter[playerid][Arama] != -1)
	{
		new arayan = Karakter[playerid][Arama];
		Karakter[playerid][Arama] = -1;
		Karakter[arayan][Arama] = -1;
		Karakter[arayan][Aramada] = 0;
		Karakter[arayan][Araniyor] = 0;
		Sunucu(arayan, "�a�r� sonland�r�ld�.");
		RemovePlayerAttachedObject(arayan, 7);
		SetPlayerSpecialAction(arayan, SPECIAL_ACTION_NONE);
	}
	Karakter[playerid][Araniyor] = 0;
	Karakter[playerid][Aramada] = 0;
	Sunucu(playerid, "�a�r� sonland�r�ld�.");
	RemovePlayerAttachedObject(playerid, 7);
	SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
	return true;
}