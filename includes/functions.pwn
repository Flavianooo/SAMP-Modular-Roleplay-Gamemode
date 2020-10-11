Vice:SunucuAyarlari()
{
	new rcon[80];
	format(rcon, sizeof(rcon), "hostname %s", MOD_ADI);
	SendRconCommand(rcon);
	format(rcon, sizeof(rcon), "password %s", MOD_SIFRE);
	SendRconCommand(rcon);
	format(rcon, sizeof(rcon), "language %s", MOD_DIL);
	SendRconCommand(rcon);
	format(rcon, sizeof(rcon), "website %s", MOD_WEBSITE);
	SendRconCommand(rcon);
	SetGameModeText(MOD_SURUM);

	// Sistemler
	AracNoktalariYarat();
	PiyasaNoktalariYarat();
	BalikNoktalariYarat();

	// Oyun
	ManualVehicleEngineAndLights();
	DisableInteriorEnterExits();
	EnableStuntBonusForAll(0);
	SetNameTagDrawDistance(20.0);
	ShowPlayerMarkers(0);

	ShowNameTags(1);
	SetNameTagDrawDistance(20.0);

	new Float:mapunit;
    MapAndreas_FindZ_For2DCoord(0.0,0.0,mapunit);
    if(mapunit <= 0.0)
    {
        MapAndreas_Init(MAP_ANDREAS_MODE_FULL);
    }
    MapAndreas_FindZ_For2DCoord(0.0,0.0,mapunit);
    if(mapunit <= 0.0)
    {
    	print("MapAndreas failed to initiated");
    } 
    else 
    {
        print("MapAndreas successfully initiated");
    }
	new saat;
	gettime(saat);
	SunucuZaman = saat;
	return true;
}

Vice:VeritabaniAyarlari()
{
	mysql_log(ERROR | WARNING);
	switch(MYSQL_BAGLANTI)
	{
		case 1: conn = mysql_connect(LSQL_SUNUCU, LSQL_KULLANICI, LSQL_SIFRE, LSQL_VERITABANI);
		case 2: conn = mysql_connect(VSQL_SUNUCU, VSQL_KULLANICI, VSQL_SIFRE, VSQL_VERITABANI);
	}
	if(mysql_errno(conn) != 0) 
    { 
        printf("** [MySQL] Couldn't connect to the database (%d).", mysql_errno(conn));

        SendRconCommand("exit");
    } 
    else 
    { 
        printf("** [MySQL] Connected to the database successfully (%d).", _:conn);
    } 
	mysql_set_charset("latin5", conn);

	if(!conn) return printf("%s", mysql_errno(conn));
	return true;
}

Vice:VeriYuklemeleri()
{
	printf("\n\n------[TÜM YÜKLEMELER]------");
	mysql_tquery(conn, "SELECT * FROM binalar", "BinalariYukle");
	mysql_tquery(conn, "SELECT * FROM evler", "EvleriYukle");
	mysql_tquery(conn, "SELECT * FROM isyeri", "IsyeriYukle");
	mysql_tquery(conn, "SELECT * FROM araclar WHERE Sahip = 0", "AraclariYukle");
	mysql_tquery(conn, "SELECT * FROM birlikler", "BirlikleriYukle");
	mysql_tquery(conn, "SELECT * FROM arsalar", "ArsalariYukle");
	mysql_tquery(conn, "SELECT * FROM ekinler", "EkinleriYukle");
	mysql_tquery(conn, "SELECT * FROM tarimurunleri", "TarimUrunleriYukle");
	return true;
}

Vice:OyunModuKapat()
{
	foreach(new i : Player)
	{
		if(IsPlayerConnected(i))
		{
			OnPlayerDisconnect(i, 1);
			KarakterVeriKaydet(i);
		}
	}
	mysql_close(conn);
	return true;
}

// --------------------------------------

Vice:HesapKontrol(playerid)
{
	Hesap[playerid][Forumid] = -1;
	new isim[MAX_PLAYER_NAME+1];
	GetPlayerName(playerid, isim, sizeof(isim));
	if(!strcmp(isim, "VC_", false, 3))
	{
		strdel(isim, 0, 3);
		foreach(new i : Player)
		{
			if(Hesap[i][Forumid] == strval(isim)) return Sunucu(playerid, "Sunucuya yalnýzca bir bilgisayardan giriþ yapabilirsiniz."), KickEx(playerid); 
		}
		Hesap[playerid][Forumid] = strval(isim);
	}
	else return Sunucu(playerid, "Giriþte isminiz VC_Forumid þeklinde olmalýdýr.(örn: VC_1)"), KickEx(playerid);
	new query[124];
	mysql_format(conn, query, sizeof(query), "SELECT id FROM hesaplar WHERE Forumid = '%i' LIMIT 1", Hesap[playerid][Forumid]);
	mysql_tquery(conn, query, "HesapVarMi", "i", playerid);
	return true;
}

Vice:HesapVarMi(playerid)
{
	if(cache_num_rows() != 0)
	{
		Hesap[playerid][SifreGirisTimer] = SetTimerEx("SifreGiris", 30 * TIMER_SANIYE, true, "i", playerid);
		GirisEkrani(playerid, "");
	} 
	else
	{
		Sunucu(playerid, ">> VC_%d kayýtlý bir hesap bulunamadý.", Hesap[playerid][Forumid]);
		Sunucu(playerid, ">> www.vice-rp.com adresinden hesap oluþturma aþamalarýna baþlayabilirsiniz.");
		KickEx(playerid);
	}
	return true;
}

Vice:HesapVeriKaydet(playerid)
{
	new query[2048];
	mysql_format(conn, query, sizeof(query), "UPDATE hesaplar SET Forumid = '%i', Admin = %i, PremiumSlot = %i, karakter1 = '%e', karakter2 = '%e', karakter3 = '%e' WHERE id = '%i' LIMIT 1",
		Hesap[playerid][Forumid],
		Hesap[playerid][Yonetici],
		Hesap[playerid][PremiumSlot],
		Hesap[playerid][Karakter1],
		Hesap[playerid][Karakter2],
		Hesap[playerid][Karakter3],
	Hesap[playerid][id]);
	mysql_tquery(conn, query);
	mysql_format(conn, query, sizeof(query), "UPDATE hesaplar SET oPremiumSkinBir = '%i', oPremiumSkinIki = '%i', oPremiumSkinUc = '%i', IsimDegisimHakki = '%i', OzelSkinAksesuar = '%i', PlakaDegisimHakki = '%i' WHERE id = '%i' LIMIT 1",
		Hesap[playerid][PremiumSkin][0],
		Hesap[playerid][PremiumSkin][1],
		Hesap[playerid][PremiumSkin][2],
		Hesap[playerid][IsimDegisimHakki],
		Hesap[playerid][OzelSkinAksesuar],
		Hesap[playerid][PlakaDegisimHakki],
	Hesap[playerid][id]);
	mysql_tquery(conn, query);
	mysql_format(conn, query, sizeof(query), "UPDATE hesaplar SET TelefonDegisimHakki = '%i', BankaHesapDegisimHakki = '%i', UcuncuDilHakki = '%i', BisikletHakki = '%i', BesYetenekPuani = '%i', OnYetenekPuani = '%i' WHERE id = '%i' LIMIT 1",
		Hesap[playerid][TelefonDegisimHakki],
		Hesap[playerid][BankaHesapDegisimHakki],
		Hesap[playerid][UcuncuDilHakki],
		Hesap[playerid][BisikletHakki],
		Hesap[playerid][BesYetenekPuani],
		Hesap[playerid][OnYetenekPuani],
	Hesap[playerid][id]);
	mysql_tquery(conn, query);
	mysql_format(conn, query, sizeof(query), "UPDATE hesaplar SET OnBesYetenekPuani = '%i', YetenekSifirlamaHakki = '%i', OzelSkinAksesuar = '%i', ikixpayday = '%i', VIP = '%i', YoneticiIsim = '%e' WHERE id = '%i' LIMIT 1",
		Hesap[playerid][OnBesYetenekPuani],
		Hesap[playerid][YetenekSifirlamaHakki],
		Hesap[playerid][OzelSkinAksesuar],
		Hesap[playerid][DoublePayday],
		Hesap[playerid][VIP],
		Hesap[playerid][YoneticiIsim],
	Hesap[playerid][id]);
	mysql_tquery(conn, query);
	return true;
}

Vice:GirisEkrani(playerid, error[])
{
	if(!strmatch(error, "")) SendClientMessage(playerid, 0xFF6347AA, error);
	Dialog_Show(playerid, DIALOG_GIRIS, DIALOG_STYLE_PASSWORD, "{99C794}Vice Roleplay - {FFFFFF}Giriþ Ekraný", "Hoþ geldin VC_%d! Giriþ yapmak için lütfen þifreni aþaðýdaki kutucuða gir.", "Giriþ", "Çýkýþ", Hesap[playerid][Forumid]);
	return true;
}

Vice:SifreKontrol(playerid)
{
	new bool:match = bcrypt_is_equal();
	if(match == true)
	{
		KillTimer(Hesap[playerid][SifreGirisTimer]);
		new Cache:VeriCek, query[128];
		mysql_format(conn, query, sizeof(query), "SELECT * FROM hesaplar WHERE Forumid = %i", Hesap[playerid][Forumid]);
		VeriCek = mysql_query(conn, query);
		cache_get_value_name_int(0, "id", Hesap[playerid][id]);
		cache_delete(VeriCek);
		KarakterleriListele(playerid);
	}
	else
	{
		GirisEkrani(playerid, "Hatalý þifre girdiniz. Lütfen tekrar deneyin.");
	}
	return true;
}

Vice:SifreHashKontrol(girilensifre[], playerid)
{
	new sifre[124];
	cache_get_value_name(0, "Sifre", sifre);
	bcrypt_check(girilensifre, sifre, "SifreKontrol", "d", playerid);	
	return true;
}

Vice:KarakterleriListele(playerid)
{
	new query[128];
	mysql_format(conn, query, sizeof(query), "SELECT * FROM hesaplar WHERE id = '%i' LIMIT 1", Hesap[playerid][id]);
	mysql_tquery(conn, query, "HesapVeriYukle", "i", playerid);

	mysql_format(conn, query, sizeof(query), "SELECT * FROM karakterler WHERE Forumid = %i", Hesap[playerid][Forumid]);
	mysql_tquery(conn, query, "KarakterListesi", "i", playerid);
	return true;
}

Vice:KarakterListesi(playerid)
{
	new rows;
	cache_get_row_count(rows);
	if(rows)
	{
		for(new i = 0; i < rows; i++)
		{
			if(i > 3) break;
			new isim[32];
			Hesap[playerid][KarakterSecim][i] = 1;
			cache_get_value_name_int(i, "id", Hesap[playerid][KarakterSecimID][i]);
			cache_get_value_name_int(i, "Kiyafet", Hesap[playerid][KarakterSkin][i]);
			if(i == 0)
			{
				cache_get_value_name(i, "isim", isim);
				format(Hesap[playerid][Karakter1], 32, "%s", isim);
			}
			else if(i == 1)
			{
				cache_get_value_name(i, "isim", isim);
				format(Hesap[playerid][Karakter2], 32, "%s", isim);
			}
			else if(i == 2)
			{
				cache_get_value_name(i, "isim", isim);
				format(Hesap[playerid][Karakter3], 32, "%s", isim);
			}
			else if(i == 3)
			{
				cache_get_value_name(i, "isim", isim);
				format(Hesap[playerid][Karakter4], 32, "%s", isim);
			}
		}
		SelectTextDraw(playerid, 0x99C794FF);
		KarakterMenuYukle(playerid);
	}
	else
	{
		Sunucu(playerid, "Karakteriniz olmadýðý için oyundan çýkartýlýyorsunuz. Bir karakter yaratmalýsýnýz.");
		KickEx(playerid);
	}
	return true;
}

