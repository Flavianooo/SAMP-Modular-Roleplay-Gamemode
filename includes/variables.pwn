new MySQL:conn;
new SunucuDakika = 0;
new SERVER_DOWNLOAD[] = "http://77.83.200.59/vc_03f753c08ba5ff2bd7d2ee230b4683b1/";
new SunucuZaman = 12;
new SunucuWeather = 2;

// Textdraw Deðiþkenleri

new PlayerText:YaraliTD[MAX_PLAYERS];
new PlayerText:KarakterSecimTD[8][MAX_PLAYERS];
new PlayerText:AracGostergesi[MAX_PLAYERS];

// --- ÇÝFTLÝK

new Text:tarim[9],PlayerText:tarim9[MAX_PLAYERS];
new Text:ciftlik_0,Text:ciftlik_1;

new PlayerBar:ciftlikprog[MAX_PLAYERS];
new Float:Doluluk[MAX_PLAYERS];
new ciftlikUpdater[MAX_PLAYERS];
new PlayerBar:bicimprog[MAX_PLAYERS];

// HESAP DEÐÝÞKENLERÝ
enum HESAP_BILGI
{
	id,
	Forumid,

	Oyunda,

	Yonetici,
	YoneticiIsim[32],

	PremiumSlot,

	KarakterSecim[4],
	KarakterSecimID[4],
	KarakterSeciminde,
	KarakterSkin[4],
	Karakter1[32],
	Karakter2[32],
	Karakter3[32],
	Karakter4[32],

	Hikaye[2048],
	Onay,

	// Market Ürünleri ve vCoin

	ViceCoin,
	VIP,
	IsimDegisimHakki,
	PlakaDegisimHakki,
	TelefonDegisimHakki,
	BisikletHakki,
	BesYetenekPuani,
	OnYetenekPuani,
	OnBesYetenekPuani,
	YetenekSifirlamaHakki,
	BankaHesapDegisimHakki,
	UcuncuDilHakki,
	MobilyaPaketi,
	EkonomiPaketi,
	DoublePayday,
	MaskeHakki,
	DortXExp,
	PremiumSkin[3],
	CoolAracPaketi,
	MeslekPaketi,
	OzelSkinAksesuar,

	// Geçici Deðerler
	KarakterVar,
	SecilenKarakter,
	SifreGirisTimer,
	bool:PMDurum,
	bool:Awork,
	bool:Swork
}
new Hesap[MAX_PLAYERS][HESAP_BILGI];

// KARAKTER DEÐÝÞKENLERÝ
enum KARAKTER_BILGI
{
	id,
	Olusturuldu,

	Isim[MAX_PLAYER_NAME+1],
	Skin,
	Float:SonPos[4],

	Float:SpecPos[4],
	SpecWorld,
	SpecInterior,

	Yas,
	Cinsiyet,
	Ten,
	Koken,

	Para,
	Saat,
	Dakika,
	Seviye,
	EXP,

	Ciftlik,
	Ekin,

	Float:Can,
	Float:Zirh,

	Rapor,
	Interior,
	VW,
	Yasakli,

	// Eþyalar

	Telefon,
	TelefonNumarasi,
	Sigara,

	// Yetenek Sistemi
	
	BalikYetenek[2],
	Liderlik[2],
	Uretim[2],
	Surus[2],
	Kimya[2],
	Hirsizlik[2],
	Guc[2],
	Dayaniklilik[2],

	// Balýk sistemi
	BalikYemi,
	Balik,
	bool:BalikTutuyor,
	BalikTimer,

	// Silah Sistemi

	Silah[MAX_OYUNCU_SILAH],
	SilahSeri[MAX_OYUNCU_SILAH],
	Mermi[MAX_OYUNCU_SILAH],

	// Birlik Sistemi
	Birlik,
	BirlikRutbe,

	// banka sistemi
	BankaNo,
	BankaPara,
	Mevduat,

	// Araç Sistemi

	AracAnahtar,
	Ehliyet,

