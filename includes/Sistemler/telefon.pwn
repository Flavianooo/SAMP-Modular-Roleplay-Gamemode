CMD:telefon(playerid, params[])
{
	if(Karakter[playerid][Telefon] == 0) return Sunucu(playerid, "Telefonunuz bulunmuyor.");
	if(Karakter[playerid][Yarali] == 1) return Sunucu(playerid, "Yaralýyken telefon kullanamazsýnýz.");
	
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
	if(Karakter[playerid][Yarali] == 1) return Sunucu(playerid, "Yaralýyken telefon kullanamazsýnýz.");
	if(Karakter[playerid][TelefonNumarasi] == 0) return Sunucu(playerid, "Arama yapmak için öncelikle bir sim kart satýn almalýsýnýz.");
	if(Karakter[playerid][Arama] != -1) return Sunucu(playerid, "Þu anda zaten bir çaðrýdasýnýz.");
	new telno;
	if(sscanf(params, "d", telno)) return Kullanim(playerid, "/ara [telefon numarasý]");
	if(telno < 1) return Sunucu(playerid, "Geçersiz telefon numarasý girdiniz.");
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
	if(gecerlilik == 0) return Sunucu(playerid, "Aradýðýnýz telefon numarasýna þu anda ulaþýlamýyor.");
	if(Karakter[oyuncu][Arama] != -1) return Sunucu(playerid, "Hat meþgul.");
	Karakter[playerid][Arama] = oyuncu;
	Karakter[oyuncu][Arama] = playerid;
	Karakter[oyuncu][Araniyor] = 1;
	Sunucu(oyuncu, "Telefonunuz çalýyor. Arayan numara: %d | Yanýtlamak için /cevapla, reddetmek için /tkapat.", Karakter[playerid][TelefonNumarasi]);
	Sunucu(playerid, "%d numaralý telefonu çaldýrýyorsunuz. Ýptal etmek için /tkapat kullanýn.", telno);
	SetPlayerSpecialAction(playerid, SPECIAL_ACTION_USECELLPHONE);
	SetPlayerAttachedObject(playerid, 7, 18868, 6, 0.086043, 0.027719, 0.003817, 95.232246, 178.651031, 1.691840, 1.002077, 1.000000, 1.000000);
	return true;
}

CMD:cevapla(playerid, params[])
{
	if(Karakter[playerid][Arama] == -1 || Karakter[playerid][Araniyor] == 0) return Sunucu(playerid, "Þu anda bir arama almýyorsunuz.");
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
	Sunucu(playerid, "Çaðrýyý yanýtladýnýz, konuþmaya baþlayabilirsiniz.");
	Sunucu(arayan, "Çaðrýnýz yanýtlandý, konuþmaya baþlayabilirsiniz.");
	SetPlayerSpecialAction(playerid, SPECIAL_ACTION_USECELLPHONE);
	SetPlayerAttachedObject(playerid, 7, 18868, 6, 0.086043, 0.027719, 0.003817, 95.232246, 178.651031, 1.691840, 1.002077, 1.000000, 1.000000);
	return true;
}

CMD:tkapat(playerid, params[])
{
	if(Karakter[playerid][Araniyor] == 0 && Karakter[playerid][Aramada] == 0 && Karakter[playerid][Arama] == -1) return Sunucu(playerid, "Bir çaðrýya dahil deðilsin.");
	if(Karakter[playerid][Arama] != -1)
	{
		new arayan = Karakter[playerid][Arama];
		Karakter[playerid][Arama] = -1;
		Karakter[arayan][Arama] = -1;
		Karakter[arayan][Aramada] = 0;
		Karakter[arayan][Araniyor] = 0;
		Sunucu(arayan, "Çaðrý sonlandýrýldý.");
		RemovePlayerAttachedObject(arayan, 7);
		SetPlayerSpecialAction(arayan, SPECIAL_ACTION_NONE);
	}
	Karakter[playerid][Araniyor] = 0;
	Karakter[playerid][Aramada] = 0;
	Sunucu(playerid, "Çaðrý sonlandýrýldý.");
	RemovePlayerAttachedObject(playerid, 7);
	SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
	return true;
}