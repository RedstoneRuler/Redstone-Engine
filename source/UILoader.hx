package;

#if sys
import sys.FileSystem;
import sys.io.File;
#end
import flixel.FlxG;
import flixel.graphics.FlxGraphic;
import openfl.Lib;
import openfl.display.BitmapData;
import flixel.graphics.atlas.FlxAtlas;
import flixel.graphics.frames.FlxAtlasFrames;

using StringTools;

class UILoader
{
	public static function initSkin():Void
	{
		if (FlxG.save.data.uiSkin == null) {
			FlxG.save.data.uiSkin = 'default';
		}
	}
	public static function loadImage(imageName:String)
	{
		#if sys
		if(FileSystem.exists(FileSystem.absolutePath('assets/ui_skins/${PlayState.uiSkin}') + '/' + '${imageName}.png')) {
			trace('LOADING ${imageName}');
			var image:BitmapData = BitmapData.fromFile(FileSystem.absolutePath('assets/ui_skins/${PlayState.uiSkin}') + '/' + '${imageName}.png');
			return FlxGraphic.fromBitmapData(image);
		}
		else {
			return FlxGraphic.fromBitmapData(BitmapData.fromFile('assets/ui_skins/default/${imageName}.png'));
		}
		#else
		return FlxGraphic.fromBitmapData(BitmapData.fromFile('assets/ui_skins/${PlayState.uiSkin}/${imageName}.png'));
		#end
	}
	public static function loadImageDirect(imageName:String)
	{
		#if sys
		if(FileSystem.exists(FileSystem.absolutePath('assets/ui_skins/${FlxG.save.data.uiSkin}') + '/' + '${imageName}.png')) {
		trace('LOADING ${imageName}');
			var image:BitmapData = BitmapData.fromFile(FileSystem.absolutePath('assets/ui_skins/${FlxG.save.data.uiSkin}') + '/' + '${imageName}.png');
			return FlxGraphic.fromBitmapData(image);
		}
		else {
			return FlxGraphic.fromBitmapData(BitmapData.fromFile('assets/ui_skins/default/${imageName}.png'));
		}
		#else
		return FlxGraphic.fromBitmapData(BitmapData.fromFile('assets/ui_skins/${FlxG.save.data.uiSkin}/${imageName}.png'));
		#end
	}
	public static function loadSparrow(imageName)
	{
		#if sys
		if(FileSystem.exists(FileSystem.absolutePath('assets/ui_skins/${PlayState.uiSkin}') + '/' + '${imageName}.xml')) {
			trace('LOADING ${imageName}');
			var image:BitmapData = BitmapData.fromFile(FileSystem.absolutePath('assets/ui_skins/${PlayState.uiSkin}') + '/' + '${imageName}.png');
			var xml:String = (sys.io.File.getContent('assets/ui_skins/${PlayState.uiSkin}/${imageName}.xml'));
			return FlxAtlasFrames.fromSparrow(FlxGraphic.fromBitmapData(image), xml);
		}
		else {
			return FlxAtlasFrames.fromSparrow('assets/ui_skins/default/${imageName}.png', 'assets/ui_skins/default/${imageName}.xml');
		}
		
		#else
		return FlxAtlasFrames.fromSparrow('assets/ui_skins/${PlayState.uiSkin}/${imageName}.png', 'assets/ui_skins/${PlayState.uiSkin}/${imageName}.xml');
		#end
	}
	public static function loadSparrowDirect(imageName)
	{
		#if sys
		if(FileSystem.exists(FileSystem.absolutePath('assets/ui_skins/${FlxG.save.data.uiSkin}') + '/' + '${imageName}.xml')) {
			trace('LOADING ${imageName}');
			var image:BitmapData = BitmapData.fromFile(FileSystem.absolutePath('assets/ui_skins/${FlxG.save.data.uiSkin}') + '/' + '${imageName}.png');
			var xml:String = (sys.io.File.getContent('assets/ui_skins/${FlxG.save.data.uiSkin}/${imageName}.xml'));
			return FlxAtlasFrames.fromSparrow(FlxGraphic.fromBitmapData(image), xml);
		}
		else {
			return FlxAtlasFrames.fromSparrow('assets/ui_skins/default/${imageName}.png', 'assets/ui_skins/default/${imageName}.xml');
		}
		#else
		return FlxAtlasFrames.fromSparrow('assets/ui_skins/default/${imageName}.png', 'assets/ui_skins/default/${imageName}.xml');
		#end
	}
}