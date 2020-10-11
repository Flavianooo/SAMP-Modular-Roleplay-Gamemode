#include <a_samp>
#include <a_mysql> // r41-3
#include <easyDialog>
#include <Pawn.CMD>
#include <streamer>
#include <foreach>
#include <crashdetect>
#include <sscanf2>
#include <bcrypt>
#include <dialogs>
#include <easyvehicle>
#include <mapandreas>
#include <progress2>
//#include <FCNPC>
#include <AnimFix>

#define MOD_ADI				"Vice Roleplay ~ vice-rp.com"
#define MOD_SURUM			"VC:RP"
#define MOD_GELISTIRICI		"Flaviano"
#define MOD_SIFRE			"123123"
#define MOD_DIL				"T�rk�e/Turkish"
#define MOD_WEBSITE			"website"	

#define MYSQL_BAGLANTI		(1) // 1:localhost 2:vds

#define LSQL_SUNUCU			"localhost"
#define LSQL_KULLANICI		"username"
#define LSQL_SIFRE			"password"
#define LSQL_VERITABANI		"dbname"

#define VSQL_SUNUCU			"hostname"
#define VSQL_KULLANICI		"username"
#define VSQL_SIFRE			"password"
#define VSQL_VERITABANI		"dbname"

#define Vice:%0(%1) forward %0(%1); public %0(%1)

#define Sunucu(%0,%1) \
	SendClientMessageEx(%0, 0x99C794FF, "[VC] {C8C8C8}"%1)

#define Kullanim(%0,%1) \
	SendClientMessageEx(%0, RENK_MAVI, "[VC] {C8C8C8}"%1)

#define SunucuEx(%0,%1) \
	SendClientMessageEx(%0, 0x99C794FF, "{C8C8C8}"%1)

#define Roleplay_Isim_Kontrol_Degil 		(0)
#define Roleplay_Isim_Kontrol_Evet 			(1)
#define Roleplay_Isim_Kontrol_Sapkali 		(2)
#define Roleplay_Isim_Kontrol_Rakamli 		(3)
#define Karakter_Adi_Var					(0)
#define Karakter_Adi_Yok					(1)

#define TIMER_SANIYE	(742)

// F�YATLANDIRMALAR

#define KIYAFET_UCRET	(300)
#define BALIK_SATIS 	(40)

// RENKLER

#define RENK_VICE		(0x99C794FF)
#define RENK_ADMIN		(0xfa5555AA)
#define	RENK_KARA1 		(0xE6E6E6E6)
#define RENK_KARA2 		(0xC8C8C8C8)
#define RENK_KARA3 		(0xAAAAAAAA)
#define RENK_KARA4 		(0x8C8C8C8C)
#define RENK_KARA5 		(0x6E6E6E6E)
#define RENK_MAVI		(0x3C5DA5FF)
#define RENK_MOR 		(0xD0AEEBFF)
#define	RENK_PEMBE 		(0xFF8282FF)
#define	RENK_SARI 		(0xFFFF0000)
#define	RENK_PM			(0xFFBB0000)
#define RENK_KOYUYESIL	(0x33AA33FF)
#define RENK_GRI		(0xAFAFAFFF)
#define RENK_VARSAYILAN	(0xFFFFFFFF)

// S�STEM KISITLAMALARI

#define MAKSIMUM_RAPOR			120
#define MAKSIMUM_BALIK_BOLGE	50
#define MAKSIMUM_BINA			200
#define MAKSIMUM_EV				600
#define MAKSIMUM_ISYERI			600
#define MAX_CIFTLIK             100
#define MAX_BIRLIK				1000

// S�LAH DURUM TANIMLAMALARI

#define SILAH_USTUNDE	0
#define SILAH_ARACTA	1
#define SILAH_EVDE		2

// OYUNCU KISITLAMALARI

#define MAX_OYUNCU_ARAC		15
#define MAX_OYUNCU_EV		15
#define MAX_OYUNCU_ISYERI	15
#define MAX_OYUNCU_SILAH	15
#define MAX_OYUNCU_BALIK	20

// EXTRA DEFINES

#define abs(%1) \
        (((%1) < 0) ? (-(%1)) : ((%1)))  

/////////////////////////////////////

#include "includes\variables.pwn"
#include "includes\textdrawlar.pwn"
#include "includes\functions.pwn"
#include <nex-ac>
#include "includes\dialogs.pwn"
#include "includes\vcguard.pwn"

#include "includes\cmd_public.pwn"
#include "includes\cmd_admin.pwn"
        
#include "includes\Sistemler\animasyonlar.pwn"

#include "includes\Sistemler\birlik.pwn"
#include "includes\Sistemler\binalar.pwn"
#include "includes\Sistemler\vicemarket.pwn"
#include "includes\Sistemler\evler.pwn"
#include "includes\Sistemler\isyeri.pwn"
#include "includes\Sistemler\araclar.pwn"
#include "includes\Sistemler\silah.pwn"
#include "includes\Sistemler\ciftlik.pwn"
//#include "includes\Sistemler\pet.pwn"
#include "includes\Sistemler\telefon.pwn"

#include "includes\Sistemler\meslek_balik.pwn"

/////////////////////////////////////

main() { }

public OnGameModeInit()
{
	SunucuAyarlari();
	VeritabaniAyarlari();
	VeriYuklemeleri();
	GenelTextDrawYukle();
	SetTimer("SaatTimer", TIMER_SANIYE * 60, true);
	SetTimer("AracGostergeTimer", 400, true);
	return true;
}

