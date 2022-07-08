package;

import Controls.KeyboardScheme;
import Controls.Control;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;
class SettingsControls extends MusicBeatState
{
	var zoomText:String;
	var selector:FlxText;
	var curSelected:Int = 0;
	var controlsStrings:Array<String> = [];
	var rebinding:Bool = false;
	var key:FlxKey;
	var directionToBind:Int;
	var frameWait:Int = 0;
	private var grpControls:FlxTypedGroup<Alphabet>;

	override function create()
	{
		var menuBG:FlxSprite = new FlxSprite().loadGraphic(UILoader.loadImage('menuDesat'));
		controlsStrings = CoolUtil.coolStringFile('Left: ${FlxG.save.data.leftBind}\nDown: ${FlxG.save.data.downBind}\n Up: ${FlxG.save.data.upBind}\n Right: ${FlxG.save.data.rightBind}');
		menuBG.color = 0xFFea71fd;
		menuBG.setGraphicSize(Std.int(menuBG.width * 1.1));
		menuBG.updateHitbox();
		menuBG.screenCenter();
		menuBG.antialiasing = true;
		add(menuBG);

		grpControls = new FlxTypedGroup<Alphabet>();
		add(grpControls);

		for (i in 0...controlsStrings.length)
		{
				var controlLabel:Alphabet = new Alphabet(0, (70 * i) + 30, controlsStrings[i], false, false);
				controlLabel.isMenuItem = true;
				controlLabel.targetY = i;
				grpControls.add(controlLabel);
			// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
		}
		super.create();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		frameWait -= 1;
		if(rebinding == true && frameWait == 0)
		{
			if(FlxG.keys.justPressed.ANY)
			{
				switch(directionToBind)
				{
					case 0:
						FlxG.save.data.leftBind = FlxG.keys.justPressed;
					case 1:
						FlxG.save.data.downBind = FlxG.keys.justPressed;
					case 2:
						FlxG.save.data.upBind = FlxG.keys.justPressed;
					case 3:
						FlxG.save.data.rightBind = FlxG.keys.justPressed;
				}
				refreshControlStrings();
				rebinding = false;
			}
		}
		if (controls.BACK) {
			FlxG.save.flush();
			FlxG.switchState(new SettingsCategories());
		}
			if (controls.UP_P)
				changeSelection(-1);
			if (controls.DOWN_P)
				changeSelection(1);

			if (controls.ACCEPT)
			{
				FlxG.sound.play('assets/sounds/confirmMenu' + TitleState.soundExt);
				rebindKey(curSelected);
			}
	}
	function refreshControlStrings():Void
	{
		grpControls.clear();
		controlsStrings = CoolUtil.coolStringFile('Left: ${FlxG.save.data.leftBind}\nDown: ${FlxG.save.data.downBind}\n Up: ${FlxG.save.data.upBind}\n Right: ${FlxG.save.data.rightBind}');
		for (i in 0...controlsStrings.length)
			{
					var controlLabel:Alphabet = new Alphabet(0, (70 * i) + 30, controlsStrings[i], false, false);
					controlLabel.isMenuItem = true;
					controlLabel.targetY = i;
					grpControls.add(controlLabel);
				// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
			}
	}
	function rebindKey(dir:Int)
	{
		frameWait = 2;
		directionToBind = dir;
		rebinding = true;
	}
	var isSettingControl:Bool = false;

	function changeSelection(change:Int = 0)
	{
		#if !switch
		// NGio.logEvent('Fresh');
		#end
		
		FlxG.sound.play('assets/sounds/scrollMenu' + TitleState.soundExt);

		curSelected += change;

		if (curSelected < 0)
			curSelected = grpControls.length - 1;
		if (curSelected >= grpControls.length)
			curSelected = 0;

		// selector.y = (70 * curSelected) + 30;

		var bullShit:Int = 0;

		for (item in grpControls.members)
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