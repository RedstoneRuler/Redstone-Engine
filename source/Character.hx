package;

import flixel.FlxSprite;
import flixel.animation.FlxBaseAnimation;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.FlxG;

using StringTools;

class Character extends FlxSprite
{
	public var animOffsets:Map<String, Array<Dynamic>>;
	public var debugMode:Bool = false;

	public var isPlayer:Bool = false;
	public var curCharacter:String = 'bf';

	public var holdTimer:Float = 0;
	var playedAnimation = false;
	public function new(x:Float, y:Float, ?character:String = "bf", ?isPlayer:Bool = false)
	{
		animOffsets = new Map<String, Array<Dynamic>>();
		super(x, y);

		curCharacter = character;
		this.isPlayer = isPlayer;

		var tex:FlxAtlasFrames;
		antialiasing = true;
		if(curCharacter == 'gf' && FlxG.save.data.optimize == true)
		{
			curCharacter = 'gf-optimized';
		}
		if(isPlayer && curCharacter == 'bf' && FlxG.save.data.optimize == true)
		{
			curCharacter = 'bf-optimized';
		}
		switch (curCharacter)
		{
			case 'gf':
				// GIRLFRIEND CODE
				tex = FlxAtlasFrames.fromSparrow('assets/images/GF_assets.png', 'assets/images/GF_assets.xml');
				frames = tex;
				animation.addByPrefix('cheer', 'GF Cheer', 24, false);
				animation.addByPrefix('singLEFT', 'GF left note', 24, false);
				animation.addByPrefix('singRIGHT', 'GF Right Note', 24, false);
				animation.addByPrefix('singUP', 'GF Up Note', 24, false);
				animation.addByPrefix('singDOWN', 'GF Down Note', 24, false);
				animation.addByIndices('sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
				animation.addByIndices('hairBlow', "GF Dancing Beat Hair blowing", [0, 1, 2, 3], "", 24);
				animation.addByIndices('hairFall', "GF Dancing Beat Hair Landing", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], "", 24, false);
				animation.addByPrefix('scared', 'GF FEAR', 24);

				addOffset('cheer');
				addOffset('sad', -2, -2);
				addOffset('danceLeft', 0, -9);
				addOffset('danceRight', 0, -9);

				addOffset("singUP", 0, 4);
				addOffset("singRIGHT", 0, -20);
				addOffset("singLEFT", 0, -19);
				addOffset("singDOWN", 0, -20);
				addOffset('hairBlow', 45, -8);
				addOffset('hairFall', 0, -9);

				addOffset('scared', -2, -17);

				playAnim('danceRight');
			case 'gf-tankmen':
				// GIRLFRIEND CODE
				tex = FlxAtlasFrames.fromSparrow('assets/images/gfTankmen.png', 'assets/images/gfTankmen.xml');
				frames = tex;
				animation.addByIndices('sad', 'GF Crying at Gunpoint', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing at Gunpoint', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing at Gunpoint', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);

				addOffset('sad', -2, -2);
				addOffset('danceLeft', 0, -9);
				addOffset('danceRight', 0, -9);

				playAnim('danceRight');
			case "pico-speaker":
				tex = FlxAtlasFrames.fromSparrow("assets/images/picoSpeaker.png", "assets/images/picoSpeaker.xml");
				frames = tex;
				animation.addByPrefix("shoot1", "Pico shoot 1", 24, false);
				animation.addByIndices('shoot1-loop', 'Pico shoot 1', [4,5,6], "", 24, true);
				animation.addByPrefix("shoot2", "Pico shoot 2", 24, false);
				animation.addByIndices('shoot2-loop', 'Pico shoot 2', [4,5,6], "", 24, true);
				animation.addByPrefix("shoot3", "Pico shoot 3", 24, false);
				animation.addByIndices('shoot3-loop', 'Pico shoot 3', [4,5,6], "", 24, true);
				animation.addByPrefix("shoot4", "Pico shoot 4", 24, false);
				animation.addByIndices('shoot4-loop', 'Pico shoot 4', [4,5,6], "", 24, true);
				
				addOffset('shoot1', 0, 0);
				addOffset('shoot1-loop', 0, 0);
				addOffset('shoot2', -1, -128);
				addOffset('shoot2-loop', -1, -128);
				addOffset('shoot3', 412, -64);
				addOffset('shoot3-loop', 412, -64);
				addOffset('shoot4', 439, -19);
				addOffset('shoot4-loop', 439, -19);

				playAnim("shoot1");
			case 'gf-optimized':
				// GIRLFRIEND CODE					
				tex = FlxAtlasFrames.fromSparrow('assets/images/gf_optimized.png', 'assets/images/gf_optimized.xml');
				frames = tex;
				animation.addByPrefix('singLEFT', 'GF left note', 24, false);
				animation.addByPrefix('singRIGHT', 'GF Right Note', 24, false);
				animation.addByPrefix('singUP', 'GF Up Note', 24, false);
				animation.addByPrefix('singDOWN', 'GF Down Note', 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
	
				addOffset('danceLeft', 0, -9);
				addOffset('danceRight', 0, -9);

				addOffset("singUP", 0, 4);
				addOffset("singRIGHT", 0, -20);
				addOffset("singLEFT", 0, -19);
				addOffset("singDOWN", 0, -20);

				playAnim('danceRight');
			case 'gf-christmas':
				tex = FlxAtlasFrames.fromSparrow('assets/images/christmas/gfChristmas.png', 'assets/images/christmas/gfChristmas.xml');
				frames = tex;
				animation.addByPrefix('cheer', 'GF Cheer', 24, false);
				animation.addByPrefix('singLEFT', 'GF left note', 24, false);
				animation.addByPrefix('singRIGHT', 'GF Right Note', 24, false);
				animation.addByPrefix('singUP', 'GF Up Note', 24, false);
				animation.addByPrefix('singDOWN', 'GF Down Note', 24, false);
				animation.addByIndices('sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
				animation.addByIndices('hairBlow', "GF Dancing Beat Hair blowing", [0, 1, 2, 3], "", 24);
				animation.addByIndices('hairFall', "GF Dancing Beat Hair Landing", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], "", 24, false);
				animation.addByPrefix('scared', 'GF FEAR', 24);

				addOffset('cheer');
				addOffset('sad', -2, -2);
				addOffset('danceLeft', 0, -9);
				addOffset('danceRight', 0, -9);

				addOffset("singUP", 0, 4);
				addOffset("singRIGHT", 0, -20);
				addOffset("singLEFT", 0, -19);
				addOffset("singDOWN", 0, -20);
				addOffset('hairBlow', 45, -8);
				addOffset('hairFall', 0, -9);

				addOffset('scared', -2, -17);

				playAnim('danceRight');

			case 'gf-car':
				tex = FlxAtlasFrames.fromSparrow('assets/images/gfCar.png', 'assets/images/gfCar.xml');
				frames = tex;
				animation.addByIndices('singUP', 'GF Dancing Beat Hair blowing CAR', [0], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat Hair blowing CAR', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat Hair blowing CAR', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);

				addOffset('danceLeft', 0);
				addOffset('danceRight', 0);

				playAnim('danceRight');

			case 'gf-pixel':
				tex = FlxAtlasFrames.fromSparrow('assets/images/weeb/gfPixel.png', 'assets/images/weeb/gfPixel.xml');
				frames = tex;
				animation.addByIndices('singUP', 'GF IDLE', [2], "", 24, false);
				animation.addByIndices('danceLeft', 'GF IDLE', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF IDLE', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);

				addOffset('danceLeft', 0);
				addOffset('danceRight', 0);

				playAnim('danceRight');

				setGraphicSize(Std.int(width * PlayState.daPixelZoom));
				updateHitbox();
				antialiasing = false;

			case 'dad':
				// DAD ANIMATION LOADING CODE
				tex = FlxAtlasFrames.fromSparrow('assets/images/DADDY_DEAREST.png', 'assets/images/DADDY_DEAREST.xml');
				frames = tex;
				animation.addByPrefix('idle', 'Dad idle dance', 24, false);
				animation.addByIndices('idle-loop', 'Dad idle dance', [11, 12], "", 12, true);
				animation.addByPrefix('singUP', 'Dad Sing Note UP', 24, false);
				animation.addByIndices('singUP-loop', 'Dad Sing Note UP', [57, 58], "", 12, true);
				animation.addByPrefix('singRIGHT', 'Dad Sing Note RIGHT', 24, false);
				animation.addByIndices('singRIGHT-loop', 'Dad Sing Note RIGHT', [17, 18], "", 12, true);
				animation.addByPrefix('singDOWN', 'Dad Sing Note DOWN', 24, false);
				animation.addByPrefix('singLEFT', 'Dad Sing Note LEFT', 24, false);
				animation.addByIndices('singLEFT-loop', 'Dad Sing Note LEFT', [13, 14], "", 12, true);

				addOffset('idle');
				addOffset('idle-loop');
				addOffset("singUP", -6, 50);
				addOffset("singUP-loop", -6, 50);
				addOffset("singRIGHT", 0, 27);
				addOffset("singRIGHT-loop", 0, 27);
				addOffset("singLEFT", -10, 10);
				addOffset("singLEFT-loop", -10, 10);
				addOffset("singDOWN", 0, -30);

				playAnim('idle');
			case 'tylo':
				tex = FlxAtlasFrames.fromSparrow('assets/images/tylo_sheet.png', 'assets/images/tylo_sheet.xml');
				frames = tex;
				animation.addByPrefix('idle', 'idle', 12, false);
				animation.addByPrefix('singLEFT', 'singLEFT0', 16, false);
				animation.addByPrefix('singDOWN', 'singDOWN0', 16, false);
				animation.addByPrefix('singRIGHT', 'singRIGHT0', 16, false);
				animation.addByPrefix('singUP', 'singUP0', 16, false);

				addOffset('idle');
				addOffset("singLEFT");
				addOffset("singDOWN");
				addOffset("singUP");
				addOffset("singRIGHT");

				//His sprite sheet is a liiiiiiiitle small
				setGraphicSize(Std.int(width * 1.6));
				updateHitbox();

				playAnim('idle');
			case 'kdog':
				tex = FlxAtlasFrames.fromSparrow('assets/images/kdog.png', 'assets/images/kdog.xml');
				frames = tex;
				animation.addByPrefix('idle', 'kdog idle', 12, false);
				animation.addByPrefix('singLEFT', 'kdog left', 24, false);
				animation.addByPrefix('singDOWN', 'kdog down', 24, false);
				animation.addByPrefix('singRIGHT', 'kdog right', 24, false);
				animation.addByPrefix('singUP', 'kdog up', 24, false);
	
				addOffset('idle', 0, -1);
				addOffset("singLEFT", -103, -3);
				addOffset("singDOWN", -90, 0);
				addOffset("singUP", -110, -8);
				addOffset("singRIGHT");
				
				setGraphicSize(Std.int(width * 3.5));
				updateHitbox();
	
				playAnim('idle');
			case 'spooky':
				tex = FlxAtlasFrames.fromSparrow('assets/images/spooky_kids_assets.png', 'assets/images/spooky_kids_assets.xml');
				frames = tex;
				animation.addByPrefix('singUP', 'spooky UP NOTE', 24, false);
				animation.addByPrefix('singDOWN', 'spooky DOWN note', 24, false);
				animation.addByPrefix('singLEFT', 'note sing left', 24, false);
				animation.addByPrefix('singRIGHT', 'spooky sing right', 24, false);
				animation.addByIndices('danceLeft', 'spooky dance idle', [0, 2, 6], "", 12, false);
				animation.addByIndices('danceRight', 'spooky dance idle', [8, 10, 12, 14], "", 12, false);

				addOffset('danceLeft');
				addOffset('danceRight');

				addOffset("singUP", -20, 26);
				addOffset("singRIGHT", -130, -14);
				addOffset("singLEFT", 130, -10);
				addOffset("singDOWN", -50, -130);

				playAnim('danceRight');
			case 'mom':
				tex = FlxAtlasFrames.fromSparrow('assets/images/Mom_Assets.png', 'assets/images/Mom_Assets.xml');
				frames = tex;

				animation.addByPrefix('idle', "Mom Idle", 24, false);
				animation.addByIndices('idle-loop', 'Mom Idle', [10, 11, 12, 13], "", 24, true);
				animation.addByPrefix('singUP', "Mom Up Pose", 24, false);
				animation.addByIndices('singUP-loop', 'Mom Up Pose', [11, 12, 13, 14], "", 24, true);
				animation.addByPrefix('singDOWN', "MOM DOWN POSE", 24, false);
				animation.addByIndices('singDOWN-loop', "MOM DOWN POSE", [11, 12, 13, 14], "", 24, true);
				animation.addByPrefix('singLEFT', 'Mom Left Pose', 24, false);
				animation.addByIndices('singLEFT-loop', "Mom Left Pose", [6, 7, 8, 9], "", 24, true);
				// ANIMATION IS CALLED MOM POSE LEFT BUT IT'S FOR THE RIGHT
				// CUZ DAVE IS DUMB!
				animation.addByPrefix('singRIGHT', 'Mom Pose Left', 24, false);
				animation.addByIndices('singRIGHT-loop', "Mom Pose Left", [7, 8, 9], "", 24, true);

				addOffset('idle');
				addOffset('idle-loop');
				addOffset("singUP", 14, 71);
				addOffset("singUP-loop", 14, 71);
				addOffset("singRIGHT", 10, -60);
				addOffset("singRIGHT-loop", 10, -60);
				addOffset("singLEFT", 250, -23);
				addOffset("singLEFT-loop", 250, -23);
				addOffset("singDOWN", 20, -160);
				addOffset("singDOWN-loop", 20, -160);

				playAnim('idle');

			case 'mom-car':
				tex = FlxAtlasFrames.fromSparrow('assets/images/momCar.png', 'assets/images/momCar.xml');
				frames = tex;

				animation.addByPrefix('idle', "Mom Idle", 24, false);
				animation.addByIndices('idle-loop', 'Mom Idle', [10, 11, 12, 13], "", 24, true);
				animation.addByPrefix('singUP', "Mom Up Pose", 24, false);
				animation.addByIndices('singUP-loop', 'Mom Up Pose', [11, 12, 13, 14], "", 24, true);
				animation.addByPrefix('singDOWN', "MOM DOWN POSE", 24, false);
				animation.addByIndices('singDOWN-loop', "MOM DOWN POSE", [11, 12, 13, 14], "", 24, true);
				animation.addByPrefix('singLEFT', 'Mom Left Pose', 24, false);
				animation.addByIndices('singLEFT-loop', "Mom Left Pose", [6, 7, 8, 9], "", 24, true);
				// ANIMATION IS CALLED MOM POSE LEFT BUT IT'S FOR THE RIGHT
				// CUZ DAVE IS DUMB!
				animation.addByPrefix('singRIGHT', 'Mom Pose Left', 24, false);
				animation.addByIndices('singRIGHT-loop', "Mom Pose Left", [6, 7, 8, 9], "", 24, true);

				addOffset('idle');
				addOffset('idle-loop');
				addOffset("singUP", 14, 71);
				addOffset("singUP-loop", 14, 71);
				addOffset("singRIGHT", 10, -60);
				addOffset("singRIGHT-loop", 10, -60);
				addOffset("singLEFT", 250, -23);
				addOffset("singLEFT-loop", 250, -23);
				addOffset("singDOWN", 20, -160);
				addOffset("singDOWN-loop", 20, -160);

				playAnim('idle');
			case 'monster':
				tex = FlxAtlasFrames.fromSparrow('assets/images/Monster_Assets.png', 'assets/images/Monster_Assets.xml');
				frames = tex;
				animation.addByPrefix('idle', 'monster idle', 24, false);
				animation.addByPrefix('singUP', 'monster up note', 24, false);
				animation.addByPrefix('singDOWN', 'monster down', 24, false);
				animation.addByPrefix('singLEFT', 'Monster Right note', 24, false);
				animation.addByPrefix('singRIGHT', 'Monster left note', 24, false);

				addOffset('idle');
				addOffset("singUP", -20, 86);
				addOffset("singRIGHT", -51);
				addOffset("singLEFT", -30);
				addOffset("singDOWN", -40, -94);
				playAnim('idle');
			case 'monster-christmas':
				tex = FlxAtlasFrames.fromSparrow('assets/images/christmas/monsterChristmas.png', 'assets/images/christmas/monsterChristmas.xml');
				frames = tex;
				animation.addByPrefix('idle', 'monster idle', 24, false);
				animation.addByPrefix('singUP', 'monster up note', 24, false);
				animation.addByPrefix('singDOWN', 'monster down', 24, false);
				animation.addByPrefix('singLEFT', 'Monster Right note', 24, false);
				animation.addByPrefix('singRIGHT', 'Monster left note', 24, false);

				addOffset('idle');
				addOffset("singUP", -20, 50);
				addOffset("singRIGHT", -51);
				addOffset("singLEFT", -30);
				addOffset("singDOWN", -40, -94);
				playAnim('idle');
			case 'pico':
				tex = FlxAtlasFrames.fromSparrow('assets/images/Pico_FNF_assetss.png', 'assets/images/Pico_FNF_assetss.xml');
				frames = tex;
				animation.addByPrefix('idle', "Pico Idle Dance", 24, false);
				animation.addByPrefix('singUP', 'pico Up note0', 24, false);
				animation.addByPrefix('singDOWN', 'Pico Down Note0', 24, false);
				if (isPlayer)
				{
					animation.addByPrefix('singLEFT', 'Pico NOTE LEFT0', 24, false);
					animation.addByPrefix('singRIGHT', 'Pico Note Right0', 24, false);
					animation.addByPrefix('singRIGHTmiss', 'Pico Note Right Miss', 24, false);
					animation.addByPrefix('singLEFTmiss', 'Pico NOTE LEFT miss', 24, false);
				}
				else
				{
					// Need to be flipped! REDO THIS LATER!
					animation.addByPrefix('singLEFT', 'Pico Note Right0', 24, false);
					animation.addByPrefix('singRIGHT', 'Pico NOTE LEFT0', 24, false);
					animation.addByPrefix('singRIGHTmiss', 'Pico NOTE LEFT miss', 24, false);
					animation.addByPrefix('singLEFTmiss', 'Pico Note Right Miss', 24, false);
				}

				animation.addByPrefix('singUPmiss', 'pico Up note miss', 24, false);
				animation.addByPrefix('singDOWNmiss', 'Pico Down Note MISS', 24, false);

				addOffset('idle');
				addOffset("singUP", -29, 27);
				addOffset("singRIGHT", -68, -7);
				addOffset("singLEFT", 65, 9);
				addOffset("singDOWN", 200, -70);
				addOffset("singUPmiss", -19, 67);
				addOffset("singRIGHTmiss", -60, 41);
				addOffset("singLEFTmiss", 62, 64);
				addOffset("singDOWNmiss", 210, -28);

				playAnim('idle');

				flipX = true;
			case 'tankman':
				tex = FlxAtlasFrames.fromSparrow('assets/images/tankmanCaptain.png', 'assets/images/tankmanCaptain.xml');
				frames = tex;
				animation.addByPrefix('idle', "Tankman Idle Dance instance 1", 24, false);
				animation.addByPrefix('singUP', 'Tankman UP note instance 1', 24, false);
				animation.addByPrefix('singDOWN', 'Tankman DOWN note instance 1', 24, false);
				animation.addByPrefix('singLEFT', 'Tankman Right Note instance 1', 24, false);
				animation.addByPrefix('singRIGHT', 'Tankman Note Left instance 1', 24, false);

				animation.addByPrefix('singUP-alt', 'TANKMAN UGH instance 1', 24, false);
				animation.addByPrefix('singDOWN-alt', 'PRETTY GOOD tankman instance 1', 24, false);

				addOffset('idle');
				addOffset("singUP", 53, 53);
				addOffset("singRIGHT", -21, -27);
				addOffset("singLEFT", 101, -12);
				addOffset("singDOWN", 68, -90);
				addOffset("singUP-alt", -15, -9);
				addOffset("singDOWN-alt", 1, 16);

				playAnim('idle');
	
				flipX = true;
			case 'bf-optimized':
				var tex = FlxAtlasFrames.fromSparrow('assets/images/bf-optimized.png', 'assets/images/bf-optimized.xml');
				frames = tex;
				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);
				animation.addByPrefix('hey', 'BF HEY', 24, false);
				animation.addByPrefix('scared', 'BF idle shaking', 24);

				addOffset('idle', -5);
				addOffset("singUP", -49, 32);
				addOffset("singRIGHT", -54, -3);
				addOffset("singLEFT", 2, -3);
				addOffset("singDOWN", -20, -50);
				addOffset("singUPmiss", -29, 27);
				addOffset("singRIGHTmiss", -30, 21);
				addOffset("singLEFTmiss", 12, 24);
				addOffset("singDOWNmiss", -11, -19);
				addOffset("hey", -3, 6);
				addOffset('scared', -6, 1);

				playAnim('idle');
				
				playAnim('idle');
				flipX = true;

			case 'bf':
				var tex = FlxAtlasFrames.fromSparrow('assets/images/BOYFRIEND.png', 'assets/images/BOYFRIEND.xml');
				frames = tex;
				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);
				animation.addByPrefix('hey', 'BF HEY', 24, false);

				animation.addByPrefix('firstDeath', "BF dies", 24, false);
				animation.addByPrefix('deathLoop', "BF Dead Loop", 24, false);
				animation.addByPrefix('deathConfirm', "BF Dead confirm", 24, false);

				animation.addByPrefix('scared', 'BF idle shaking', 24);

				addOffset('idle', -5);
				addOffset("singUP", -49, 32);
				addOffset("singRIGHT", -54, -3);
				addOffset("singLEFT", 2, -3);
				addOffset("singDOWN", -20, -50);
				addOffset("singUPmiss", -29, 27);
				addOffset("singRIGHTmiss", -30, 21);
				addOffset("singLEFTmiss", 12, 24);
				addOffset("singDOWNmiss", -11, -19);
				addOffset("hey", -3, 6);
				addOffset('firstDeath', 37, 11);
				addOffset('deathLoop', 37, 5);
				addOffset('deathConfirm', 37, 69);
				addOffset('scared', -6, 1);

				playAnim('idle');

				flipX = true;
			case 'bf-holding-gf':
				var tex = FlxAtlasFrames.fromSparrow('assets/images/bfAndGF.png', 'assets/images/bfAndGF.xml');
				frames = tex;
				animation.addByPrefix('idle', 'BF idle dance w gf', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);
				animation.addByPrefix('catch', 'BF catches GF', 24, false);

				addOffset('idle');
				addOffset("singUP", -29, 10);
				addOffset("singRIGHT", -41, 23);
				addOffset("singLEFT", 12, 7);
				addOffset("singDOWN", -10, -10);
				addOffset("singUPmiss", -29, 10);
				addOffset("singRIGHTmiss", -41, 23);
				addOffset("singLEFTmiss", 12, 7);
				addOffset("singDOWNmiss", -10, -10);
				addOffset("catch", 0, 0);

				playAnim('idle');
				flipX = true;
			case 'bf-dead':
				var tex = FlxAtlasFrames.fromSparrow('assets/images/bf-dead.png', 'assets/images/bf-dead.xml');
				frames = tex;
				animation.addByPrefix('firstDeath', "BF dies", 24, false);
				animation.addByPrefix('deathLoop', "BF Dead Loop", 24, false);
				animation.addByPrefix('deathConfirm', "BF Dead confirm", 24, false);

				addOffset('firstDeath', 37, 11);
				addOffset('deathLoop', 37, 5);
				addOffset('deathConfirm', 37, 69);
				playAnim('firstDeath');
				flipX = true;

			case 'bf-holding-gf-dead':
				var tex = FlxAtlasFrames.fromSparrow('assets/images/bfHoldingGF-DEAD.png', 'assets/images/bfHoldingGF-DEAD.xml');
				frames = tex;
				animation.addByPrefix('firstDeath', "BF Dies with GF", 24, false);
				animation.addByPrefix('deathLoop', "BF Dead with GF Loop", 24, false);
				animation.addByPrefix('deathConfirm', "RETRY confirm holding gf", 24, false);

				addOffset('firstDeath', 37, 14);
				addOffset('deathLoop', 37, -3);
				addOffset('deathConfirm', 37, 28);
				playAnim('firstDeath');
				flipX = true;
			case 'bf-christmas':
				var tex = FlxAtlasFrames.fromSparrow('assets/images/christmas/bfChristmas.png', 'assets/images/christmas/bfChristmas.xml');
				frames = tex;
				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);
				animation.addByPrefix('hey', 'BF HEY', 24, false);

				addOffset('idle', -5);
				addOffset("singUP", -29, 27);
				addOffset("singRIGHT", -38, -7);
				addOffset("singLEFT", 12, -6);
				addOffset("singDOWN", -10, -50);
				addOffset("singUPmiss", -29, 27);
				addOffset("singRIGHTmiss", -30, 21);
				addOffset("singLEFTmiss", 12, 24);
				addOffset("singDOWNmiss", -11, -19);
				addOffset("hey", 7, 4);

				playAnim('idle');

				flipX = true;
			case 'bf-car':
				var tex = FlxAtlasFrames.fromSparrow('assets/images/bfCar.png', 'assets/images/bfCar.xml');
				frames = tex;
				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByIndices('idle-loop', 'BF idle dance', [11, 12, 10, 13], "", 24, true); //better swap between normal and loop
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByIndices('singUP-loop', 'BF NOTE UP0', [11, 12, 13, 14], "", 24, true);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				animation.addByIndices('singLEFT-loop', 'BF NOTE LEFT0', [12, 13, 14, 15], "", 24, true);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				animation.addByIndices('singRIGHT-loop', 'BF NOTE RIGHT0', [58, 59, 60, 61], "", 24, true);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByIndices('singDOWN-loop', 'BF NOTE DOWN0', [26, 27, 28, 29], "", 24, true);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);