	// Ev Sistemi

	KiralananEv,
	KiraOdeme,
	EvAnahtar,

	// Ýþyeri Sistemi

	KiralananIsyeri,
	IsyeriAnahtar,
	IsyeriOrtak,

	// Geçici Deðerler
	yYas,
	yCinsiyet,
	yTenRengi,
	yKoken,
	yIsim[MAX_PLAYER_NAME+1],
	Arama,
	Araniyor,
	Aramada,
	AracSpawnID[MAX_OYUNCU_ARAC],
	EvIsaretID[MAX_OYUNCU_EV],
	IsyeriIsaretID[MAX_OYUNCU_ISYERI],
	bool:SoruSordu,
	SoruIcerik[124],
	EtkilesimNPC,
	EtkilesimDeger,
	bool:Anim,
	Yarali,
	YaraliTimeri,
	YaraliSuresi,
	bool:BayginDurum,
	Text3D:YaraliText,
	EhliyetTesti,
	EhliyetCP,

	bool:ACSpawn,
	bool:KarakterSpawnlandi,
	bool:Giris
}
new Karakter[MAX_PLAYERS][KARAKTER_BILGI];

enum BIRLIK_BILGI
{
	id,
	Isim[40],
	Tur,
	Seviye,

	R1[32],
	R2[32],
	R3[32],
	R4[32],
	R5[32],
	R6[32],
	R7[32],
	R8[32],
	R9[32],
	R10[32],
	R11[32],
	R12[32],
	R13[32],
	R14[32],
	R15[32],
	R16[32],
	R17[32],
	R18[32],
	R19[32],
	R20[32],
	UyeYetkisi[20],

	bool:Gecerli
}
new Birlikler[MAX_BIRLIK][BIRLIK_BILGI];

// PET SÝSTEMÝ

enum PET_BILGI
{
	id,
	oyunid,
	Isim[32],

	Skin,
	Float:PetPos[4],
	Interior,
	World,

	Sahip,
	Text3D:PetLabel,

	bool:Gecerli
}
new Pet[MAX_PLAYERS][PET_BILGI];

// ÇÝFTLÝK SÝSTEMÝ

enum ciftlikEnum {
	cID,
	Float:cminX,
	Float:cminY,
	Float:cmaxX,
	Float:cmaxY,
	Float:cDonum,
	cSahipID,
	cIsim[50],
	cAktif,
	bool:cIslem,
	cKasa,
	cUrun,
	cOlgunlasma,
	cPara,
	cZone,
	cArsa
}
new CiftlikInfo[MAX_CIFTLIK][ciftlikEnum];

enum ekinEnum {
	ekinfiyat,
	ekinisim[20],
	ekinzaman
}
new ekinlerveri[][ekinEnum] = {
	{0, "Yok", 0},
	{10, "Arpa", 2},
	{15, "Buðday", 3},
    {20, "Mýsýr", 4},
    {25, "Þeker Pancarý", 5},
    {30, "Patates", 6},
    {35, "Ayçiçeði", 7},
    {40, "Kanola", 8}	
};

enum piyasaEnum {
	piyasaisim[20],
	Float:piyasax,
	Float:piyasay,
	Float:piyasaz,
	urun1,
	urun2,
	urun3,
	urun4,
	urun5,
	urun6,
	urun7
}
new piyasaveri[][piyasaEnum] = {
	{"Linton Mills", -23.2975,-269.7049,5.4297, 70, 110, 118, 130, 182, 230, 242},
	{"Whitney Grain", 1201.4846,245.2734,19.5547, 88, 100, 160, 180, 200, 232, 260},
	{"Greenwich Mill", 1546.9772,29.8143,24.1406, 72, 128, 140, 154, 220, 252, 272},
	{"Carmell Corn", -265.9543,-2213.5620,29.0420, 80, 108, 172, 200, 204, 256, 280},
	{"Solarin Industries", 2666.9336,-1474.1478,30.5938, 68, 112, 148, 188, 228, 220, 292}
};

