#if sys
package;

import sys.FileSystem;
import sys.io.File;
import flixel.FlxG;
import flixel.graphics.FlxGraphic;
import openfl.Lib;
import openfl.display.BitmapData;
import flixel.graphics.atlas.FlxAtlas;
import flixel.graphics.frames.FlxAtlasFrames;

using StringTools;

class ModLoader
{
	public static function loadImage(file:String, directory:String)
	{
		trace('LOADING ${file}');
		var image:BitmapData = BitmapData.fromFile(('mods/${directory}') + '/' + '${file}.png');
		return FlxGraphic.fromBitmapData(image);
	}
	public static function loadSparrow(file:String, directory:String)
	{
		trace('LOADING ${file}');
		var image:BitmapData = BitmapData.fromFile(('mods/${directory}') + '/' + '${file}.png');
		var xml:String = (File.getContent('mods/${directory}/${file}.xml'));
		return FlxAtlasFrames.fromSparrow(FlxGraphic.fromBitmapData(image), xml);
	}
	public static function customWeekList()
	{
		var weekList:Array<Dynamic> = [];
		for(i in FileSystem.readDirectory('mods/weeks'))
		{
			if(FileSystem.isDirectory('mods/weeks/${i}'))
			{
				weekList.push(i);
			}
		}
		for(i in 0...weekList.length)
		{
			exclude:Array<String> = File.getContent('mods/weeks/exclude.txt').trim().split('\n')
			if(exclude.contains(weekList[i]))
			{
				weekList.remove(i);
			}
		}
		return weekList;
	}
	public static function getWeekConfigs(week:String)
	{
		var json = WeekJson.loadFromJson('config', week);
		var returnArray:Array<Dynamic> = [json.title, json.songs, json.defaultLocked, json.characters];
		return returnArray;
	}
	public static function getFreeplaySongs()
	{
		var songList:Array<String> = [];
		var weekList = customWeekList();
		for(i in weekList)
		{
			var songData:Array<String> = File.getContent('mods/weeks/${weekList[i]}/freeplay.txt').trim().split('\n');
			for (i in 0...songData.length)
			{
				songList.push(songData[i]);
			}
		}
		trace(songList);
		return songList;
	}
	public static function getFreeplayFolders()
	{
		var dirList:Array<String> = [];
		var weekList = customWeekList();
		for(i in weekList)
		{
			for(g in 0...(File.getContent('mods/weeks/${weekList[i]}/freeplay.txt')).length)
			{
				dirList.push(weekList[i]);
			}
		}
		return dirList;
	}
}
#end