public OnGameModeExit()
{
	foreach(new i: Player)
	{
		if(IsPlayerConnected(i))
		{
			KarakterVeriKaydet(i);
			HesapVeriKaydet(i);
		}
	}
	OyunModuKapat();
	return true;
}

public OnPlayerConnect(playerid)
{
	// roleplay color
	SetPlayerColor(playerid, 0xFFFFFFAA);

	// delete all cache
	KarakterVeriSifirla(playerid);

	// load
	TextDrawlariYukle(playerid);
	CiftlikZoneYukle(playerid);

	// stream settings
	Streamer_SetVisibleItems(STREAMER_TYPE_OBJECT, 10000);
	/*Streamer_ToggleChunkStream(1);
	Streamer_ToggleErrorCallback(1);
*/
	// Giri� - Kamera A��s�
	SetPlayerCameraPos(playerid, 158.3348,-2098.9861,56.6490);
	SetPlayerCameraLookAt(playerid, 176.5682,-2053.3926,48.5751);
	return true;
}

public OnPlayerDisconnect(playerid, reason)
{
	TextDrawlariSil(playerid);
	KarakterVeriKaydet(playerid);
	KarakterVeriSifirla(playerid);
	new query[128];
	if(Karakter[playerid][Giris])
	{
		mysql_format(conn, query, sizeof(query), "UPDATE hesaplar SET Oyunda = 0 WHERE id = %i", Hesap[playerid][id]);
		mysql_query(conn, query);
	}
	return true;
}

public OnPlayerRequestClass(playerid, classid)
{
	HesapKontrol(playerid);
	TogglePlayerSpectating(playerid, true);
	return true;
}

public OnPlayerRequestDownload(playerid, type, crc)
{
	if(!IsPlayerConnected(playerid))
		return 0;
	new filename[64], filefound, final_url[256];
	if(type == DOWNLOAD_REQUEST_TEXTURE_FILE)
		filefound = FindTextureFileNameFromCRC(crc, filename, sizeof(filename));
	else if(type == DOWNLOAD_REQUEST_MODEL_FILE)
		filefound = FindModelFileNameFromCRC(crc, filename, sizeof(filename));

	if(filefound)
	{
		format(final_url, sizeof(final_url), "%s/%s", SERVER_DOWNLOAD, filename);
		RedirectDownload(playerid, final_url);
	}
	return 1;
}

public OnPlayerFinishedDownloading(playerid, virtualworld)
{
	if(Karakter[playerid][Giris] == true) return false;
    return 1;
}

public OnPlayerSpawn(playerid)
{
	TogglePlayerSpectating(playerid, false);
	SetPlayerWeather(playerid, SunucuWeather);
	SetPlayerTime(playerid, SunucuZaman, 0);
	new query[144];
	mysql_format(conn, query, sizeof(query), "SELECT * FROM silahlar WHERE Sahip = %i AND SilahDurum = %i", Karakter[playerid][id], SILAH_USTUNDE);
	mysql_tquery(conn, query, "SilahVeriYukle", "i", playerid);
	Streamer_Update(playerid);
	SpawnAyarla(playerid);
	if(Karakter[playerid][Yarali] == 1)
	{
		Karakter[playerid][Can] = 30;
		SenkronAyarla(playerid);
		YaraliYap(playerid);
	}
	else
	{	
		SenkronAyarla(playerid);
	}
	return true;
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
	if(newstate == PLAYER_STATE_DRIVER || newstate == PLAYER_STATE_PASSENGER)
	{
		if(IsPlayerInAnyVehicle(playerid))
		{
			new aracid = GetPlayerVehicleID(playerid);
			if(newstate == PLAYER_STATE_DRIVER)
			{
				if(Araclar[aracid][AracTur] > 0)
				{
					if(Araclar[aracid][AracTur] == 1 && Karakter[playerid][EhliyetTesti] == 1)
					{
						SunucuEx(playerid, "{3C5DA5}[S�R�C� KURSU] S�r�� testiniz ba�lad�. ��aretli noktalar� takip edin, h�z s�n�r� bulunmamaktad�r.");
						Karakter[playerid][EhliyetCP] = 1;
						SetPlayerCheckpoint(playerid, 949.5048,-1392.8918,13.0291, 6.0);
					}
					else
					{
						SunucuEx(playerid, "{3C5DA5}[ARA�]{C8C8C8} Ara� T�r�: %s | Model: %s", AracTurIsim(aracid), AracModelCek(aracid));
					}
				}
				else if(Araclar[aracid][Sahip] > 0)
				{
					SunucuEx(playerid, "{3C5DA5}[ARA�]{C8C8C8} Sahip: %s | Model: %s | Fiyat: %s | Vergi: %s", AracSahipIsim(aracid), AracModelCek(aracid), NumaraFormati(AracFiyatCek(aracid)), NumaraFormati(Araclar[aracid][Vergi]));
				}
			}
			new gosterge[96];
			format(gosterge, sizeof(gosterge), "Benzin:_%.2f_lt Hiz:_0_km/h KM:_%dkm", Araclar[aracid][Benzin], floatround(Araclar[aracid][Kilometre], floatround_round));
			PlayerTextDrawSetString(playerid, AracGostergesi[playerid], gosterge);
			PlayerTextDrawShow(playerid, AracGostergesi[playerid]);
		}
	}
	if(newstate == PLAYER_STATE_ONFOOT || newstate == PLAYER_STATE_WASTED)
	{
		if(oldstate == PLAYER_STATE_DRIVER || oldstate == PLAYER_STATE_PASSENGER)
		{
			PlayerTextDrawHide(playerid, AracGostergesi[playerid]);
		}
	}
	return true;
}