// ARAÇ DEÐÝÞKENLERÝ

enum ARAC_BILGI
{
	id,

	Model,
	Plaka[32],
	Sahip,
	Vergi,
	Float:Benzin,
	Float:Kilometre,
	AracTur,
	
	AracKilit,
	// Silah Sistemi
	AracSilah[MAX_OYUNCU_SILAH],
	AracSilahMermi[MAX_OYUNCU_SILAH],
	AracSilahSeri[MAX_OYUNCU_SILAH],

	Renk[2],
	World,
	Interior,
	Float:AracPos[4],
	Float:AracSonPos[4],

	bool:Gecerli
}
new Araclar[MAX_VEHICLES][ARAC_BILGI];

enum BINA_BILGI
{
	id,

	bool:Gecerli,
	BinaAdi[24],
	Float:Ext[3],
	Float:Int[3],
	Interior,
	World,
	IcWorld,
	IcInterior,
	Durum,
	Tur,

	Pickup,
	Text3D:Label[124]
}
new Binalar[MAKSIMUM_BINA][BINA_BILGI];

enum EV_BILGI
{
	id,

	bool:Gecerli,
	Adres[32],
	Float:Ext[3],
	Float:Int[3],
	Interior,
	World,
	IcWorld,
	IcInterior,
	Durum,
	EvDekor,

	Fiyat,
	KiraFiyat,
	Sahip,
	SahipIsim[MAX_PLAYER_NAME+1],

	SatisTimer,
	Pickup,
	Text3D:Label[124]
}
new Evler[MAKSIMUM_EV][EV_BILGI];

enum ISYERI_BILGI
{
	id,

	bool:Gecerli,
	IsyeriAd[32],
	Adres[32],
	Float:Ext[3],
	Float:Int[3],
	Interior,
	World,
	IcWorld,
	IcInterior,
	Durum,
	Tur,
	Kasa,

	Fiyat,
	Sahip,
	SahipIsim[MAX_PLAYER_NAME+1],

	SatisTimer,
	Pickup,
	Text3D:Label[124],

	OrtakDurum
}
new Isyeri[MAKSIMUM_ISYERI][ISYERI_BILGI];

enum kokendil{kokendili[64]};
new kokendilleri[][kokendil] =
{
	{"Ýngilizce"},
	{"Ukraynaca"},
	{"Ýspanyolca"},
	{"Almanca"},
	{"Portekizce"},
	{"Ýtalyanca"},
	{"Rusça"},
	{"Çince"},
	{"Japonca"},
	{"Fransýzca"},
	{"Arnavutça"},
	{"Ermenice"},
	{"Azerice"},
	{"Boþnakça"},
	{"Bulgarca"},
	{"Çekce"},
	{"Arapça"},
	{"Estonca"},
	{"Fince"},
	{"Gürcüce"},
	{"Yunanca"},
	{"Felemenkçe"},
	{"Macarca"},
	{"Hintçe"},
	{"Endonezce"},
	{"Ýrlandaca"},
	{"Kazakça"},
	{"Litvanca"},
	{"Makedonca"},
	{"Korece"},
	{"Ýskoçça"},
	{"Rumence"},
	{"Sýrpça"},
	{"Slovakça"},
	{"Ýsveççe"},
	{"Mandarin"},
	{"Vietnamca"},
	{"Yugoslavca"},
	{"ibranice"}
};

