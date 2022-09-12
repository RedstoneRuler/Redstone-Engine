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
class SettingsCategories extends MusicBeatState
{
	var zoomText:String;
	var selector:FlxText;
	var curSelected:Int = 0;
	var controlsStrings:Array<String> = [];

	private var grpControls:FlxTypedGroup<Alphabet>;

	override function create()
	{
		#if sys
		var menuBG:FlxSprite = new FlxSprite(-80).loadGraphic(UILoader.loadImageDirect('menuDesat'));
		#else
		var menuBG:FlxSprite = new FlxSprite(-80).loadGraphic('assets/ui_skins/default/menuDesat.png');
		#end
		
		#if sys
		controlsStrings = CoolUtil.coolStringFile("Gameplay\nKeybindings\nGraphics\nOptimization\nConfigure UI Skin");
		#else
		controlsStrings = CoolUtil.coolStringFile("Gameplay\nKeybindings\nGraphics\nOptimization");
		#end
		trace(controlsStrings);
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
			var controlLabel:Alphabet = new Alphabet(0, (70 * i) + 30, controlsStrings[i], true, false);
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
		if (controls.BACK) {
			FlxG.save.flush();
			FlxG.sound.playMusic('assets/music/freakyMenu' + TitleState.soundExt, 4);
			FlxG.switchState(new MainMenuState());
		}
			if (controls.UP_P)
				changeSelection(-1);
			if (controls.DOWN_P)
				changeSelection(1);

			if (controls.ACCEPT)
			{
				switch(curSelected)
				{
					case 0:
						FlxG.switchState(new SettingsGameplay());
					case 1:
						openSubState(new KeyBindMenu());
					case 2:
						FlxG.switchState(new SettingsGraphics());
					case 3:
						FlxG.switchState(new SettingsOptimization());
					case 4:
						FlxG.switchState(new SettingsUI());
				}
			}
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