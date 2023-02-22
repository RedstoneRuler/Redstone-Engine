package;

import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;
import lime.media.openal.AL;
import openfl.utils.Future;
import openfl.media.Sound;

using StringTools;

class FreeplayState extends MusicBeatState
{
	public static var rate:Float = 1.0;

	var songs:Array<String> = [];
	var colorList:Array<FlxColor> = [];
	var iconList:Array<String> = [];

	var selector:FlxText;
	var curSelected:Int = 0;
	var curDifficulty:Int = 1;

	var scoreText:FlxText;
	var diffText:FlxText;
	var previewtext:FlxText;
	var lerpScore:Float = 0;
	var lerpAccuracy:Float = 0;
	var intendedScore:Int = 0;
	var intendedAccuracy:Float = 0;
	var isDebug:Bool = false;

	private var grpSongs:FlxTypedGroup<Alphabet>;
	private var curPlaying:Bool = false;

	var defaultCamZoom:Float = 1;
	private var iconArray:Array<HealthIcon> = [];

	var bg:FlxSprite;
	var scoreBG:FlxSprite;

	var json:Dynamic; //too lazy to check what the class is for a json, let the game figure it out lmao

	var songFolders:Array<String> = [];

	override function create()
	{
		rate = 1;
		/* 
			if (FlxG.sound.music != null)
			{
				if (!FlxG.sound.music.playing)
					FlxG.sound.playMusic('assets/music/freakyMenu' + TitleState.soundExt);
			}
		 */
		#if debug
		isDebug = true;
		#end

		var songStrings:Array<String> = CoolUtil.coolTextFile('assets/data/freeplaySonglist.txt');
		var baseStrings = songStrings;

		#if sys
		var fullDirs:Array<String> = ModLoader.getFreeplayFolders();
		for(i in 0...baseStrings.length)
		{
			songFolders.push('');
		}
		for(i in 0...fullDirs.length)
		{
			songFolders.push(fullDirs[i]);
		}

		var customTracks:Array<String> = ModLoader.getFreeplaySongs();
		for(i in 0...customTracks.length)
		{
			songStrings.push(customTracks[i]);
		}
		#end
		
		for (i in 0...songStrings.length)
		{
			var songShit = songStrings[i].split(',');
			songShit.remove(' ');
			var songName = songShit[0];
			addSong(songName, songShit[1], FlxColor.fromString(songShit[2]), Std.parseInt(songShit[3]));
		}
	
		//HARDCODED SONG TEMPLATE: addSong('title', 'icon', color, week);

		trace(songs);
		trace(colorList);
		trace(iconList);

		songs.remove(''); //if empty strings got in there, just clear them out, they probably came from the text file
		// LOAD MUSIC

		// LOAD CHARACTERS

		bg = new FlxSprite().loadGraphic(UILoader.loadImageDirect('menuDesat'));
		add(bg);

		grpSongs = new FlxTypedGroup<Alphabet>();
		add(grpSongs);

		for (i in 0...songs.length)
		{
			var songText:Alphabet = new Alphabet(0, (70 * i) + 30, songs[i], true, false);
			songText.isMenuItem = true;
			songText.targetY = i;
			grpSongs.add(songText);

			var icon:HealthIcon = new HealthIcon(iconList[i]);
			icon.sprTracker = songText;

			// using a FlxGroup is too much fuss!
			iconArray.push(icon);
			add(icon);

			// songText.x += 40;
			// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
			// songText.screenCenter(X);
		}

		scoreText = new FlxText(FlxG.width * 0.56, 5, 0, "", 32);
		// scoreText.autoSize = false;
		scoreText.setFormat("assets/fonts/vcr.ttf", 32, FlxColor.WHITE, RIGHT);
		// scoreText.alignment = RIGHT;

		scoreBG = new FlxSprite(scoreText.x - 6, 0).makeGraphic(1, 66, 0x99000000);
		scoreBG.antialiasing = false;
		scoreBG.scale.x = FlxG.width - scoreText.x + 6;
		scoreBG.x = FlxG.width - scoreBG.scale.x / 2;
		add(scoreBG);
		


		diffText = new FlxText(scoreText.x, scoreText.y + 36, 0, "", 24);
		diffText.font = scoreText.font;
		add(diffText);

		previewtext = new FlxText(scoreText.x, scoreText.y + 96, 0, "Playback Speed: " + FlxMath.roundDecimal(rate, 2) + "x (Shift, R)", 24);
		previewtext.font = scoreText.font;
		#if cpp add(previewtext); #end

		add(scoreText);

		changeSelection();
		changeDiff();

		// FlxG.sound.playMusic('assets/music/title' + TitleState.soundExt, 0);
		// FlxG.sound.music.fadeIn(2, 0, 0.8);
		selector = new FlxText();

		selector.size = 40;
		selector.text = ">";
		// add(selector);

		var swag:Alphabet = new Alphabet(1, 0, "swag");

		// JUST DOIN THIS SHIT FOR TESTING!!!
		/* 
			var md:String = Markdown.markdownToHtml(Assets.getText('CHANGELOG.md'));

			var texFel:TextField = new TextField();
			texFel.width = FlxG.width;
			texFel.height = FlxG.height;
			// texFel.
			texFel.htmlText = md;

			FlxG.stage.addChild(texFel);

			// scoreText.textField.htmlText = md;

			trace(md);
		 */

		super.create();
	}

