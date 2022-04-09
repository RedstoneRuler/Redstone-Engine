package;
import flixel.math.FlxPoint;
import flixel.graphics.frames.FlxFrame.FlxFrameAngle;
import openfl.geom.Rectangle;
import flixel.math.FlxRect;
import haxe.xml.Access;
import openfl.system.System;
import flixel.FlxG;
import flixel.graphics.frames.FlxAtlasFrames;
import openfl.utils.AssetType;
import openfl.utils.Assets as OpenFlAssets;
import lime.utils.Assets;
import flixel.FlxSprite;
import sys.io.File;
import sys.FileSystem;
import flixel.graphics.FlxGraphic;
import openfl.display.BitmapData;

import flash.media.Sound;

using StringTools;
class Paths
{
	public static var currentTrackedAssets:Map<String, FlxGraphic> = [];
	public static var dumpExclusions:Array<String> =
	[
		'assets/music/freakyMenu' + TitleState.soundExt,
		'assets/shared/music/breakfast' + TitleState.soundExt,
	];
	public static var currentTrackedSounds:Map<String, Sound> = [];
	// stolen from psych engine but whatever lmfao
		public static function clearUnusedMemory() {
			// clear non local assets in the tracked assets list
			for (key in currentTrackedAssets.keys()) {
				// if it is not currently contained within the used local assets
				if (!localTrackedAssets.contains(key) 
					&& !dumpExclusions.contains(key)) {
					// get rid of it
					var obj = currentTrackedAssets.get(key);
					@:privateAccess
					if (obj != null) {
						openfl.Assets.cache.removeBitmapData(key);
						FlxG.bitmap._cache.remove(key);
						obj.destroy();
						currentTrackedAssets.remove(key);
					}
				}
			}
			// run the garbage collector for good measure lmfao
			System.gc();
		}
	
		// define the locally tracked assets
		public static var localTrackedAssets:Array<String> = [];
		public static function clearStoredMemory(?cleanUnused:Bool = false) {
			// clear anything not in the tracked assets list
			@:privateAccess
			for (key in FlxG.bitmap._cache.keys())
			{
				var obj = FlxG.bitmap._cache.get(key);
				if (obj != null && !currentTrackedAssets.exists(key)) {
					openfl.Assets.cache.removeBitmapData(key);
					FlxG.bitmap._cache.remove(key);
					obj.destroy();
				}
			}
	
			// clear all sounds that are cached
			for (key in currentTrackedSounds.keys()) {
				if (!localTrackedAssets.contains(key) 
				&& !dumpExclusions.contains(key) && key != null) {
					//trace('test: ' + dumpExclusions, key);
					Assets.cache.clear(key);
					currentTrackedSounds.remove(key);
				}
			}	
			// flags everything to be cleared out next unused memory clear
			localTrackedAssets = [];
			openfl.Assets.cache.clear("songs");
		}
}
