private["_int","_newModel","_doLoop","_wait","_hiveVer","_isHiveOk","_playerID","_playerObj","_randomSpot","_publishTo","_primary","_secondary","_key","_result","_charID","_playerObj","_playerName","_finished","_spawnPos","_spawnDir","_items","_counter","_magazines","_weapons","_group","_backpack","_worldspace","_direction","_newUnit","_score","_position","_isNew","_inventory","_backpack","_medical","_survival","_stats","_state"];
//Set Variables

diag_log ("STARTING LOGIN: " + str(_this));

_playerID = _this select 0;
_playerObj = _this select 1;
_playerName = name _playerObj;
_worldspace = [];

if (count _this > 2) then {
	dayz_players = dayz_players - [_this select 2];
};

//waitUntil{allowConnection};

//Variables
_inventory =	[];
_backpack = 	[];
_items = 		[];
_magazines = 	[];
_weapons = 		[];
_medicalStats =	[];
_survival =		[0,0,0];
_tent =			[];
_state = 		[];
_direction =	0;
_model =		"";
_newUnit =		objNull;

if (_playerID == "") then {
	_playerID = getPlayerUID _playerObj;
};

if ((_playerID == "") or (isNil "_playerID")) exitWith {
	diag_log ("LOGIN FAILED: Player [" + _playerName + "] has no login ID");
};

endLoadingScreen;
diag_log ("LOGIN ATTEMPT: " + str(_playerID) + " " + _playerName);

_key = format["CHILD:101:%1:%2:%3:",_playerID,dayZ_instance,_playerName];
_primary = [_key,false,dayZ_hivePipeAuth] call server_hiveReadWrite;

if (isNull _playerObj or !isPlayer _playerObj) exitWith {
	diag_log ("LOGIN RESULT: Exiting, player object null: " + str(_playerObj));
};

if ((_primary select 0) == "ERROR") exitWith {
    diag_log format ["LOGIN RESULT: Exiting, failed to load _primary: %1 for player: %2 ",_primary,_playerID];
};

//Process request
_newPlayer  = _primary select 1;
_isNew      = count _primary < 6;
_charID     = _primary select 2;
_randomSpot = false;
_hiveVer    = 0;

//Set character variables
_inventory = _primary select 4;
_backpack  = _primary select 5;
_survival  = _primary select 6;
_model     = _primary select 7;
_hiveVer   = _primary select 8;




diag_log ("LOGIN LOADED: " + str(_playerObj) + " Type: " + (typeOf _playerObj));
diag_log ("Inventory: " + str(_inventory));

_isHiveOk = false;
if (_hiveVer >= dayz_hiveVersionNo) then {
	_isHiveOk = true;
};

diag_log("Check");
diag_log("Inventory Count: " + str(count _inventory));
if (count _inventory == 1) then {
	diag_log("Inventory Select 0: " + str((_inventory select 0)));
	if ( (_inventory select 0) == "New Player" ) then {
		_chance = round(random 100);
		diag_log ("Random chance " + str(_chance));

		switch (true) do {
			case (_chance <= 5):
			{
				// Huntsman 5%
				_inventory = [["ItemCompass","ItemKnife","ItemFlashlight"], ["ItemPainkiller","ItemBandage"]];
				_backpack = ["CZ_VestPouch_EP1",[[],[]],[["FoodSteakCooked","ItemSodaCoke"],[1,1]]];
			};
			case (_chance <= 10):
			{
				// Police Officer 5%
				_inventory = [["M9","ItemFlashlightRed"], ["15Rnd_9x19_M9","15Rnd_9x19_M9","15Rnd_9x19_M9","ItemPainkiller","ItemBandage"]];
				_backpack = ["",[[],[]],[[],[]]];
			};
			
			case (_chance <= 15):
			{
				// Miltary 5%
				_inventory = [["MP5A5","ItemFlashlightRed","ItemGPS"], ["30Rnd_9x19_MP5","30Rnd_9x19_MP5","30Rnd_9x19_MP5","ItemPainkiller","ItemBandage"]];
				_backpack = ["DZ_Assault_Pack_EP1",[[],[]],[["FoodCanFrankBeans","ItemSodaCoke"],[1,1]]];
			};
			
			case (_chance <= 25):
			{
				// Camper Loadout 10%
				_inventory = [["ItemMatchbox","ItemCompass","ItemMap","ItemWatch","ItemFlashlight"], ["ItemTent","ItemPainkiller","ItemBandage"]];
				_backpack = ["DZ_CivilBackpack_EP1",[[],[]],[["FoodCanFrankBeans","ItemSodaCoke"],[1,1]]];
			};

			case (_chance <= 35):
			{
				// Woodsman 10%
				_inventory = [["MeleeHatchet"], ["ItemBandage","ItemCompass","ItemPainkiller","ItemBandage","ItemFlashlight"]];
				_backpack = ["DZ_Patrol_Pack_EP1",[[],[]],[["ItemHeatPack","ItemSodaCoke"],[1,1]]];
			};

			default
			{
				_inventory = [["ItemFlashlight","ItemMap"], ["ItemBandage","ItemPainkiller","ItemBandage"]];
				_backpack = ["DZ_CivilBackpack_EP1",[[],[]],[["FoodCanFrankBeans","ItemSodaCoke"],[1,1]]];
			};
		};
	};
};

_clientID = owner _playerObj;
dayzPlayerLogin = [_charID,_inventory,_backpack,_survival,_isNew,dayz_versionNo,_model,_isHiveOk,_newPlayer];
_clientID publicVariableClient "dayzPlayerLogin";

//_playerObj enableSimulation false;