	override function beatHit()
	{
		super.beatHit();
		FlxG.camera.zoom += 0.015; // mid fight masses style zooming per song bpm
	}

	override function newMeasure()
	{
		super.newMeasure();
		FlxG.camera.zoom += 0.03;
		if (json.notes[Math.floor(curStep / 16)] != null)
		{
			if (json.notes[Math.floor(curStep / 16)].changeBPM)
			{
				Conductor.changeBPM(json.notes[Math.floor(curStep / 16)].bpm);
			}
		}
	}

	function addSong(song:String, icon:String = 'blank', color:FlxColor = 0xFF9271FD, week:Int = 0)
	{
		if (StoryMenuState.weekUnlocked[week] || isDebug) {
			songs.push(song);
			iconList.push(icon);
			colorList.push(color);
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		
		if (FlxG.sound.music != null)
			Conductor.songPosition = FlxG.sound.music.time;

		FlxG.camera.zoom = FlxMath.lerp(defaultCamZoom, FlxG.camera.zoom, CoolUtil.boundTo(1 - (elapsed * 3.125), 0, 1));

		if (FlxG.sound.music.volume < 0.7)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		lerpScore = CoolUtil.coolLerp(lerpScore, intendedScore, 0.4);
		lerpAccuracy = CoolUtil.coolLerp(lerpAccuracy, intendedAccuracy, 0.4);
		bg.color = colorList[curSelected];

		positionHighscore();

		scoreText.text = 'PERSONAL BEST: ${Math.round(lerpScore)}, ${FlxMath.roundDecimal(lerpAccuracy, 2)}%';

		var upP = controls.UP_P;
		var downP = controls.DOWN_P;
		var accepted = controls.ACCEPT;

		if (upP)
		{
			changeSelection(-1);
		}
		if (downP)
		{
			changeSelection(1);
		}

		if (FlxG.keys.pressed.SHIFT)
		{
			if (controls.LEFT_P)
			{
				rate -= 0.05;
			}
			if (controls.RIGHT_P)
			{
				rate += 0.05;
			}
			if (controls.RESET)
			{
				rate = 1;
			}

			if (rate > 4)
			{
				rate = 4;
			}
			else if (rate < 0.25)
			{
				rate = 0.25;
			}
			previewtext.text = "Playback Speed: " + FlxMath.roundDecimal(rate, 2) + "x (Shift, R)";
		} else {
			if (controls.LEFT_P)
				changeDiff(-1);
			if (controls.RIGHT_P)
				changeDiff(1);
		}

		if (controls.BACK)
		{
			FlxG.sound.playMusic('assets/music/freakyMenu' + TitleState.soundExt, 4);
			FlxG.switchState(new MainMenuState());
		}

		#if cpp
		@:privateAccess
		{
			if (FlxG.sound.music.playing)
				lime.media.openal.AL.sourcef(FlxG.sound.music._channel.__source.__backend.handle, lime.media.openal.AL.PITCH, rate);
		}
		#end

		if (accepted)
		{
			if(songs[curSelected].toLowerCase() == 'test')
				curDifficulty = 1;

			var poop:String = Highscore.formatSong(songs[curSelected].toLowerCase(), curDifficulty);

			trace(poop);
			PlayState.SONG = Song.loadFromJson(poop, songs[curSelected].toLowerCase(), (songFolders[curSelected] != ''), songFolders[curSelected]);
			PlayState.isStoryMode = false;
			PlayState.storyDifficulty = curDifficulty;
			FlxG.switchState(new PlayState());
			if (FlxG.sound.music != null) {
				FlxG.sound.music.stop();
			}
		}
	}

	function positionHighscore()
	{
		scoreText.x = FlxG.width - scoreText.width - 6;
		scoreBG.scale.x = FlxG.width - scoreText.x + 6;
		scoreBG.x = FlxG.width - scoreBG.scale.x / 2;
	
		diffText.x = Std.int(scoreBG.x + scoreBG.width / 2);
		diffText.x -= (diffText.width / 2);
	}
	
	function changeDiff(change:Int = 0)
	{
		curDifficulty += change;

		if (curDifficulty < 0)
			curDifficulty = 2;
		if (curDifficulty > 2)
			curDifficulty = 0;

		#if !switch
		intendedScore = Highscore.getScore(songs[curSelected], curDifficulty);
		intendedAccuracy = Highscore.getAccuracy(songs[curSelected], curDifficulty);
		#end

		PlayState.storyDifficulty = curDifficulty;

		diffText.text = "< " + CoolUtil.difficultyString() + " >";
		positionHighscore();
	}

	function changeSelection(change:Int = 0)
	{
		FlxG.sound.play('assets/sounds/scrollMenu' + TitleState.soundExt, 0.4);
		curSelected += change;

		if (curSelected < 0)
			curSelected = songs.length - 1;
		if (curSelected >= songs.length)
			curSelected = 0;

		// selector.y = (70 * curSelected) + 30;

		#if !switch
		intendedScore = Highscore.getScore(songs[curSelected], curDifficulty);
		intendedAccuracy = Highscore.getAccuracy(songs[curSelected], curDifficulty);
		// lerpScore = 0;
		#end

		json = Song.loadFromJson(songs[curSelected].toLowerCase(), songs[curSelected].toLowerCase(), (songFolders[curSelected] != ''), songFolders[curSelected]);

		#if sys
		trace(songFolders[curSelected]);
		if(songFolders[curSelected] != '') {
			trace('softcoded!');
			FlxG.sound.playMusic('mods/weeks/' + songFolders[curSelected] + '/' + songs[curSelected].toLowerCase() + "/Inst" + TitleState.soundExt, 0);
		} else {
			trace('hardcoded!');
			FlxG.sound.playMusic('assets/songs/' + songs[curSelected].toLowerCase() + "/Inst" + TitleState.soundExt, 0);
		}
		#else
		FlxG.sound.playMusic('assets/songs/' + songs[curSelected].toLowerCase() + "/Inst" + TitleState.soundExt, 0);
		#end

		if(json != null)
			Conductor.changeBPM(json.bpm);
		else
			Conductor.changeBPM(0);
		
		var bullShit:Int = 0;
		
		for (i in 0...iconArray.length)
		{
			iconArray[i].alpha = 0.6;
		}

		iconArray[curSelected].alpha = 1;
		for (item in grpSongs.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			// item.setGraphicSize(Std.int(item.width * 0.8));

			if (item.targetY == 0)
			{
				item.alpha = 1;
				// item.setGraphicSize(Std.int(item.width));
			}
		}
	}
}