				addOffset('idle', -5);
				addOffset('idle-loop', -5);
				addOffset("singUP", -29, 27);
				addOffset("singUP-loop", -29, 27);
				addOffset("singRIGHT", -38, -7);
				addOffset("singRIGHT-loop", -38, -7);
				addOffset("singLEFT", 12, -6);
				addOffset("singLEFT-loop", 12, -6);
				addOffset("singDOWN", -10, -50);
				addOffset("singDOWN-loop", -10, -50);
				addOffset("singUPmiss", -29, 27);
				addOffset("singRIGHTmiss", -30, 21);
				addOffset("singLEFTmiss", 12, 24);
				addOffset("singDOWNmiss", -11, -19);
				playAnim('idle');

				flipX = true;
			case 'bf-pixel':
				frames = FlxAtlasFrames.fromSparrow('assets/images/weeb/bfPixel.png', 'assets/images/weeb/bfPixel.xml');
				animation.addByPrefix('idle', 'BF IDLE', 24, false);
				animation.addByPrefix('singUP', 'BF UP NOTE', 24, false);
				animation.addByPrefix('singLEFT', 'BF LEFT NOTE', 24, false);
				animation.addByPrefix('singRIGHT', 'BF RIGHT NOTE', 24, false);
				animation.addByPrefix('singDOWN', 'BF DOWN NOTE', 24, false);
				animation.addByPrefix('singUPmiss', 'BF UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF DOWN MISS', 24, false);

