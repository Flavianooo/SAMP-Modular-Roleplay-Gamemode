// YÖNETÝCÝ KOMUTLARI

CMD:petver(playerid, params[])
{
	if(Hesap[playerid][Yonetici] < 7) return YetersizYetki(playerid);
	new oyuncu, petisim[32], skin;
	if(sscanf(params, "uds[32]", oyuncu, skin, petisim)) return Kullanim(playerid, "/petver [id/isim] [skin id] [pet adý]");
	if(!IsPlayerConnected(oyuncu) || !Karakter[oyuncu][Giris]) return Sunucu(playerid, "Geçersiz oyuncu.");
	if(strlen(petisim) < 1 || strlen(petisim) > 32) return Sunucu(playerid, "Pet ismi 1 ile 32 karakter arasýnda olmalýdýr.");
	new isimkontrol[MAX_PLAYER_NAME+2];
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		GetPlayerName(i, isimkontrol, sizeof(isimkontrol));
		if(!strcmp(isimkontrol, petisim, true))
		{
			Sunucu(playerid, "Bu isim kullanýlýyor. Farklý bir pet ismi seçin.");
			return true;
		}
	}
	if(skin < 0) return Sunucu(playerid, "Geçersiz skin girdiniz.");
	new Float:x, Float:y, Float:z, Float:a, interior, world, query[192];
	GetPlayerPos(oyuncu, Float:x, Float:y, Float:z);
	GetPlayerFacingAngle(oyuncu, Float:a);
	interior = GetPlayerInterior(oyuncu);
	world = GetPlayerVirtualWorld(oyuncu);
	mysql_format(conn, query, sizeof(query), "INSERT INTO petler (Sahip, Isim, Skin, X, Y, Z, A, Interior, World) VALUES(%i, '%e', %i, %.4f, %.4f, %.4f, %.4f, %i, %i)",
	Karakter[oyuncu][id],
	petisim,
	skin,
	x,
	y,
	z,
	a,
	interior,
	world);
	mysql_tquery(conn, query, "PetYaratildi", "iisffffiii", playerid, oyuncu, petisim, x, y, z, a, skin, interior, world);
	return true;
}

Vice:PetYaratildi(playerid, oyuncu, petisim[], Float:x, Float:y, Float:z, Float:a, skin, interior, world)
{
	new petid = FCNPC_Create(petisim);
	Pet[petid][Gecerli] = true;
	Pet[petid][oyunid] = petid;
	Pet[petid][id] = cache_insert_id();
	FCNPC_Spawn(Pet[petid][oyunid], skin, Float:x + 2.0, Float:y, Float:z);
	FCNPC_SetAngle(Pet[petid][oyunid], Float:a - 180.0);
	FCNPC_SetHealth(Pet[petid][oyunid], 100.0);
	FCNPC_SetVirtualWorld(Pet[petid][oyunid], world);
	FCNPC_SetInterior(Pet[petid][oyunid], interior);
	format(Pet[petid][Isim], 32, "%s", petisim);
	Pet[petid][Sahip] = Karakter[oyuncu][id];
	Pet[petid][Skin] = skin;
	Pet[petid][Interior] = interior;
	Pet[petid][World] = world;
	Pet[petid][PetPos][0] = x;
	Pet[petid][PetPos][1] = y;
	Pet[petid][PetPos][2] = z;
	Pet[petid][PetPos][3] = a;
	new str[100];
	format(str, sizeof(str), "%s(%d)\nHP: %.2f", Pet[petid][Isim], Pet[petid][oyunid], FCNPC_GetHealth(Pet[petid][oyunid]));
	Pet[petid][PetLabel] = CreateDynamic3DTextLabel(str, RENK_KOYUYESIL, 0.0, 0.0, -0.25, 20.0, Pet[petid][oyunid]);
	Sunucu(playerid, "%s adlý kiþiye bir pet verdiniz. Ýsim: %s - Pet ID: %d - VeritabanýID: %d", RPIsim(oyuncu), petisim, Pet[petid][oyunid], Pet[petid][id]);
	Sunucu(oyuncu, "%s adlý yetkili size bir pet verdi. Ýsim: %s", RPIsim(playerid), petisim);
	return true;
}

Vice:PetYukle(playerid)
{
	new rows;
	cache_get_row_count(rows);
	if(rows)
	{
		new petid, str[100], petisim[32];
		for(new i; i < rows; i++)
		{
			cache_get_value_name(i, "Isim", petisim, 32);
			petid = FCNPC_Create(petisim);
			Pet[petid][Gecerli] = true;
			Pet[petid][oyunid] = petid;
			cache_get_value_name_int(i, "id", Pet[petid][id]);
			cache_get_value_name_int(i, "Skin", Pet[petid][Skin]);
			cache_get_value_name_int(i, "Interior", Pet[petid][Interior]);
			cache_get_value_name_int(i, "World", Pet[petid][World]);
			cache_get_value_name_float(i, "X", Pet[petid][PetPos][0]);
			cache_get_value_name_float(i, "Y", Pet[petid][PetPos][1]);
			cache_get_value_name_float(i, "Z", Pet[petid][PetPos][2]);
			cache_get_value_name_float(i, "A", Pet[petid][PetPos][3]);
			FCNPC_Spawn(Pet[petid][oyunid], Pet[petid][Skin], Pet[petid][PetPos][0] + 2.0, Pet[petid][PetPos][1], Pet[petid][PetPos][2]);
			FCNPC_SetAngle(Pet[petid][oyunid], Pet[petid][PetPos][3] - 180.0);
			FCNPC_SetHealth(Pet[petid][oyunid], 100.0);
			FCNPC_SetVirtualWorld(Pet[petid][oyunid], Pet[petid][World]);
			FCNPC_SetInterior(Pet[petid][oyunid], Pet[petid][Interior]);
			format(Pet[petid][Isim], 32, "%s", petisim);

			format(str, sizeof(str), "%s(%d)\nHP: %.2f", Pet[petid][Isim], Pet[petid][oyunid], FCNPC_GetHealth(Pet[petid][oyunid]));
			Pet[petid][PetLabel] = CreateDynamic3DTextLabel(str, RENK_KOYUYESIL, 0.0, 0.0, -0.25, 20.0, Pet[petid][oyunid]);
			Sunucu(playerid, "Petiniz %s dünyaya getirildi.", Pet[petid][Isim]);
		}
	}
	return true;
}

public FCNPC_OnTakeDamage(npcid, issuerid, Float:amount, weaponid, bodypart)
{
	new petid = PetIDCek(npcid);
	new str[100];
	if(FCNPC_GetHealth(Pet[petid][oyunid]) - amount > 0)
	{
		format(str, sizeof(str), "%s(%d)\nHP: %.2f", Pet[petid][Isim], Pet[petid][oyunid], FCNPC_GetHealth(Pet[petid][oyunid]) - amount);
	}
	else
	{
		format(str, sizeof(str), "%s(%d)\n[BU PET YARALI]", Pet[petid][Isim], Pet[petid][oyunid], FCNPC_GetHealth(Pet[petid][oyunid]) - amount);
	}	
	UpdateDynamic3DTextLabelText(Pet[petid][PetLabel], RENK_KOYUYESIL, str);
	return true;
}

Vice:PetIDCek(npcid)
{
	new petid;
	for(new i; i < MAX_PLAYERS; i++)
	{
		if(npcid == Pet[i][oyunid])
		{
			petid = Pet[i][oyunid];
			break;
		} 
	}
	return petid;
}