Vice:HesapVeriYukle(playerid)
{
	if(cache_num_rows())
	{
		cache_get_value_name_int(0, "Admin", Hesap[playerid][Yonetici]);
		cache_get_value_name_int(0, "PremiumSlot", Hesap[playerid][PremiumSlot]);
		cache_get_value_name(0, "YoneticiIsim", Hesap[playerid][YoneticiIsim], 32);
		// market ürünleri
		cache_get_value_name_int(0, "IsimDegisimHakki", Hesap[playerid][IsimDegisimHakki]);
		cache_get_value_name_int(0, "PlakaDegisimHakki", Hesap[playerid][PlakaDegisimHakki]);
		cache_get_value_name_int(0, "TelefonDegisimHakki", Hesap[playerid][TelefonDegisimHakki]);
		cache_get_value_name_int(0, "BisikletHakki", Hesap[playerid][BisikletHakki]);
		cache_get_value_name_int(0, "BesYetenekPuani", Hesap[playerid][BesYetenekPuani]);
		cache_get_value_name_int(0, "OnYetenekPuani", Hesap[playerid][OnYetenekPuani]);
		cache_get_value_name_int(0, "OnBesYetenekPuani", Hesap[playerid][OnBesYetenekPuani]);
		cache_get_value_name_int(0, "YetenekSifirlamaHakki", Hesap[playerid][YetenekSifirlamaHakki]);
		cache_get_value_name_int(0, "BankaHesapDegisimHakki", Hesap[playerid][BankaHesapDegisimHakki]);
		cache_get_value_name_int(0, "UcuncuDilHakki", Hesap[playerid][UcuncuDilHakki]);
		cache_get_value_name_int(0, "VIP", Hesap[playerid][VIP]);
		cache_get_value_name_int(0, "ikixpayday", Hesap[playerid][DoublePayday]);
		cache_get_value_name_int(0, "MaskeHakki", Hesap[playerid][MaskeHakki]);
		cache_get_value_name_int(0, "DortXExp", Hesap[playerid][DortXExp]);
		cache_get_value_name_int(0, "CoolAracPaketi", Hesap[playerid][CoolAracPaketi]);
		cache_get_value_name_int(0, "EkonomiPaketi", Hesap[playerid][EkonomiPaketi]);
		cache_get_value_name_int(0, "MeslekPaketi", Hesap[playerid][MeslekPaketi]);
		cache_get_value_name_int(0, "OzelSkinAksesuar", Hesap[playerid][OzelSkinAksesuar]);
		cache_get_value_name_int(0, "oPremiumSkinBir", Hesap[playerid][PremiumSkin][0]);
		cache_get_value_name_int(0, "oPremiumSkinIki", Hesap[playerid][PremiumSkin][1]);
		cache_get_value_name_int(0, "oPremiumSkinUc", Hesap[playerid][PremiumSkin][2]);
	}
	return true;
}

Vice:KarakterVeriYukle(playerid)
{
	if(cache_num_rows())
	{
		cache_get_value_name_int(0, "id", Karakter[playerid][id]); // yinele
		cache_get_value_name_int(0, "Olusturuldu", Karakter[playerid][Olusturuldu]);

		cache_get_value_name(0, "isim", Karakter[playerid][Isim], MAX_PLAYER_NAME);
		cache_get_value_name_int(0, "Kiyafet", Karakter[playerid][Skin]);
		cache_get_value_name_float(0, "X", Karakter[playerid][SonPos][0]);
		cache_get_value_name_float(0, "Y", Karakter[playerid][SonPos][1]);
		cache_get_value_name_float(0, "Z", Karakter[playerid][SonPos][2]);
		cache_get_value_name_float(0, "A", Karakter[playerid][SonPos][3]);
		cache_get_value_name_int(0, "Yarali", Karakter[playerid][Yarali]);
		cache_get_value_name_int(0, "YaraliSuresi", Karakter[playerid][YaraliSuresi]);

		cache_get_value_name_int(0, "Yas", Karakter[playerid][Yas]);
		cache_get_value_name_int(0, "Cinsiyet", Karakter[playerid][Cinsiyet]);
		cache_get_value_name_int(0, "TenRengi", Karakter[playerid][Ten]);
		cache_get_value_name_int(0, "Koken", Karakter[playerid][Koken]);
		cache_get_value_name_int(0, "Para", Karakter[playerid][Para]);
		cache_get_value_name_int(0, "Oynama_Saati", Karakter[playerid][Saat]);
		cache_get_value_name_int(0, "Dakika", Karakter[playerid][Dakika]);
		cache_get_value_name_int(0, "EXP", Karakter[playerid][EXP]);
		cache_get_value_name_int(0, "Seviye", Karakter[playerid][Seviye]);
		cache_get_value_name_float(0, "Can", Karakter[playerid][Can]);
		cache_get_value_name_float(0, "Zirh", Karakter[playerid][Zirh]);
		cache_get_value_name_int(0, "Rapor", Karakter[playerid][Rapor]);
		cache_get_value_name_int(0, "Interior", Karakter[playerid][Interior]);
		cache_get_value_name_int(0, "VW", Karakter[playerid][VW]);
		cache_get_value_name_int(0, "Yasakli", Karakter[playerid][Yasakli]);

		cache_get_value_name_int(0, "BankaNo", Karakter[playerid][BankaNo]);
		cache_get_value_name_int(0, "BankaPara", Karakter[playerid][BankaPara]);

		// Eþyalar

		cache_get_value_name_int(0, "Telefon", Karakter[playerid][Telefon]);
		cache_get_value_name_int(0, "TelefonNumarasi", Karakter[playerid][TelefonNumarasi]);
		cache_get_value_name_int(0, "Sigara", Karakter[playerid][Sigara]);

		// Yetenek Sistemi
		cache_get_value_name_int(0, "BalikEXP", Karakter[playerid][BalikYetenek][0]);
		cache_get_value_name_int(0, "BalikSeviye", Karakter[playerid][BalikYetenek][1]);

		// Birlik Sistemi

		cache_get_value_name_int(0, "Birlik", Karakter[playerid][Birlik]);
		cache_get_value_name_int(0, "BirlikRutbe", Karakter[playerid][BirlikRutbe]);

		//Balýk Sistemi
		cache_get_value_name_int(0, "Balik", Karakter[playerid][Balik]);
		cache_get_value_name_int(0, "BalikYemi", Karakter[playerid][BalikYemi]);

		//araç
		cache_get_value_name_int(0, "AracAnahtar", Karakter[playerid][AracAnahtar]);
		cache_get_value_name_int(0, "Ehliyet", Karakter[playerid][Ehliyet]);

		// ev
		cache_get_value_name_int(0, "EvAnahtar", Karakter[playerid][EvAnahtar]);
		cache_get_value_name_int(0, "KiralananEv", Karakter[playerid][KiralananEv]);
		cache_get_value_name_int(0, "KiraOdeme", Karakter[playerid][KiraOdeme]);

		// Ýþyeri

		cache_get_value_name_int(0, "IsyeriAnahtar", Karakter[playerid][IsyeriAnahtar]);
		cache_get_value_name_int(0, "IsyeriOrtak", Karakter[playerid][IsyeriOrtak]);

		new query[128];
		mysql_format(conn, query, sizeof(query), "SELECT * FROM petler WHERE Sahip = %i", Karakter[playerid][id]);
		mysql_tquery(conn, query, "PetYukle", "i", playerid);

		switch(Karakter[playerid][Olusturuldu])
		{
			case 0:
			{
				Sunucu(playerid, "Karakteriniz henüz yapýlandýrýlmamýþ görünüyor. Karakter yapýlandýrma ekranýna yönlendiriliyorsunuz.");
				Dialog_Show(playerid, DIALOG_KARAKTER_YARAT, DIALOG_STYLE_MSGBOX, "{99C794}Karakter Yapýlandýrma", "Az sonra karakter özelliklerinizi seçeceksiniz.\nBu özelliklerin isim deðiþimi ve karakter yapýlandýrma paketi dýþýnda deðiþtirilemeyeceðini unutmayýn.\nLütfen dikkatli seçim yapýn, devam etmek için bu ekraný onaylayýn.", "Onayla", "Ýptal");
			}
			default:
			{
				Sunucu(playerid, "Karakteriniz dünyaya getirilirken lütfen biraz bekleyin...");
				SetPlayerCameraPos(playerid, 158.3348,-2098.9861,56.6490);
				SetPlayerCameraLookAt(playerid, 176.5682,-2053.3926,48.5751);
				SetTimerEx("KarakterAyarla", 2500, false, "i", playerid);
			}
		}
	}
	else
	{
		Sunucu(playerid, "Bu slotta bir karakteriniz bulunmuyor.");
	}
	return true;
}

Vice:SonVeriKarakter(playerid)
{
	Karakter[playerid][Interior] = GetPlayerInterior(playerid);
	Karakter[playerid][VW] = GetPlayerVirtualWorld(playerid);
	Karakter[playerid][Skin] = GetPlayerSkin(playerid);
	GetPlayerHealth(playerid, Karakter[playerid][Can]);
	GetPlayerArmour(playerid, Karakter[playerid][Zirh]);
	GetPlayerPos(playerid, Karakter[playerid][SonPos][0], Karakter[playerid][SonPos][1], Karakter[playerid][SonPos][2]);
	GetPlayerFacingAngle(playerid, Karakter[playerid][SonPos][3]);	
	return true;
}