public OnPlayerUpdate(playerid)
{
	if(Karakter[playerid][Para] != GetPlayerMoney(playerid))
	{
		ResetPlayerMoney(playerid);
		GivePlayerMoney(playerid, Karakter[playerid][Para]);
	}
	return 1;
}
 
public OnPlayerText(playerid, text[])
{
	if(!IsPlayerConnected(playerid)) return GirisYapmadi(playerid), false;
	if(!Karakter[playerid][Giris]) return GirisYapmadi(playerid), false;
	if(!strcmp(text, ":)", true))
	{
		cmd(playerid, 1, "g�l�mser.");
		return false;
	}
	if(!strcmp(text, ":(", true))
	{
		cmd(playerid, 1, "somurtur.");
		return false;
	}
	if(!strcmp(text, ":D", true))
	{
		cmd(playerid, 1, "kahkaha atar.");
		return false;
	}
	if(!strcmp(text, ":/", true))
	{
		cmd(playerid, 1, "a�z�n� yamultur.");
		return false;
	}
	if(!strcmp(text, ";)", true))
	{
		cmd(playerid, 1, "g�z k�rpar.");
		return false;
	}
	new str[128];
	if(Karakter[playerid][Aramada] == 1 && Karakter[playerid][Arama] != -1 && Karakter[playerid][Araniyor] == 0)
	{
		new aranan = Karakter[playerid][Arama];
		if(strlen(text) > 84)
		{
			format(str, sizeof(str), "%s (telefon): %.84s", RPIsim(playerid), text);
			SendClientMessage(aranan, RENK_PM, str);
			LocalChat(playerid, 20.0, str, RENK_KARA1, RENK_KARA2, RENK_KARA3, RENK_KARA4);

			format(str, sizeof(str), "%s (telefon): ...%s", RPIsim(playerid), text[84]);
			SendClientMessage(aranan, RENK_PM, str);
			LocalChat(playerid, 20.0, str, RENK_KARA1, RENK_KARA2, RENK_KARA3, RENK_KARA4);
		}
		else
		{
			format(str, sizeof(str), "%s (telefon): %s", RPIsim(playerid), text);
			SendClientMessage(aranan, RENK_PM, str);
			LocalChat(playerid, 20.0, str, RENK_KARA1, RENK_KARA2, RENK_KARA3, RENK_KARA4);
		}
		return false;
	}	
	if(strlen(text) > 84)
	{
		format(str, sizeof(str), "%s: %.84s", RPIsim(playerid), text);
		LocalChat(playerid, 20.0, str, RENK_KARA1, RENK_KARA2, RENK_KARA3, RENK_KARA4);
		
		format(str, sizeof(str), "%s: ... %s", RPIsim(playerid), text[84]);
		LocalChat(playerid, 20.0, str, RENK_KARA1, RENK_KARA2, RENK_KARA3, RENK_KARA4);
	} 
	else 
	{
		format(str, sizeof(str), "%s: %s", RPIsim(playerid), text);
		LocalChat(playerid, 20.0, str, RENK_KARA1, RENK_KARA2, RENK_KARA3, RENK_KARA4);
	}
	return false;
}

