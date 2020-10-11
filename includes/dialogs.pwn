Dialog:DIALOG_GIRIS(playerid, response, listitem, inputtext[])
{
	if(!response) return KickEx(playerid);

	if(strlen(inputtext) < 3 || strlen(inputtext) > 30)
	{
		GirisEkrani(playerid, "Þifrenizi 3-30 karakter arasýnda girmelisiniz.");
		return true;
	}
	
	new query[128];
	mysql_format(conn, query, sizeof(query), "SELECT * FROM hesaplar WHERE Forumid = '%i' LIMIT 1", Hesap[playerid][Forumid]);
	mysql_tquery(conn, query, "SifreHashKontrol", "si", inputtext, playerid);
	return true;
}

Dialog:DIALOG_KARAKTER_YARAT(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		Dialog_Show(playerid, DIALOG_KARAKTER_YAS, DIALOG_STYLE_INPUT, "{99C794}Karakter Yaþý", "{FFFFFF}Karakterinizin kaç yaþýnda olmasýný istiyorsunuz?\n{3C5DA5}NOT:{FFFFFF} 13 ve 100 arasýnda bir yaþ deðeri girmelisiniz.", "Onayla", "Ýptal");
	}
	else
	{
		KickEx(playerid);
	}
	return true;
}

Dialog:DIALOG_KARAKTER_YAS(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		new yas = strval(inputtext);
		if(isnull(inputtext) || yas < 13 || yas > 100) return Dialog_Show(playerid, DIALOG_KARAKTER_YAS, DIALOG_STYLE_INPUT, "{99C794}Karakter Yaþý", "Hatalý yaþ deðeri girdiniz.\n{FFFFFF}Karakterinizin kaç yaþýnda olmasýný istiyorsunuz?\n{3C5DA5}NOT:{FFFFFF} 13 ve 100 arasýnda bir yaþ deðeri girmelisiniz.", "Onayla", "Ýptal");
		Karakter[playerid][Yas] = yas;
		Dialog_Show(playerid, DIALOG_KARAKTER_TENRENGI, DIALOG_STYLE_LIST, "{99C794}Karakter Ten Rengi", "Beyaz\nSiyah", "Onayla", "Ýptal");
	}
	else
	{
		KickEx(playerid);
	}
	return true;
}

Dialog:DIALOG_KARAKTER_TENRENGI(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		Karakter[playerid][Ten] = listitem + 1;
		Dialog_Show(playerid, DIALOG_KARAKTER_CINSIYET, DIALOG_STYLE_LIST, "{99C794}Karakter Cinsiyeti", "Erkek\nKadýn", "Onayla", "Ýptal");
	}
	else
	{
		KickEx(playerid);
	}
	return true;
}

Dialog:DIALOG_KARAKTER_CINSIYET(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		Karakter[playerid][Cinsiyet] = listitem + 1;
		new kokenstr[1024];
		for(new i = 0; i < sizeof(Kokenler); i++)
		{
			format(kokenstr, sizeof(kokenstr), "%s%s\n", kokenstr, Kokenler[i][Ulke]);
		}
		Dialog_Show(playerid, DIALOG_KARAKTER_KOKEN, DIALOG_STYLE_LIST, "{99C794}Karakter Kökeni", kokenstr, "Onayla", "Ýptal");
	}
	else
	{
		KickEx(playerid);
	}
	return true;
}

Dialog:DIALOG_KARAKTER_KOKEN(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		Karakter[playerid][Koken] = listitem;
		new dialogstr[1540];
		switch(Karakter[playerid][Ten])
		{
			case 1:
			{
				switch(Karakter[playerid][Cinsiyet])
				{
					case 1:
					{
						for(new i; i < sizeof(ErkekBeyazSkinler); i++)
						{
							format(dialogstr, sizeof(dialogstr), "%s%d\nID: %d\n", dialogstr, ErkekBeyazSkinler[i], ErkekBeyazSkinler[i]);
						}
					}
					default:
					{
						for(new i; i < sizeof(KadinBeyazSkinler); i++)
						{
							format(dialogstr, sizeof(dialogstr), "%s%d\nID: %d\n", dialogstr, KadinBeyazSkinler[i], KadinBeyazSkinler[i]);
						}
					}
				}
			}
			default:
			{
				switch(Karakter[playerid][Cinsiyet])
				{
					case 1:
					{
						for(new i; i < sizeof(ErkekSiyahSkinler); i++)
						{
							format(dialogstr, sizeof(dialogstr), "%s%d\nID: %d\n", dialogstr, ErkekSiyahSkinler[i], ErkekSiyahSkinler[i]);
						}
					}
					default:
					{	
						for(new i; i < sizeof(KadinSiyahSkinler); i++)
						{
							format(dialogstr, sizeof(dialogstr), "%s%d\nID: %d\n", dialogstr, KadinSiyahSkinler[i], KadinSiyahSkinler[i]);
						}
					}
				}
			}
		}
		ShowPlayerDialog(playerid, 23302, DIALOG_STYLE_PREVMODEL, "Karakter Gorunumu", dialogstr, "Onayla", "Ýptal");
	}
	else
	{
		KickEx(playerid);
	}
	return true;
}