Vice:KarakterVeriKaydet(playerid)
{
	SonVeriKarakter(playerid);

	new query[1520];
	mysql_format(conn, query, sizeof(query), "UPDATE karakterler SET isim = '%e', Kiyafet = %i, X = %.4f, Y = %.4f, Z = %.4f, A = %.4f, Yas = %i, Cinsiyet = %i, TenRengi = %i, Koken = %i, Para = %i, Can = %.4f, Zirh = %.4f, Rapor = %i, Interior = %i, VW = %i WHERE id = '%i'",
		Karakter[playerid][Isim],
		Karakter[playerid][Skin],
		Karakter[playerid][SonPos][0],
		Karakter[playerid][SonPos][1],
		Karakter[playerid][SonPos][2],
		Karakter[playerid][SonPos][3],
		Karakter[playerid][Yas],
		Karakter[playerid][Cinsiyet],
		Karakter[playerid][Ten],
		Karakter[playerid][Koken],
		Karakter[playerid][Para],
		Karakter[playerid][Can],
		Karakter[playerid][Zirh],
		Karakter[playerid][Rapor],
		Karakter[playerid][Interior],
		Karakter[playerid][VW],
	Karakter[playerid][id]);
	mysql_tquery(conn, query);

	mysql_format(conn, query, sizeof(query), "UPDATE karakterler SET Yasakli = %i, Yarali = %i, YaraliSuresi = %i, Oynama_Saati = %i, Dakika = %i, EXP = %i, Seviye = %i WHERE id = '%i'",
		Karakter[playerid][Yasakli],
		Karakter[playerid][Yarali],
		Karakter[playerid][YaraliSuresi],
		Karakter[playerid][Saat],
		Karakter[playerid][Dakika],
		Karakter[playerid][EXP],
		Karakter[playerid][Seviye],
	Karakter[playerid][id]);
	mysql_tquery(conn, query);

	mysql_format(conn, query, sizeof(query), "UPDATE karakterler SET BalikYemi = %i, Balik = %i, BankaNo = %i, BankaPara = %i, Mevduat = %i WHERE id = '%i'",
		Karakter[playerid][BalikYemi],
		Karakter[playerid][Balik],
		Karakter[playerid][BankaNo],
		Karakter[playerid][BankaPara],
		Karakter[playerid][Mevduat],
	Karakter[playerid][id]);
	mysql_tquery(conn, query);

	mysql_format(conn, query, sizeof(query), "UPDATE karakterler SET KiralananEv = %i, KiraOdeme = %i, AracAnahtar = %i, EvAnahtar = %i WHERE id = %i",
		Karakter[playerid][KiralananEv],
		Karakter[playerid][KiraOdeme],
		Karakter[playerid][AracAnahtar],
		Karakter[playerid][EvAnahtar],
	Karakter[playerid][id]);
	mysql_tquery(conn, query);

	mysql_format(conn, query, sizeof(query), "UPDATE karakterler SET IsyeriOrtak = %i, IsyeriAnahtar = %i, Balik = %i, BalikYemi = %i, Telefon = %i, TelefonNumarasi = %i WHERE id = %i",
		Karakter[playerid][IsyeriOrtak],
		Karakter[playerid][IsyeriAnahtar],
		Karakter[playerid][Balik],
		Karakter[playerid][BalikYemi],
		Karakter[playerid][Telefon],
		Karakter[playerid][TelefonNumarasi],
	Karakter[playerid][id]);
	mysql_tquery(conn, query);

	mysql_format(conn, query, sizeof(query), "UPDATE karakterler SET BalikEXP = %i, BalikSeviye = %i, Sigara = %i, Ehliyet = %i, Birlik = %i, BirlikRutbe = %i WHERE id = %i",
		Karakter[playerid][BalikYetenek][0],
		Karakter[playerid][BalikYetenek][1],
		Karakter[playerid][Sigara],
		Karakter[playerid][Ehliyet],
		Karakter[playerid][Birlik],
		Karakter[playerid][BirlikRutbe],
	Karakter[playerid][id]);
	mysql_tquery(conn, query);
	return true;
}

Vice:KarakterYarat(playerid)
{
	Sunucu(playerid, "Baþarýlý bir þekilde karakterinizi yarattýnýz.");
	Karakter[playerid][id] = cache_insert_id();
	KarakterVeriKontrol(playerid);
	return true;
}

Vice:KarakterVeriKontrol(playerid)
{
	new query[128];
	mysql_format(conn, query, sizeof(query), "SELECT * FROM karakterler WHERE id = '%i' LIMIT 1", Karakter[playerid][id]);
	mysql_tquery(conn, query, "KarakterVeriYukle", "i", playerid);
	return true;
}

Vice:KarakterVeriSifirla(playerid)
{
	// HESAP
	Hesap[playerid][SecilenKarakter] = 0;
	Hesap[playerid][KarakterSeciminde] = 0;
	Hesap[playerid][KarakterSecim][0] = 0;
	Hesap[playerid][KarakterSecim][1] = 0;
	Hesap[playerid][KarakterSecim][2] = 0;
	Hesap[playerid][KarakterSecim][3] = 0;
	Hesap[playerid][PMDurum] = false;
	Hesap[playerid][Awork] = false;
	Hesap[playerid][Swork] = false;
	Hesap[playerid][Yonetici] = 0;
	Hesap[playerid][EkonomiPaketi] = 0;
	Hesap[playerid][ViceCoin] = 0;
	Hesap[playerid][VIP] = 0;
	Hesap[playerid][IsimDegisimHakki] = 0;
	Hesap[playerid][PlakaDegisimHakki] = 0;
	Hesap[playerid][TelefonDegisimHakki] = 0;
	Hesap[playerid][BesYetenekPuani] = 0;
	Hesap[playerid][OnYetenekPuani] = 0;
	Hesap[playerid][OnBesYetenekPuani] = 0;
	Hesap[playerid][YetenekSifirlamaHakki] = 0;
	format(Hesap[playerid][YoneticiIsim], 32, "Yok");
	// -----
	Karakter[playerid][Giris] = false;
	Karakter[playerid][ACSpawn] = false;
	Karakter[playerid][KarakterSpawnlandi] = false;
	Karakter[playerid][id] = 0;
	Karakter[playerid][Olusturuldu] = 0;
	Karakter[playerid][Skin] = 0;
	Karakter[playerid][SonPos][0] = 0.0;
	Karakter[playerid][SonPos][1] = 0.0;
	Karakter[playerid][SonPos][2] = 0.0;
	Karakter[playerid][SonPos][3] = 0.0;
	Karakter[playerid][Yas] = 0;
	Karakter[playerid][Cinsiyet] = 0;
	Karakter[playerid][Ten] = 0;
	Karakter[playerid][Koken] = 0;
	Karakter[playerid][Para] = 0;
	Karakter[playerid][Saat] = 0;
	Karakter[playerid][Dakika] = 0;
	Karakter[playerid][EXP] = 0;
	Karakter[playerid][Seviye] = 1;
	Karakter[playerid][Rapor] = 0;
	Karakter[playerid][Interior] = 0;
	Karakter[playerid][VW] = 0;

	Karakter[playerid][Ciftlik] = -1;
	Karakter[playerid][Ekin] = 0;

	// Eþyalar

	Karakter[playerid][Telefon] = 0;
	Karakter[playerid][TelefonNumarasi] = 0;
	Karakter[playerid][Sigara] = 0;

	// Yetenek Sistemi
	for(new i = 0; i < 2; i++)
	{
		Karakter[playerid][BalikYetenek][i] = 0;
		Karakter[playerid][Liderlik][i] = 0;
		Karakter[playerid][Uretim][i] = 0;
		Karakter[playerid][Surus][i] = 0;
		Karakter[playerid][Kimya][i] = 0;
		Karakter[playerid][Hirsizlik][i] = 0;
		Karakter[playerid][Guc][i] = 0;
		Karakter[playerid][Dayaniklilik][i] = 0;
	}

	// Birlik Sistemi

	Karakter[playerid][Birlik] = -1;
	Karakter[playerid][BirlikRutbe] = 0;

	// Balýk sistemi
	Karakter[playerid][BalikYemi] = 0;
	Karakter[playerid][Balik] = 0;
	Karakter[playerid][BalikTutuyor] = false;

	// Silah Sistemi

	for(new i = 0; i < MAX_OYUNCU_SILAH; i++)
	{
		Karakter[playerid][Silah][i] = 0;
		Karakter[playerid][SilahSeri][i] = 0;
		Karakter[playerid][Mermi][i] = 0;
	}

	// banka sistemi
	Karakter[playerid][BankaNo] = 0;
	Karakter[playerid][BankaPara] = 0;
	Karakter[playerid][Mevduat] = 0;

	// araç sistemi
	Karakter[playerid][AracAnahtar] = 0;
	Karakter[playerid][Ehliyet] = 0;
	Karakter[playerid][EhliyetTesti] = 0;
	Karakter[playerid][EhliyetCP] = 0;

	// ev sistemi
	Karakter[playerid][EvAnahtar] = -1;
	Karakter[playerid][KiralananEv] = -1;
	Karakter[playerid][KiraOdeme] = 0;

	// iþyeri sistemi

	Karakter[playerid][IsyeriAnahtar] = -1;
	Karakter[playerid][IsyeriOrtak] = -1;

 	// Geçici veriler
	Karakter[playerid][yYas] = 0;
	Karakter[playerid][yCinsiyet] = 0;
	Karakter[playerid][yTenRengi] = 0;
	Karakter[playerid][yKoken] = 0;
	Karakter[playerid][yIsim] = strval("Yok");
	Karakter[playerid][Arama] = -1;
	Karakter[playerid][Araniyor] = 0;
	Karakter[playerid][Aramada] = 0;
	Karakter[playerid][AracSpawnID] = 0;
	Karakter[playerid][SoruSordu] = false;
	Karakter[playerid][SoruIcerik] = strval("Yok");

	Karakter[playerid][EtkilesimNPC] = -1;
	Karakter[playerid][EtkilesimDeger] = 0;
	Karakter[playerid][Yarali] = 0;
	Karakter[playerid][YaraliSuresi] = 0;
	Karakter[playerid][BayginDurum] = false;

	Karakter[playerid][Anim] = false;

	PVarSifirla(playerid);
	return true;
}

Vice:PVarSifirla(playerid)
{
	DeletePVar(playerid, "AracRenk");
	DeletePVar(playerid, "ViceMarketPlaka");
	DeletePVar(playerid, "MotorCalistiriyor");
	DeletePVar(playerid, "BenzinAliyor");
	return true;
}

Vice:KarakterAyarla(playerid)
{
	new query[128];
	mysql_format(conn, query, sizeof(query), "UPDATE hesaplar SET Oyunda = 1 WHERE id = %i", Hesap[playerid][id]);
	mysql_query(conn, query);
	Karakter[playerid][Giris] = true;
	ResetPlayerMoney(playerid);
	GivePlayerMoney(playerid, Karakter[playerid][Para]);
	SetPlayerScore(playerid, Karakter[playerid][Seviye]);
	SetPlayerName(playerid, Karakter[playerid][Isim]);
	SetPlayerSkin(playerid, Karakter[playerid][Skin]);
	SetPlayerPos(playerid, Karakter[playerid][SonPos][0], Karakter[playerid][SonPos][1], Karakter[playerid][SonPos][2]);
	SetPlayerFacingAngle(playerid, Karakter[playerid][SonPos][3]);
	SetPlayerInterior(playerid, Karakter[playerid][Interior]);
	SetPlayerVirtualWorld(playerid, Karakter[playerid][VW]);
	SetSpawnInfo(playerid, NO_TEAM, Karakter[playerid][Skin], Karakter[playerid][SonPos][0], Karakter[playerid][SonPos][1], Karakter[playerid][SonPos][2], Karakter[playerid][SonPos][3], 0, 0, 0, 0, 0, 0);
	SpawnPlayer(playerid);
	Sunucu(playerid, "Karakter verileriniz yüklendi. Her þey hazýr!");
	return true;
}