				addOffset('idle');
				addOffset("singUP");
				addOffset("singRIGHT");
				addOffset("singLEFT");
				addOffset("singDOWN");
				addOffset("singUPmiss");
				addOffset("singRIGHTmiss");
				addOffset("singLEFTmiss");
				addOffset("singDOWNmiss");

				setGraphicSize(Std.int(width * 6));
				updateHitbox();

				playAnim('idle');

				width -= 100;
				height -= 100;

				antialiasing = false;

				flipX = true;
			case 'bf-pixel-dead':
				frames = FlxAtlasFrames.fromSparrow('assets/images/weeb/bfPixelsDEAD.png', 'assets/images/weeb/bfPixelsDEAD.xml');
				animation.addByPrefix('singUP', "BF Dies pixel", 24, false);
				animation.addByPrefix('firstDeath', "BF Dies pixel", 24, false);
				animation.addByPrefix('deathLoop', "Retry Loop", 24, false);
				animation.addByPrefix('deathConfirm', "RETRY CONFIRM", 24, false);
				animation.play('firstDeath');

				addOffset('firstDeath');
				addOffset('deathLoop', -37);
				addOffset('deathConfirm', -37);
				playAnim('firstDeath');
				// pixel bullshit
				setGraphicSize(Std.int(width * 6));
				updateHitbox();
				antialiasing = false;
				flipX = true;

