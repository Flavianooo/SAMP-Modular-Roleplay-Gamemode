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
					Sunucu(playerid, "[VCGuard] Hile korumas� taraf�ndan sunucudan at�ld�n�z.");
					Sunucu(playerid, "[VCGuard] E�er hatal� oldu�unu d���n�yorsan�z yetkililere bildirebilirsiniz.");
					AntiCheatKickWithDesync(playerid, code);	
				}

			}
			default:
			{
				Sunucu(playerid, "[VCGuard] Hile korumas� taraf�ndan sunucudan at�ld�n�z. KOD: #%d", code);
				Sunucu(playerid, "[VCGuard] E�er hatal� oldu�unu d���n�yorsan�z yetkililere bildirebilirsiniz.");
			}
		}
	}
	return true;
}