Vice:SpawnAyarla(playerid)
{
	SetPlayerSkillLevel(playerid,WEAPONSKILL_PISTOL,998);
    SetPlayerSkillLevel(playerid,WEAPONSKILL_PISTOL_SILENCED,999);
    SetPlayerSkillLevel(playerid,WEAPONSKILL_DESERT_EAGLE,999);
    SetPlayerSkillLevel(playerid,WEAPONSKILL_SHOTGUN,999);
    SetPlayerSkillLevel(playerid,WEAPONSKILL_SAWNOFF_SHOTGUN,998);
    SetPlayerSkillLevel(playerid,WEAPONSKILL_SPAS12_SHOTGUN,999);
    SetPlayerSkillLevel(playerid,WEAPONSKILL_MICRO_UZI,998);
    SetPlayerSkillLevel(playerid,WEAPONSKILL_MP5,999);
    SetPlayerSkillLevel(playerid,WEAPONSKILL_AK47,999);
    SetPlayerSkillLevel(playerid,WEAPONSKILL_M4,999);
    SetPlayerSkillLevel(playerid,WEAPONSKILL_SNIPERRIFLE,999);
	return true;
}

Vice:KarakterGoster(playerid, hedefid)
{
	new cinsiyetdurum[10], tenrengidurum[10], karakterkoken[48];
	switch(Karakter[playerid][Cinsiyet])
	{
		case 0: cinsiyetdurum = "Yok";
		case 1: cinsiyetdurum = "Erkek";
		case 2: cinsiyetdurum = "Kadýn";
	}
	switch(Karakter[playerid][Ten])
	{
		case 0: tenrengidurum = "Yok";
		case 1: tenrengidurum = "Beyaz";
		case 2: tenrengidurum = "Siyahi";
	}

	for(new i = 0; i < sizeof(Kokenler); i++)
	{
		if(Karakter[playerid][Koken] == i)
		{
			format(karakterkoken, sizeof(karakterkoken), "%s", Kokenler[i][Ulke]);
			break;
		}
	}

	SunucuEx(hedefid, "------------------------------------------------------------------------");
	SunucuEx(hedefid, ">> Hesap: VC_%d | Ýsim: %s | Yetki: %s", Hesap[playerid][Forumid], RPIsim(playerid), YetkiIsim(playerid));
	SunucuEx(hedefid, ">> Kýyafet: %d | Yaþ: %d | Ten Rengi: %s | Cinsiyet: %s | Köken: %s", Karakter[playerid][Skin], Karakter[playerid][Yas], tenrengidurum, cinsiyetdurum, karakterkoken);
	SunucuEx(hedefid, ">> Nakit Para: %s | Banka Numarasý: %d | Banka Parasý: %s | Mevduat: %s", NumaraFormati(Karakter[playerid][Para]), Karakter[playerid][BankaNo], NumaraFormati(Karakter[playerid][BankaPara]), NumaraFormati(Karakter[playerid][Mevduat]));
	SunucuEx(hedefid, ">> Dakika: %d | EXP: %d/%d | Oynama Saati: %d", Karakter[playerid][Dakika], Karakter[playerid][EXP], Karakter[playerid][Seviye]*4, Karakter[playerid][Saat]);
	SunucuEx(hedefid, "------------------------------------------------------------------------");
	return true;
}

Vice:SaatTimer()
{
	new saat;
	gettime(saat);
	SunucuZaman = saat;	
	SunucuDakika++;
	if(SunucuDakika >= 60)
	{
		for(new i = 0; i < MAX_VEHICLES; i++)
		{
			if(Araclar[i][AracTur] < 1 && Araclar[i][Gecerli])
			{
				Araclar[i][Vergi] += AracVergiHesapla(i);
			}
		}
		for(new d = 0; d != MAX_CIFTLIK; d ++) if(CiftlikInfo[d][cAktif] && CiftlikInfo[d][cUrun] > 0 && CiftlikInfo[d][cOlgunlasma] > 0) 
		{
			CiftlikInfo[d][cOlgunlasma] -= 1;
			new query[128];
			mysql_format(conn, query, sizeof(query), "UPDATE arsalar SET olgunlasma = %i WHERE id = %i", CiftlikInfo[d][cOlgunlasma], d);
			mysql_tquery(conn, query);
		}	
		SunucuDakika = 0;
	}
	foreach(new i: Player)
	{
		if(IsPlayerConnected(i))
		{
			if(Karakter[i][Giris])
			{
				SetPlayerTime(i, SunucuZaman, 0);
				Karakter[i][Dakika]++;
				if(Karakter[i][Dakika] >= 60)
				{
					Karakter[i][Dakika] = 0;
					Karakter[i][Saat]++;
					Karakter[i][EXP]++;
					new gerekliexp = Karakter[i][Seviye] * 4, payday;
					if(Karakter[i][EXP] >= gerekliexp)
					{
						Karakter[i][Seviye]++;
						Karakter[i][EXP] = 0;
						SetPlayerScore(i, Karakter[i][Seviye]);
					}

					switch(Karakter[i][Seviye])
					{
						case 1..10: payday = 200;
						case 11..20: payday = 225;
						case 21..30: payday = 250;
						case 31..40: payday = 275;
						default: payday = 300;
					}
					ParaVer(i, payday);
					Sunucu(i, "Saatlik bonus olarak {99C794}%s{C8C8C8} kazandýnýz.", NumaraFormati(payday));
					if(Karakter[i][Mevduat] > 0)
					{
						Karakter[i][Mevduat] += floatround(Karakter[i][Mevduat] * 0.003);
						Sunucu(i, "Mevduat hesabýnýzdaki para arttý. Mevduat hesabýnýzda %s bulunuyor.", NumaraFormati(Karakter[i][Mevduat]));
					}
					if(Karakter[i][KiralananEv] != -1)
					{
						new evid = Karakter[i][KiralananEv];
						if(Karakter[i][Para] < Evler[evid][KiraFiyat])
						{
							Sunucu(i, "Kira ücretini ödemek için yeterli paranýz yok. Kiradan çýkartýldýnýz.");
							Karakter[i][KiralananEv] = -1;
							Karakter[i][KiraOdeme] = 0;
							KarakterVeriKaydet(i);
						}
						else
						{
							ParaVer(i, -Evler[evid][KiraFiyat]);
							Karakter[i][KiraOdeme] += Evler[evid][KiraFiyat];
							KarakterVeriKaydet(i);
							Sunucu(i, "Ev kirasý olarak %s para ödediniz.", NumaraFormati(Evler[evid][KiraFiyat]));
						}
					}
				}
			}
		}
	}
	return true;
}

Vice:AracGostergeTimer()
{
	foreach(new i : Player)
	{
		if(IsPlayerInAnyVehicle(i))
		{
			new aracid = GetPlayerVehicleID(i);
			Araclar[aracid][Kilometre] += GetVehicleDistanceFromPoint(aracid, Araclar[aracid][AracSonPos][0], Araclar[aracid][AracSonPos][1], Araclar[aracid][AracSonPos][2]) / 4000;
			GetVehiclePos(aracid, Araclar[aracid][AracSonPos][0], Araclar[aracid][AracSonPos][1], Araclar[aracid][AracSonPos][2]);
			if(Araclar[aracid][Benzin] < 0.1 && Araclar[aracid][AracTur] == 0)
			{
				Araclar[aracid][Benzin] = 0.0;
				SwitchEngine(aracid, false);
			}
			else if(Araclar[aracid][AracTur] == 0)
			{
				if(Araclar[aracid][Benzin] > 0.0)
				{
					Araclar[aracid][Benzin] -= OyuncuHiziniCek(i)/3500.0;
				}
			}
			new gosterge[80];
			format(gosterge, sizeof(gosterge), "Benzin:_%.2f_lt Hiz:_%d_km/h KM:_%dkm", Araclar[aracid][Benzin], floatround(AracHizKontrol(i), floatround_round), floatround(Araclar[aracid][Kilometre], floatround_round) - 1);
			PlayerTextDrawSetString(i, AracGostergesi[i], gosterge);
		}
	}
	return true;
}

// -------------------------------------

randomEx(min, max)
	return random(max-min)+min;

stock IsimGetir(playerid)
{
	new isim[MAX_PLAYER_NAME];
	GetPlayerName(playerid, isim, sizeof(isim));
	return isim;
}

KickEx(playerid)
{
	SetTimerEx("KickTimer", 100, false, "d", playerid);
	return true;
}

Vice:KickTimer(playerid)
{
	Kick(playerid);
}

RPIsim(playerid)
{
	new isim[24];
	
	format(isim, 24, "%s", IsimGetir(playerid));
	strreplace(isim, '_', ' ');
    return isim;
}

strreplace(string[], find, replace)
{
    for(new i=0; string[i]; i++)
    {
        if(string[i] == find)
        {
            string[i] = replace;
        }
    }
}

RPIsimKontrol(player_name[])
{
    for(new i = 0, j = strlen(player_name); i < j; i ++)
    {
        switch(player_name[i])
        {
            case '0'..'9':
            {
                return Roleplay_Isim_Kontrol_Rakamli;
            }
        }
    }

    if(65 <= player_name[0] <= 90)
    {
        new underscore_1 = strfind(player_name, "_");
        if(underscore_1 >= 3)
        {
            if(65 <= player_name[underscore_1 + 1] <= 90)
            {
                if(strfind(player_name, "_", false, (underscore_1 + 1)) == -1)
                {
                    if(((strlen(player_name) - underscore_1) - 1) >= 3)
                    {
                        return Roleplay_Isim_Kontrol_Evet;
                    }
                }
            }
            else
            {
                if(((strlen(player_name) - underscore_1) - 1) <= 2)
                {
                    return Roleplay_Isim_Kontrol_Degil;
                }
                else
                {
                    return Roleplay_Isim_Kontrol_Sapkali;
                }
            }
        }
    }
    else
    {
        if(strfind(player_name, "_") <= 3)
        {
            return Roleplay_Isim_Kontrol_Degil;
        }
        else
        {
            return Roleplay_Isim_Kontrol_Sapkali;
        }
    }
    return Roleplay_Isim_Kontrol_Degil;
}

stock strmatch(const String1[], const String2[])
{
    if ((strcmp(String1, String2, true, strlen(String2)) == 0) && (strlen(String2) == strlen(String1)))
    {
        return true;
    }
    else
    {
        return false;
    }
}

// ---------------------------------
stock SendNearbyMessage(playerid, Float:radius, color, const str[], {Float,_}:...)
{
	static
	    args,
	    start,
	    end,
	    string[144]
	;
	#emit LOAD.S.pri 8
	#emit STOR.pri args

	if (args > 16)
	{
		#emit ADDR.pri str
		#emit STOR.pri start

	    for (end = start + (args - 16); end > start; end -= 4)
		{
	        #emit LREF.pri end
	        #emit PUSH.pri
		}
		#emit PUSH.S str
		#emit PUSH.C 144
		#emit PUSH.C string

		#emit LOAD.S.pri 8
		#emit CONST.alt 4
		#emit SUB
		#emit PUSH.pri

		#emit SYSREQ.C format
		#emit LCTRL 5
		#emit SCTRL 4

        foreach (new i : Player)
		{
			if (IsPlayerNearPlayer(i, playerid, radius)) {
  				SendClientMessage(i, color, string);
			}
		}
		return 1;
	}
	foreach (new i : Player)
	{
		if (IsPlayerNearPlayer(i, playerid, radius)) {
			SendClientMessage(i, color, str);
		}
	}
	return 1;
}