			case 'senpai':
				frames = FlxAtlasFrames.fromSparrow('assets/images/weeb/senpai.png', 'assets/images/weeb/senpai.xml');
				animation.addByPrefix('idle', 'Senpai Idle', 24, false);
				animation.addByPrefix('singUP', 'SENPAI UP NOTE', 24, false);
				animation.addByPrefix('singLEFT', 'SENPAI LEFT NOTE', 24, false);
				animation.addByPrefix('singRIGHT', 'SENPAI RIGHT NOTE', 24, false);
				animation.addByPrefix('singDOWN', 'SENPAI DOWN NOTE', 24, false);

				addOffset('idle');
				addOffset("singUP", 5, 37);
				addOffset("singRIGHT");
				addOffset("singLEFT", 40);
				addOffset("singDOWN", 14);

				playAnim('idle');

				setGraphicSize(Std.int(width * 6));
				updateHitbox();

				antialiasing = false;
			case 'senpai-angry':
				frames = FlxAtlasFrames.fromSparrow('assets/images/weeb/senpai.png', 'assets/images/weeb/senpai.xml');
				animation.addByPrefix('idle', 'Angry Senpai Idle', 24, false);
				animation.addByPrefix('singUP', 'Angry Senpai UP NOTE', 24, false);
				animation.addByPrefix('singLEFT', 'Angry Senpai LEFT NOTE', 24, false);
				animation.addByPrefix('singRIGHT', 'Angry Senpai RIGHT NOTE', 24, false);
				animation.addByPrefix('singDOWN', 'Angry Senpai DOWN NOTE', 24, false);

