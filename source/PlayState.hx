package;

import lime.app.Application;
import lime.graphics.RenderContextAttributes;
import Section.SwagSection;
import Song.SwagSong;
import WiggleEffect.WiggleEffectType;
import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.effects.FlxTrail;
import flixel.addons.effects.FlxTrailArea;
import flixel.addons.effects.chainable.FlxEffectSprite;
import flixel.addons.effects.chainable.FlxWaveEffect;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.atlas.FlxAtlas;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar;
import flixel.util.FlxCollision;
import flixel.util.FlxColor;
import flixel.util.FlxSort;
import flixel.util.FlxStringUtil;
import flixel.util.FlxTimer;
import haxe.Json;
import lime.utils.Assets;
import openfl.display.BlendMode;
import openfl.display.StageQuality;
import openfl.filters.ShaderFilter;
import openfl.Lib;

#if sys
import VideoHandler;
#end

using StringTools;

class PlayState extends MusicBeatState
{
	public static var curStage:String = '';
	public static var SONG:SwagSong;
	public static var isStoryMode:Bool = false;
	public static var storyWeek:Int = 0;
	public static var storyPlaylist:Array<String> = [];
	public static var storyDifficulty:Int = 1;
	public static var curSong:String = "";
	public static var deathCount:Int = 0;
	public static var practiceMode:Bool = false;
	public static var isPixelStage:Bool = false;
	public static var uiSkin:String;
	public static var noteSprite:FlxAtlasFrames;
	var halloweenLevel:Bool = false;

	private var vocals:FlxSound;

	private var dad:Character;
	private var gf:Character;
	private var boyfriend:Boyfriend;

	private var notes:FlxTypedGroup<Note>;
	private var unspawnNotes:Array<Note> = [];

	private var strumLine:FlxSprite;
	private var curSection:Int = 0;

	private var camFollow:FlxObject;

	private static var prevCamFollow:FlxObject;

	private var strumLineNotes:FlxTypedGroup<FlxSprite>;
	private var playerStrums:FlxTypedGroup<FlxSprite>;
	private var opponentStrums:FlxTypedGroup<FlxSprite>;
	var grpNoteSplashes:FlxTypedGroup<NoteSplash>;

	private var camZooming:Bool = false;

	private var gfSpeed:Int = 1;
	private var health:Float = 1;
	private var combo:Int = 0;

	private var healthBarBG:FlxSprite;
	private var healthBar:FlxBar;

	private var generatedMusic:Bool = false;
	private var startingSong:Bool = false;

	private var iconP1:HealthIcon;
	private var iconP2:HealthIcon;
	private var camHUD:FlxCamera;
	private var camGame:FlxCamera;

	var dialogue:Array<String> = ['blah blah blah', 'coolswag'];

	var halloweenBG:FlxSprite;
	var isHalloween:Bool = false;

	var phillyCityLights:FlxTypedGroup<FlxSprite>;
	var phillyTrain:FlxSprite;
	var trainSound:FlxSound;

	var limo:FlxSprite;
	var grpLimoDancers:FlxTypedGroup<BackgroundDancer>;
	var fastCar:FlxSprite;

	var upperBoppers:FlxSprite;
	var bottomBoppers:FlxSprite;
	var santa:FlxSprite;

	var bgGirls:BackgroundGirls;
	var wiggleShit:WiggleEffect = new WiggleEffect();

	var tankRolling:FlxSprite;
	var tankX:Int = 400;
	var tankSpeed:Float = FlxG.random.float(5, 7);
	var tankAngle:Float = FlxG.random.float(-90, 45);
	var tank0:FlxSprite;
	var tank1:FlxSprite;
	var tank2:FlxSprite;
	var tank3:FlxSprite;
	var tank4:FlxSprite;
	var tank5:FlxSprite;
	var tankWatchtower:FlxSprite;
	var picoStep:Ps;
	var tankStep:Ts;
	var tankmanRun:FlxTypedGroup<TankmenBG>;
	
	var talking:Bool = true;

	var songScore:Int = 0;
	var missCount:Int = 0;
	public static var changedDifficulty:Bool = false;
	var accuracy:Float = 100.00;
	var displayAccuracy:String = '?';
	var totalNotes:Int = 0;
	var firstHit:Bool = true;
	var goneUnder:Bool = false;
	var goneUnder100:Bool = false;

	var scoreTxt:FlxText;
	var missTxt:FlxText;
	var accuracyTxt:FlxText;

	var wasSickHit:Bool = false;

	var accuracyRating:String = '?';
	var clearStats:String = '';
	var hitRate:Float = 1; //Making sure you start at 100% accuracy if you hit a sick note
	public static var campaignScore:Int = 0;

	var defaultCamZoom:Float = 1.05;

	// how big to stretch the pixel art assets
	public static var daPixelZoom:Float = 6;

	var inCutscene:Bool = false;

	var altbeat:Bool = true;

	var wasPractice:Bool = false;
	var wasBotplay:Bool = false;
	var mashVar:Float = 0;
	var mashLimit:Float;

	var bfNote:Bool = false;
	var opponentNote:Bool = false;

	var sicks:Int = 0;
	var goods:Int = 0;
	var bads:Int = 0;
	var shits:Int = 0;

	static public var canHitOtherNote:Bool = false;
	static public var canHitNote:Bool = false;

	function preloadAssets():Void
		{
			var loadAssets:Array<Dynamic> = [];
			loadAssets.push(UILoader.loadImage('combo'));
			loadAssets.push(UILoader.loadImage('sick'));
			loadAssets.push(UILoader.loadImage('good'));
			loadAssets.push(UILoader.loadImage('bad'));
			loadAssets.push(UILoader.loadImage('shit'));

			loadAssets.push(UILoader.loadImage('num0'));
			loadAssets.push(UILoader.loadImage('num1'));
			loadAssets.push(UILoader.loadImage('num2'));
			loadAssets.push(UILoader.loadImage('num3'));
			loadAssets.push(UILoader.loadImage('num4'));
			loadAssets.push(UILoader.loadImage('num5'));
			loadAssets.push(UILoader.loadImage('num6'));
			loadAssets.push(UILoader.loadImage('num7'));
			loadAssets.push(UILoader.loadImage('num8'));
			loadAssets.push(UILoader.loadImage('num9'));
			if(FlxG.save.data.details)
			{
				if(SONG.song.toLowerCase() == 'stress')
					loadAssets.push(new FlxSprite().loadGraphic(Paths.image('tankmanKilled1')));
			}
		}
	
	override public function create()
	{
		noteSprite = UILoader.loadSparrowDirect('notes');
		curStage = 'stage';
		practiceMode = false;
		wasPractice = false;
		isPixelStage = false;
		// var gameCam:FlxCamera = FlxG.camera;
		camGame = new FlxCamera();
		camHUD = new FlxCamera();
		camHUD.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camHUD);

		FlxCamera.defaultCameras = [camGame];

		persistentUpdate = true;
		persistentDraw = true;