stock SendClientMessageEx(playerid, color, const text[], {Float, _}:...)
{
	static
	    args,
	    str[144];

	/*
     *  Custom function that uses #emit to format variables into a string.
     *  This code is very fragile; touching any code here will cause crashing!
	*/
	if ((args = numargs()) == 3)
	{
	    SendClientMessage(playerid, color, text);
	}
	else
	{
		while (--args >= 3)
		{
			#emit LCTRL 5
			#emit LOAD.alt args
			#emit SHL.C.alt 2
			#emit ADD.C 12
			#emit ADD
			#emit LOAD.I
			#emit PUSH.pri
		}
		#emit PUSH.S text
		#emit PUSH.C 144
		#emit PUSH.C str
		#emit PUSH.S 8
		#emit SYSREQ.C format
		#emit LCTRL 5
		#emit SCTRL 4

		SendClientMessage(playerid, color, str);

		#emit RETN
	}
	return 1;
}

LocalChat(playerid, Float:radi, string[], color1, color2, color3, color4)
{
	if (!IsPlayerConnected(playerid))
		return 0;

	new
		Float:currentPos[3],
		Float:oldPos[3],
		Float:checkPos[3]
	;

	GetPlayerPos(playerid, oldPos[0], oldPos[1], oldPos[2]);
	foreach (new i : Player)
	{
		if (!IsPlayerConnected(playerid)) continue;

		GetPlayerPos(i, currentPos[0], currentPos[1], currentPos[2]);
		for (new p = 0; p < 3; p++)
		{
			checkPos[p] = (oldPos[p] - currentPos[p]);
		}

		if (GetPlayerVirtualWorld(i) != GetPlayerVirtualWorld(playerid))
			continue;

		if (((checkPos[0] < radi/16) && (checkPos[0] > -radi/16)) && ((checkPos[1] < radi/16) && (checkPos[1] > -radi/16)) && ((checkPos[2] < radi/16) && (checkPos[2] > -radi/16)))
		{
			SendClientMessage(i, color1, string);
		}
		else if (((checkPos[0] < radi/8) && (checkPos[0] > -radi/8)) && ((checkPos[1] < radi/8) && (checkPos[1] > -radi/8)) && ((checkPos[2] < radi/8) && (checkPos[2] > -radi/8)))
		{
			SendClientMessage(i, color2, string);
		}
		else if (((checkPos[0] < radi/4) && (checkPos[0] > -radi/4)) && ((checkPos[1] < radi/4) && (checkPos[1] > -radi/4)) && ((checkPos[2] < radi/4) && (checkPos[2] > -radi/4)))
		{
			SendClientMessage(i, color3, string);
		}
		else if (((checkPos[0] < radi/2) && (checkPos[0] > -radi/2)) && ((checkPos[1] < radi/2) && (checkPos[1] > -radi/2)) && ((checkPos[2] < radi/2) && (checkPos[2] > -radi/2)))
		{
			SendClientMessage(i, color4, string);
		}
	}
	return 1;
}

stock AdminGonder(color, const str[], {Float,_}:...)
{
	static
	    args,
	    start,
	    end,
	    string[144]
	;
	#emit LOAD.S.pri 8
	#emit STOR.pri args

	if (args > 8)
	{
		#emit ADDR.pri str
		#emit STOR.pri start

	    for (end = start + (args - 8); end > start; end -= 4)
		{
	        #emit LREF.pri end
	        #emit PUSH.pri
		}
		#emit PUSH.S str
		#emit PUSH.C 144
		#emit PUSH.C string

		#emit LOAD.S.pri 8
		#emit ADD.C 4
		#emit PUSH.pri

		#emit SYSREQ.C format
		#emit LCTRL 5
		#emit SCTRL 4

        foreach (new i : Player)
		{
			if(Hesap[i][Awork] == true) {
				if (Hesap[i][Yonetici] > 1) {
					SendClientMessage(i, color, string);
				}
			}
		}
		return 1;
	}
	foreach (new i : Player)
	{
		if(Hesap[i][Awork] == true) {
			if (Hesap[i][Yonetici] > 1) {
				SendClientMessage(i, color, str);
			}
		}
	}
	return 1;
}

stock SupportGonder(color, const str[], {Float,_}:...)
{
	static
	    args,
	    start,
	    end,
	    string[144]
	;
	#emit LOAD.S.pri 8
	#emit STOR.pri args

	if (args > 8)
	{
		#emit ADDR.pri str
		#emit STOR.pri start

	    for (end = start + (args - 8); end > start; end -= 4)
		{
	        #emit LREF.pri end
	        #emit PUSH.pri
		}
		#emit PUSH.S str
		#emit PUSH.C 144
		#emit PUSH.C string

		#emit LOAD.S.pri 8
		#emit ADD.C 4
		#emit PUSH.pri

		#emit SYSREQ.C format
		#emit LCTRL 5
		#emit SCTRL 4

        foreach (new i : Player)
		{
			if(Hesap[i][Swork] == true) {
				if (Hesap[i][Yonetici] == 1) {
					SendClientMessage(i, color, string);
				}
			}
		}
		return 1;
	}
	foreach (new i : Player)
	{
		if(Hesap[i][Swork] == true) {
			if (Hesap[i][Yonetici] == 1) {
				SendClientMessage(i, color, str);
			}
		}
	}
	return 1;
}

HerkeseGonder(color, const text[], {Float, _}:...)
{
	static args, str[144];

	if((args = numargs()) == 2)
	{
	    SendClientMessageToAll(color, text);
	}
	else
	{
		while (--args >= 2)
		{
			#emit LCTRL 5
			#emit LOAD.alt args
			#emit SHL.C.alt 2
			#emit ADD.C 12
			#emit ADD
			#emit LOAD.I
			#emit PUSH.pri
		}
		#emit PUSH.S text
		#emit PUSH.C 144
		#emit PUSH.C str
		#emit LOAD.S.pri 8
		#emit ADD.C 4
		#emit PUSH.pri
		#emit SYSREQ.C format
		#emit LCTRL 5
		#emit SCTRL 4

		SendClientMessageToAll(color, str);
		#emit RETN
	}
	return true;
}

stock IsPlayerNearPlayer(playerid, targetid, Float:radius)
{
	static
		Float:fX,
		Float:fY,
		Float:fZ;

	GetPlayerPos(targetid, fX, fY, fZ);

	return (GetPlayerInterior(playerid) == GetPlayerInterior(targetid) && GetPlayerVirtualWorld(playerid) == GetPlayerVirtualWorld(targetid)) && IsPlayerInRangeOfPoint(playerid, radius, fX, fY, fZ);
}

Vice:GenelMesajGonder(playerid, mesaj[])
{
	new MesajString[1604];
    format(MesajString, sizeof(MesajString),"[VC] {FFFFFF}%s ", mesaj);
    SendClientMessage(playerid, 0x99C794FF, MesajString);
	return true;
}

Vice:YetersizYetki(playerid)
{
	return Sunucu(playerid, "Sunucuda böyle bir komut bulunmamaktadýr.");
}

Vice:YetersizPara(playerid)
{
	return Sunucu(playerid, "Üstünüzde yeterli para bulunmuyor.");
}

Vice:GirisYapmadi(playerid)
{
	return Sunucu(playerid, "Öncelikle sunucuya giriþ yapmalýsýnýz.");
}

Vice:ParaVer(playerid, miktar)
{
	Karakter[playerid][Para] += miktar;
	GivePlayerMoney(playerid, miktar);
	new gtext[80];
	if(miktar != 0)
	{
		if(miktar < 0)
		{
			format(gtext, sizeof(gtext), "~r~~h~%s$", NumaraFormati(miktar));
			GameTextForPlayer(playerid, gtext, 1000, 1);
		}
		else
		{
			format(gtext, sizeof(gtext), "~g~~h~+%s$", NumaraFormati(miktar));
			GameTextForPlayer(playerid, gtext, 1000, 1);
		}
	}
	return true;
}

stock GivePlayerHealth(playerid,Float:Health)
{
	new Float:health; GetPlayerHealth(playerid,health);
	Karakter[playerid][Can] += Health;
	SetPlayerHealth(playerid,health+Health);
}

stock ID_IsimGetir(playername[])
{
  	for(new i = 0; i <= MAX_PLAYERS; i++)
	{
	    if(IsPlayerConnected(i))
	    {
	      new playername2[MAX_PLAYER_NAME];
	      GetPlayerName(i, playername2, sizeof(playername2));
	      if(strcmp(playername2, playername, true, strlen(playername)) == 0)
	      {
	        return i;
	      }
	    }
	}
	return INVALID_PLAYER_ID;
}

stock SendMessageToChannel(ChannelId[],const string[])
{
	#if defined dcconnector_included
		new DCC_Channel:TargetChannel;
		if (_:TargetChannel == 0)
		TargetChannel = DCC_FindChannelById(ChannelId); // Discord channel ID
		DCC_SendChannelMessage(TargetChannel, string);
	#else
		format(ChannelId,36,"rgtsd %s",string); // to not get stupid warnnings (non effectable)
	#endif
	return 1;
}

stock TarihCek()
{
	static tarih[36];
	getdate(tarih[2], tarih[1], tarih[0]);
	gettime(tarih[3], tarih[4], tarih[5]);
	format(tarih, sizeof(tarih), "%02d/%02d/%d, %02d:%02d", tarih[0], tarih[1], tarih[2], tarih[3], tarih[4]);
	return tarih;
}

stock AnimOynat(playerid, animlib[], animname[], Float:fDelta, loop, lockx, locky, freeze, time, forcesync = 0)
{
    ApplyAnimation(playerid, animlib, "null", fDelta, loop, lockx, locky, freeze, time, forcesync); // Pre-load animation library
    Karakter[playerid][Anim] = true;
	return ApplyAnimation(playerid, animlib, animname, fDelta, loop, lockx, locky, freeze, time, forcesync);
}

Vice:KillAnim(playerid)
{
	ClearAnimations(playerid);
	return true;
}

Vice:YaraliYap(playerid)
{		
	if(Karakter[playerid][BayginDurum] == false)
	{
		if(IsPlayerInAnyVehicle(playerid)) RemovePlayerFromVehicle(playerid);
		Karakter[playerid][BayginDurum] = true;
		TogglePlayerControllable(playerid, false);
		Karakter[playerid][YaraliText] = CreateDynamic3DTextLabel("[BU OYUNCU YARALI]", 0xFF6347AA, 0, 0, 0.4, 20.0, playerid);
		if(Karakter[playerid][YaraliSuresi] <= 1) Karakter[playerid][YaraliSuresi] = 81;
		PlayerTextDrawShow(playerid, YaraliTD[playerid]);
		Karakter[playerid][YaraliTimeri] = SetTimerEx("YaraliTimer", TIMER_SANIYE, true, "i", playerid);
		Sunucu(playerid, "Yaralandýnýz, 80 saniye boyunca yerde kalacaksýnýz.");
		ApplyAnimation(playerid, "PED", "FLOOR_hit", 4.1, 0, 1, 1, 1, 0, 1);
	}
	return true;
}

Vice:YaraliBitir(playerid)
{
	KillTimer(Karakter[playerid][YaraliTimeri]);
	DestroyDynamic3DTextLabel(Karakter[playerid][YaraliText]);
	PlayerTextDrawHide(playerid, YaraliTD[playerid]);
	TogglePlayerControllable(playerid, true);
	ClearAnimations(playerid);
	Sunucu(playerid, "Yaralý durumunuz sona erdi ve ayaða kalktýnýz.");
	Karakter[playerid][Yarali] = 0;
	Karakter[playerid][BayginDurum] = false;
	return true;
}