enum kokendata{Ulke[32]};
new Kokenler[][kokendata] =
{
	{"Ingiltere"},
	{"Amerika"},
	{"Ukrayna"},
	{"Ispanya"},
	{"Almanya"},
	{"Brezilya"},
	{"Italya"},
	{"Rusya"},
	{"China"},
	{"Japonya"},
	{"Fransa"},
	{"Arnavutluk"},
	{"Arjantin"},
	{"Avustralya"},
	{"Andorrra"},
	{"Ermenistan"},
	{"Avusturya"},
	{"Azerbaycan"},
	{"Bahama"},
	{"Belarus"},
	{"Belcika"},
	{"Bolivya"},
	{"BosnaHersek"},
	{"Bulgaristan"},
	{"Kamerun"},
	{"Kanada"},
	{"Kolombiya"},
	{"KostaRika"},
	{"Kuba"},
	{"Cekya"},
	{"Dominik"},
	{"Misir"},
	{"Estonya"},
	{"Finlandiya"},
	{"Gana"},
	{"Gurcistan"},
	{"Guatemala"},
	{"Yunanistan"},
	{"Hollanda"},
	{"Haiti"},
	{"Macaristan"},
	{"Hindistan"},
	{"Endonezya"},
	{"Irlanda"},
	{"Jamaika"},
	{"Kazakistan"},
	{"Litvanya"},
	{"Makedonya"},
	{"Meksika"},
	{"YeniZelanda"},
	{"Nijerya"},
	{"KuzeyKore"},
	{"GuneyKore"},
	{"Panama"},
	{"Paraguay"},
	{"Filipin"},
	{"Portekiz"},
	{"Iskocya"},
	{"Romanya"},
	{"Sirbistan"},
	{"Slovakya"},
	{"Isvec"},
	{"Tayvan"},
	{"Uruguay"},
	{"Vietnam"},
	{"Venezuela"},
	{"Yugoslavya"},
	{"Ýsrail"}
};

new ErkekBeyazSkinler[] =
{	
	1,2,3,8,23,26,27,29,30,32,33,33,34,37,38,42,44,45,47,48,49,57,58,59,60,61,62,68,70,72,73,78,81,
	82,88,94,95,96,97,99,100,101,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,
	124,125,126,127,128,132,133,135,137,146,147,153,154,155,158,159,160, 161, 162, 164, 165, 167, 170, 171,
	173,174,175,177,179,181,184,185,186,187,188,189,200,202,203,204,206,208,210,212,213,217,223,227,228,
	229,230,234,235,236,240,241,242,247,248,249,250,252,254,255,258,259,261,268,272,273,289,290,291,292,
	294,299,303,304,305
};

new ErkekSiyahSkinler[] =
{
	4,5,6,7,14,15,16,17,18,19,20,21,22,24,25,28,36,50,51,66,67,79,80,83,84,86,102,103,104,105,106,107,134,136,142,
	143,144,156,163,168,180,182,183,220,221,222,253,260,262,293,296,297
};

new KadinBeyazSkinler[] =
{
	11,12,31,39,41,53,54,55,56,63,64,75,85,87,89,90,91,92,93,129,130,131,138,140,141,145,151,152,157,169,172,178,
	191,182,193,194,196,197,198,201,211,205,216,224,225,226,232,233,237,246,251,257,263
};

new KadinSiyahSkinler[] =
{
	9,10,40,69,76,190,195,207,215,218,219,238,243,244,245,256,298
};

