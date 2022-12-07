package;

import lime.utils.Assets;
import flixel.FlxG;
#if sys
import sys.io.File;
#end

using StringTools;

class CoolUtil
{
	public static var difficultyArray:Array<String> = ['EASY', "NORMAL", "HARD"];
	public static var version:String = '1.6.0';

	public static function difficultyString():String
	{
		return difficultyArray[PlayState.storyDifficulty];
	}

	public static function removeFromString(remove:String = "", string:String = "")
	{
		return string.replace(remove, "");
	}

	public static function coolTextFile(path:String):Array<String>
	{
		#if sys
		var daList:Array<String> = File.getContent(path).trim().split('\n');
		#else
		var daList:Array<String> = Assets.getText(path).trim().split('\n');
		#end

		for (i in 0...daList.length)
		{
			daList[i] = daList[i].trim();
		}

		return daList;
	}
	
	public static function coolStringFile(path:String):Array<String>
		{
			var daList:Array<String> = path.trim().split('\n');
	
			for (i in 0...daList.length)
			{
				daList[i] = daList[i].trim();
			}
	
			return daList;
		}

	public static function numberArray(max:Int, ?min = 0):Array<Int>
	{
		var dumbArray:Array<Int> = [];
		for (i in min...max)
		{
			dumbArray.push(i);
		}
		return dumbArray;
	}

	public static function camLerpShit(ratio:Float)
	{
		return FlxG.elapsed / (1 / 60) * ratio;
	}
	
	public static function coolLerp(a:Float, b:Float, ratio:Float)
	{
		return a + camLerpShit(ratio) * (b - a);
	}
}