Vice:YaraliTimer(playerid)
{
	if(GetPlayerAnimationIndex(playerid) != 1150) ApplyAnimation(playerid, "PED", "FLOOR_hit", 4.1, 0, 1, 1, 1, 0, 1);
	new yaralimesaj[24];
	Karakter[playerid][YaraliSuresi]--;
	format(yaralimesaj, sizeof(yaralimesaj), "Yaralisin:_%d_saniye", Karakter[playerid][YaraliSuresi]);
	PlayerTextDrawSetString(playerid, YaraliTD[playerid], yaralimesaj);
	if(Karakter[playerid][YaraliSuresi] < 1)
	{
		YaraliBitir(playerid);
	}
	return true;
}

Vice:SifreGiris(playerid)
{
	Sunucu(playerid, "30 saniye içinde þifrenizi girmediðiniz için atýldýnýz.");
	KillTimer(Hesap[playerid][SifreGirisTimer]);
	KickEx(playerid);
	return 1;
}

Vice:OyuncuCoz(playerid)
{
	if(Karakter[playerid][Yarali] != 1)
	{
		TogglePlayerControllable(playerid, true);
	}
	return true;
}

stock OyuncuYakin(playerid, hedefid, Float:menzil = 4.0)
{
	if(IsPlayerConnected(playerid) && IsPlayerConnected(hedefid))
	{
		new Float:x, Float:y, Float:z;
		GetPlayerPos(playerid, x, y, z);
		if(IsPlayerInRangeOfPoint(hedefid, menzil, x, y, z) && GetPlayerVirtualWorld(playerid) == GetPlayerVirtualWorld(hedefid) && GetPlayerInterior(playerid) == GetPlayerInterior(hedefid)) return 1;
	}
	return 0;
}

stock NumaraFormati(numara, onek[] = "$")
{
	static mesaj[32], length;
	format(mesaj, sizeof(mesaj), "%d", (numara < 0) ? (-numara) : (numara));

	if((length = strlen(mesaj)) > 3)
	{
		for (new i = length, l = 0; --i >= 0; l ++) {
			if((l > 0) && (l % 3 == 0)) strins(mesaj, ",", i + 1);
		}
	}
	if(onek[0] != 0)
		strins(mesaj, onek, 0);

	if(numara < 0)
		strins(mesaj, "-", 0);

	return mesaj;
}

Vice:KarakterMenuYukle(playerid)
{
	switch(Hesap[playerid][KarakterSecim][0])
	{
		case 1:
		{
			PlayerTextDrawSetPreviewModel(playerid, KarakterSecimTD[5][playerid], Hesap[playerid][KarakterSkin][0]);
			PlayerTextDrawSetString(playerid, KarakterSecimTD[0][playerid], Hesap[playerid][Karakter1]);
		}
		default:
		{
			PlayerTextDrawSetPreviewModel(playerid, KarakterSecimTD[5][playerid], 0);
			PlayerTextDrawSetString(playerid, KarakterSecimTD[0][playerid], "Bos_Slot");
		}
	}
	switch(Hesap[playerid][KarakterSecim][1])
	{
		case 1:
		{
			PlayerTextDrawSetPreviewModel(playerid, KarakterSecimTD[2][playerid], Hesap[playerid][KarakterSkin][1]);
			PlayerTextDrawSetString(playerid, KarakterSecimTD[1][playerid], Hesap[playerid][Karakter2]);
		}
		default:
		{
			PlayerTextDrawSetPreviewModel(playerid, KarakterSecimTD[2][playerid], 0);
			PlayerTextDrawSetString(playerid, KarakterSecimTD[1][playerid], "Bos_Slot");
		}
	}
	switch(Hesap[playerid][KarakterSecim][2])
	{
		case 1:
		{
			PlayerTextDrawSetPreviewModel(playerid, KarakterSecimTD[4][playerid], Hesap[playerid][KarakterSkin][2]);
			PlayerTextDrawSetString(playerid, KarakterSecimTD[3][playerid], Hesap[playerid][Karakter3]);
		}
		default:
		{
			PlayerTextDrawSetPreviewModel(playerid, KarakterSecimTD[4][playerid], 0);
			PlayerTextDrawSetString(playerid, KarakterSecimTD[3][playerid], "Bos_Slot");
		}
	}
	switch(Hesap[playerid][KarakterSecim][3])
	{
		case 1:
		{
			PlayerTextDrawSetPreviewModel(playerid, KarakterSecimTD[7][playerid], Hesap[playerid][KarakterSkin][3]);
			PlayerTextDrawSetString(playerid, KarakterSecimTD[6][playerid], Hesap[playerid][Karakter4]);
		}
		default:
		{
			PlayerTextDrawSetPreviewModel(playerid, KarakterSecimTD[7][playerid], 0);
			PlayerTextDrawSetString(playerid, KarakterSecimTD[6][playerid], "Bos_Slot");
		}
	}
	for(new i = 0; i < 8; i++)
	{
		PlayerTextDrawShow(playerid, KarakterSecimTD[i][playerid]);
	}
	Hesap[playerid][KarakterSeciminde] = 1;
	return true;
}

Vice:KarakterMenuGizle(playerid)
{
	for(new i = 0; i < 8; i++)
	{
		PlayerTextDrawHide(playerid, KarakterSecimTD[i][playerid]);
	}
	return true;
}

Vice:SenkronAyarla(playerid)
{
	SetPlayerPos(playerid, Karakter[playerid][SonPos][0], Karakter[playerid][SonPos][1], Karakter[playerid][SonPos][2]);
	SetPlayerFacingAngle(playerid, Karakter[playerid][SonPos][3]);
	SetPlayerCameraPos(playerid, Karakter[playerid][SonPos][0], Karakter[playerid][SonPos][1], Karakter[playerid][SonPos][2] + 2.5);
	SetPlayerCameraLookAt(playerid, Karakter[playerid][SonPos][0], Karakter[playerid][SonPos][1], Karakter[playerid][SonPos][2]);
	SetPlayerInterior(playerid, Karakter[playerid][Interior]);
	SetPlayerVirtualWorld(playerid, Karakter[playerid][VW]);	
	SetCameraBehindPlayer(playerid);
    SetPlayerSkin(playerid, Karakter[playerid][Skin]); 
    SetPlayerHealth(playerid, Karakter[playerid][Can]);
    SetPlayerArmour(playerid, Karakter[playerid][Zirh]);
	return true;
}

stock IsNumeric(const str[])
{
	for (new i = 0, l = strlen(str); i != l; i ++)
	{
		if(i == 0 && str[0] == '-')
			continue;

		else if(str[i] < '0' || str[i] > '9')
			return 0;
	}
	return 1;
}

stock cmd(playerid, durum, sz_komut[])
{
	new str[1024];
	switch(durum)
	{
		case 0:
		{
			format(str, sizeof(str), "/%s", sz_komut);
			PC_EmulateCommand(playerid, str);
		}
		case 1:
		{
			format(str, sizeof(str), "%s %s", RPIsim(playerid), sz_komut);
			SendNearbyMessage(playerid, 20.0, RENK_MOR, str);
		}
		case 2:
		{
			format(str, sizeof(str), "%s (( %s ))", sz_komut, RPIsim(playerid));
			SendNearbyMessage(playerid, 20.0, 0x80CAADFF, str);
		}
	}
	return 1;
}

stock YuzdeHesapla(sayi, Float:yuzde)
{
	new Float:sonuc;
	sonuc = (sayi * yuzde) / 100.0;
	return floatround(sonuc, floatround_round);
}

stock OyuncuHiziniCek(playerid, bool:mph = true)
{
	new
	Float:xx,
	Float:yy,
	Float:zz,
	Float:pSpeed;

	if(IsPlayerInAnyVehicle(playerid))
	{
		GetVehicleVelocity(GetPlayerVehicleID(playerid),xx,yy,zz);
	}
	else
	{
		GetPlayerVelocity(playerid,xx,yy,zz);
	}

	pSpeed = floatsqroot((xx * xx) + (yy * yy) + (zz * zz));
	return mph ? floatround((pSpeed * 165.12)) : floatround((pSpeed * 103.9));
}

stock AracHizKontrol(playerid)
{
	if(IsPlayerInAnyVehicle(playerid)) {
		static Float:fSpeed, Float:fVelocity[3];
		GetVehicleVelocity(GetPlayerVehicleID(playerid), fVelocity[0], fVelocity[1], fVelocity[2]);
		fSpeed = floatmul(floatsqroot((fVelocity[0] * fVelocity[0]) + (fVelocity[1] * fVelocity[1]) + (fVelocity[2] * fVelocity[2])), 100.0);
		return floatround(fSpeed, floatround_round);
	}
	return 0;
}

stock YetkiIsim(playerid)
{
	new yetki = Hesap[playerid][Yonetici], yetkiisim[32];
	switch(yetki)
	{
		case 0: yetkiisim = "Yok";
		case 1..5: yetkiisim = "Oyun Yetkilisi";
		case 6,7: yetkiisim = "Genel Yetkili";
		case 8: yetkiisim = "Developer";
		case 9: yetkiisim = "Yönetici";
	}
	return yetkiisim;
}