new stock aracIsimler[][] = {
	"Landstalker", "Bravura", "Buffalo", "Linerunner", "Perrenial", "Sentinel", "Dumper", "Firetruck", "Trashmaster",
	"Stretch", "Manana", "Infernus", "Voodoo", "Pony", "Mule", "Cheetah", "Ambulance", "Leviathan", "Moonbeam",
	"Esperanto", "Taxi", "Washington", "Bobcat", "Whoopee", "BF Injection", "Hunter", "Premier", "Enforcer",
	"Securicar", "Banshee", "Predator", "Bus", "Rhino", "Barracks", "Hotknife", "Trailer", "Previon", "Coach",
	"Cabbie", "Stallion", "Rumpo", "RC Bandit", "Romero", "Packer", "Monster", "Admiral", "Squalo", "Seasparrow",
	"Pizzaboy", "Tram", "Trailer", "Turismo", "Speeder", "Reefer", "Tropic", "Flatbed", "Yankee", "Caddy", "Solair",
	"Berkley's", "Skimmer", "PCJ-600", "Faggio", "Freeway", "RC Baron", "RC Raider", "Glendale", "Oceanic",
	"Sanchez", "Sparrow", "Patriot", "Quad", "Coastguard", "Dinghy", "Hermes", "Sabre", "Rustler", "ZR-350", "Walton",
	"Regina", "Comet", "BMX", "Burrito", "Camper", "Marquis", "Baggage", "Dozer", "Maverick", "News Chopper", "Rancher",
	"FBI Rancher", "Virgo", "Greenwood", "Jetmax", "Hotring", "Sandking", "Blista", "Police Maverick",
	"Boxville", "Benson", "Mesa", "RC Goblin", "Hotring Racer A", "Hotring Racer B", "Bloodring Banger", "Rancher",
	"Super GT", "Elegant", "Journey", "Bike", "Mountain Bike", "Beagle", "Cropduster", "Stunt", "Tanker", "Roadtrain",
	"Nebula", "Majestic", "Buccaneer", "Shamal", "Hydra", "FCR-900", "NRG-500", "HPV1000", "Cement Truck", "Tow Truck",
	"Fortune", "Cadrona", "SWAT Truck", "Willard", "Forklift", "Tractor", "Combine", "Feltzer", "Remington", "Slamvan",
	"Blade", "Streak", "Freight", "Vortex", "Vincent", "Bullet", "Clover", "Sadler", "Firetruck", "Hustler", "Intruder",
	"Primo", "Cargobob", "Tampa", "Sunrise", "Merit", "Utility", "Nevada", "Yosemite", "Windsor", "Monster", "Monster",
	"Uranus", "Jester", "Sultan", "Stratum", "Elegy", "Raindance", "RC Tiger", "Flash", "Tahoma", "Savanna", "Bandito",
	"Freight Flat", "Streak Carriage", "Kart", "Mower", "Dune", "Sweeper", "Broadway", "Tornado", "AT-400", "DFT-30",
	"Huntley", "Stafford", "BF-400", "News Van", "Tug", "Trailer", "Emperor", "Wayfarer", "Euros", "Hotdog", "Club",
	"Freight Box", "Trailer", "Andromada", "Dodo", "RC Cam", "Launch", "VCPD Devriye Aracý", "VCPD Devriye Aracý", "VCPD Devriye Aracý",
	"Police Rancher", "Picador", "S.W.A.T", "Alpha", "Phoenix", "Glendale", "Sadler", "Luggage", "Luggage", "Stairs",
	"Boxville", "Tiller", "Utility Trailer"
};

