Vice:OnCheatDetected(playerid, ip_address[], type, code)
{
	if(type) BlockIpAddress(ip_address, 0);
	else
	{
		switch(code)
		{
			case 21:
			{
				if(Karakter[playerid][Giris] == true && Karakter[playerid][ACSpawn])
				{
					Sunucu(playerid, "[VCGuard] Hile korumasý tarafýndan sunucudan atýldýnýz.");
					Sunucu(playerid, "[VCGuard] Eðer hatalý olduðunu düþünüyorsanýz yetkililere bildirebilirsiniz.");
					AntiCheatKickWithDesync(playerid, code);	
				}

			}
			default:
			{
				Sunucu(playerid, "[VCGuard] Hile korumasý tarafýndan sunucudan atýldýnýz. KOD: #%d", code);
				Sunucu(playerid, "[VCGuard] Eðer hatalý olduðunu düþünüyorsanýz yetkililere bildirebilirsiniz.");
			}
		}
	}
	return true;
}