		if (SONG == null) {
			SONG = Song.loadFromJson('tutorial');
		}
		if(FlxG.save.data.splash) {
			grpNoteSplashes = new FlxTypedGroup<NoteSplash>();
			var sploosh = new NoteSplash(100, 100, 0);
			sploosh.alpha = 0.1;
			grpNoteSplashes.add(sploosh);
		}
		Conductor.mapBPMChanges(SONG);
		Conductor.changeBPM(SONG.bpm, SONG.numerator, SONG.denominator);
		switch (SONG.song.toLowerCase())
		{
			case 'tutorial':
				dialogue = ["Hey you're pretty cute.", 'Use the arrow keys to keep up\nwith me singing.'];
			case 'bopeebo':
				dialogue = [
					'HEY!',
					"You think you can just sing\nwith my daughter like that?",
					"If you want to date her...",
					"You're going to have to go\nthrough ME first!"
				];
			case 'fresh':
				dialogue = ["Not too shabby boy.", ""];
			case 'dad-battle':
				dialogue = [
					"gah you think you're hot stuff?",
					"If you can beat me here...",
					"Only then I will even CONSIDER letting you\ndate my daughter!"
				];
			case 'senpai':
				dialogue = CoolUtil.coolTextFile('assets/data/senpai/senpaiDialogue.txt');
			case 'roses':
				dialogue = CoolUtil.coolTextFile('assets/data/roses/rosesDialogue.txt');
			case 'thorns':
				dialogue = CoolUtil.coolTextFile('assets/data/thorns/thornsDialogue.txt');
		}
		switch(SONG.song.toLowerCase())
		{
			case 'spookeez' | 'south' | 'monster':
				curStage = "spooky";
			case 'pico' | 'philly-nice' | 'blammed':
				curStage = "philly";
			case 'satin-panties' | 'high' | 'milf':
				defaultCamZoom = 0.90;
				curStage = 'limo';
			case 'cocoa' | 'eggnog':
				defaultCamZoom = 0.80;
				curStage = 'mall';
			case 'winter-horrorland':
				curStage = 'mallEvil';
			case 'senpai' | 'roses':
				isPixelStage = true;
				curStage = 'school';
			case 'thorns':
				isPixelStage = true;
				curStage = 'schoolEvil';
			case 'ugh' | 'guns' | 'stress':
				defaultCamZoom = 0.9;
				curStage = "tank";
				picoStep = Json.parse(openfl.utils.Assets.getText(Paths.json('stress/picospeaker')));
				tankStep = Json.parse(openfl.utils.Assets.getText(Paths.json('stress/tankSpawn')));
		}
		if(isPixelStage) {
			uiSkin = 'pixel';
		} else {
			uiSkin = FlxG.save.data.uiSkin;
		}
		if(FlxG.save.data.bg)
		{
			if (curStage == 'spooky')
			{
				halloweenLevel = true;

				var hallowTex = FlxAtlasFrames.fromSparrow('assets/images/halloween_bg.png', 'assets/images/halloween_bg.xml');

				halloweenBG = new FlxSprite(-200, -100);
				halloweenBG.frames = hallowTex;
				halloweenBG.animation.addByPrefix('idle', 'halloweem bg0');
				halloweenBG.animation.addByPrefix('lightning', 'halloweem bg lightning strike', 24, false);
				halloweenBG.animation.play('idle');
				halloweenBG.antialiasing = true;
				add(halloweenBG);

				isHalloween = true;
			}
			else if (curStage == 'philly')
			{
				var bg:FlxSprite = new FlxSprite(-100).loadGraphic('assets/images/philly/sky.png');
				bg.scrollFactor.set(0.1, 0.1);
				add(bg);

				var city:FlxSprite = new FlxSprite(-10).loadGraphic('assets/images/philly/city.png');
				city.scrollFactor.set(0.3, 0.3);
				city.setGraphicSize(Std.int(city.width * 0.85));
				city.updateHitbox();
				add(city);

				phillyCityLights = new FlxTypedGroup<FlxSprite>();
				add(phillyCityLights);

				for (i in 0...5)
				{
					var light:FlxSprite = new FlxSprite(city.x).loadGraphic('assets/images/philly/win' + i + '.png');
					light.scrollFactor.set(0.3, 0.3);
					light.visible = false;
					light.setGraphicSize(Std.int(light.width * 0.85));
					light.updateHitbox();
					light.antialiasing = true;
					phillyCityLights.add(light);
				}

				var streetBehind:FlxSprite = new FlxSprite(-40, 50).loadGraphic('assets/images/philly/behindTrain.png');
				add(streetBehind);

				phillyTrain = new FlxSprite(2000, 360).loadGraphic('assets/images/philly/train.png');
				add(phillyTrain);

				trainSound = new FlxSound().loadEmbedded('assets/sounds/train_passes' + TitleState.soundExt);
				FlxG.sound.list.add(trainSound);

				// var cityLights:FlxSprite = new FlxSprite().loadGraphic(AssetPaths.win0.png);

				var street:FlxSprite = new FlxSprite(-40, streetBehind.y).loadGraphic('assets/images/philly/street.png');
				add(street);
			}
			else if (curStage == 'limo')
			{
				var skyBG:FlxSprite = new FlxSprite(-120, -50).loadGraphic('assets/images/limo/limoSunset.png');
				skyBG.scrollFactor.set(0.1, 0.1);
				add(skyBG);

				var bgLimo:FlxSprite = new FlxSprite(-200, 480);
				bgLimo.frames = FlxAtlasFrames.fromSparrow('assets/images/limo/bgLimo.png', 'assets/images/limo/bgLimo.xml');
				bgLimo.animation.addByPrefix('drive', "background limo pink", 24);
				bgLimo.animation.play('drive');
				bgLimo.scrollFactor.set(0.4, 0.4);
				add(bgLimo);

				grpLimoDancers = new FlxTypedGroup<BackgroundDancer>();
				add(grpLimoDancers);

				for (i in 0...5)
				{
					var dancer:BackgroundDancer = new BackgroundDancer((370 * i) + 130, bgLimo.y - 400);
					dancer.scrollFactor.set(0.4, 0.4);
					grpLimoDancers.add(dancer);
				}

				var overlayShit:FlxSprite = new FlxSprite(-500, -600).loadGraphic('assets/images/limo/limoOverlay.png');
				overlayShit.alpha = 0.5;
				add(overlayShit);

				// var shaderBullshit = new BlendModeEffect(new OverlayShader(), FlxColor.RED);

				// FlxG.camera.setFilters([new ShaderFilter(cast shaderBullshit.shader)]);

				// overlayShit.shader = shaderBullshit;

				var limoTex = FlxAtlasFrames.fromSparrow('assets/images/limo/limoDrive.png', 'assets/images/limo/limoDrive.xml');

				limo = new FlxSprite(-120, 550);
				limo.frames = limoTex;
				limo.animation.addByPrefix('drive', "Limo stage", 24);
				limo.animation.play('drive');
				limo.antialiasing = true;

				fastCar = new FlxSprite(-300, 160).loadGraphic('assets/images/limo/fastCarLol.png');
				// add(limo);
			}
			else if (curStage == 'mall')
			{
				var bg:FlxSprite = new FlxSprite(-1000, -500).loadGraphic('assets/images/christmas/bgWalls.png');
				bg.antialiasing = true;
				bg.scrollFactor.set(0.2, 0.2);
				bg.active = false;
				bg.setGraphicSize(Std.int(bg.width * 0.8));
				bg.updateHitbox();
				add(bg);

				upperBoppers = new FlxSprite(-240, -90);
				upperBoppers.frames = FlxAtlasFrames.fromSparrow('assets/images/christmas/upperBop.png', 'assets/images/christmas/upperBop.xml');
				upperBoppers.animation.addByPrefix('bop', "Upper Crowd Bob", 24, false);
				upperBoppers.antialiasing = true;
				upperBoppers.scrollFactor.set(0.33, 0.33);
				upperBoppers.setGraphicSize(Std.int(upperBoppers.width * 0.85));
				upperBoppers.updateHitbox();
				add(upperBoppers);

				var bgEscalator:FlxSprite = new FlxSprite(-1100, -600).loadGraphic('assets/images/christmas/bgEscalator.png');
				bgEscalator.antialiasing = true;
				bgEscalator.scrollFactor.set(0.3, 0.3);
				bgEscalator.active = false;
				bgEscalator.setGraphicSize(Std.int(bgEscalator.width * 0.9));
				bgEscalator.updateHitbox();
				add(bgEscalator);

				var tree:FlxSprite = new FlxSprite(370, -250).loadGraphic('assets/images/christmas/christmasTree.png');
				tree.antialiasing = true;
				tree.scrollFactor.set(0.40, 0.40);
				add(tree);

				bottomBoppers = new FlxSprite(-300, 140);
				bottomBoppers.frames = FlxAtlasFrames.fromSparrow('assets/images/christmas/bottomBop.png', 'assets/images/christmas/bottomBop.xml');
				bottomBoppers.animation.addByPrefix('bop', 'Bottom Level Boppers', 24, false);
				bottomBoppers.antialiasing = true;
				bottomBoppers.scrollFactor.set(0.9, 0.9);
				bottomBoppers.setGraphicSize(Std.int(bottomBoppers.width * 1));
				bottomBoppers.updateHitbox();
				add(bottomBoppers);

				var fgSnow:FlxSprite = new FlxSprite(-600, 700).loadGraphic('assets/images/christmas/fgSnow.png');
				fgSnow.active = false;
				fgSnow.antialiasing = true;
				add(fgSnow);

				santa = new FlxSprite(-840, 150);
				santa.frames = FlxAtlasFrames.fromSparrow('assets/images/christmas/santa.png', 'assets/images/christmas/santa.xml');
				santa.animation.addByPrefix('idle', 'santa idle in fear', 24, false);
				santa.antialiasing = true;
				add(santa);
			}
			else if (curStage == 'mallEvil')
			{
				var bg:FlxSprite = new FlxSprite(-400, -500).loadGraphic('assets/images/christmas/evilBG.png');
				bg.antialiasing = true;
				bg.scrollFactor.set(0.2, 0.2);
				bg.active = false;
				bg.setGraphicSize(Std.int(bg.width * 0.8));
				bg.updateHitbox();
				add(bg);

				var evilTree:FlxSprite = new FlxSprite(300, -300).loadGraphic('assets/images/christmas/evilTree.png');
				evilTree.antialiasing = true;
				evilTree.scrollFactor.set(0.2, 0.2);
				add(evilTree);

				var evilSnow:FlxSprite = new FlxSprite(-200, 700).loadGraphic("assets/images/christmas/evilSnow.png");
				evilSnow.antialiasing = true;
				add(evilSnow);
			}
			else if (curStage == 'school')
			{
				// defaultCamZoom = 0.9;

				var bgSky = new FlxSprite().loadGraphic('assets/images/weeb/weebSky.png');
				bgSky.scrollFactor.set(0.1, 0.1);
				add(bgSky);

				var repositionShit = -200;

				var bgSchool:FlxSprite = new FlxSprite(repositionShit, 0).loadGraphic('assets/images/weeb/weebSchool.png');
				bgSchool.scrollFactor.set(0.6, 0.90);
				add(bgSchool);

				var bgStreet:FlxSprite = new FlxSprite(repositionShit).loadGraphic('assets/images/weeb/weebStreet.png');
				bgStreet.scrollFactor.set(0.95, 0.95);
				add(bgStreet);

				var fgTrees:FlxSprite = new FlxSprite(repositionShit + 170, 130).loadGraphic('assets/images/weeb/weebTreesBack.png');
				fgTrees.scrollFactor.set(0.9, 0.9);
				add(fgTrees);

				var bgTrees:FlxSprite = new FlxSprite(repositionShit - 380, -800);
				var treetex = FlxAtlasFrames.fromSpriteSheetPacker('assets/images/weeb/weebTrees.png', 'assets/images/weeb/weebTrees.txt');
				bgTrees.frames = treetex;
				bgTrees.animation.add('treeLoop', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18], 12);
				bgTrees.animation.play('treeLoop');
				bgTrees.scrollFactor.set(0.85, 0.85);
				add(bgTrees);

				var treeLeaves:FlxSprite = new FlxSprite(repositionShit, -40);
				treeLeaves.frames = FlxAtlasFrames.fromSparrow('assets/images/weeb/petals.png', 'assets/images/weeb/petals.xml');
				treeLeaves.animation.addByPrefix('leaves', 'PETALS ALL', 24, true);
				treeLeaves.animation.play('leaves');
				treeLeaves.scrollFactor.set(0.85, 0.85);
				add(treeLeaves);

				var widShit = Std.int(bgSky.width * 6);

				bgSky.setGraphicSize(widShit);
				bgSchool.setGraphicSize(widShit);
				bgStreet.setGraphicSize(widShit);
				bgTrees.setGraphicSize(Std.int(widShit * 1.4));
				fgTrees.setGraphicSize(Std.int(widShit * 0.8));
				treeLeaves.setGraphicSize(widShit);

				fgTrees.updateHitbox();
				bgSky.updateHitbox();
				bgSchool.updateHitbox();
				bgStreet.updateHitbox();
				bgTrees.updateHitbox();
				treeLeaves.updateHitbox();

				bgGirls = new BackgroundGirls(-100, 190);
				bgGirls.scrollFactor.set(0.9, 0.9);

				if (SONG.song.toLowerCase() == 'roses')
				{
					bgGirls.getScared();
				}

				bgGirls.setGraphicSize(Std.int(bgGirls.width * daPixelZoom));
				bgGirls.updateHitbox();
				add(bgGirls);
			}
			else if (curStage == 'schoolEvil')
			{
				var waveEffectBG = new FlxWaveEffect(FlxWaveMode.ALL, 2, -1, 3, 2);
				var waveEffectFG = new FlxWaveEffect(FlxWaveMode.ALL, 2, -1, 5, 2);

				var posX = 400;
				var posY = 200;

				if(FlxG.save.data.shaders == true)
				{
					var bg:FlxSprite = new FlxSprite(posX, posY).loadGraphic('assets/images/weeb/evilSchoolBG.png');
					bg.scale.set(6, 6);
					// bg.setGraphicSize(Std.int(bg.width * 6));
					// bg.updateHitbox();
					add(bg);
	
					var fg:FlxSprite = new FlxSprite(posX, posY).loadGraphic('assets/images/weeb/evilSchoolFG.png');
					fg.scale.set(6, 6);
					// fg.setGraphicSize(Std.int(fg.width * 6));
					// fg.updateHitbox();
					add(fg);
	
					wiggleShit.effectType = WiggleEffectType.DREAMY;
					wiggleShit.waveAmplitude = 0.01;
					wiggleShit.waveFrequency = 60;
					wiggleShit.waveSpeed = 0.8;
	
					bg.shader = wiggleShit.shader;
					fg.shader = wiggleShit.shader;
	
					var waveSprite = new FlxEffectSprite(bg, [waveEffectBG]);
					var waveSpriteFG = new FlxEffectSprite(fg, [waveEffectFG]);
	
					// Using scale since setGraphicSize() doesnt work???
					waveSprite.scale.set(6, 6);
					waveSpriteFG.scale.set(6, 6);
					waveSprite.setPosition(posX + 80, posY + 165);
					waveSpriteFG.setPosition(posX + 80, posY + 165);
	
					waveSprite.scrollFactor.set(0.7, 0.8);
					waveSpriteFG.scrollFactor.set(0.9, 0.8);
	
					// waveSprite.setGraphicSize(Std.int(waveSprite.width * 6));
					// waveSprite.updateHitbox();
					// waveSpriteFG.setGraphicSize(Std.int(fg.width * 6));
					// waveSpriteFG.updateHitbox();
	
					add(waveSprite);
					add(waveSpriteFG);
				}
				else
				{
					var bg:FlxSprite = new FlxSprite(posX, posY);
					bg.frames = FlxAtlasFrames.fromSparrow('assets/images/weeb/animatedEvilSchool.png', 'assets/images/weeb/animatedEvilSchool.xml');
					bg.animation.addByPrefix('idle', 'background 2', 24);
					bg.animation.play('idle');
					bg.scrollFactor.set(0.8, 0.9);
					bg.scale.set(6, 6);
					add(bg);
				}
			}
			else if (curStage == 'tank')
			{
				var tankSky:FlxSprite = new FlxSprite(-400, -400).loadGraphic(Paths.image('tankSky'));
				tankSky.antialiasing = true;
				tankSky.scrollFactor.set(0, 0);
				add(tankSky);
				
				var tankClouds:FlxSprite = new FlxSprite(-700, -100).loadGraphic(Paths.image('tankClouds'));
				tankClouds.antialiasing = true;
				tankClouds.scrollFactor.set(0.1, 0.1);
				add(tankClouds);
				
				var tankMountains:FlxSprite = new FlxSprite(-300, -20).loadGraphic(Paths.image('tankMountains'));
				tankMountains.antialiasing = true;
				tankMountains.setGraphicSize(Std.int(tankMountains.width * 1.1));
				tankMountains.scrollFactor.set(0.2, 0.2);
				tankMountains.updateHitbox();
				add(tankMountains);
				
				var tankBuildings:FlxSprite = new FlxSprite(-200, 0).loadGraphic(Paths.image('tankBuildings'));
				tankBuildings.antialiasing = true;
				tankBuildings.setGraphicSize(Std.int(tankBuildings.width * 1.1));
				tankBuildings.scrollFactor.set(0.3, 0.3);
				tankBuildings.updateHitbox();
				add(tankBuildings);
				
				var tankRuins:FlxSprite = new FlxSprite(-200, 0).loadGraphic(Paths.image('tankRuins'));
				tankRuins.antialiasing = true;
				tankRuins.setGraphicSize(Std.int(tankRuins.width * 1.1));
				tankRuins.scrollFactor.set(0.35, 0.35);
				tankRuins.updateHitbox();
				add(tankRuins);

				var smokeLeft:FlxSprite = new FlxSprite(-200, -100).loadGraphic(Paths.image('smokeLeft'));
				smokeLeft.frames = Paths.getSparrowAtlas('smokeLeft');
				smokeLeft.animation.addByPrefix('idle', 'SmokeBlurLeft', 24, true);
				smokeLeft.animation.play('idle');
				smokeLeft.scrollFactor.set (0.4, 0.4);
				smokeLeft.antialiasing = true;
				add(smokeLeft);

				var smokeRight:FlxSprite = new FlxSprite(1100, -100).loadGraphic(Paths.image('smokeRight'));
				smokeRight.frames = Paths.getSparrowAtlas('smokeRight');
				smokeRight.animation.addByPrefix('idle', 'SmokeRight', 24, true);
				smokeRight.animation.play('idle');
				smokeRight.scrollFactor.set (0.4, 0.4);
				smokeRight.antialiasing = true;
				add(smokeRight);
				
				tankWatchtower = new FlxSprite(100, 50);
				tankWatchtower.frames = Paths.getSparrowAtlas('tankWatchtower');
				tankWatchtower.animation.addByPrefix('idle', 'watchtower gradient color', 24, false);
				tankWatchtower.animation.play('idle');
				tankWatchtower.scrollFactor.set(0.5, 0.5);
				tankWatchtower.antialiasing = true;
				add(tankWatchtower);

				tankmanRun = new FlxTypedGroup<TankmenBG>();
				add(tankmanRun);
				
				tankRolling = new FlxSprite(300,300);
				tankRolling.frames = Paths.getSparrowAtlas('tankRolling');
				tankRolling.animation.addByPrefix('idle', 'BG tank w lighting ', 24, true);
				tankRolling.scrollFactor.set(0.5, 0.5);
				tankRolling.antialiasing = true;
				tankRolling.animation.play('idle');	
				add(tankRolling);

				var tankGround:FlxSprite = new FlxSprite(-420, -150).loadGraphic(Paths.image('tankGround'));
				tankGround.setGraphicSize(Std.int(tankGround.width * 1.15));
				tankGround.updateHitbox();
				tankGround.antialiasing = true;
				add(tankGround);
				tank0 = new FlxSprite(-500, 650);
				tank0.frames = Paths.getSparrowAtlas('tank0');
				tank0.animation.addByPrefix('idle', 'fg tankhead far right', 24, false);
				tank0.scrollFactor.set(1.7, 1.5);
				tank0.antialiasing = true;

				tank1 = new FlxSprite(-300, 750);
				tank1.frames = Paths.getSparrowAtlas('tank1');
				tank1.animation.addByPrefix('idle', 'fg', 24, false);
				tank1.scrollFactor.set(2, 0.2);
				tank1.antialiasing = true;

				tank2 = new FlxSprite(450, 940);
				tank2.frames = Paths.getSparrowAtlas('tank2');
				tank2.animation.addByPrefix('idle', 'foreground', 24, false);
				tank2.scrollFactor.set(1.5, 1.5);
				tank2.antialiasing = true;

				tank4 = new FlxSprite(1300, 900);
				tank4.frames = Paths.getSparrowAtlas('tank4');
				tank4.animation.addByPrefix('idle', 'fg', 24, false);
				tank4.scrollFactor.set(1.5, 1.5);
				tank4.antialiasing = true;

				tank5 = new FlxSprite(1620, 700);
				tank5.frames = Paths.getSparrowAtlas('tank5');
				tank5.animation.addByPrefix('idle', 'fg', 24, false);
				tank5.scrollFactor.set(1.5, 1.5);
				tank5.antialiasing = true;

				tank3 = new FlxSprite(1300, 1200);
				tank3.frames = Paths.getSparrowAtlas('tank3');
				tank3.animation.addByPrefix('idle', 'fg', 24, false);
				tank3.scrollFactor.set(1.5, 1.5);
				tank3.antialiasing = true;
				add(tank0);
				add(tank1);
				add(tank2);
				add(tank4);
				add(tank5);
				add(tank3);
			}
			else if(curStage == 'stage')
			{
				var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic('assets/images/stageback.png');
				bg.antialiasing = true;
				bg.scrollFactor.set(0.9, 0.9);
				bg.active = false;
				add(bg);

				var stageFront:FlxSprite = new FlxSprite(-650, 600).loadGraphic('assets/images/stagefront.png');
				stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
				stageFront.updateHitbox();
				stageFront.antialiasing = true;
				stageFront.scrollFactor.set(0.9, 0.9);
				stageFront.active = false;
				add(stageFront);

				var stageCurtains:FlxSprite = new FlxSprite(-500, -300).loadGraphic('assets/images/stagecurtains.png');
				stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
				stageCurtains.updateHitbox();
				stageCurtains.antialiasing = true;
				stageCurtains.scrollFactor.set(1.3, 1.3);
				stageCurtains.active = false;

				add(stageCurtains);
			}
		}
		var gfVersion:String = 'gf';

		switch (curStage)
		{
			case 'stage':
				defaultCamZoom = 0.9;
			case 'limo':
				gfVersion = 'gf-car';
			case 'mall' | 'mallEvil':
				gfVersion = 'gf-christmas';
			case 'school':
				gfVersion = 'gf-pixel';
			case 'schoolEvil':
				gfVersion = 'gf-pixel';
			case 'tank':
				if(SONG.song.toLowerCase() == 'stress') {
					gfVersion = 'pico-speaker';
				} else {
					gfVersion = 'gf-tankmen';
				}
		}

		gf = new Character(400, 130, gfVersion);
		gf.scrollFactor.set(0.95, 0.95);

		dad = new Character(100, 100, SONG.player2);

		var camPos:FlxPoint = new FlxPoint(dad.getGraphicMidpoint().x, dad.getGraphicMidpoint().y);

		switch (SONG.player2)
		{
			case 'gf':
				dad.setPosition(gf.x, gf.y);
				gf.visible = false;
				if (isStoryMode)
				{
					camPos.x += 600;
					tweenCamIn();
				}

			case "spooky":
				dad.y += 200;
			case "monster":
				dad.y += 100;
			case 'monster-christmas':
				dad.y += 130;
			case 'dad':
				camPos.x += 400;
			case 'pico':
				camPos.x += 600;
				dad.y += 300;
			case 'parents-christmas':
				dad.x -= 500;
			case 'senpai':
				dad.x += 150;
				dad.y += 360;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
			case 'senpai-angry':
				dad.x += 150;
				dad.y += 360;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
			case 'spirit':
				dad.x -= 150;
				dad.y += 100;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
			case 'kdog':
				dad.x += 0;
				dad.y += 300;
				camPos.set(dad.getGraphicMidpoint().x + 550, dad.getGraphicMidpoint().y - 900);
			case 'tankman':
				dad.y += 150;
		}
		if(gfVersion == 'gf-tankmen')
		{
			gf.x -= 200;
		}
		else if(gfVersion == 'pico-speaker')
		{
			gf.x -= 140;
			gf.y -= 100;
		}

		boyfriend = new Boyfriend(770, 450, SONG.player1);
		var daScroll:Bool = FlxG.save.data.downscroll;
		// REPOSITIONING PER STAGE
		switch (curStage)
		{
			case 'limo':
				boyfriend.y -= 220;
				boyfriend.x += 260;
				if(FlxG.save.data.bg)
				{
					resetFastCar();
					add(fastCar);
				}

			case 'mall':
				boyfriend.x += 200;

			case 'mallEvil':
				boyfriend.x += 320;
				dad.y -= 80;
			case 'school':
				boyfriend.x += 200;
				boyfriend.y += 220;
					gf.x += 180;
					gf.y += 300;
			case 'schoolEvil':
				// trailArea.scrollFactor.set();

				var evilTrail = new FlxTrail(dad, null, 4, 24, 0.3, 0.069);
				// evilTrail.changeValuesEnabled(false, false, false, false);
				// evilTrail.changeGraphic()
				add(evilTrail);
				// evilTrail.scrollFactor.set(1.1, 1.1);

				boyfriend.x += 200;
				boyfriend.y += 220;
					gf.x += 180;
					gf.y += 300;
			case 'tank':
				boyfriend.x += 40;
				gf.x += 10;
				gf.y -= 30;
				dad.x -= 80;
				dad.y += 60;
		}
			add(gf);

		// Shitty layering but whatev it works LOL
		if (curStage == 'limo')
			add(limo);

		add(dad);
		add(boyfriend);

		var doof:DialogueBox = new DialogueBox(false, dialogue);
		// doof.x += 70;
		// doof.y = FlxG.height * 0.5;
		doof.scrollFactor.set();
		doof.finishThing = startCountdown;

		Conductor.songPosition = -5000;

		if(daScroll) //offset the strumline if downscroll is on
			strumLine = new FlxSprite(0, 550).makeGraphic(FlxG.width, 10);
		else
			strumLine = new FlxSprite(0, 50).makeGraphic(FlxG.width, 10);
		strumLine.scrollFactor.set();

		strumLineNotes = new FlxTypedGroup<FlxSprite>();
		add(strumLineNotes);
		if(FlxG.save.data.splash)
			add(grpNoteSplashes);
		playerStrums = new FlxTypedGroup<FlxSprite>();
		opponentStrums = new FlxTypedGroup<FlxSprite>();

		// startCountdown();

		generateSong(SONG.song);

		// add(strumLine);

		camFollow = new FlxObject(0, 0, 1, 1);

		camFollow.setPosition(camPos.x, camPos.y);

		if (prevCamFollow != null)
		{
			camFollow = prevCamFollow;
			prevCamFollow = null;
		}

		add(camFollow);
		// FlxG.camera.setScrollBounds(0, FlxG.width, 0, FlxG.height);
		FlxG.camera.zoom = defaultCamZoom;
		FlxG.camera.focusOn(camFollow.getPosition());

		FlxG.worldBounds.set(0, 0, FlxG.width, FlxG.height);

		FlxG.fixedTimestep = false;

		if(FlxG.save.data.downscroll)
			healthBarBG = new FlxSprite(0, (FlxG.height * 2)).loadGraphic('assets/images/healthBar.png');
		else 
			healthBarBG = new FlxSprite(0, FlxG.height * 0.9).loadGraphic('assets/images/healthBar.png');

		healthBarBG = new FlxSprite(0, FlxG.height * 0.9).loadGraphic('assets/images/healthBar.png');
		healthBarBG.screenCenter(X);
		healthBarBG.scrollFactor.set();
		add(healthBarBG);

		healthBar = new FlxBar(healthBarBG.x + 4, healthBarBG.y + 4, RIGHT_TO_LEFT, Std.int(healthBarBG.width - 8), Std.int(healthBarBG.height - 8), this,
			'health', 0, 2);
		healthBar.scrollFactor.set();
		healthBar.createFilledBar(0xFFFF0000, 0xFF66FF33);
		// healthBar
		add(healthBar);

		scoreTxt = new FlxText(healthBarBG.x + healthBarBG.width - 535, healthBarBG.y + 40, 0, "", 20);
		scoreTxt.setFormat("assets/fonts/vcr.ttf", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		scoreTxt.scrollFactor.set();
		add(scoreTxt);

		missTxt = new FlxText(healthBarBG.x + healthBarBG.width - 350, healthBarBG.y + 40, 0, "", 20);
		missTxt.setFormat("assets/fonts/vcr.ttf", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		missTxt.scrollFactor.set();
		add(missTxt);

		accuracyTxt = new FlxText(healthBarBG.x + healthBarBG.width - 200, healthBarBG.y + 40, 0, "", 20);
		accuracyTxt.setFormat("assets/fonts/vcr.ttf", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		accuracyTxt.scrollFactor.set();
		add(accuracyTxt);
		var iconDAD:String;
		
		iconP1 = new HealthIcon(SONG.player1, true);
		iconP1.y = healthBar.y - (iconP1.height / 2);
		add(iconP1);

		iconP2 = new HealthIcon(SONG.player2, false);
		iconP2.y = healthBar.y - (iconP2.height / 2);
		add(iconP2);
		
		if(FlxG.save.data.splash)
			grpNoteSplashes.cameras = [camHUD];
		strumLineNotes.cameras = [camHUD];
		notes.cameras = [camHUD];
		healthBar.cameras = [camHUD];
		healthBarBG.cameras = [camHUD];
		iconP1.cameras = [camHUD];
		iconP2.cameras = [camHUD];
		scoreTxt.cameras = [camHUD];
		missTxt.cameras = [camHUD];
		accuracyTxt.cameras = [camHUD];
		doof.cameras = [camHUD];

		// if (SONG.song == 'South')
		// FlxG.camera.alpha = 0.7;
		// UI_camera.zoom = 1;

		// cameras = [FlxG.cameras.list[1]];
		startingSong = true;
		if (isStoryMode)
		{
			switch (curSong.toLowerCase())
			{
				case "winter-horrorland":
					var blackScreen:FlxSprite = new FlxSprite(0, 0).makeGraphic(Std.int(FlxG.width * 2), Std.int(FlxG.height * 2), FlxColor.BLACK);
					add(blackScreen);
					blackScreen.scrollFactor.set();
					camHUD.visible = false;

					new FlxTimer().start(0.1, function(tmr:FlxTimer)
					{
						remove(blackScreen);
						FlxG.sound.play('assets/sounds/Lights_Turn_On' + TitleState.soundExt);
						camFollow.y = -2050;
						camFollow.x += 200;
						FlxG.camera.focusOn(camFollow.getPosition());
						FlxG.camera.zoom = 1.5;

						new FlxTimer().start(0.8, function(tmr:FlxTimer)
						{
							camHUD.visible = true;
							remove(blackScreen);
							FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom}, 2.5, {
								ease: FlxEase.quadInOut,
								onComplete: function(twn:FlxTween)
								{
									startCountdown();
								}
							});
						});
					});
				case 'senpai':
					schoolIntro(doof);
				case 'roses':
					FlxG.sound.play('assets/sounds/ANGRY' + TitleState.soundExt);
					schoolIntro(doof);
				case 'thorns':
					schoolIntro(doof);
				case 'ugh':
					playCutscene('ughCutscene.mp4');
				case 'guns':
					playCutscene('gunsCutscene.mp4');
				case 'stress':
					playCutscene('stressCutscene.mp4');
				default:
					startCountdown();
			}
		}
		else
		{
			switch (curSong.toLowerCase())
			{
				default:
					startCountdown();
			}
		}

		super.create();
	}
	function truncateFloat( number : Float, precision : Int): Float
	{
		var num = number;
		num = num * Math.pow(10, precision);
		num = Math.round( num ) / Math.pow(10, precision);
		return num;
	}
	function playCutscene(name:String, ?atend:Bool)
	{
		#if sys
		inCutscene = true;
	
		var video:VideoHandler = new VideoHandler();
		FlxG.sound.music.stop();
		video.finishCallback = function()
		{
			if (atend == true)
			{
				if (storyPlaylist.length <= 0)
					FlxG.switchState(new StoryMenuState());
				else
				{
					SONG = Song.loadFromJson(storyPlaylist[0].toLowerCase());
					FlxG.switchState(new PlayState());
				}
			}
			else
				startCountdown();
		}
		video.playVideo('assets/videos/' + name);
		#else
		startCountdown();
		#end
	}
	function schoolIntro(?dialogueBox:DialogueBox):Void
	{
		var black:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
		black.scrollFactor.set();
		add(black);

		var red:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, 0xFFff1b31);
		red.scrollFactor.set();

		var senpaiEvil:FlxSprite = new FlxSprite();
		senpaiEvil.frames = FlxAtlasFrames.fromSparrow('assets/images/weeb/senpaiCrazy.png', 'assets/images/weeb/senpaiCrazy.xml');
		senpaiEvil.animation.addByPrefix('idle', 'Senpai Pre Explosion', 24, false);
		senpaiEvil.x = 0;
		senpaiEvil.y = 0;
		senpaiEvil.setGraphicSize(Std.int(senpaiEvil.width * 6));
		senpaiEvil.scrollFactor.set();
		senpaiEvil.updateHitbox();
		senpaiEvil.screenCenter();

		if (SONG.song.toLowerCase() == 'roses' || SONG.song.toLowerCase() == 'thorns')
		{
			remove(black);

			if (SONG.song.toLowerCase() == 'thorns')
			{
				add(red);
			}
		}

		new FlxTimer().start(0.3, function(tmr:FlxTimer)
		{
			black.alpha -= 0.15;

			if (black.alpha > 0)
			{
				tmr.reset(0.3);
			}
			else
			{
				if (dialogueBox != null)
				{
					inCutscene = true;

					if (SONG.song.toLowerCase() == 'thorns')
					{
						add(senpaiEvil);
						senpaiEvil.alpha = 0;
						new FlxTimer().start(0.3, function(swagTimer:FlxTimer)
						{
							senpaiEvil.alpha += 0.15;
							if (senpaiEvil.alpha < 1)
							{
								swagTimer.reset();
							}
							else
							{
								senpaiEvil.animation.play('idle');
								FlxG.sound.play('assets/sounds/Senpai_Dies' + TitleState.soundExt, 1, false, null, true, function()
								{
									remove(senpaiEvil);
									remove(red);
									FlxG.camera.fade(FlxColor.WHITE, 0.01, true, function()
									{
										add(dialogueBox);
									}, true);
								});
								new FlxTimer().start(3.2, function(deadTime:FlxTimer)
								{
									FlxG.camera.fade(FlxColor.WHITE, 1.6, false);
								});
							}
						});
					}
					else
					{
						add(dialogueBox);
					}
				}
				else
					startCountdown();

				remove(black);
			}
		});
	}

	var startTimer:FlxTimer;
	var perfectMode:Bool = false;

	function startCountdown():Void
	{
		inCutscene = false;
		trace(noteSprite);
		generateStaticArrows(0);
		generateStaticArrows(1);

		talking = false;
		startedCountdown = true;
		Conductor.songPosition = 0;
		Conductor.songPosition -= Conductor.crochet * 5;

		// Higher BPMs will typically have more notes, so make the antimash more forgiving if that's the case, as the system does slip up sometimes
		// and increment the mash var for a proper hit as if it wasn't one
		mashLimit = 1.5 * (SONG.bpm / 50);
		FlxG.log.add('THE LIMIT ${mashLimit}');
		var swagCounter:Int = 0;

		startTimer = new FlxTimer().start(Conductor.crochet / 1000, function(tmr:FlxTimer)
		{
			/*
			if(Conductor.bpm > 150) {
				if(altbeat == true && dad.animation.getByName('danceLeft') == null) {
					dad.dance();
				}
				else if(dad.animation.getByName('danceLeft') != null) {
					dad.dance();
				}
				if(altbeat == true) {
					boyfriend.playAnim('idle', true);
				}
			}
			else {
			*/
				dad.dance();
				boyfriend.playAnim('idle', true);
			//}
			gf.dance();

			var altSuffix:String = "";
			if(isPixelStage)
			{
				altSuffix = '-pixel';
			}
			switch (swagCounter)
			{
				case 0:
					FlxG.sound.play('assets/sounds/intro3' + altSuffix + TitleState.soundExt, 0.6);
				case 1:
					var ready:FlxSprite = new FlxSprite().loadGraphic(UILoader.loadImage('ready'));
					ready.scrollFactor.set();
					ready.updateHitbox();

					if (isPixelStage)
						ready.setGraphicSize(Std.int(ready.width * daPixelZoom));

					ready.screenCenter();
					add(ready);
					FlxTween.tween(ready, {y: ready.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							ready.destroy();
						}
					});
					FlxG.sound.play('assets/sounds/intro2' + altSuffix + TitleState.soundExt, 0.6);
				case 2:
					var set:FlxSprite = new FlxSprite().loadGraphic(UILoader.loadImage('set'));
					set.scrollFactor.set();

					if (isPixelStage)
						set.setGraphicSize(Std.int(set.width * daPixelZoom));

					set.screenCenter();
					add(set);
					FlxTween.tween(set, {y: set.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							set.destroy();
						}
					});
					FlxG.sound.play('assets/sounds/intro1' + altSuffix + TitleState.soundExt, 0.6);
				case 3:
					var go:FlxSprite = new FlxSprite().loadGraphic(UILoader.loadImage('go'));
					go.scrollFactor.set();

					if (isPixelStage)
						go.setGraphicSize(Std.int(go.width * daPixelZoom));

					go.updateHitbox();

					go.screenCenter();
					add(go);
					FlxTween.tween(go, {y: go.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							go.destroy();
						}
					});
					FlxG.sound.play('assets/sounds/introGo' + altSuffix + TitleState.soundExt, 0.6);
				case 4:
			}

			swagCounter += 1;
			// generateSong('fresh');
		}, 5);
	}

	var previousFrameTime:Int = 0;
	var lastReportedPlayheadPosition:Int = 0;
	var songTime:Float = 0;

	function startSong():Void
	{
		preloadAssets();
		startingSong = false;

		previousFrameTime = FlxG.game.ticks;
		lastReportedPlayheadPosition = 0;

		if (!paused)
			FlxG.sound.playMusic("assets/songs/" + SONG.song.toLowerCase() + "/Inst" + TitleState.soundExt, 1, false);
		vocals.play();
	}

	var debugNum:Int = 0;

	private function generateSong(dataPath:String):Void
	{
		// FlxG.log.add(ChartParser.parse());
		var songData = SONG;
		FlxG.log.add(Conductor.bpm);
		FlxG.log.add(songData.bpm);
		Conductor.changeBPM(songData.bpm, songData.numerator, songData.denominator);
		curSong = songData.song;

		if(SONG.needsVoices) {
			vocals = new FlxSound().loadEmbedded("assets/songs/" + curSong.toLowerCase() + "/Voices" + TitleState.soundExt);
		}
		else {
			vocals = new FlxSound();
		}

		FlxG.sound.list.add(vocals);

		notes = new FlxTypedGroup<Note>();
		add(notes);

		var noteData:Array<SwagSection>;

		// NEW SHIT
		noteData = songData.notes;

		var playerCounter:Int = 0;

		var daBeats:Int = 0; // Not exactly representative of 'daBeats' lol, just how much it has looped
		for (section in noteData)
		{
			var dontExtend:Bool = false;
			var coolSection:Int = Std.int(section.lengthInSteps / Conductor.denominator);

			for (songNotes in section.sectionNotes)
			{
				var daStrumTime:Float = songNotes[0];
				var altNote:Bool = songNotes[3];
				var daNoteData:Int = Std.int(songNotes[1] % 4);

				if (FlxG.save.data.random == true) {
					daNoteData = FlxG.random.int(0,3);
				}
				var gottaHitNote:Bool = section.mustHitSection;
				if (songNotes[1] > 3)
				{
					gottaHitNote = !section.mustHitSection;
				}

				var oldNote:Note;
				if (unspawnNotes.length > 0)
					oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];
				else
					oldNote = null;

				var swagNote:Note = new Note(daStrumTime, daNoteData, oldNote, false, altNote);
				swagNote.sustainLength = songNotes[2];
				swagNote.scrollFactor.set(0, 0);

				var susLength:Float = swagNote.sustainLength;

				susLength = (susLength / Conductor.holdStepCrochet);
				unspawnNotes.push(swagNote);

				for (susNote in 0...Math.floor(susLength))
				{
					oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];

					var sustainNote:Note = new Note(daStrumTime + (Conductor.stepCrochet * susNote) + Conductor.stepCrochet, daNoteData, oldNote, true);
					sustainNote.scrollFactor.set();
					unspawnNotes.push(sustainNote);

					sustainNote.mustPress = gottaHitNote;

					if (sustainNote.mustPress)
					{
						sustainNote.x += FlxG.width / 2; // general offset
					}
				}

				swagNote.mustPress = gottaHitNote;

				if (swagNote.mustPress)
				{
					swagNote.x += FlxG.width / 2; // general offset
				}
			}
			daBeats += 1;
		}

		// trace(unspawnNotes.length);
		// playerCounter += 1;

		unspawnNotes.sort(sortByShit);

		generatedMusic = true;
	}

	function sortByShit(Obj1:Note, Obj2:Note):Int
	{
		return FlxSort.byValues(FlxSort.ASCENDING, Obj1.strumTime, Obj2.strumTime);
	}

	private function generateStaticArrows(player:Int):Void
	{
		for (i in 0...4)
		{
			// FlxG.log.add(i);
			var babyArrow:FlxSprite = new FlxSprite(0, strumLine.y);
			switch (curStage)
			{
				case 'school' | 'schoolEvil':
					babyArrow.loadGraphic('assets/ui_skins/pixel/arrows-pixels.png', true, 17, 17);
					babyArrow.animation.add('green', [6]);
					babyArrow.animation.add('red', [7]);
					babyArrow.animation.add('blue', [5]);
					babyArrow.animation.add('purplel', [4]);

					babyArrow.setGraphicSize(Std.int(babyArrow.width * daPixelZoom));
					babyArrow.updateHitbox();
					babyArrow.antialiasing = false;

					switch (Math.abs(i))
					{
						case 0:
							babyArrow.x += Note.swagWidth * 0;
							babyArrow.animation.add('static', [0]);
							babyArrow.animation.add('pressed', [4, 8], 12, false);
							babyArrow.animation.add('confirm', [12, 16], 16, false);
						case 1:
							babyArrow.x += Note.swagWidth * 1;
							babyArrow.animation.add('static', [1]);
							babyArrow.animation.add('pressed', [5, 9], 12, false);
							babyArrow.animation.add('confirm', [13, 17], 16, false);
						case 2:
							babyArrow.x += Note.swagWidth * 2;
							babyArrow.animation.add('static', [2]);
							babyArrow.animation.add('pressed', [6, 10], 12, false);
							babyArrow.animation.add('confirm', [14, 18], 16, false);
						case 3:
							babyArrow.x += Note.swagWidth * 3;
							babyArrow.animation.add('static', [3]);
							babyArrow.animation.add('pressed', [7, 11], 12, false);
							babyArrow.animation.add('confirm', [15, 19], 16, false);
					}

				default:
					babyArrow.frames = noteSprite;
					babyArrow.animation.addByPrefix('green', 'arrowUP');
					babyArrow.animation.addByPrefix('blue', 'arrowDOWN');
					babyArrow.animation.addByPrefix('purple', 'arrowLEFT');
					babyArrow.animation.addByPrefix('red', 'arrowRIGHT');

					babyArrow.antialiasing = true;
					babyArrow.setGraphicSize(Std.int(babyArrow.width * 0.7));
					switch (Math.abs(i))
					{
						case 0:
							babyArrow.x += Note.swagWidth * 0;
							babyArrow.animation.addByPrefix('static', 'arrowLEFT');
							babyArrow.animation.addByPrefix('pressed', 'left press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'left confirm', 18, false);
						case 1:
							babyArrow.x += Note.swagWidth * 1;
							babyArrow.animation.addByPrefix('static', 'arrowDOWN');
							babyArrow.animation.addByPrefix('pressed', 'down press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'down confirm', 18, false);
						case 2:
							babyArrow.x += Note.swagWidth * 2;
							babyArrow.animation.addByPrefix('static', 'arrowUP');
							babyArrow.animation.addByPrefix('pressed', 'up press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'up confirm', 18, false);
						case 3:
							babyArrow.x += Note.swagWidth * 3;
							babyArrow.animation.addByPrefix('static', 'arrowRIGHT');
							babyArrow.animation.addByPrefix('pressed', 'right press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'right confirm', 18, false);
					}
			}

			babyArrow.updateHitbox();
			babyArrow.scrollFactor.set();

			if (!isStoryMode)
			{
				babyArrow.y -= 10;
				babyArrow.alpha = 0;
				FlxTween.tween(babyArrow, {y: babyArrow.y + 10, alpha: 1}, 1, {ease: FlxEase.circOut, startDelay: 0.5 + (0.2 * i)});
			}
			babyArrow.ID = i;

			if (player == 1)
			{
				playerStrums.add(babyArrow);
			}
			else {
				opponentStrums.add(babyArrow);
			}

			babyArrow.animation.play('static');
			babyArrow.x += 50;
			babyArrow.x += ((FlxG.width / 2) * player);

			strumLineNotes.add(babyArrow);
		}
	}

	function tweenCamIn():Void
	{
		FlxTween.tween(FlxG.camera, {zoom: 1.3}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.elasticInOut});
	}

	override function openSubState(SubState:FlxSubState)
	{
		if (paused)
		{
			if (FlxG.sound.music != null)
			{
				FlxG.sound.music.pause();
				vocals.pause();
			}

			if (!startTimer.finished)
				startTimer.active = false;
		}

		super.openSubState(SubState);
	}

	override function closeSubState()
	{
		if (paused)
		{
			if (FlxG.sound.music != null && !startingSong)
			{
				resyncVocals();
			}

			if (!startTimer.finished)
				startTimer.active = true;
			paused = false;
		}

		super.closeSubState();
	}

	function resyncVocals():Void
	{
		vocals.pause();

		FlxG.sound.music.play();
		Conductor.songPosition = FlxG.sound.music.time;
		vocals.time = Conductor.songPosition;
		vocals.play();
	}

	private var paused:Bool = false;
	var startedCountdown:Bool = false;
	var canPause:Bool = true;

	function dadNoteShit(daNote:Note):Void
	{
		opponentStrums.forEach(function(spr:FlxSprite)
		{
			if (Math.abs(daNote.noteData) == spr.ID)
			{
				spr.animation.play('confirm', true);
				if(!isPixelStage) {
					spr.centerOffsets();
					spr.offset.x -= 13;
					spr.offset.y -= 13;
				}
			}
		});
	}
	function bfNoteShit(daNote:Note):Void
	{
		bfNote = true;
		opponentNote = false;
		playerStrums.forEach(function(spr:FlxSprite)
		{
			if (Math.abs(daNote.noteData) == spr.ID)
			{
				spr.animation.play('confirm', true);
				if(!PlayState.isPixelStage) {
					spr.centerOffsets();
					spr.offset.x -= 13;
					spr.offset.y -= 13;
				}
			}
		});
	}
	override public function update(elapsed:Float)
	{
		FlxG.watch.addQuick('bfNote', bfNote);
		FlxG.watch.addQuick('opponentNote', opponentNote);
		if(startedCountdown && wasPractice) {
			FlxG.sound.music.onComplete = gameOverPractice;
		} else {
			FlxG.sound.music.onComplete = endSong;
		}
		var refreshRate:Int = Application.current.window.displayMode.refreshRate;
		if(FlxG.save.data.fps == refreshRate)
		{
		}
		else
		{
		}
		#if debug
		if (FlxG.keys.pressed.SPACE) //mouse wheel health easter egg
		{
			health += FlxG.mouse.wheel / 5;
		}
		#end
		#if !debug
		perfectMode = false;
		#end
		/*
		if (FlxG.keys.justPressed.NINE)
		{
			if (iconP1.animation.curAnim.name == 'bf-old')
				iconP1.animation.play(SONG.player1);
			else
				iconP1.animation.play('bf-old');
		}
		*/

		if(FlxG.save.data.bg)
		{
			switch (curStage)
			{
				case 'philly':
					if (trainMoving)
					{
						trainFrameTiming += elapsed;

						if (trainFrameTiming >= 1 / 24)
						{
							updateTrainPos();
							trainFrameTiming = 0;
						}
					}
					phillyCityLights.members[curLight].alpha -= (Conductor.crochet / 1000) * FlxG.elapsed;
				case 'tank':
					moveTank();
			}
		}

		super.update(elapsed);
		if(practiceMode == true) {
			wasPractice = true;
		}
		if(FlxG.save.data.bot == true) {
			wasBotplay = true;
		}
		if(FlxG.save.data.bot != true) {
			scoreTxt.text = "Score: " + songScore;
			missTxt.text = "Misses: " + missCount;
			if(displayAccuracy == '?')
				accuracyTxt.text = "Accuracy: " + displayAccuracy;
			else
				accuracyTxt.text = "Accuracy: " + displayAccuracy + "% - " + accuracyRating + ' (${clearStats})';
		} else{
			scoreTxt.text = "";
			missTxt.text = "AUTOPLAY ON";
			accuracyTxt.text = "";
		}
		if (FlxG.keys.justPressed.ENTER && startedCountdown && canPause)
		{
			persistentUpdate = false;
			persistentDraw = true;
			paused = true;

			openSubState(new PauseSubState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
		}

		if (FlxG.keys.justPressed.SEVEN)
		{
			FlxG.switchState(new ChartingState());
		}

		// FlxG.watch.addQuick('VOL', vocals.amplitudeLeft);
		// FlxG.watch.addQuick('VOLRight', vocals.amplitudeRight);

		iconP1.setGraphicSize(Std.int(FlxMath.lerp(iconP1.width, 150, 0.09 / (FPS_Mem.times.length / 144))));
		iconP2.setGraphicSize(Std.int(FlxMath.lerp(iconP2.width, 150, 0.09 / (FPS_Mem.times.length / 144))));

		iconP1.updateHitbox();
		iconP2.updateHitbox();

		var iconOffset:Int = 26;

		iconP1.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01) - iconOffset);
		iconP2.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01)) - (iconP2.width - iconOffset);

		if (health > 2)
			health = 2;

		if (healthBar.percent < 20) {
			iconP1.animation.curAnim.curFrame = 1;
			iconP2.animation.curAnim.curFrame = 2;
		}
		else if (healthBar.percent > 80) {
			iconP2.animation.curAnim.curFrame = 1;
			iconP1.animation.curAnim.curFrame = 2;
		}
		else {
			iconP2.animation.curAnim.curFrame = 0;
			iconP1.animation.curAnim.curFrame = 0;
		}

		/* if (FlxG.keys.justPressed.NINE)
			FlxG.switchState(new Charting()); */

		#if debug
		if (FlxG.keys.justPressed.EIGHT)
			FlxG.switchState(new AnimationDebug(SONG.player2));
		#end

		if (startingSong)
		{
			if (startedCountdown)
			{
				Conductor.songPosition += FlxG.elapsed * 1000;
				if (Conductor.songPosition >= 0)
					startSong();
			}
		}
		else
		{
			//Conductor.songPosition = FlxG.sound.music.time;
			Conductor.songPosition += FlxG.elapsed * 1000;

			if (!paused)
			{
				songTime += FlxG.game.ticks - previousFrameTime;
				previousFrameTime = FlxG.game.ticks;

				// Interpolation type beat
				if (Conductor.lastSongPos != Conductor.songPosition)
				{
					songTime = (songTime + Conductor.songPosition) / 2;
					Conductor.lastSongPos = Conductor.songPosition;
					// Conductor.songPosition += FlxG.elapsed * 1000;
					// trace('MISSED FRAME');
				}
			}

			// Conductor.lastSongPos = FlxG.sound.music.time;
		}
		FlxG.camera.follow(camFollow, LOCKON, 0.04 * (60 / FPS_Mem.times.length));
		FlxG.watch.addQuick('FPS', FPS_Mem.times.length);
		if (generatedMusic && PlayState.SONG.notes[Std.int(curStep / 16)] != null)
		{
			if (curBeat % 4 == 0)
			{
				//trace(PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection);
			}

			if (camFollow.x != dad.getMidpoint().x + 150 && (!PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection && SONG.autoCamera != true || opponentNote == true
				&& SONG.autoCamera == true))
			{
				camFollow.setPosition(dad.getMidpoint().x + 150, dad.getMidpoint().y - 100);
				// camFollow.setPosition(lucky.getMidpoint().x - 120, lucky.getMidpoint().y + 210);
				switch (dad.curCharacter)
				{
					case 'mom':
						camFollow.y = dad.getMidpoint().y;
					case 'senpai':
						camFollow.y = dad.getMidpoint().y - 430;
						camFollow.x = dad.getMidpoint().x - 100;
					case 'kdog':
						camFollow.y = dad.getMidpoint().y - 700;
						camFollow.x = dad.getMidpoint().x - 400;
					case 'senpai-angry':
						camFollow.y = dad.getMidpoint().y - 430;
						camFollow.x = dad.getMidpoint().x - 100;
				}

				if (dad.curCharacter == 'mom')
					vocals.volume = 1;

				if (SONG.song.toLowerCase() == 'tutorial')
				{
					tweenCamIn();
				}
			}
			else if ((bfNote == true && opponentNote == false && SONG.autoCamera == true || PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection && SONG.autoCamera != true)
				&& camFollow.x != boyfriend.getMidpoint().x - 100)
			{
				camFollow.setPosition(boyfriend.getMidpoint().x - 100, boyfriend.getMidpoint().y - 100);
				switch (curStage)
				{
					case 'limo':
						camFollow.x = boyfriend.getMidpoint().x - 300;
					case 'mall':
						camFollow.y = boyfriend.getMidpoint().y - 200;
					case 'school':
						camFollow.x = boyfriend.getMidpoint().x - 200;
						camFollow.y = boyfriend.getMidpoint().y - 200;
					case 'schoolEvil':
						camFollow.x = boyfriend.getMidpoint().x - 200;
						camFollow.y = boyfriend.getMidpoint().y - 200;
				}

				if (SONG.song.toLowerCase() == 'tutorial')
				{
					FlxTween.tween(FlxG.camera, {zoom: 1}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.elasticInOut});
				}
			}
		}

		if (camZooming)
		{
			/*
			if(FlxG.drawFramerate > 60) {
				FlxG.camera.zoom = FlxMath.lerp(defaultCamZoom, FlxG.camera.zoom, 0.95 * (60 / FlxG.drawFramerate));
				camHUD.zoom = FlxMath.lerp(1, camHUD.zoom, 0.95 * (60 / FlxG.drawFramerate));
			}
			else {
			*/
				FlxG.camera.zoom = FlxMath.lerp(defaultCamZoom, FlxG.camera.zoom, 0.95);
				camHUD.zoom = FlxMath.lerp(1, camHUD.zoom, 0.95);
			//}
			
		}

		FlxG.watch.addQuick("beatShit", curBeat);
		FlxG.watch.addQuick("stepShit", curStep);

		if (curSong == 'Fresh')
		{
			switch (curBeat)
			{
				case 16:
					camZooming = true;
					gfSpeed = 2;
				case 48:
					gfSpeed = 1;
				case 80:
					gfSpeed = 2;
				case 112:
					gfSpeed = 1;
				case 163:
					// FlxG.sound.music.stop();
					// FlxG.switchState(new TitleState());
			}
		}

		if (curSong == 'Bopeebo')
		{
			switch (curBeat)
			{
				case 128, 129, 130:
					vocals.volume = 0;
					// FlxG.sound.music.stop();
					// FlxG.switchState(new PlayState());
			}
		}
		// better streaming of shit

		// RESET = Quick Game Over Screen
		if (controls.RESET)
		{
			health = 0;
			trace("RESET = True");
		}

		// CHEAT = brandon's a pussy
		if (controls.CHEAT)
		{
			health += 1;
			trace("User is cheating!");
		}
		if (health <= 0 && practiceMode == false)
		{
			gameOver(true);
		}

		if (unspawnNotes[0] != null)
		{
			if (unspawnNotes[0].strumTime - Conductor.songPosition < 1500)
			{
				var dunceNote:Note = unspawnNotes[0];
				notes.add(dunceNote);

				var index:Int = unspawnNotes.indexOf(dunceNote);
				unspawnNotes.splice(index, 1);
			}
		}

		if (generatedMusic)
		{
			var daScroll:Bool = FlxG.save.data.downscroll;
			notes.forEachAlive(function(daNote:Note)
			{
				if (daNote.y > FlxG.height)
				{
					daNote.active = false;
					daNote.visible = false;
				}
				else
				{
					daNote.visible = true;
					daNote.active = true;
				}
				if((!daNote.isSustainNote) && daNote.wasGoodHit)
				{
					daNote.kill();
					notes.remove(daNote, true);
					daNote.destroy();
				}
				if (daScroll)
					daNote.y = (strumLine.y - (Conductor.songPosition - daNote.strumTime) * (-0.45 * FlxMath.roundDecimal(SONG.speed, 2)));
				else
					daNote.y = (strumLine.y - (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(SONG.speed, 2)));

				// WIP interpolation shit? Need to fix the pause issue
				// daNote.y = (strumLine.y - (songTime - daNote.strumTime) * (0.45 * PlayState.SONG.speed));
				if(daScroll)
				{
					if(daNote.isSustainNote && daNote.animation.curAnim.name.endsWith('end') && daNote.prevNote != null)
						daNote.y += (daNote.prevNote.height);
					else if(daNote.isSustainNote)
						daNote.y += daNote.height / 2;

					if(daNote.isSustainNote && daNote.wasGoodHit)
					{
						daNote.kill();
						notes.remove(daNote, true);
						daNote.destroy();
					}
				}
				else
				{
					if (daNote.isSustainNote && (daNote.y + daNote.offset.y <= strumLine.y + Note.swagWidth / 2) && (!daNote.mustPress || (daNote.wasGoodHit || (daNote.prevNote.wasGoodHit && !daNote.canBeHit))))
					{
						if(daNote.isSustainNote) {
							var swagRect:FlxRect;
							swagRect = new FlxRect(0, strumLine.y + Note.swagWidth / 2 - daNote.y, daNote.width * 2, daNote.height * 2);
							swagRect.y /= daNote.scale.y;
							swagRect.height -= swagRect.y;
							daNote.clipRect = swagRect;
						}
						if(!daNote.isSustainNote && daNote.mustPress || canHitOtherNote && daNote.mustPress) // For false positives, to prevent input dropping
						{
							daNote.kill();
							notes.remove(daNote, true);
							daNote.destroy();
						}
						if(daNote.prevNote.isSustainNote && daNote.mustPress && !daNote.isSustainNote) //Same here
						{
							daNote.prevNote.kill();
							notes.remove(daNote.prevNote, true);
							daNote.prevNote.destroy();
						}
					}
				}
				if ((!daNote.mustPress || FlxG.save.data.bot == true) && daNote.wasGoodHit)
				{
					var anim:String = "";
					switch (Math.abs(daNote.noteData))
					{
						case 0:
							anim = 'LEFT';
						case 1:
							anim = 'DOWN';
						case 2:
							anim = 'UP';
						case 3:
							anim = 'RIGHT';
					}
					if(daNote.mustPress == true) {
						bfNoteShit(daNote);
						botHit(daNote);
					}
					else {
						if(bfNote == false)
							opponentNote = true;
						else
							opponentNote = false;
						dadNoteShit(daNote);
					}
					if (SONG.song != 'Tutorial')
						camZooming = true;

					var altAnim:String = "";

					if (SONG.notes[Math.floor(curStep / 16)] != null)
					{
						if (SONG.notes[Math.floor(curStep / 16)].altAnim) {
							altAnim = '-alt';
						} else if(SONG.notes[Math.floor(curStep / 16)].altAnim2 && dad.animation.getByName('sing' + anim + '-alt') != null) {
							altAnim = '-alt';
						}
					}
					if(daNote.altNote == true) {
						altAnim = '-alt';
					}
					if(!daNote.mustPress) // Preventing dad from singing bf's notes with autoplay on
					{
						switch (Math.abs(daNote.noteData))
						{
							case 0:
								dad.playAnim('singLEFT' + altAnim, true);
							case 1:
								dad.playAnim('singDOWN' + altAnim, true);
							case 2:
								dad.playAnim('singUP' + altAnim, true);
							case 3:
								dad.playAnim('singRIGHT' + altAnim, true);
						}
					}
					if(!daNote.mustPress)
						dad.holdTimer = 0;

					if (SONG.needsVoices)
						vocals.volume = 1;

					//if(!daNote.isSustainNote)
						daNote.kill();
						notes.remove(daNote, true);
						daNote.destroy();
				}
				// WIP interpolation shit? Need to fix the pause issue
				// daNote.y = (strumLine.y - (songTime - daNote.strumTime) * (0.45 * PlayState.SONG.speed));

				if (daNote.y < -daNote.height && !FlxG.save.data.downscroll || daNote.y >= strumLine.y + 106 && FlxG.save.data.downscroll)
				{
					if (daNote.isSustainNote && daNote.wasGoodHit)
					{
						daNote.kill();
						notes.remove(daNote, true);
						daNote.destroy();
					}
					else
					{
						if (daNote.tooLate || !daNote.wasGoodHit)
						{
							// Force a good note hit if it goes offscreen, preventing lag from triggering a miss
							if(FlxG.save.data.bot == true || !daNote.mustPress) {
								daNote.active = false;
								daNote.visible = false;
								daNote.kill();
								notes.remove(daNote, true);
								daNote.destroy();
							}
							else {
								noteMiss(daNote.noteData, true);
							}
						}

						daNote.active = false;
						daNote.visible = false;

						daNote.kill();
						notes.remove(daNote, true);
						daNote.destroy();
					}
				}
			});
		}

		if (!inCutscene) {
			if (FlxG.save.data.bot != true) //Allow key inputs if autoplay is off
				keyShit();
			else {
				//Otherwise, forbid key inputs but continue to perform basic animation stuff
				if(boyfriend.holdTimer > Conductor.stepCrochet * 4 * 0.001) {
					if (boyfriend.animation.curAnim.name.startsWith('sing') && !boyfriend.animation.curAnim.name.endsWith('miss'))
					{
						boyfriend.playAnim('idle');
					}
				}
				playerStrums.forEach(function(spr:FlxSprite)
					{
						if(spr.animation.curAnim.finished) {
							spr.animation.play('static');
							spr.centerOffsets();
						}
					});	
			}
			opponentStrums.forEach(function(spr:FlxSprite)
			{
				if(spr.animation.curAnim.finished) {
					spr.animation.play('static');
					spr.centerOffsets();
				}
			});
		}

		#if debug
		if (FlxG.keys.justPressed.ONE)
			endSong;
		#end
		FlxG.watch.addQuick("Can Hit Note",PlayState.canHitNote);
	}
	function gameOver(gitaroo:Bool = false):Void
	{
		boyfriend.stunned = true;

		persistentUpdate = false;
		persistentDraw = false;
		paused = true;

		vocals.stop();
		FlxG.sound.music.stop();

		// 1 / 1000 chance for Gitaroo Man easter egg
		if (FlxG.random.bool(0.1) && gitaroo == true)
		{
			// gitaroo man easter egg
			FlxG.switchState(new GitarooPause());
		}
		else
			openSubState(new GameOverSubstate(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y, curStage == 'tank'));

		// FlxG.switchState(new GameOverState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
	}
	function gameOverPractice():Void
	{
			boyfriend.stunned = true;
	
			persistentUpdate = false;
			persistentDraw = false;
			paused = true;
	
			vocals.stop();
			FlxG.sound.music.stop();
	
			openSubState(new GameOverSubstate(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
	}
	function finishWeek():Void
	{
		switch(SONG.song.toLowerCase())
		{
		// I was gonna do this but then I remembered the kickstarter is over lmfao
		/*
		case 'stress':
			FlxG.switchState(new VideoState('assets/videos/kickstarterTrailer.webm', new PlayState(), 0));
		*/
		default:
			FlxG.switchState(new StoryMenuState());
		}
		
	}
	function endSong():Void
	{
		canPause = false;
		FlxG.sound.music.volume = 0;
		vocals.volume = 0;
		if (SONG.validScore && !wasBotplay)
		{
			#if !switch
			Highscore.saveScore(SONG.song, songScore, accuracy, storyDifficulty);
			#end
		}

		if (isStoryMode)
		{
			campaignScore += songScore;

			storyPlaylist.remove(storyPlaylist[0]);

			if (storyPlaylist.length <= 0)
			{
				FlxG.sound.playMusic('assets/music/freakyMenu' + TitleState.soundExt);

				transIn = FlxTransitionableState.defaultTransIn;
				transOut = FlxTransitionableState.defaultTransOut;
				
				finishWeek();

				StoryMenuState.weekUnlocked[Std.int(Math.min(storyWeek + 1, StoryMenuState.weekUnlocked.length - 1))] = true;

				if (SONG.validScore && !wasBotplay)
				{
					NGio.unlockMedal(60961);
					Highscore.saveWeekScore(storyWeek, campaignScore, storyDifficulty);
				}

				FlxG.save.data.weekUnlocked = StoryMenuState.weekUnlocked;
				FlxG.save.flush();
			}
			else
			{
				var difficulty:String = "";

				if (storyDifficulty == 0)
					difficulty = '-easy';

				if (storyDifficulty == 2)
					difficulty = '-hard';

				trace('LOADING NEXT SONG');
				trace(PlayState.storyPlaylist[0].toLowerCase() + difficulty);

				if (SONG.song.toLowerCase() == 'eggnog')
				{
					var blackShit:FlxSprite = new FlxSprite(-FlxG.width * FlxG.camera.zoom,
						-FlxG.height * FlxG.camera.zoom).makeGraphic(FlxG.width * 3, FlxG.height * 3, FlxColor.BLACK);
					blackShit.scrollFactor.set();
					add(blackShit);
					camHUD.visible = false;

					FlxG.sound.play('assets/sounds/Lights_Shut_off' + TitleState.soundExt);
				}

				FlxTransitionableState.skipNextTransIn = true;
				FlxTransitionableState.skipNextTransOut = true;
				prevCamFollow = camFollow;

				PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0].toLowerCase() + difficulty, PlayState.storyPlaylist[0]);
				FlxG.sound.music.stop();

				FlxG.switchState(new PlayState());
				//Cutscene.switchState(new PlayState(), true, PlayState.storyPlaylist[0].toLowerCase());
			}
		}
		else
		{
			trace('WENT BACK TO FREEPLAY??');
			FlxG.switchState(new FreeplayState());
		}
	}

	var endingSong:Bool = false;
	function setupNumbers():Void
	{
		var rating = new FlxSprite();
		rating.frames = FlxAtlasFrames.fromSparrow('assets/images/numberSheet.png', 'assets/images/numberSheet.xml');
		rating.animation.addByPrefix("num0", "0-", 24, false);
		rating.animation.addByPrefix("num1", "1-", 24, false);
		rating.animation.addByPrefix("num2", "2-", 24, false);
		rating.animation.addByPrefix("num3", "3-", 24, false);
		rating.animation.addByPrefix("num4", "4-", 24, false);
		rating.animation.addByPrefix("num5", "5-", 24, false);
		rating.animation.addByPrefix("num6", "6-", 24, false);
		rating.animation.addByPrefix("num7", "7-", 24, false);
		rating.animation.addByPrefix("num8", "8-", 24, false);
		rating.animation.addByPrefix("num9", "9-", 24, false);
	}
	private function popUpScore(strumtime:Float, daNote:Note):Void
	{
		if(FlxG.save.data.hitSounds == true)
			FlxG.sound.play("assets/sounds/hitSound.wav", 4);
		var daRating:String = "sick";
		var noteDiff:Float = Math.abs(strumtime - Conductor.songPosition);
		// boyfriend.playAnim('hey');
		vocals.volume = 1;

		var placement:String = Std.string(combo);

		var coolText:FlxText = new FlxText(0, 0, 0, placement, 32);
		coolText.screenCenter();
		coolText.x = FlxG.width * 0.55;
		
		var score:Int = 350;
		if(FlxG.save.data.bot != true) {
			if (noteDiff > (FlxG.save.data.noteframe / 60) * 1000 * 0.9)
				{
					shits += 1;
					daRating = 'shit';
					score = 50;
					hitRate -= 1;
				}
				else if (noteDiff > (FlxG.save.data.noteframe / 60) * 1000 * 0.75)
				{
					bads += 1;
					daRating = 'bad';
					score = 100;
					hitRate -= 0.50;
				}
				else if (noteDiff > (FlxG.save.data.noteframe / 60) * 1000 * 0.2)
				{
					goods += 1;
					daRating = 'good';
					score = 200;
					hitRate += 0.50;
				}
			songScore += score;
			updateAccuracy(strumtime, daRating, noteDiff);
		}		
		/* if (combo > 60)
				daRating = 'sick';
			else if (combo > 12)
				daRating = 'good'
			else if (combo > 4)
				daRating = 'bad';
		 */
		if(daRating == 'sick') {
			sicks += 1;
			hitRate += 1;
			if (!daNote.isSustainNote && FlxG.save.data.splash)
			{
				var recycledNote = grpNoteSplashes.recycle(NoteSplash);
				recycledNote.setupNoteSplash(daNote.x, daNote.y, daNote.noteData);
				grpNoteSplashes.add(recycledNote);
			}
		}
		//setupNumbers();
		var rating:FlxSprite = new FlxSprite();
		rating.loadGraphic(UILoader.loadImage(daRating));
		rating.screenCenter();
		rating.x = coolText.x - 40;
		rating.y -= 60;
		rating.acceleration.y = 550;
		rating.velocity.y -= FlxG.random.int(140, 175);
		rating.velocity.x -= FlxG.random.int(0, 10);
		add(rating);

		var comboSpr:FlxSprite = new FlxSprite().loadGraphic(UILoader.loadImage('combo'));
		comboSpr.screenCenter();
		comboSpr.x = coolText.x;
		comboSpr.acceleration.y = 600;
		comboSpr.velocity.y -= 150;
		comboSpr.velocity.x += FlxG.random.int(1, 10);
		add(comboSpr); //ninjamuffin forgor 💀

		if (!PlayState.isPixelStage)
		{
			rating.setGraphicSize(Std.int(rating.width * 0.7));
			rating.antialiasing = true;
			comboSpr.setGraphicSize(Std.int(comboSpr.width * 0.7));
			comboSpr.antialiasing = true;
		}
		else
		{
			rating.setGraphicSize(Std.int(rating.width * daPixelZoom * 0.7));
			comboSpr.setGraphicSize(Std.int(comboSpr.width * daPixelZoom * 0.7));
		}

		comboSpr.updateHitbox();
		rating.updateHitbox();

		var seperatedScore:Array<Int> = [];

		seperatedScore.push(Math.floor(combo / 100));
		seperatedScore.push(Math.floor((combo - (seperatedScore[0] * 100)) / 10));
		seperatedScore.push(combo % 10);

		var daLoop:Int = 0;
		for (i in seperatedScore)
		{
			var numScore:FlxSprite = new FlxSprite().loadGraphic(UILoader.loadImage('num${Std.int(i)}'));
			numScore.screenCenter();
			numScore.x = coolText.x + (43 * daLoop) - 90;
			numScore.y += 80;

			if (!PlayState.isPixelStage)
			{
				numScore.antialiasing = true;
				numScore.setGraphicSize(Std.int(numScore.width * 0.5));
			}
			else
			{
				numScore.setGraphicSize(Std.int(numScore.width * daPixelZoom));
			}
			numScore.updateHitbox();

			numScore.acceleration.y = FlxG.random.int(200, 300);
			numScore.velocity.y -= FlxG.random.int(140, 160);
			numScore.velocity.x = FlxG.random.float(-5, 5);

			add(numScore);

			FlxTween.tween(numScore, {alpha: 0}, 0.2, {
				onComplete: function(tween:FlxTween)
				{
					numScore.destroy();
				},
				startDelay: Conductor.crochet * 0.002
			});

			daLoop++;
		}
		/* 
			trace(combo);
			trace(seperatedScore);
		 */

		coolText.text = Std.string(seperatedScore);
		#if debug
		//add(coolText);
		#end

		FlxTween.tween(rating, {alpha: 0}, 0.2, {
			startDelay: Conductor.crochet * 0.001
		});

		FlxTween.tween(comboSpr, {alpha: 0}, 0.2, {
			onComplete: function(tween:FlxTween)
			{
				coolText.destroy();
				comboSpr.destroy();

				rating.destroy();
			},
			startDelay: Conductor.crochet * 0.001
		});

		curSection += 1;
	}
	function updateAccuracy(strumtime:Float = 0, daRating:String = '', noteDiff:Float = 0):Void //Not having any arguments means that it's using the modern accuracy system, so no need to account for them.
	{
		// ALL OF THIS COMMENTED SHIT IS JUST ME GOING IN WAY OVER MY HEAD
		// I SHOULD PROBABLY JUST REMOVE IT BUT I MIGHT AS WELL LET ALL OF YOU LAUGH AT ME
		/*
		//starting you off relatively high
		if(firstHit == true) {
			if(daRating == 'sick') {
				accuracy = 100;
			}
			else if(daRating == 'good') {
				accuracy = Math.round(70 + (noteDiff / 50));
			}
			else {
				accuracy = Math.round(noteDiff / 50);
			}
		}
		//accuracy will improve if note was hit good or sick, otherwise it will lower
		else if(daRating == 'shit' || daRating == 'bad') {
			accuracy -= Math.round(noteDiff / 50);
		}
		else if(daRating == 'good') {
			if(FlxG.save.data.noteframe > 7) {
				accuracy -= Math.round(noteDiff / 70);
			}
			else {
				accuracy += ((Math.abs(Math.round(strumtime - Conductor.songPosition)) / 6));
			}
		}
		else {
		*/
		totalNotes += 1;
		FlxG.watch.addQuick('totalNotes', totalNotes);
		/*
		if(FlxG.save.data.accuracy == false) {
			var greaterThan20:Bool = true;
			var accuracyDivide:Float;
			if(accuracy < 1)
				accuracyDivide = 25; //avoids divide by zero overflows
			else
				accuracyDivide = accuracy;
			if(accuracy < 20)
				greaterThan20 = false;
				
			FlxG.watch.addQuick('Hit', (strumtime - Conductor.songPosition) / 10);
			FlxG.watch.addQuick('Hit ABS', Math.abs(strumtime - Conductor.songPosition) / 10);
			FlxG.watch.addQuick('Accuracy Increment', (strumtime - Conductor.songPosition) / 10 / (accuracyDivide / 25) / (totalNotes / 25));

			//some leniency to make 100% accuracy actually possible
			if(Math.abs(strumtime - Conductor.songPosition) / 10 <= 5.5) {
				accuracy += Math.abs(strumtime - Conductor.songPosition) / 10 / (greaterThan20 ? (accuracy / 25) : (1)) / (totalNotes / 25);
			} else {
				accuracy -= Math.abs(strumtime - Conductor.songPosition) / 10 / (greaterThan20 ? (accuracy / 25) : (1)) / (totalNotes / 25);
			}
		} else {
		*/
			accuracy = Math.max(0, hitRate / totalNotes * 100);
		//}
		//}
		//firstHit = false;
		accuracyLogic();
	}
	function accuracyLogic():Void
	{
		//For some reason FlxMath.bound causes it to turn into infinity?
		//idk what's going on there but whatever lmfao
		if(accuracy > 100) {
			accuracy = 100;
		}
		if(accuracy < 0) {
			accuracy = 0;
		}
		accuracy = FlxMath.roundDecimal(accuracy, 2);
		updateRating();
		/*
		// accuracy can't go back to 100 after going lower
		if(goneUnder100 && accuracy > 99) {
			accuracy = 99;
		}
		else if(!goneUnder100 && accuracy < 100)
		{
			goneUnder100 = true;
		}
		
		// same deal but for 95+ instead
		if(goneUnder && accuracy > 95) {
			accuracy = 95;
		}
		else if(!goneUnder && accuracy < 95)
		{
			goneUnder = true;
		}
		*/
	}
	function updateRating():Void
	{ 
		var accuracyRound:Int = Math.round(accuracy);
		var ratingList:Array<String> = [
			"Perfect!!!",
			"Sick!!",
			"Great!",
			"Good",
			"Average",
			"Bad",
			"Shit",
			"Awful",
			"Open your eyes, man!"
		];
		// Why can't you use '...' for switch statements
		// I'm trying to make this look nicer and instead I gotta do this
			if(accuracy == 100)
				accuracyRating = ratingList[0];
			else if(accuracyRound >= 90 && accuracyRound <= 100)
				accuracyRating = ratingList[1];
			else if(accuracyRound >= 80 && accuracyRound < 90)
				accuracyRating = ratingList[2];
			else if(accuracyRound >= 75 && accuracyRound < 80)
				accuracyRating = ratingList[3];
			else if(accuracyRound >= 70 && accuracyRound < 75)
				accuracyRating = ratingList[4];
			else if(accuracyRound >= 50 && accuracyRound < 70)
				accuracyRating = ratingList[5];
			else if(accuracyRound >= 40 && accuracyRound < 50)
				accuracyRating = ratingList[6];
			else if(accuracyRound >= 20 && accuracyRound < 40)
				accuracyRating = ratingList[7];
			else if(accuracyRound > 0 && accuracyRound < 20)
				accuracyRating = ratingList[8];
			else if(accuracyRound > 0)
				accuracyRating = ratingList[9];
			if(accuracyRating == null) //Probably means it didn't meet any of these criteria, which is understandable cuz my code sucks
				accuracyRating = ratingList[9];
		// I'm so sorry for this script
		displayAccuracy = ("" + accuracy); // makin sure the game knows it's converting it into a string
		updateFC();
	}
	function updateFC():Void
	{
		if(missCount == 0) {
			clearStats = 'MFC';
			if(goods != 0 || bads != 0 || shits != 0)
			{
				if(goods != 0)
					clearStats = 'GFC';
				if(bads != 0 || shits != 0)
					clearStats = 'FC';
			}
		}
		else if(missCount < 10)
			clearStats = 'SDCB';
		else
			clearStats = 'Clear';
		FlxG.watch.addQuick('Sicks', sicks);
		FlxG.watch.addQuick('Goods', goods);
		FlxG.watch.addQuick('Bads', bads);
		FlxG.watch.addQuick('Shits', shits);
	}
	private function keyShit():Void
	{
		//Making it read from arrays to minimize input lag
		var pressArray:Array<Bool> = [controls.LEFT_P, controls.DOWN_P, controls.UP_P, controls.RIGHT_P]; 
		var holdArray:Array<Bool> = [controls.LEFT, controls.DOWN, controls.UP, controls.RIGHT];
		var releaseArray:Array<Bool> = [controls.LEFT_R, controls.DOWN_R, controls.UP_R, controls.RIGHT_R];

		if (pressArray.contains(true) && generatedMusic)
		{
			boyfriend.holdTimer = 0;

			var possibleNotes:Array<Note> = [];

			var ignoreList:Array<Int> = [];

			notes.forEachAlive(function(daNote:Note)
			{
				if (daNote.canBeHit && daNote.mustPress)
				{
					// the sorting probably doesn't need to be in here? who cares lol
					possibleNotes.push(daNote);
					possibleNotes.sort((a, b) -> Std.int(a.strumTime - b.strumTime));

					ignoreList.push(daNote.noteData);
				}
			});

			if (possibleNotes.length > 0)
			{
				var daNote = possibleNotes[0];

				if (FlxG.save.data.bot == true)
					noteCheck(true, daNote);

				
				// Jump notes
				if (possibleNotes.length >= 2)
				{
					if (possibleNotes[0].strumTime == possibleNotes[1].strumTime)
					{
						for (coolNote in possibleNotes)
						{
							if (pressArray[coolNote.noteData])
								goodNoteHit(coolNote);
							else
							{
								var inIgnoreList:Bool = false;
								for (shit in 0...ignoreList.length)
								{
									if (pressArray[ignoreList[shit]])
										inIgnoreList = true;
								}
								if (!inIgnoreList)
									badNoteCheck();
							}
						}
					}
					else if (possibleNotes[0].noteData == possibleNotes[1].noteData)
					{
						noteCheck(pressArray[daNote.noteData], daNote);
					}
					else
					{
						for (coolNote in possibleNotes)
						{
							noteCheck(pressArray[coolNote.noteData], coolNote);
						}
					}
				}
				else // regular notes?
				{
					noteCheck(pressArray[daNote.noteData], daNote);
				}
				if (daNote.wasGoodHit)
				{
					daNote.kill();
					notes.remove(daNote, true);
					daNote.destroy();
				}
			}
			else
			{
				badNoteCheck();
			}
		}
		
		if (holdArray.contains(true) && !boyfriend.stunned && generatedMusic)
		{
			notes.forEachAlive(function(daNote:Note)
			{
				if (daNote.canBeHit && daNote.mustPress && daNote.isSustainNote && FlxG.save.data.bot == false)
				{
					if(holdArray[daNote.noteData])
						goodNoteHit(daNote);
				}
			});
		}

		if (boyfriend.holdTimer > Conductor.stepCrochet * 4 * 0.001 && !holdArray.contains(true))
		{
			if (boyfriend.animation.curAnim.name.startsWith('sing') && !boyfriend.animation.curAnim.name.endsWith('miss'))
			{
				boyfriend.playAnim('idle');
			}
		}

		playerStrums.forEach(function(spr:FlxSprite)
		{
			if (pressArray[spr.ID] && spr.animation.curAnim.name != 'confirm')
				spr.animation.play('pressed');
			if (releaseArray[spr.ID])
				spr.animation.play('static');

			if (spr.animation.curAnim.name == 'confirm' && !PlayState.isPixelStage)
			{
				spr.centerOffsets();
				spr.offset.x -= 13;
				spr.offset.y -= 13;
			}
			else
				spr.centerOffsets();
		});
	}

	function noteMiss(direction:Int = 1, wasPassedNote:Bool = false):Void
	{
		vocals.volume = 0;
		missCount += 1;
		if(wasPassedNote) {
			health -= 0.0475;
			hitRate -= 1;
			updateAccuracy();
		} else {
			health -= 0.04;
			hitRate -= 0.5;
			updateAccuracy();
		}
		firstHit = false;
		accuracyLogic();
		
		if (combo > 5)
		{
				gf.playAnim('sad');
		}
		combo = 0;

		songScore -= 10;

		FlxG.sound.play('assets/sounds/missnote' + FlxG.random.int(1, 3) + TitleState.soundExt, FlxG.random.float(0.1, 0.2));

		boyfriend.stunned = true;

		// get stunned for 5 seconds
		new FlxTimer().start(5 / 60, function(tmr:FlxTimer)
		{
			boyfriend.stunned = false;
		});
		switch (direction)
		{
			case 0:
				boyfriend.playAnim('singLEFTmiss', true);
			case 1:
				boyfriend.playAnim('singDOWNmiss', true);
			case 2:
				boyfriend.playAnim('singUPmiss', true);
			case 3:
				boyfriend.playAnim('singRIGHTmiss', true);
		}
	}

	function badNoteCheck()
	{
		// just double pasting this shit cuz fuk u
		// REDO THIS SYSTEM!
		var upP = controls.UP_P;
		var rightP = controls.RIGHT_P;
		var downP = controls.DOWN_P;
		var leftP = controls.LEFT_P;
		if(!FlxG.save.data.ghost) {
			if (leftP)
				noteMiss(0);
			if (downP)
				noteMiss(1);
			if (upP)
				noteMiss(2);
			if (rightP)
				noteMiss(3);
		}
	}

	function noteCheck(keyP:Bool, note:Note):Void
	{
		if (keyP) {
			goodNoteHit(note);
		}
		else if(FlxG.save.data.ghost)
		{
			mashVar += 0.3;
			if(mashVar > mashLimit) {
				//noteMiss(note.noteData);
			}
		}
	}
	function goodNoteHit(note:Note):Void
	{
		if (!note.wasGoodHit)
		{
			bfNote = true;
			opponentNote = false;
			if (!note.isSustainNote)
			{
				combo += 1;
				popUpScore(note.strumTime, note);			
			}
			if (note.noteData >= 0) {
				health += 0.023;
			}
			else {
				health += 0.004;
			}
			if(boyfriend.animation.curAnim.name != 'hey') {
				switch (note.noteData)
				{
					case 0:
						boyfriend.playAnim('singLEFT', true);
					case 1:
						boyfriend.playAnim('singDOWN', true);
					case 2:
						boyfriend.playAnim('singUP', true);
					case 3:
						boyfriend.playAnim('singRIGHT', true);
				}
			}

			playerStrums.forEach(function(spr:FlxSprite)
			{
				if (Math.abs(note.noteData) == spr.ID)
				{
					spr.animation.play('confirm', true);
				}
			});

			note.wasGoodHit = true;
			vocals.volume = 1;

			if (!note.isSustainNote)
			{
				note.kill();
				notes.remove(note, true);
				note.destroy();
			}
		}
	}
	function botHit(note:Note):Void
	{
		boyfriend.holdTimer = 0;
		if (!note.isSustainNote)
		{
			popUpScore(note.strumTime, note);
			combo += 1;
		}
		if(boyfriend.animation.curAnim.name != 'hey') {
			switch (note.noteData)
			{
				case 0:
					boyfriend.playAnim('singLEFT', true);
				case 1:
					boyfriend.playAnim('singDOWN', true);
				case 2:
					boyfriend.playAnim('singUP', true);
				case 3:
					boyfriend.playAnim('singRIGHT', true);
			}
		}
		if (note.noteData >= 0) 
		{
			health += 0.023;
		}
		else {
			health += 0.004;
		}
		vocals.volume = 1;
	}
	var fastCarCanDrive:Bool = true;

	function resetFastCar():Void
	{
		fastCar.x = -12600;
		fastCar.y = FlxG.random.int(140, 250);
		fastCar.velocity.x = 0;
		fastCarCanDrive = true;
	}

	function fastCarDrive()
	{
		FlxG.sound.play('assets/sounds/carPass' + FlxG.random.int(0, 1) + TitleState.soundExt, 0.7);

		fastCar.velocity.x = (FlxG.random.int(170, 220) / FlxG.elapsed) * 3;
		fastCarCanDrive = false;
		new FlxTimer().start(2, function(tmr:FlxTimer)
		{
			resetFastCar();
		});
	}

	var trainMoving:Bool = false;
	var trainFrameTiming:Float = 0;

	var trainCars:Int = 8;
	var trainFinishing:Bool = false;
	var trainCooldown:Int = 0;

	function trainStart():Void
	{
		trainMoving = true;
		if (!trainSound.playing)
			trainSound.play(true);
	}

	var startedMoving:Bool = false;

	function updateTrainPos():Void
	{
		if (trainSound.time >= 4700)
		{
			startedMoving = true;
				gf.playAnim('hairBlow');
		}

		if (startedMoving)
		{
			phillyTrain.x -= 400;

			if (phillyTrain.x < -2000 && !trainFinishing)
			{
				phillyTrain.x = -1150;
				trainCars -= 1;

				if (trainCars <= 0)
					trainFinishing = true;
			}

			if (phillyTrain.x < -4000 && trainFinishing)
				trainReset();
		}
	}

	function trainReset():Void
	{
		gf.playAnim('hairFall');
		phillyTrain.x = FlxG.width + 200;
		trainMoving = false;
		// trainSound.stop();
		// trainSound.time = 0;
		trainCars = 8;
		trainFinishing = false;
		startedMoving = false;
	}

	function lightningStrikeShit():Void
	{
		FlxG.sound.play('assets/sounds/thunder_' + FlxG.random.int(1, 2) + TitleState.soundExt);
		halloweenBG.animation.play('lightning');

		lightningStrikeBeat = curBeat;
		lightningOffset = FlxG.random.int(8, 24);

		boyfriend.playAnim('scared', true);
		gf.playAnim('scared', true);
	}

	function moveTank()
	{
		if(!inCutscene)
		{
			tankAngle += FlxG.elapsed * tankSpeed;
			tankRolling.angle = tankAngle - 90 + 15;
			tankRolling.x = tankX + 1500 * Math.cos(Math.PI / 180 * (1 * tankAngle + 180));
			tankRolling.y = 1300 + 1100 * Math.sin(Math.PI / 180 * (1 * tankAngle + 180));
		}
	}
	override function stepHit()
	{
		if(SONG.song.toLowerCase() == 'stress')
			{
				//RIGHT
				for(i in 0...picoStep.right.length)
				{
					if (curStep == picoStep.right[i])
					{
						gf.playAnim('shoot' + FlxG.random.int(1, 2), true);
					}
				}
				//LEFT
				for(i in 0...picoStep.left.length)
				{
					if (curStep == picoStep.left[i])
					{
						gf.playAnim('shoot' + FlxG.random.int(3, 4), true);
					}
				}
				if(FlxG.save.data.details == true)
				{
					//Left tankspawn
					for (i in 0...tankStep.left.length)
					{
						if (curStep == tankStep.left[i]){
							var tankmanRunner:TankmenBG = new TankmenBG();
							tankmanRunner.resetShit(FlxG.random.int(630, 730) * -1, 255, true, 1, 1.5);
							tankmanRun.add(tankmanRunner);
						}
					}
					//Right spawn
					for(i in 0...tankStep.right.length)
					{
						if (curStep == tankStep.right[i]){
							var tankmanRunner:TankmenBG = new TankmenBG();
							tankmanRunner.resetShit(FlxG.random.int(1500, 1700) * 1, 275, false, 1, 1.5);
							tankmanRun.add(tankmanRunner);
						}
					}
				}
			}
		super.stepHit();
		if (SONG.needsVoices)
		{
			if (Math.abs(FlxG.sound.music.time - Conductor.songPosition) > 20
				|| (SONG.needsVoices && Math.abs(vocals.time - Conductor.songPosition ) > 20))
			{
				resyncVocals();
			}
		}

		if (dad.curCharacter == 'spooky' && curStep % 4 == 2)
		{
			// dad.dance();
		}
	}

	var lightningStrikeBeat:Int = 0;
	var lightningOffset:Int = 8;

	override function beatHit()
	{
		notes.forEachAlive(function(daNote:Note)
		{
			if(!daNote.mustPress)
				bfNote = false;
		});
		mashVar -= 0.8;
		if(mashVar < 0) mashVar = 0;
		if(Conductor.bpm > 140) //There's nothing stopping us from not doing this, but it just looks weird at higher BPMs
			altbeat = !altbeat;
		else
			altbeat = true;
		super.beatHit();

		if(camZooming && FlxG.save.data.zoom == true) {
			FlxG.camera.zoom += 0.015;
			camHUD.zoom += 0.03;
		}
		if (generatedMusic)
		{
			notes.sort(FlxSort.byY, FlxSort.DESCENDING);
		}

		if (SONG.notes[Math.floor(curStep / 16)] != null)
		{
			if (SONG.notes[Math.floor(curStep / 16)].changeBPM)
			{
				Conductor.changeBPM(SONG.notes[Math.floor(curStep / 16)].bpm, SONG.numerator, SONG.denominator);
				FlxG.log.add('CHANGED BPM!');
			}
			// else
			// Conductor.changeBPM(SONG.bpm);

			// Dad doesnt interupt his own notes
			
		}
		// FlxG.log.add('change bpm' + SONG.notes[Std.int(curStep / 16)].changeBPM);
		wiggleShit.update(Conductor.crochet);

		// HARDCODING FOR MILF ZOOMS!
		if (curSong.toLowerCase() == 'milf' && curBeat >= 168 && curBeat < 200 && camZooming && FlxG.camera.zoom < 1.35)
		{
			FlxG.camera.zoom += 0.015;
			camHUD.zoom += 0.03;
		}
		else if (camZooming && FlxG.camera.zoom < 1.35 && curBeat % Conductor.numerator == 0 && FlxG.save.data.zoom == false)
		{
			FlxG.camera.zoom += 0.015;
			camHUD.zoom += 0.03;
		}
		
		iconP1.setGraphicSize(Std.int(iconP1.width + 45));
		iconP2.setGraphicSize(Std.int(iconP2.width + 45));

		iconP1.updateHitbox();
		iconP2.updateHitbox();

		if (curBeat % gfSpeed == 0)
		{
			gf.dance();
		}
		//Could probably clean this up if I put it in Character.hx instead but ehhhhhhh
		if(dad.animation.curAnim.name == ("singDOWN-alt") && dad.curCharacter == 'tankman' && !dad.animation.curAnim.finished)
		{
			dad.holdTimer = 0;
		}
		else {
			/*
			if(Conductor.bpm > 150)
			{
				if(altbeat == true && dad.animation.getByName('danceLeft') == null) {
					if(dad.animation.curAnim.name.contains("idle") || dad.animation.curAnim.name.contains("dance") || dad.animation.curAnim.name.contains('-loop')) {
						dad.dance();
					}
				}
				else if(dad.animation.getByName('danceLeft') != null) {
					if(dad.animation.curAnim.name.contains("idle") || dad.animation.curAnim.name.contains("dance") || dad.animation.curAnim.name.contains('-loop')) {
						dad.dance();
					}
				}
				if(altbeat == true) {
					if (!boyfriend.animation.curAnim.name.startsWith("sing"))
					{
						boyfriend.playAnim('idle', true);
					}
				}
			}
			else {
			*/
			if(altbeat == true || dad.animation.getByName('danceLeft') != null) {
				if(dad.animation.curAnim.name.contains("idle") || dad.animation.curAnim.name.contains("dance") || dad.animation.curAnim.name.contains('-loop')) {
					dad.dance();
				}
				else if(!dad.animation.curAnim.name.startsWith("sing")) {
					dad.dance();
				}
			}
			if ((altbeat == true || boyfriend.animation.getByName('danceLeft') != null) && !boyfriend.animation.curAnim.name.startsWith("sing"))
			{
				boyfriend.playAnim('idle', true);
			}
			//}	
		}

		if (curBeat % 8 == 7)
		{
			if(SONG.song == 'Bopeebo')
				boyfriend.playAnim('hey', true);

			if (SONG.song == 'Tutorial' && dad.curCharacter == 'gf' && curBeat > 16 && curBeat < 48 && PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection)
			{
				boyfriend.playAnim('hey', true);
				dad.playAnim('cheer', true);
			}
		}

		if(FlxG.save.data.bg)
		{
			switch (curStage)
			{
				case 'school':
					bgGirls.dance();

				case 'mall':
					upperBoppers.animation.play('bop', true);
					bottomBoppers.animation.play('bop', true);
					santa.animation.play('idle', true);

				case 'limo':
					grpLimoDancers.forEach(function(dancer:BackgroundDancer)
					{
						dancer.dance();
					});

					if (FlxG.random.bool(10) && fastCarCanDrive) {
						fastCarDrive();
					}
				case "philly":
					if (!trainMoving)
						trainCooldown += 1;

					if (curBeat % 4 == 0)
					{
						phillyCityLights.forEach(function(light:FlxSprite)
						{
							light.visible = false;
						});

						curLight = FlxG.random.int(0, phillyCityLights.length - 1);

						phillyCityLights.members[curLight].visible = true;
						phillyCityLights.members[curLight].alpha = 1;
					}

					if (curBeat % 8 == 4 && FlxG.random.bool(30) && !trainMoving && trainCooldown > 8)
					{
						trainCooldown = FlxG.random.int(-4, 0);
						trainStart();
					}
				case 'tank':
					tankWatchtower.animation.play('idle', true);
					tank0.animation.play('idle', true);
					tank1.animation.play('idle', true);
					tank2.animation.play('idle', true);
					tank4.animation.play('idle', true);
					tank5.animation.play('idle', true);
					tank3.animation.play('idle', true);
			}
		}
		if (isHalloween && FlxG.random.bool(10) && curBeat > lightningStrikeBeat + lightningOffset)
		{
			lightningStrikeShit();
		}
		
	}
	var curLight:Int = 0;
}
//picoshoot
typedef Ps = 
{
	var right:Array<Int>;
	var left:Array<Int>;
}

//tank spawns
typedef Ts = 
{
	var right:Array<Int>;
	var left:Array<Int>;
}