new SatilikAraclar[][] = {
	{400, 45000, "Gerçek bir jip!"}, 
	{401, 19000, "Sürat teknesi!"}, 
	{402, 110000, "Fiyat performansta uçurur."}, 
	{404, 16000, "Ne varsa eskilerde var!"}, 
	{410, 15000, "Sýradan."}, 
	{412, 21000, "En badass araba."}, 
	{413, 29000, "Bir þeyler taþýyacaksan en iyisi."},
	{414, 40000, "Kapasitesi çok büyük."}, 
	{418, 25000, "Geniþ bir þey arýyorsan en iyisi.."}, 
	{419, 24000, "Ýspanyol rüyasý."}, {421, 50000, "Klasik severler."},
	{422, 22000, "Herkes kamyonet ister."}, 
	{426, 27200, "En çok tercih edilen, VCPD bile bundan alýyor!"}, 
	{429, 310000, "Yalnýzca üst seviye insanlara hitap eder!"}, 
	{436, 17000, "Ayaðýný yerden keser."}, {439, 39500, "Tam konfor!"},
	{440, 29000, "Daha iyisi yok."}, 
	{445, 42500, "Takým elbise giyenler için."}, 
	{456, 75000, "Ýþçilerin hayali."}, 
	{458, 27500, "Aile arabasý."}, 
	{459, 42000, "Müzik severler."}, 
	{461, 23000, "Hýz severler."},
	{462, 5000, "En hýzlý motor!"}, 
	{463, 18000, "Egzozu patlatýrken uzun yolculuklara hazýr mýyýz?"}, 
	{466, 13800, "En saðlam çelikten yapýldý!"}, 
	{467, 27500, "Vice Þehrinin sembolik arabasý."}, 
	{468, 20300, "Herkesin meraký."}, 
	{471, 27500, "En güzel hobi."},
	{474, 26000, "Varoþlarýn rüyasý."}, 
	{475, 55000, "Erkek gibi."}, 
	{477, 330000, "Richman bebeði"}, 
	{478, 15000, "Keyifli sürüþ"}, 
	{479, 19000, "Asla yolda kalmaz."}, 
	{480, 200000, "Kýzlarýn rüyasý."},
	{482, 39500, "Tam bir operasyon arabasý."}, 
	{483, 20000, "Þehrin en þirin arabasý!"}, 
	{489, 80000, "Yalnýzca patronlar biner!"}, 
	{491, 23500, "Hem klas hem ucuz!"}, 
	{492, 26000, "Gerçek bir klasik."}, 
	{496, 36000, "Hýzlý kaçar."},
	{498, 42000, "En güzel götürme arabasý."}, 
	{499, 49000, "Her þeyi taþýr."}, 
	{500, 45000, "Playboy adamlarýnýn rüyasý."}, 
	{505, 85000, "Richman klasiði"}, 
	{506, 300000, "Hýz peþindeysen bunu al"}, 
	{507, 27000, "Hýz tutkusu."},
	{508, 40000, "Keyifli yolculuklar ve tüttürmeler!"}, 
	{516, 29000, "Efsane bir araç."}, 
	{517, 27000, "Her zaman klasik."}, 
	{518, 26000, "Bütün kýzlar size bakacak!"}, 
	{521, 32000, "Hýz tutkunlarý için."}, 
	{526, 30000, "Çok klas."},
	{527, 24000, "Keyifli sürüþler."}, 
	{529, 17500, "Koltuklarý kadar rahat."}, 
	{533, 60000, "Hayat lüksü."}, 
	{534, 65000, "Richman klasiði"}, 
	{535, 53000, "Gençlerin rüyasý."}, 
	{536, 37500, "Varoþlarýn rüyasý."},
	{540, 23500, "Tam bir keyif arabasý."}, 
	{542, 16500, "Adeta bir porsche."}, 
	{543, 21000, "Asla yolda kalmaz."}, 
	{545, 85000, "Gerçek bir klasik ve Ýtalyan eseri."}, 
	{546, 22000, "Sadece iþini yapanlarýn arabasý."},
	{547, 26000, "En kullanýþlý araba."}, 
	{549, 11000, "Daha güzeli yok."}, 
	{550, 19000, "Ara sokaklarýn canavarý."}, 
	{551, 36000, "Takým giyen araba"}, 
	{554, 65000, "Konforlu parti canavarý."}, 
	{555, 110000, "Kadýn avcýsý."}, 
	{558, 54000, "Gizli güç"},
	{559, 56000, "Hýz ve konfor!"}, 
	{560, 125000, "Alabileceðin en iyi fiyat performans."}, 
	{561, 25250, "Her zaman güvenli."}, 
	{562, 80000, "Deðerini yalnýzca arabadan anlayanlar bilir."}, 
	{565, 60000, "Az yakar çok kaçar."},
	{566, 32000, "Ýþini bilenlerin arabasý."}, 
	{567, 35000, "En seksi araba."}, 
	{575, 47000, "Kadýnlarýn göz bebeði"}, 
	{576, 38000, "Hortum gibi."}, 
	{405, 33000, "Tank gibi."}, 
	{578, 58000, "Herkesi taþýr."}, 
	{579, 250000, "En klas araba."}, 
	{580, 140000, "Her dönemin klasiði."},
	{581, 23500, "Hýzý kim sevmez ki?"}, 
	{605, 5200, "Görünüþe önem vermiyorsanýz tam size göre!"}, 
	{604, 6800, "Temiz bir aile arabasý."}, 
	{585, 29000, "Ýþini yapar."}, 
	{586, 18500, "Hayalleri süsler."}, 
	{587, 57500, "Bu görünüm baþka yerde yok."}, 
	{589, 25500, "Küçük olduðuma bakma."},
	{600, 15000, "Asla yolda kalmaz."}, 
	{602, 56000, "Jantlarýn dumanýna gömül"}, 
	{451, 350000, "En klas ve hýzlý araba."}, 
	{415, 330000, "Vice Þehrinin Sembolü."}, 
	{541, 330000, "Daha kalitelisi yok."}, 
	{411, 360000, "Þehrin en hýzlýsý."},
	{603, 190000, "Býraksak konuþacak."},
	{424, 40000, "Asla yolda kalmaz."}, 
	{434, 70000, "Jantlarýn dumanýna gömül"}, 
	{457, 50000, "En klas ve hýzlý araba."}, 
	{460, 250000, "Vice Þehrinin Sembolü."}, 
	{495, 90000, "Daha kalitelisi yok."},
	{522, 300000, "Þehrin en hýzlýsý."},
	{409, 500000, "Býraksak konuþacak."},
	{423, 25000, "Dondurma aracý."},
	{470, 250000, "Askeri."},
	{486, 80000, "Dev bir dozer."},
	{494, 250000, "Hotring Racer..."},
	{502, 250000, "Hotring Racer A..."},
	{503, 250000, "Hotring Racer B..."},
    {504, 60000, "Býraksak konuþacak."},
	{508, 30000, "Karavan."},
	{524, 70000, "Dev bir dozer."},
	{556, 350000, "Canavar bir kamyon."},
	{557, 350000, "Canavar bir kamyon daha."},
	{568, 80000, "Býraksak konuþacak."},
	{588, 45000, "Sosisli..."},
	{532, 20000, "Tarlanýzý özenle biçer."},
	{531, 13000, "Tarlanýzý özenle eker."}
};