public OnPlayerEditDynamicObject(playerid, objectid, response, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz)
{
	if(response == EDIT_RESPONSE_FINAL)
	{
		Sunucu(playerid, "Objeyi d�zenledin.");
	}
	if(response == EDIT_RESPONSE_CANCEL)
	{
		Sunucu(playerid, "Objeyi d�zenlemekten vazge�tin.");
	}
	return true;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if(newkeys == KEY_YES)
	{
		if(IsPlayerInAnyVehicle(playerid) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
		{
			cmd(playerid, 0, "arac motor");
			return true;
		}
		if(BinaYakin(playerid) != -1)
		{
			new binaid = BinaYakin(playerid);
			if(Binalar[binaid][Durum] == 1) return Sunucu(playerid, "Bu bina kilitli. Giri� yapamazs�n�z.");
			if(Binalar[binaid][Int][0] == 0.0 && Binalar[binaid][Int][1] == 0.0 && Binalar[binaid][Int][2] == 0.0) return Sunucu(playerid, "Bu binan�n i� mekan� hen�z ayarlanmam�� g�r�n�yor.");
			SetPlayerPos(playerid, Binalar[binaid][Int][0], Binalar[binaid][Int][1], Binalar[binaid][Int][2]);
			SetPlayerVirtualWorld(playerid, Binalar[binaid][IcWorld]);
			SetPlayerInterior(playerid, Binalar[binaid][IcInterior]);
			SetCameraBehindPlayer(playerid);
			TogglePlayerControllable(playerid, false);
			Karakter[playerid][VW] = GetPlayerVirtualWorld(playerid);
			Karakter[playerid][Interior] = GetPlayerInterior(playerid);
			SetTimerEx("OyuncuCoz", 4000, false, "i", playerid);
			return true;
		}
		if(BinaIcYakin(playerid) != -1)
		{
			new binaid = BinaIcYakin(playerid);
			SetPlayerPos(playerid, Binalar[binaid][Ext][0], Binalar[binaid][Ext][1], Binalar[binaid][Ext][2]);
			SetPlayerVirtualWorld(playerid, Binalar[binaid][World]);
			SetPlayerInterior(playerid, Binalar[binaid][Interior]);
			TogglePlayerControllable(playerid, false);
			Karakter[playerid][VW] = GetPlayerVirtualWorld(playerid);
			Karakter[playerid][Interior] = GetPlayerInterior(playerid);
			SetTimerEx("OyuncuCoz", 4000, false, "i", playerid);
			return true;
		}
		if(EvYakin(playerid) != -1)
		{
			new evid = EvYakin(playerid);
			if(Evler[evid][Durum] == 1) return Sunucu(playerid, "Bu ev kilitli. Giri� yapamazs�n�z.");
			if(Evler[evid][Int][0] == 0.0 && Evler[evid][Int][1] == 0.0 && Evler[evid][Int][2] == 0.0) return Sunucu(playerid, "Bu evin i� mekan� hen�z ayarlanmam�� g�r�n�yor.");
			SetPlayerPos(playerid, Evler[evid][Int][0], Evler[evid][Int][1], Evler[evid][Int][2]);
			SetPlayerVirtualWorld(playerid, Evler[evid][IcWorld]);
			SetPlayerInterior(playerid, Evler[evid][IcInterior]);
			TogglePlayerControllable(playerid, false);
			Karakter[playerid][VW] = GetPlayerVirtualWorld(playerid);
			Karakter[playerid][Interior] = GetPlayerInterior(playerid);
			SetTimerEx("OyuncuCoz", 4000, false, "i", playerid);
			return true;
		}
		if(EvIcYakin(playerid) != -1)
		{
			new evid = EvIcYakin(playerid);
			SetPlayerPos(playerid, Evler[evid][Ext][0], Evler[evid][Ext][1], Evler[evid][Ext][2]);
			SetPlayerVirtualWorld(playerid, Evler[evid][World]);
			SetPlayerInterior(playerid, Evler[evid][Interior]);
			TogglePlayerControllable(playerid, false);
			Karakter[playerid][VW] = GetPlayerVirtualWorld(playerid);
			Karakter[playerid][Interior] = GetPlayerInterior(playerid);
			SetTimerEx("OyuncuCoz", 4000, false, "i", playerid);
			return true;
		}
		if(IsyeriYakin(playerid) != -1)
		{
			new isyeriid = IsyeriYakin(playerid);
			if(Isyeri[isyeriid][Durum] == 1) return Sunucu(playerid, "Bu i�yeri kilitli. Giri� yapamazs�n�z.");
			if(Isyeri[isyeriid][Int][0] == 0.0 && Isyeri[isyeriid][Int][1] == 0.0 && Isyeri[isyeriid][Int][2] == 0.0) return Sunucu(playerid, "Bu i�yerinin i� mekan� hen�z ayarlanmam�� g�r�n�yor.");
			SetPlayerPos(playerid, Isyeri[isyeriid][Int][0], Isyeri[isyeriid][Int][1], Isyeri[isyeriid][Int][2]);
			SetPlayerVirtualWorld(playerid, Isyeri[isyeriid][IcWorld]);
			SetPlayerInterior(playerid, Isyeri[isyeriid][IcInterior]);
			TogglePlayerControllable(playerid, false);
			Karakter[playerid][VW] = GetPlayerVirtualWorld(playerid);
			Karakter[playerid][Interior] = GetPlayerInterior(playerid);
			SetTimerEx("OyuncuCoz", 4000, false, "i", playerid);
			return true;
		}
		if(IsyeriIcYakin(playerid) != -1)
		{
			new isyeriid = IsyeriIcYakin(playerid);
			SetPlayerPos(playerid, Isyeri[isyeriid][Ext][0], Isyeri[isyeriid][Ext][1], Isyeri[isyeriid][Ext][2]);
			SetPlayerVirtualWorld(playerid, Isyeri[isyeriid][World]);
			SetPlayerInterior(playerid, Isyeri[isyeriid][Interior]);
			TogglePlayerControllable(playerid, false);
			Karakter[playerid][VW] = GetPlayerVirtualWorld(playerid);
			Karakter[playerid][Interior] = GetPlayerInterior(playerid);
			SetTimerEx("OyuncuCoz", 4000, false, "i", playerid);
			return true;
		}
	}
	if(newkeys == KEY_NO)
	{
		if(IsPlayerInAnyVehicle(playerid) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
		{
			cmd(playerid, 0, "arac far");
		}
		if(GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_SMOKE_CIGGY)
		{
			SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
			ClearAnimations(playerid);
		}
	}
	if(newkeys & KEY_SUBMISSION)
	{
			if(Karakter[playerid][Ciftlik] != -1 && GetPVarInt(playerid, "CiftlikBicimIslem") == 1)
			{
				if(GetPlayerProgressBarValue(playerid, bicimprog[playerid]) >= GetPVarInt(playerid, "CiftlikEkinler"))
				{
					new cid = Karakter[playerid][Ciftlik];
					Sunucu(playerid, "Ba�ar�yla tarlan�zda ekili olan %s bitkisini bi�tiniz.", ekinlerveri[CiftlikInfo[cid][cUrun]][ekinisim]);
					Doluluk[playerid] = 0;
					CiftlikInfo[cid][cUrun] = 0;
					CiftlikInfo[cid][cOlgunlasma] = 0;
					HidePlayerProgressBar(playerid, bicimprog[playerid]);
					DestroyPlayerProgressBar(playerid, bicimprog[playerid]);
					TextDrawHideForPlayer(playerid, ciftlik_0);
					TextDrawHideForPlayer(playerid, ciftlik_1);
					SetPVarInt(playerid, "CiftlikBicimIslem", 0);
					DeletePVar(playerid, "CiftlikBicimIslem");
					SetPVarInt(playerid, "CiftlikEkinler", 0);
					DeletePVar(playerid, "CiftlikEkinler");
					CiftlikInfo[Karakter[playerid][Ciftlik]][cIslem] = false;
					Ciftlik_Kaydet(cid);
					return 1;
				}
				new query[110], Cache:VeriCek, rows;
				mysql_format(conn, query, sizeof(query), "SELECT * FROM ekinler WHERE ciftlikid = %i", Karakter[playerid][Ciftlik]);
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
						if(GetVehicleDistanceFromPoint(GetPlayerVehicleID(playerid), x, y, z) < 4.0)
						{
							new idx;
							cache_get_value_name_int(i, "objeid", idx);
							cache_delete(VeriCek);
							Doluluk[playerid] += 1;
							SetPlayerProgressBarValue(playerid, bicimprog[playerid], Doluluk[playerid]);
							DestroyDynamicObject(idx);
							mysql_format(conn, query, sizeof(query), "DELETE FROM ekinler WHERE objeid = %i", idx);
							mysql_query(conn, query);
							UrunYarat(playerid, Karakter[playerid][Ciftlik]);
							break;
						}
					}	
				}
			}
	}
	return true;
}