stock LokasyonBul(Float:fX, Float:fY, Float:fZ)
{
	enum bolgeBilgi
	{
		bolgeAdi[32 char],
		Float:bolgePos[6]
	};
	new const bolgelerBilgi[][bolgeBilgi] =
	{
		{!"Blueberry",                    {104.50, -220.10, 2.30, 349.60, 152.20, 200.00}},
		{!"Blueberry",                    {19.60, -404.10, 3.80, 349.60, -220.10, 200.00}},
		{!"Blueberry Acres",              {-319.60, -220.10, 0.00, 104.50, 293.30, 200.00}},
		{!"Commerce",                     {1323.90, -1842.20, -89.00, 1701.90, -1722.20, 110.90}},
		{!"Commerce",                     {1323.90, -1722.20, -89.00, 1440.90, -1577.50, 110.90}},
		{!"Commerce",                     {1370.80, -1577.50, -89.00, 1463.90, -1384.90, 110.90}},
		{!"Commerce",                     {1463.90, -1577.50, -89.00, 1667.90, -1430.80, 110.90}},
		{!"Commerce",                     {1583.50, -1722.20, -89.00, 1758.90, -1577.50, 110.90}},
		{!"Commerce",                     {1667.90, -1577.50, -89.00, 1812.60, -1430.80, 110.90}},
		{!"Conference Center",            {1046.10, -1804.20, -89.00, 1323.90, -1722.20, 110.90}},
		{!"Conference Center",            {1073.20, -1842.20, -89.00, 1323.90, -1804.20, 110.90}},
		{!"Cranberry Station",            {-2007.80, 56.30, 0.00, -1922.00, 224.70, 100.00}},
		{!"Creek",                        {2749.90, 1937.20, -89.00, 2921.60, 2669.70, 110.90}},
		{!"Dillimore",                    {580.70, -674.80, -9.50, 861.00, -404.70, 200.00}},
		{!"Doherty",                      {-2270.00, -324.10, -0.00, -1794.90, -222.50, 200.00}},
		{!"Doherty",                      {-2173.00, -222.50, -0.00, -1794.90, 265.20, 200.00}},
		{!"Downtown",                     {-1982.30, 744.10, -6.10, -1871.70, 1274.20, 200.00}},
		{!"Downtown",                     {-1871.70, 1176.40, -4.50, -1620.30, 1274.20, 200.00}},
		{!"Downtown",                     {-1700.00, 744.20, -6.10, -1580.00, 1176.50, 200.00}},
		{!"Downtown",                     {-1580.00, 744.20, -6.10, -1499.80, 1025.90, 200.00}},
		{!"Downtown",                     {-2078.60, 578.30, -7.60, -1499.80, 744.20, 200.00}},
		{!"Downtown",                     {-1993.20, 265.20, -9.10, -1794.90, 578.30, 200.00}},
		{!"Downtown Los Santos",          {1463.90, -1430.80, -89.00, 1724.70, -1290.80, 110.90}},
		{!"Downtown Los Santos",          {1724.70, -1430.80, -89.00, 1812.60, -1250.90, 110.90}},
		{!"Downtown Los Santos",          {1463.90, -1290.80, -89.00, 1724.70, -1150.80, 110.90}},
		{!"Downtown Los Santos",          {1370.80, -1384.90, -89.00, 1463.90, -1170.80, 110.90}},
		{!"Downtown Los Santos",          {1724.70, -1250.90, -89.00, 1812.60, -1150.80, 110.90}},
		{!"Downtown Los Santos",          {1370.80, -1170.80, -89.00, 1463.90, -1130.80, 110.90}},
		{!"Downtown Los Santos",          {1378.30, -1130.80, -89.00, 1463.90, -1026.30, 110.90}},
		{!"Downtown Los Santos",          {1391.00, -1026.30, -89.00, 1463.90, -926.90, 110.90}},
		{!"Downtown Los Santos",          {1507.50, -1385.20, 110.90, 1582.50, -1325.30, 335.90}},
		{!"East Beach",                   {2632.80, -1852.80, -89.00, 2959.30, -1668.10, 110.90}},
		{!"East Beach",                   {2632.80, -1668.10, -89.00, 2747.70, -1393.40, 110.90}},
		{!"East Beach",                   {2747.70, -1668.10, -89.00, 2959.30, -1498.60, 110.90}},
		{!"East Beach",                   {2747.70, -1498.60, -89.00, 2959.30, -1120.00, 110.90}},
		{!"East Los Santos",              {2421.00, -1628.50, -89.00, 2632.80, -1454.30, 110.90}},
		{!"East Los Santos",              {2222.50, -1628.50, -89.00, 2421.00, -1494.00, 110.90}},
		{!"East Los Santos",              {2266.20, -1494.00, -89.00, 2381.60, -1372.00, 110.90}},
		{!"East Los Santos",              {2381.60, -1494.00, -89.00, 2421.00, -1454.30, 110.90}},
		{!"East Los Santos",              {2281.40, -1372.00, -89.00, 2381.60, -1135.00, 110.90}},
		{!"East Los Santos",              {2381.60, -1454.30, -89.00, 2462.10, -1135.00, 110.90}},
		{!"East Los Santos",              {2462.10, -1454.30, -89.00, 2581.70, -1135.00, 110.90}},
		{!"Ganton",                       {2222.50, -1852.80, -89.00, 2632.80, -1722.30, 110.90}},
		{!"Ganton",                       {2222.50, -1722.30, -89.00, 2632.80, -1628.50, 110.90}},
		{!"Garcia",                       {-2411.20, -222.50, -0.00, -2173.00, 265.20, 200.00}},
		{!"Garcia",                       {-2395.10, -222.50, -5.30, -2354.00, -204.70, 200.00}},
		{!"Glen Park",                    {1812.60, -1449.60, -89.00, 1996.90, -1350.70, 110.90}},
		{!"Glen Park",                    {1812.60, -1100.80, -89.00, 1994.30, -973.30, 110.90}},
		{!"Glen Park",                    {1812.60, -1350.70, -89.00, 2056.80, -1100.80, 110.90}},
		{!"Green Palms",                  {176.50, 1305.40, -3.00, 338.60, 1520.70, 200.00}},
		{!"Idlewood",                     {1812.60, -1852.80, -89.00, 1971.60, -1742.30, 110.90}},
		{!"Idlewood",                     {1812.60, -1742.30, -89.00, 1951.60, -1602.30, 110.90}},
		{!"Idlewood",                     {1951.60, -1742.30, -89.00, 2124.60, -1602.30, 110.90}},
		{!"Idlewood",                     {1812.60, -1602.30, -89.00, 2124.60, -1449.60, 110.90}},
		{!"Idlewood",                     {2124.60, -1742.30, -89.00, 2222.50, -1494.00, 110.90}},
		{!"Idlewood",                     {1971.60, -1852.80, -89.00, 2222.50, -1742.30, 110.90}},
		{!"Jefferson",                    {1996.90, -1449.60, -89.00, 2056.80, -1350.70, 110.90}},
		{!"Jefferson",                    {2124.60, -1494.00, -89.00, 2266.20, -1449.60, 110.90}},
		{!"Jefferson",                    {2056.80, -1372.00, -89.00, 2281.40, -1210.70, 110.90}},
		{!"Jefferson",                    {2056.80, -1210.70, -89.00, 2185.30, -1126.30, 110.90}},
		{!"Jefferson",                    {2185.30, -1210.70, -89.00, 2281.40, -1154.50, 110.90}},
		{!"Jefferson",                    {2056.80, -1449.60, -89.00, 2266.20, -1372.00, 110.90}},
		{!"Las Colinas",                  {1994.30, -1100.80, -89.00, 2056.80, -920.80, 110.90}},
		{!"Las Colinas",                  {2056.80, -1126.30, -89.00, 2126.80, -920.80, 110.90}},
		{!"Las Colinas",                  {2185.30, -1154.50, -89.00, 2281.40, -934.40, 110.90}},
		{!"Las Colinas",                  {2126.80, -1126.30, -89.00, 2185.30, -934.40, 110.90}},
		{!"Las Colinas",                  {2747.70, -1120.00, -89.00, 2959.30, -945.00, 110.90}},
		{!"Las Colinas",                  {2632.70, -1135.00, -89.00, 2747.70, -945.00, 110.90}},
		{!"Las Colinas",                  {2281.40, -1135.00, -89.00, 2632.70, -945.00, 110.90}},
		{!"Las Payasadas",                {-354.30, 2580.30, 2.00, -133.60, 2816.80, 200.00}},
		{!"Little Mexico",                {1701.90, -1842.20, -89.00, 1812.60, -1722.20, 110.90}},
		{!"Little Mexico",                {1758.90, -1722.20, -89.00, 1812.60, -1577.50, 110.90}},
		{!"Los Flores",                   {2581.70, -1454.30, -89.00, 2632.80, -1393.40, 110.90}},
		{!"Los Flores",                   {2581.70, -1393.40, -89.00, 2747.70, -1135.00, 110.90}},
		{!"Los Santos International",     {1249.60, -2394.30, -89.00, 1852.00, -2179.20, 110.90}},
		{!"Los Santos International",     {1852.00, -2394.30, -89.00, 2089.00, -2179.20, 110.90}},
		{!"Los Santos International",     {1382.70, -2730.80, -89.00, 2201.80, -2394.30, 110.90}},
		{!"Los Santos International",     {1974.60, -2394.30, -39.00, 2089.00, -2256.50, 60.90}},
		{!"Los Santos International",     {1400.90, -2669.20, -39.00, 2189.80, -2597.20, 60.90}},
		{!"Los Santos International",     {2051.60, -2597.20, -39.00, 2152.40, -2394.30, 60.90}},
		{!"Marina",                       {647.70, -1804.20, -89.00, 851.40, -1577.50, 110.90}},
		{!"Marina",                       {647.70, -1577.50, -89.00, 807.90, -1416.20, 110.90}},
		{!"Marina",                       {807.90, -1577.50, -89.00, 926.90, -1416.20, 110.90}},
		{!"Market",                       {787.40, -1416.20, -89.00, 1072.60, -1310.20, 110.90}},
		{!"Market",                       {952.60, -1310.20, -89.00, 1072.60, -1130.80, 110.90}},
		{!"Market",                       {1072.60, -1416.20, -89.00, 1370.80, -1130.80, 110.90}},
		{!"Market",                       {926.90, -1577.50, -89.00, 1370.80, -1416.20, 110.90}},
		{!"Market Station",               {787.40, -1410.90, -34.10, 866.00, -1310.20, 65.80}},
		{!"Martin Bridge",                {-222.10, 293.30, 0.00, -122.10, 476.40, 200.00}},
		{!"Missionary Hill",              {-2994.40, -811.20, 0.00, -2178.60, -430.20, 200.00}},
		{!"Montgomery",                   {1119.50, 119.50, -3.00, 1451.40, 493.30, 200.00}},
		{!"Montgomery",                   {1451.40, 347.40, -6.10, 1582.40, 420.80, 200.00}},
		{!"Montgomery Intersection",      {1546.60, 208.10, 0.00, 1745.80, 347.40, 200.00}},
		{!"Montgomery Intersection",      {1582.40, 347.40, 0.00, 1664.60, 401.70, 200.00}},
		{!"Mulholland",                   {1414.00, -768.00, -89.00, 1667.60, -452.40, 110.90}},
		{!"Mulholland",                   {1281.10, -452.40, -89.00, 1641.10, -290.90, 110.90}},
		{!"Mulholland",                   {1269.10, -768.00, -89.00, 1414.00, -452.40, 110.90}},
		{!"Mulholland",                   {1357.00, -926.90, -89.00, 1463.90, -768.00, 110.90}},
		{!"Mulholland",                   {1318.10, -910.10, -89.00, 1357.00, -768.00, 110.90}},
		{!"Mulholland",                   {1169.10, -910.10, -89.00, 1318.10, -768.00, 110.90}},
		{!"Mulholland",                   {768.60, -954.60, -89.00, 952.60, -860.60, 110.90}},
		{!"Mulholland",                   {687.80, -860.60, -89.00, 911.80, -768.00, 110.90}},
		{!"Mulholland",                   {737.50, -768.00, -89.00, 1142.20, -674.80, 110.90}},
		{!"Mulholland",                   {1096.40, -910.10, -89.00, 1169.10, -768.00, 110.90}},
		{!"Mulholland",                   {952.60, -937.10, -89.00, 1096.40, -860.60, 110.90}},
		{!"Mulholland",                   {911.80, -860.60, -89.00, 1096.40, -768.00, 110.90}},
		{!"Mulholland",                   {861.00, -674.80, -89.00, 1156.50, -600.80, 110.90}},
		{!"Mulholland Intersection",      {1463.90, -1150.80, -89.00, 1812.60, -768.00, 110.90}},
		{!"North Rock",                   {2285.30, -768.00, 0.00, 2770.50, -269.70, 200.00}},
		{!"Ocean Docks",                  {2373.70, -2697.00, -89.00, 2809.20, -2330.40, 110.90}},
		{!"Ocean Docks",                  {2201.80, -2418.30, -89.00, 2324.00, -2095.00, 110.90}},
		{!"Ocean Docks",                  {2324.00, -2302.30, -89.00, 2703.50, -2145.10, 110.90}},
		{!"Ocean Docks",                  {2089.00, -2394.30, -89.00, 2201.80, -2235.80, 110.90}},
		{!"Ocean Docks",                  {2201.80, -2730.80, -89.00, 2324.00, -2418.30, 110.90}},
		{!"Ocean Docks",                  {2703.50, -2302.30, -89.00, 2959.30, -2126.90, 110.90}},
		{!"Ocean Docks",                  {2324.00, -2145.10, -89.00, 2703.50, -2059.20, 110.90}},
		{!"Richman",                      {647.50, -1118.20, -89.00, 787.40, -954.60, 110.90}},
		{!"Richman",                      {647.50, -954.60, -89.00, 768.60, -860.60, 110.90}},
		{!"Richman",                      {225.10, -1369.60, -89.00, 334.50, -1292.00, 110.90}},
		{!"Richman",                      {225.10, -1292.00, -89.00, 466.20, -1235.00, 110.90}},
		{!"Richman",                      {72.60, -1404.90, -89.00, 225.10, -1235.00, 110.90}},
		{!"Richman",                      {72.60, -1235.00, -89.00, 321.30, -1008.10, 110.90}},
		{!"Richman",                      {321.30, -1235.00, -89.00, 647.50, -1044.00, 110.90}},
		{!"Richman",                      {321.30, -1044.00, -89.00, 647.50, -860.60, 110.90}},
		{!"Richman",                      {321.30, -860.60, -89.00, 687.80, -768.00, 110.90}},
		{!"Richman",                      {321.30, -768.00, -89.00, 700.70, -674.80, 110.90}},
		{!"Rodeo",                        {72.60, -1684.60, -89.00, 225.10, -1544.10, 110.90}},
		{!"Rodeo",                        {72.60, -1544.10, -89.00, 225.10, -1404.90, 110.90}},
		{!"Rodeo",                        {225.10, -1684.60, -89.00, 312.80, -1501.90, 110.90}},
		{!"Rodeo",                        {225.10, -1501.90, -89.00, 334.50, -1369.60, 110.90}},
		{!"Rodeo",                        {334.50, -1501.90, -89.00, 422.60, -1406.00, 110.90}},
		{!"Rodeo",                        {312.80, -1684.60, -89.00, 422.60, -1501.90, 110.90}},
		{!"Rodeo",                        {422.60, -1684.60, -89.00, 558.00, -1570.20, 110.90}},
		{!"Rodeo",                        {558.00, -1684.60, -89.00, 647.50, -1384.90, 110.90}},
		{!"Rodeo",                        {466.20, -1570.20, -89.00, 558.00, -1385.00, 110.90}},
		{!"Rodeo",                        {422.60, -1570.20, -89.00, 466.20, -1406.00, 110.90}},
		{!"Rodeo",                        {466.20, -1385.00, -89.00, 647.50, -1235.00, 110.90}},
		{!"Rodeo",                        {334.50, -1406.00, -89.00, 466.20, -1292.00, 110.90}},
		{!"Santa Maria Beach",            {342.60, -2173.20, -89.00, 647.70, -1684.60, 110.90}},
		{!"Santa Maria Beach",            {72.60, -2173.20, -89.00, 342.60, -1684.60, 110.90}},
		{!"Temple",                       {1252.30, -1130.80, -89.00, 1378.30, -1026.30, 110.90}},
		{!"Temple",                       {1252.30, -1026.30, -89.00, 1391.00, -926.90, 110.90}},
		{!"Temple",                       {1252.30, -926.90, -89.00, 1357.00, -910.10, 110.90}},
		{!"Temple",                       {952.60, -1130.80, -89.00, 1096.40, -937.10, 110.90}},
		{!"Temple",                       {1096.40, -1130.80, -89.00, 1252.30, -1026.30, 110.90}},
		{!"Temple",                       {1096.40, -1026.30, -89.00, 1252.30, -910.10, 110.90}},
		{!"Verdant Bluffs",               {930.20, -2488.40, -89.00, 1249.60, -2006.70, 110.90}},
		{!"Verdant Bluffs",               {1073.20, -2006.70, -89.00, 1249.60, -1842.20, 110.90}},
		{!"Verdant Bluffs",               {1249.60, -2179.20, -89.00, 1692.60, -1842.20, 110.90}},
		{!"Verdant Meadows",              {37.00, 2337.10, -3.00, 435.90, 2677.90, 200.00}},
		{!"Verona Beach",                 {647.70, -2173.20, -89.00, 930.20, -1804.20, 110.90}},
		{!"Verona Beach",                 {930.20, -2006.70, -89.00, 1073.20, -1804.20, 110.90}},
		{!"Verona Beach",                 {851.40, -1804.20, -89.00, 1046.10, -1577.50, 110.90}},
		{!"Verona Beach",                 {1161.50, -1722.20, -89.00, 1323.90, -1577.50, 110.90}},
		{!"Verona Beach",                 {1046.10, -1722.20, -89.00, 1161.50, -1577.50, 110.90}},
		{!"Vinewood",                     {787.40, -1310.20, -89.00, 952.60, -1130.80, 110.90}},
		{!"Vinewood",                     {787.40, -1130.80, -89.00, 952.60, -954.60, 110.90}},
		{!"Vinewood",                     {647.50, -1227.20, -89.00, 787.40, -1118.20, 110.90}},
		{!"Vinewood",                     {647.70, -1416.20, -89.00, 787.40, -1227.20, 110.90}},
		{!"Willowfield",                  {1970.60, -2179.20, -89.00, 2089.00, -1852.80, 110.90}},
		{!"Willowfield",                  {2089.00, -2235.80, -89.00, 2201.80, -1989.90, 110.90}},
		{!"Willowfield",                  {2089.00, -1989.90, -89.00, 2324.00, -1852.80, 110.90}},
		{!"Willowfield",                  {2201.80, -2095.00, -89.00, 2324.00, -1989.90, 110.90}},
		{!"Willowfield",                  {2541.70, -1941.40, -89.00, 2703.50, -1852.80, 110.90}},
		{!"Willowfield",                  {2324.00, -2059.20, -89.00, 2541.70, -1852.80, 110.90}},
		{!"Willowfield",                  {2541.70, -2059.20, -89.00, 2703.50, -1941.40, 110.90}},
		{!"Los Santos",                   {44.60, -2892.90, -242.90, 2997.00, -768.00, 900.00}},
		{!"Las Venturas",                 {869.40, 596.30, -242.90, 2997.00, 2993.80, 900.00}},
		{!"Bone County",                  {-480.50, 596.30, -242.90, 869.40, 2993.80, 900.00}},
		{!"Tierra Robada",                {-2997.40, 1659.60, -242.90, -480.50, 2993.80, 900.00}},
		{!"Tierra Robada",                {-1213.90, 596.30, -242.90, -480.50, 1659.60, 900.00}},
		{!"San Fierro",                   {-2997.40, -1115.50, -242.90, -1213.90, 1659.60, 900.00}},
		{!"Red County",                   {-1213.90, -768.00, -242.90, 2997.00, 596.30, 900.00}},
		{!"Flint County",                 {-1213.90, -2892.90, -242.90, 44.60, -768.00, 900.00}},
		{!"Whetstone",                    {-2997.40, -2892.90, -242.90, -1213.90, -1115.50, 900.00}}
	};
	static isim[32] = "Vice City";

	for (new i = 0; i != sizeof(bolgelerBilgi); i ++) if((fX >= bolgelerBilgi[i][bolgePos][0] && fX <= bolgelerBilgi[i][bolgePos][3]) && (fY >= bolgelerBilgi[i][bolgePos][1] && fY <= bolgelerBilgi[i][bolgePos][4]) && (fZ >= bolgelerBilgi[i][bolgePos][2] && fZ <= bolgelerBilgi[i][bolgePos][5])) {
		strunpack(isim, bolgelerBilgi[i][bolgeAdi]);
		break;
	}
	return isim;
}