				addOffset('idle');
				addOffset("singUP", 5, 37);
				addOffset("singRIGHT");
				addOffset("singLEFT", 40);
				addOffset("singDOWN", 14);

				playAnim('idle');

				setGraphicSize(Std.int(width * 6));
				updateHitbox();

				antialiasing = false;

			case 'spirit':
				frames = FlxAtlasFrames.fromSpriteSheetPacker('assets/images/weeb/spirit.png', 'assets/images/weeb/spirit.txt');
				animation.addByPrefix('idle', "idle spirit_", 24, false);
				animation.addByPrefix('singUP', "up_", 24, false);
				animation.addByPrefix('singRIGHT', "right_", 24, false);
				animation.addByPrefix('singLEFT', "left_", 24, false);
				animation.addByPrefix('singDOWN', "spirit down_", 24, false);

				addOffset('idle', -220, -280);
				addOffset('singUP', -220, -240);
				addOffset("singRIGHT", -220, -280);
				addOffset("singLEFT", -200, -280);
				addOffset("singDOWN", 170, 110);

				setGraphicSize(Std.int(width * 6));
				updateHitbox();

				playAnim('idle');

				antialiasing = false;

			case 'parents-christmas':
				frames = FlxAtlasFrames.fromSparrow('assets/images/christmas/mom_dad_christmas_assets.png',
					'assets/images/christmas/mom_dad_christmas_assets.xml');
				animation.addByPrefix('idle', 'Parent Christmas Idle', 24, false);
				