public OnPlayerClickTextDraw(playerid, Text:clickedid)
{
	if(_:clickedid == INVALID_TEXT_DRAW)
	{
	    if(Hesap[playerid][KarakterSeciminde] == 1)
	    {
			SelectTextDraw(playerid, 0x99C794FF);	
		}
	}
	return true;
}

public OnPlayerClickPlayerTextDraw(playerid, PlayerText:playertextid)
{
	new query[144];
	if(playertextid == KarakterSecimTD[5][playerid])
	{
		mysql_format(conn, query, sizeof(query), "SELECT * FROM karakterler WHERE id = %i LIMIT 1", Hesap[playerid][KarakterSecimID][0]);
		mysql_tquery(conn, query, "KarakterVeriYukle", "i", playerid);	
		CancelSelectTextDraw(playerid);
		Hesap[playerid][KarakterSeciminde] = 0;
		KarakterMenuGizle(playerid);
	}
	if(playertextid == KarakterSecimTD[2][playerid])
	{
		mysql_format(conn, query, sizeof(query), "SELECT * FROM karakterler WHERE id = %i LIMIT 1", Hesap[playerid][KarakterSecimID][1]);
		mysql_tquery(conn, query, "KarakterVeriYukle", "i", playerid);	
		CancelSelectTextDraw(playerid);
		Hesap[playerid][KarakterSeciminde] = 0;
		KarakterMenuGizle(playerid);
	}
	if(playertextid == KarakterSecimTD[4][playerid])
	{
		mysql_format(conn, query, sizeof(query), "SELECT * FROM karakterler WHERE id = %i LIMIT 1", Hesap[playerid][KarakterSecimID][2]);
		mysql_tquery(conn, query, "KarakterVeriYukle", "i", playerid);	
		CancelSelectTextDraw(playerid);
		Hesap[playerid][KarakterSeciminde] = 0;
		KarakterMenuGizle(playerid);
	}
	if(playertextid == KarakterSecimTD[7][playerid])
	{
		mysql_format(conn, query, sizeof(query), "SELECT * FROM karakterler WHERE id = %i LIMIT 1", Hesap[playerid][KarakterSecimID][3]);
		mysql_tquery(conn, query, "KarakterVeriYukle", "i", playerid);	
		CancelSelectTextDraw(playerid);
		Hesap[playerid][KarakterSeciminde] = 0;
		KarakterMenuGizle(playerid);
	}
	if(playertextid == tarim9[playerid])
    {
		for(new i = 0; i < 9; i++) 
		{
			TextDrawHideForPlayer(playerid, tarim[i]);
		}
		PlayerTextDrawHide(playerid, tarim9[playerid]); 
		CancelSelectTextDraw(playerid);
	}
	return true;
}

public OnPlayerDeath(playerid, killerid, reason)
{
	new silahseri, silahmermi, query[144];
	for(new i = 0; i < MAX_OYUNCU_SILAH; i++)
	{
		if(Karakter[playerid][Silah][i] == 0) continue;
		silahseri = Karakter[playerid][SilahSeri][i];
		silahmermi = Karakter[playerid][Mermi][i];
		mysql_format(conn, query, sizeof(query), "UPDATE silahlar SET SilahMermi = %i WHERE SilahSeri = %i", silahmermi, silahseri);
		mysql_tquery(conn, query);
	}
	Karakter[playerid][Yarali] = 1;
	GetPlayerPos(playerid, Karakter[playerid][SonPos][0], Karakter[playerid][SonPos][1], Karakter[playerid][SonPos][2]);
	SetSpawnInfo(playerid, NO_TEAM, Karakter[playerid][Skin], Karakter[playerid][SonPos][0], Karakter[playerid][SonPos][1], Karakter[playerid][SonPos][2], 0, 0, 0, 0, 0, 0, 0);
	Karakter[playerid][Can] = 30;
	SetPlayerHealth(playerid, Karakter[playerid][Can]);
	Log_Kaydet("loglar/olum_loglari.txt", "[%s] %s adli kisi %s tarafindan %s silahla olduruldu.", TarihCek(), RPIsim(playerid), RPIsim(killerid), SilahIsim(reason));
	return true;
}