new faracveri[][] = {
	{482, 15000, 10},
	{498, 21000, 18},
	{499, 27000, 12},
	{578, 34000, 1},
	{515, 50000, 1},
	{426, 15000, 0},
	{488, 300000, 0},
	{582, 40000, 0},
	{466, 8000, 0},
	{492, 14000, 0},
	{445, 18000, 0},
	{507, 24000, 0},
	{428, 25000, 15},
	{438, 8000, 0},
	{420, 12000, 0},
	{418, 15000, 0},
	{525, 25000, 0},
	{416, 50000, 0},
	{544, 80000, 0},
	{407, 80000, 0},
	{417, 500000, 0},
	{409, 1000000, 0}
};

enum EV_DEKOR_ENUM {
	EvDekorId,
	EvDekorTip[32],
	EvDekorFiyat
}
new EvDekorlar[][EV_DEKOR_ENUM] = 
{
	{0, "Boþ Depo", 0},
	{1, "Ghetto", 15000},
	{2, "Orta Lüks", 10000},
	{3, "Orta Lüks", 10000},
	{4, "Lüks", 60000},
	{5, "Lüks", 40000},
	{6, "Lüks", 60000},
	{7, "Orta Lüks", 40000},
	{8, "Lüks", 30000},
	{9, "Orta Lüks", 60000},
	{10, "Lüks", 50000},
	{11, "Ghetto", 15000},
	{12, "Orta", 10000},
	{13, "Orta", 8000},
	{14, "Orta", 7000},
	{15, "Orta", 10000},
	{16, "Lüks", 30000},
	{17, "Tek Odalý", 5000},
	{18, "Lüks", 40000},
	{19, "Lüks", 50000},
	{20, "Lüks", 60000},
	{21, "Karavan", 5000},
	{22, "Lüks/Tek Odalý", 10000}
};