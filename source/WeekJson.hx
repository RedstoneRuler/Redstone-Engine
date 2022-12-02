#if sys
package;

import Section.SwagSection;
import haxe.Json;
import haxe.format.JsonParser;
#if sys
import sys.io.File;
#end

using StringTools;

typedef CustomWeek =
{
	var songs:Array<String>;
	var title:String;
	var defaultLocked:Bool;
	var characters:Array<String>;
}

class WeekJson
{
	var songs:Array<String>;
	var title:String;
	var defaultLocked:Bool;
	var characters:Array<String>;

	public function new(title, songs, defaultLocked, characters)
	{
		this.songs = songs;
		this.title = title;
		this.defaultLocked = defaultLocked;
		this.characters = characters;
	}

	public static function loadFromJson(jsonInput:String, ?folder:String):CustomWeek
	{
		var rawJson = File.getContent('mods/weeks/' + folder.toLowerCase() + '/' + jsonInput.toLowerCase() + '.json').trim();
		
		while (!rawJson.endsWith("}"))
		{
			rawJson = rawJson.substr(0, rawJson.length - 1);
		}

		return parseJSONshit(rawJson);
	}

	public static function parseJSONshit(rawJson:String):CustomWeek
	{
		var swagShit:CustomWeek = cast Json.parse(rawJson);
		return swagShit;
	}
}
#end