				animation.addByPrefix('singLEFT', 'Parent Left Note Dad', 24, false);
				animation.addByPrefix('singDOWN', 'Parent Down Note Dad', 24, false);
				animation.addByPrefix('singUP', 'Parent Up Note Dad', 24, false);
				animation.addByPrefix('singRIGHT', 'Parent Right Note Dad', 24, false);

				animation.addByPrefix('singLEFT-alt', 'Parent Left Note Mom', 24, false);
				animation.addByPrefix('singDOWN-alt', 'Parent Down Note Mom', 24, false);
				animation.addByPrefix('singUP-alt', 'Parent Up Note Mom', 24, false);
				animation.addByPrefix('singRIGHT-alt', 'Parent Right Note Mom', 24, false);

				addOffset('idle');
				addOffset("singUP", -47, 24);
				addOffset("singRIGHT", -1, -23);
				addOffset("singLEFT", -30, 16);
				addOffset("singDOWN", -31, -29);
				addOffset("singUP-alt", -47, 24);
				addOffset("singRIGHT-alt", -1, -24);
				addOffset("singLEFT-alt", -30, 15);
				addOffset("singDOWN-alt", -30, -27);

				playAnim('idle');
		}

		dance();

		if (isPlayer)
		{
			flipX = !flipX;
			// Doesn't flip for BF, since his are already in the right place???
			if (!curCharacter.startsWith('bf'))
			{
				// var animArray
				var oldRight = animation.getByName('singRIGHT').frames;
				animation.getByName('singRIGHT').frames = animation.getByName('singLEFT').frames;
				animation.getByName('singLEFT').frames = oldRight;

				// IF THEY HAVE MISS ANIMATIONS??
				if (animation.getByName('singRIGHTmiss') != null)
				{
					var oldMiss = animation.getByName('singRIGHTmiss').frames;
					animation.getByName('singRIGHTmiss').frames = animation.getByName('singLEFTmiss').frames;
					animation.getByName('singLEFTmiss').frames = oldMiss;
				}
			}
		}
		FlxG.log.add(curCharacter);
	}
	override function update(elapsed:Float)
	{
		if (!isPlayer)
		{
			if (animation.curAnim.name.startsWith('sing'))
			{
				if(animation.curAnim.name.contains("singDOWN-alt") && curCharacter == 'tankman' && !animation.curAnim.finished)
				{} else {
					holdTimer += elapsed;
				}
			}

			var dadVar:Float = 4;

			if (curCharacter == 'dad')
				dadVar = 6.1;
			if (holdTimer >= Conductor.stepCrochet * dadVar * 0.001)
			{
				dance();
				holdTimer = 0;
			}
		}

			if(curCharacter.startsWith('gf')) {
				if (animation.curAnim.name == 'hairFall' && animation.curAnim.finished)
				{
					playAnim('danceRight');
				}
			}

		if(animation.curAnim.finished)
		{
			if (animation.getByName(animation.curAnim.name + '-loop') != null)
			{
				playAnim(animation.curAnim.name + '-loop');
			}
		}
		super.update(elapsed);
	}

	private var danced:Bool = false;

	// FOR GF DANCING SHIT
	public function dance()
	{
		if (!debugMode)
		{
			if(animation.getByName('danceLeft') != null)
			{
				if (!animation.curAnim.name.startsWith('hair'))
				{
					danced = !danced;
					if (danced) {
						playAnim('danceRight', true);
					}
					else {
						playAnim('danceLeft',true);
					}
				}
			}
			else {
				playAnim('idle', true);
			}
		}
	}

	public function playAnim(AnimName:String, Force:Bool = false, Reversed:Bool = false, Frame:Int = 0):Void
	{
		if(animation.getByName(AnimName) != null) //Avoids warnings
		{
			animation.play(AnimName, Force, Reversed, Frame);
			var daOffset = animOffsets.get(animation.curAnim.name);
			if (animOffsets.exists(animation.curAnim.name))
			{
				offset.set(daOffset[0], daOffset[1]);
			}
			else
				offset.set(0, 0);
			if (curCharacter.startsWith('gf'))
			{
				if (AnimName == 'singLEFT')
				{
					danced = true;
				}
				else if (AnimName == 'singRIGHT')
				{
					danced = false;
				}
				if (AnimName == 'singUP' || AnimName == 'singDOWN')
				{
					danced = !danced;
				}
			}
		}
	}
	public function addOffset(name:String, x:Float = 0, y:Float = 0)
	{
		animOffsets[name] = [x, y];
	}
}