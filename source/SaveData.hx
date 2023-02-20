package;

import flixel.FlxG;
import lime.app.Application;
import flixel.input.gamepad.FlxGamepad;
import openfl.Lib;

using StringTools;

class SaveData
{
	public static function formatSaveFile():Void
	{
		if (FlxG.save.data.leftBind == null) {
			FlxG.save.data.leftBind = 'A';
		}
		if (FlxG.save.data.downBind == null) {
			FlxG.save.data.downBind = 'S';
		}
		if (FlxG.save.data.upBind == null) {
			FlxG.save.data.upBind = 'W';
		}
		if (FlxG.save.data.rightBind == null) {
			FlxG.save.data.rightBind = 'D';
		}
		if (FlxG.save.data.killBind == null) {
			FlxG.save.data.killBind = 'R';
		}
		if (FlxG.save.data.bot == null) {
			FlxG.save.data.bot = false;
		}
		if (FlxG.save.data.ghost == null) {
			FlxG.save.data.ghost = false;
		}
		if (FlxG.save.data.accuracy == null) {
			FlxG.save.data.accuracy = true;
		}
		if (FlxG.save.data.noteframe == null) {
			FlxG.save.data.noteframe = 10;
		}
		if (FlxG.save.data.splash == null) {
			FlxG.save.data.splash = true;
		}
		if (FlxG.save.data.random == null) {
			FlxG.save.data.random = false;
		}
		if (FlxG.save.data.downscroll == null) {
			FlxG.save.data.downscroll = false;
		}
		if (FlxG.save.data.optimize == null) {
			FlxG.save.data.optimize = false;
		}
		if (FlxG.save.data.bg == null) {
			FlxG.save.data.bg = true;
		}
		if (FlxG.save.data.characters == null) {
			FlxG.save.data.characters = true;
		}
		if (FlxG.save.data.details == null) {
			FlxG.save.data.details = true;
		}
		if (FlxG.save.data.zoom == null) {
			FlxG.save.data.zoom = false;
		}
		if (FlxG.save.data.glow == null) {
			FlxG.save.data.glow = false;
		}
		if (FlxG.save.data.fps == null) {
			FlxG.save.data.fps = #if sys Application.current.window.displayMode.refreshRate #else 60 #end;
		}
		if (FlxG.save.data.splash == null) {
			FlxG.save.data.splash = true;
		}
		if(FlxG.save.data.shaders == null) {
			FlxG.save.data.shaders = false;
		}
		if(FlxG.save.data.fps < 30) {
			FlxG.save.data.fps = 60; // FAILSAFE!
		}
		FlxG.save.flush();
		PlayerSettings.player1.controls.loadKeyBinds();
	}
}