stock GetPosBehindVehicle(vehicleid, &Float:x, &Float:y, &Float:z, Float:offset=0.5)
{
	new Float:vehicleSize[3], Float:vehiclePos[3];
	GetVehiclePos(vehicleid, vehiclePos[0], vehiclePos[1], vehiclePos[2]);
	GetVehicleModelInfo(GetVehicleModel(vehicleid), VEHICLE_MODEL_INFO_SIZE, vehicleSize[0], vehicleSize[1], vehicleSize[2]);
	GetXYBehindVehicle(vehicleid, vehiclePos[0], vehiclePos[1], (vehicleSize[1]/2)+offset);
	x = vehiclePos[0];
	y = vehiclePos[1];
	z = vehiclePos[2];
	return 1;
}

stock GetXYBehindVehicle(vehicleid, &Float:q, &Float:w, Float:distance)
{
	new Float:a;
	GetVehiclePos(vehicleid, q, w, a);
	GetVehicleZAngle(vehicleid, a);
	q += (distance * -floatsin(-a, degrees));
	w += (distance * -floatcos(-a, degrees));
}

stock GetVehicleRotation(vehicleid,&Float:rx,&Float:ry,&Float:rz)
{
	new Float:qw,Float:qx,Float:qy,Float:qz;
	GetVehicleRotationQuat(vehicleid,qw,qx,qy,qz);
	rx = asin(2*qy*qz-2*qx*qw);
	ry = -atan2(qx*qz+qy*qw,0.5-qx*qx-qy*qy);
	rz = -atan2(qx*qy+qz*qw,0.5-qx*qx-qz*qz);
}

Vice: Float:GetVehicleSpeed2(vehicleid, Miles)
{
	new Float:Speed[4];
	GetVehicleVelocity(vehicleid, Speed[0], Speed[1], Speed[2]);
	if(Miles == 0) Speed[3] = floatsqroot(((Speed[0] * Speed[0]) + (Speed[1] * Speed[1])) + (Speed[2] * Speed[2])) * 136.666667;
	else Speed[3] = floatsqroot(((Speed[0] * Speed[0]) + (Speed[1] * Speed[1])) + (Speed[2] * Speed[2])) * 85.4166672;
	floatround(Speed[3], floatround_round);
	return Speed[3];
}

Vice:Log_Kaydet(const path[], const str[], {Float,_}:...)
{
	static args, start, end, File:file, string[1024];
	if((start = strfind(path, "/")) != -1) {
		strmid(string, path, 0, start + 1);

		if(!fexist(string))
			return printf("Girilen log klasörü geçersiz. (%s)", string);
	}
	#emit LOAD.S.pri 8
	#emit STOR.pri args

	file = fopen(path, io_append);

	if(!file)
		return 0;

	if(args > 8)
	{
	#emit ADDR.pri str
	#emit STOR.pri start

		for (end = start + (args - 8); end > start; end -= 4)
		{
        #emit LREF.pri end
        #emit PUSH.pri
		}
	#emit PUSH.S str
	#emit PUSH.C 1024
	#emit PUSH.C string
	#emit PUSH.C args
	#emit SYSREQ.C format

		fwrite(file, string);
		fwrite(file, "\r\n");
		fclose(file);

	#emit LCTRL 5
	#emit SCTRL 4
	#emit RETN
	}
	fwrite(file, str);
	fwrite(file, "\r\n");
	fclose(file);
	return 1;
}