public OnPlayerCommandPerformed(playerid, cmd[], params[], result, flags)
{
    if(result == -1)
    {
        Sunucu(playerid, "Sunucuda b�yle bir komut bulunmamaktad�r.");
        return 0;
    }
    return 1;
}

public OnPlayerCommandReceived(playerid, cmd[], params[], flags)
{
	if(!Karakter[playerid][Giris]) return Sunucu(playerid, "Giri� yapmadan komut kullanamazs�n�z."), 0;
	Log_Kaydet("loglar/komut_kullanimi.txt", "[%s] %s: /%s %s", TarihCek(), RPIsim(playerid), cmd, params);
	return 1;
}

public OnPlayerInteriorChange(playerid, newinteriorid, oldinteriorid)
{
	return true;
}

public OnPlayerEnterCheckpoint(playerid)
{
	DisablePlayerCheckpoint(playerid);
	new aracid;
	if(IsPlayerInAnyVehicle(playerid))
	{
		aracid = GetPlayerVehicleID(playerid);
	}
	if(Karakter[playerid][EhliyetTesti] == 1 && Araclar[aracid][AracTur] == 1)
	{
		switch(Karakter[playerid][EhliyetCP]) 
		{
			case 1: SetPlayerCheckpoint(playerid, 813.0014,-1393.5789,13.2916,6.0); //
			case 2: SetPlayerCheckpoint(playerid, 635.1101,-1348.7632,13.2659,6.0); //
			case 3: SetPlayerCheckpoint(playerid, 631.0803,-1237.9666,17.6244,6.0); //
			case 4: SetPlayerCheckpoint(playerid, 538.2895,-1247.1970,16.4389,6.0); //
			case 5: SetPlayerCheckpoint(playerid, 283.9133,-1410.0597,13.6326,6.0); //
			case 6: SetPlayerCheckpoint(playerid, 157.8391,-1546.3020,10.7945,6.0); //
			case 7: SetPlayerCheckpoint(playerid, 214.4846,-1659.8125,12.4021,6.0); //
			case 8: 
			{
				if(IsPlayerInRangeOfPoint(playerid, 25.0, 214.4846,-1659.8125,12.4021))
				{
					SetPlayerCheckpoint(playerid, 386.9896,-1719.0431,7.6581,6.0); //
				}
				else
				{
					Sunucu(playerid, "Hile ��phesi nedeniyle s�nav iptal oldu. L�tfen tekrar deneyin.");
					Log_Kaydet("loglar/checkpoint_hilesi.txt", "[%s] %s adli kisinin ehliyet sinavi hile suphesi nedeniyle iptal oldu.", TarihCek(), RPIsim(playerid));
					Karakter[playerid][EhliyetTesti] = 0;
					AracSpawnla(aracid);
					new Float:x, Float:y, Float:z;
					GetVehiclePos(aracid, Float:x, Float:y, Float:z);
					SetPlayerPos(playerid, Float:x, Float:y, Float:z + 2.0);
				}
			}
			case 9: SetPlayerCheckpoint(playerid, 636.6415,-1749.6857,13.0817,6.0); //
			case 10: SetPlayerCheckpoint(playerid, 1018.9664,-1814.8740,13.8303,6.0); //
			case 11: SetPlayerCheckpoint(playerid, 1178.2490,-1853.6982,13.2736,6.0); //
			case 12: SetPlayerCheckpoint(playerid, 1314.1515,-1841.0607,13.2574,6.0); //
			case 13: SetPlayerCheckpoint(playerid, 1314.0039,-1625.3364,13.2578,6.0); //
			case 14: SetPlayerCheckpoint(playerid, 1357.3412,-1439.5521,13.2648,6.0); //
			case 15: SetPlayerCheckpoint(playerid, 1152.1827,-1397.5198,13.3916,6.0); //
			case 16: SetPlayerCheckpoint(playerid, 968.0258,-1392.5929,12.9562,6.0); //
			case 17:
			{
				new Float:aracHp;
				GetVehicleHealth(aracid, aracHp);
				if(aracHp < 750.0)
				{
					Sunucu(playerid, "Araca �ok fazla hasar verdi�inizden dolay� s�nav� ge�emediniz.");
					Karakter[playerid][EhliyetTesti] = 0;
					AracSpawnla(aracid);
					new Float:x, Float:y, Float:z;
					GetVehiclePos(aracid, Float:x, Float:y, Float:z);
					SetPlayerPos(playerid, Float:x, Float:y, Float:z + 2.0);
				}
				else
				{
					Sunucu(playerid, "S�nav� ba�ar�yla ge�tiniz. Art�k ehliyet sahibisiniz.");
					Karakter[playerid][EhliyetTesti] = 0;
					Karakter[playerid][EhliyetCP] = 0;
					Karakter[playerid][Ehliyet] = 1;
					KarakterVeriKaydet(playerid);
					AracSpawnla(aracid);
					new Float:x, Float:y, Float:z;
					GetVehiclePos(aracid, Float:x, Float:y, Float:z);
					SetPlayerPos(playerid, Float:x, Float:y, Float:z + 2.0);
				}
				AracSpawnla(aracid);
			}
		}
		Karakter[playerid][EhliyetCP]++;
	} 
	return true;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{	
	switch(dialogid)
	{
		case 23300:
		{
			if(response)
			{
				switch(Karakter[playerid][Cinsiyet])
				{
					case 1:
					{
						switch(Karakter[playerid][Ten])
						{
							case 1:
							{
								new model;
								for(new i = 0; i < sizeof(ErkekBeyazSkinler); i++)
								{
									if(listitem == i) model = ErkekBeyazSkinler[i];
								}
								SetPVarInt(playerid, "AlinacakSkin", model);
								Dialog_Show(playerid, DIALOG_KIYAFET_ONAY, DIALOG_STYLE_MSGBOX, "{99C794}K�yafet Sat�n Alma", "{FFFFFF}%d ID'li skini {3C5DA5}%s{FFFFFF} kar��l���nda sat�n almak istedi�inize emin misiniz?\n{3C5DA5}NOT:{FFFFFF} Bu i�lemin geri d�n��� yoktur. �st�n�zdeki k�yafet de�i�ecek.", "Onayla", "�ptal", model, NumaraFormati(KIYAFET_UCRET));
							}
							case 2:
							{
								new model;
								for(new i = 0; i < sizeof(ErkekSiyahSkinler); i++)
								{
									if(listitem == i) model = ErkekSiyahSkinler[i];
								}
								SetPVarInt(playerid, "AlinacakSkin", model);
								Dialog_Show(playerid, DIALOG_KIYAFET_ONAY, DIALOG_STYLE_MSGBOX, "{99C794}K�yafet Sat�n Alma", "{FFFFFF}%d ID'li skini {3C5DA5}%s{FFFFFF} kar��l���nda sat�n almak istedi�inize emin misiniz?\n{3C5DA5}NOT:{FFFFFF} Bu i�lemin geri d�n��� yoktur. �st�n�zdeki k�yafet de�i�ecek.", "Onayla", "�ptal", model, NumaraFormati(KIYAFET_UCRET));
							}
						}
					}
					case 2:
					{
						switch(Karakter[playerid][Ten])
						{
							case 1:
							{
								new model;
								for(new i = 0; i < sizeof(KadinBeyazSkinler); i++)
								{
									if(listitem == i) model = KadinBeyazSkinler[i];
								}
								SetPVarInt(playerid, "AlinacakSkin", model);
								Dialog_Show(playerid, DIALOG_KIYAFET_ONAY, DIALOG_STYLE_MSGBOX, "{99C794}K�yafet Sat�n Alma", "{FFFFFF}%d ID'li skini {3C5DA5}%s{FFFFFF} kar��l���nda sat�n almak istedi�inize emin misiniz?\n{3C5DA5}NOT:{FFFFFF} Bu i�lemin geri d�n��� yoktur. �st�n�zdeki k�yafet de�i�ecek.", "Onayla", "�ptal", model, NumaraFormati(KIYAFET_UCRET));
							}
							case 2:
							{
								new model;
								for(new i = 0; i < sizeof(KadinSiyahSkinler); i++)
								{
									if(listitem == i) model = KadinSiyahSkinler[i];
								}
								SetPVarInt(playerid, "AlinacakSkin", model);
								Dialog_Show(playerid, DIALOG_KIYAFET_ONAY, DIALOG_STYLE_MSGBOX, "{99C794}K�yafet Sat�n Alma", "{FFFFFF}%d ID'li skini {3C5DA5}%s{FFFFFF} kar��l���nda sat�n almak istedi�inize emin misiniz?\n{3C5DA5}NOT:{FFFFFF} Bu i�lemin geri d�n��� yoktur. �st�n�zdeki k�yafet de�i�ecek.", "Onayla", "�ptal", model, NumaraFormati(KIYAFET_UCRET));
							}
						}
					}
				}
			}
		}
		case 23301:
		{
			if(response)
			{
				new aracmodel = SatilikAraclar[listitem][0], fiyat = SatilikAraclar[listitem][1];
				if(Karakter[playerid][Para] < fiyat) return Sunucu(playerid, "Bu arac� sat�n almak i�in yeterli miktarda paran yok.");
				SetPVarInt(playerid, "AracModel", aracmodel);
				SetPVarInt(playerid, "AracFiyat", fiyat);
				Dialog_Show(playerid, DIALOG_ARAC_SATINAL, DIALOG_STYLE_MSGBOX, "{99C794}Ara� Sat�n Al", "{3C5DA5}%s{FFFFFF} model arac� {3C5DA5}%s{FFFFFF} kar��l���nda sat�n almak istiyor musun?", "Onayla", "�ptal", GetVehicleNameByModel(aracmodel), NumaraFormati(fiyat));
			}
		}
		case 23302:
		{
			if(response)
			{
				new model;
				switch(Karakter[playerid][Cinsiyet])
				{
					case 1:
					{
						switch(Karakter[playerid][Ten])
						{
							case 1:
							{						
								for(new i = 0; i < sizeof(ErkekBeyazSkinler); i++)
								{
									if(listitem == i) model = ErkekBeyazSkinler[i];
								}
							}
							case 2:
							{
								for(new i = 0; i < sizeof(ErkekSiyahSkinler); i++)
								{
									if(listitem == i) model = ErkekSiyahSkinler[i];
								}
							}
						}
					}
					case 2:
					{
						switch(Karakter[playerid][Ten])
						{
							case 1:
							{
								for(new i = 0; i < sizeof(KadinBeyazSkinler); i++)
								{
									if(listitem == i) model = KadinBeyazSkinler[i];
								}
							}
							case 2:
							{
								for(new i = 0; i < sizeof(KadinSiyahSkinler); i++)
								{
									if(listitem == i) model = KadinSiyahSkinler[i];
								}
							}
						}
					}
				}
				Karakter[playerid][Skin] = model;
				if(Karakter[playerid][Para] == 0)
				{
					ResetPlayerMoney(playerid);
					Karakter[playerid][Para] = 300;
					GivePlayerMoney(playerid, Karakter[playerid][Para]);
				}
				Karakter[playerid][SonPos][0] = 1524.0515;
				Karakter[playerid][SonPos][1] = -1670.5951;
				Karakter[playerid][SonPos][2] = 13.5469;
				Karakter[playerid][SonPos][3] = 270.0;
				Karakter[playerid][Olusturuldu] = 1;
				
				new query[192];
				mysql_format(conn, query, sizeof(query), "UPDATE karakterler SET Olusturuldu = 1 WHERE id = %i", Karakter[playerid][id]);
				mysql_query(conn, query);
				Sunucu(playerid, "L�tfen karakter verileriniz y�klenirken biraz bekleyin...");
				SetPlayerCameraPos(playerid, 158.3348,-2098.9861,56.6490);
				SetPlayerCameraLookAt(playerid, 176.5682,-2053.3926,48.5751);
				SetTimerEx("KarakterAyarla", 1500, false, "i", playerid);
			}
			else
			{
				KickEx(playerid);
			}
		}
	}
	return true;
}

public OnPlayerEnterDynamicArea(playerid, areaid) 
{
	if(Karakter[playerid][Giris])
	{
		for(new i = 0; i < MAX_CIFTLIK; i++) if(CiftlikInfo[i][cArsa] == areaid)
		{
			if(CiftlikInfo[i][cSahipID] == 0)
			{
			Sunucu(playerid, "�iftlik Ad�: Florida Eyalet �iftlikleri (ID: %d)",i);
			Sunucu(playerid, "�iftlik Sahibi: %d | Fiyat: %s | D�n�m: %.2f", CiftlikInfo[i][cSahipID], NumaraFormati(CiftlikInfo[i][cPara]), CiftlikInfo[i][cDonum]);
			Sunucu(playerid, "Bu arsa sat�l�k! Arsay� sat�n almak i�in '/satinal'");
			Karakter[playerid][Ciftlik] = i;
			}
			else
			{
			Sunucu(playerid, "�iftlik Ad�: %s (ID: %d)", CiftlikInfo[i][cIsim], i);
			Sunucu(playerid, "�iftlik Sahibi: %d | Fiyat: %s | Toplam D�n�m: %.2f", CiftlikInfo[i][cSahipID], NumaraFormati(CiftlikInfo[i][cPara]), CiftlikInfo[i][cDonum]);
			Sunucu(playerid, "Ekili �r�n: %s | �r�nlerin olgunla�mas�na %d saat kald�.", ekinlerveri[CiftlikInfo[i][cUrun]][ekinisim], CiftlikInfo[i][cOlgunlasma]);
			Karakter[playerid][Ciftlik] = i;
			}
		}
	}
	return 1;
}

public OnPlayerLeaveDynamicArea(playerid, areaid) 
{
    Karakter[playerid][Ciftlik] = -1;
}

public OnPlayerExitVehicle(playerid, vehicleid)
{
	if(GetPVarInt(playerid, "CiftlikEkimIslem") == 1)
 	{
		Doluluk[playerid] = 0;
		HidePlayerProgressBar(playerid, ciftlikprog[playerid]);
		TextDrawHideForPlayer(playerid, ciftlik_0);
		TextDrawHideForPlayer(playerid, ciftlik_1);
		KillTimer(ciftlikUpdater[playerid]);
		if(Karakter[playerid][Ciftlik] != -1) CiftlikInfo[Karakter[playerid][Ciftlik]][cIslem] = false;
		SetPVarInt(playerid, "CiftlikEkimIslem", 0);
		DeletePVar(playerid, "CiftlikEkimIslem");
		Sunucu(playerid, "Tarla ekimi s�ras�nda trakt�rden indi�iniz i�in ekim i�lemi durdu.");
	}
	if(GetPVarInt(playerid, "CiftlikBicimIslem") == 1)
	{
		Doluluk[playerid] = 0;
		HidePlayerProgressBar(playerid, bicimprog[playerid]);
		DestroyPlayerProgressBar(playerid, bicimprog[playerid]);
		TextDrawHideForPlayer(playerid, ciftlik_0);
		TextDrawHideForPlayer(playerid, ciftlik_1);
		new cc = GetPVarInt(playerid,"oncekiciftlik");
		CiftlikInfo[cc][cIslem] = false;
		SetPVarInt(playerid, "CiftlikBicimIslem", 0);
		DeletePVar(playerid, "CiftlikBicimIslem");
		SetPVarInt(playerid, "CiftlikEkinler", 0);
		DeletePVar(playerid, "CiftlikEkinler");
		DeletePVar(playerid, "oncekiciftlik");
		Sunucu(playerid, "Tarlay� bi�erken bi�erd�verden indi�iniz i�in bi�me i�lemi durdu.");
	}
	if(Karakter[playerid][EhliyetTesti] == 1)
	{
		Sunucu(playerid, "Ara�tan indi�iniz i�in s�r�� testi iptal oldu.");
		Karakter[playerid][EhliyetTesti] = 0;
		AracSpawnla(vehicleid);
		new Float:x, Float:y, Float:z;
		GetVehiclePos(vehicleid, x, y, z);
		SetPlayerPos(playerid, Float:x, Float:y, Float:z + 2.0);
	}
	return true;
}