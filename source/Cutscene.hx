package;
import Song.SwagSong;
import lime.app.Promise;
import lime.app.Future;
import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.util.FlxTimer;

import openfl.utils.Assets;
import lime.utils.Assets as LimeAssets;
import lime.utils.AssetLibrary;
import lime.utils.AssetManifest;

import haxe.io.Path;

class Cutscene extends MusicBeatState
{
	#if (!windows && !android)
	var SONG:SwagSong;
	inline static var MIN_TIME = 1.0;
	
	var target:FlxState;
	var stopMusic = false;

	
	function new(target:FlxState, stopMusic:Bool)
	{
		super();
		this.target = target;
		this.stopMusic = stopMusic;
	}
	
	override function create()
	{
	}

	inline static public function switchState(target:FlxState, stopMusic = false, song:String)
	{
		switch(song.toLowerCase())
		{
			case 'ugh':
				FlxG.switchState(new VideoState('assets/videosWebm/ughCutscene.webm', new PlayState(), 90));
			case 'guns':
				FlxG.switchState(new VideoState('assets/videosWebm/gunsCutscene.webm', new PlayState(), 90));
			case 'stress':
				FlxG.switchState(new VideoState('assets/videosWebm/stressCutscene.webm', new PlayState(), 90));
			default:
				FlxG.switchState(getNextState(target, stopMusic));
		}
	}
	
	static function getNextState(target:FlxState, stopMusic = false):FlxState
	{
		Paths.setCurrentLevel("week" + PlayState.storyWeek);
		if (stopMusic && FlxG.sound.music != null)
			FlxG.sound.music.stop();
		
		return target;
	}
	#end
}