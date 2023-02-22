package;

import lime.app.Application;
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
class SettingsGraphics extends MusicBeatState
{
	var zoomText:String;
	var splashText:String;
	var selector:FlxText;
	var curSelected:Int = 0;
	var controlsStrings:Array<String> = [];
	var displayFPS:String;
	var versionShit:FlxText = new FlxText(5, FlxG.height - 18, 0, "", 12);
	var leftHoldTimer:Float;
	var rightHoldTimer:Float;
	private var grpControls:FlxTypedGroup<Alphabet>;

	override function create()
	{
		switch(FlxG.save.data.splash) {
			case false:
				splashText = "Note Splashes Off";
			case true:
				splashText = "Note Splashes On";
		}
		switch(FlxG.save.data.zoom) {
			case false:
				zoomText = "Camera zooms per measure";
			case true:
				zoomText = "Camera zooms per beat";
		}

		var menuBG:FlxSprite = new FlxSprite(-80).loadGraphic(UILoader.loadImageDirect('menuDesat'));
		
		controlsStrings = CoolUtil.coolStringFile(
			(FlxG.save.data.shaders ? "Shaders On" : "Shaders Off")
			+ "\n" + (FlxG.save.data.strumAnimDad ? "Animated Opponent Strums" : "Static Opponent Strums")
			+ "\n" + (FlxG.save.data.strumAnimBF ? "Animated Player Strums" : "Static Player Strums")
			+ "\n" + (FlxG.save.data.glow ? "Note Glow On" : "Note Glow Off")
			+ "\n" + (zoomText)
			+ "\n" + (splashText));
		
		#if !html5 versionShit.text = "Framerate: " + FlxG.save.data.fps + " (Left, Right)"; #end
		trace(controlsStrings);
		menuBG.color = 0xFFea71fd;
		menuBG.setGraphicSize(Std.int(menuBG.width * 1.1));
		menuBG.updateHitbox();
		menuBG.screenCenter();
		menuBG.antialiasing = true;
		add(menuBG);

		grpControls = new FlxTypedGroup<Alphabet>();
		add(grpControls);

		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);
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
		versionShit.text = "Framerate: " + FlxG.save.data.fps;
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		super.update(elapsed);

		#if !html5
		if(FlxG.keys.pressed.LEFT) {
			if(leftHoldTimer == 0 || leftHoldTimer >= 0.5) {
				SaveData.setFrameRate(FlxG.save.data.fps - 1);
			}
			leftHoldTimer += elapsed;
		} else {
			leftHoldTimer = 0;
		}

		if(FlxG.keys.pressed.RIGHT) {
			if(rightHoldTimer == 0 || rightHoldTimer >= 0.5) {
				SaveData.setFrameRate(FlxG.save.data.fps + 1);
			}
			rightHoldTimer += elapsed;
		} else {
			rightHoldTimer = 0;
		}
		#end
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
				grpControls.remove(grpControls.members[curSelected]);
				switch(curSelected)
				{
					case 0:
						FlxG.save.data.shaders = !FlxG.save.data.shaders;
						var ctrl:Alphabet = new Alphabet(0, (70 * curSelected) + 30, (FlxG.save.data.shaders ? "Shaders On" : "Shaders Off"), true, false);
						ctrl.isMenuItem = true;
						ctrl.targetY = curSelected;
						grpControls.add(ctrl);
					case 1:
						FlxG.save.data.strumAnimDad = !FlxG.save.data.strumAnimDad;
						var ctrl:Alphabet = new Alphabet(0, (70 * curSelected) + 30, (FlxG.save.data.strumAnimDad ? "Animated Opponent Strums" : "Static Opponent Strums"), true, false);
						ctrl.isMenuItem = true;
						ctrl.targetY = curSelected - 1;
						grpControls.add(ctrl);
					case 2:
						FlxG.save.data.strumAnimBF = !FlxG.save.data.strumAnimBF;
						var ctrl:Alphabet = new Alphabet(0, (70 * curSelected) + 30, (FlxG.save.data.strumAnimBF ? "Animated Player Strums" : "Static Player Strums"), true, false);
						ctrl.isMenuItem = true;
						ctrl.targetY = curSelected - 2;
						grpControls.add(ctrl);
					case 3:
						FlxG.save.data.glow = !FlxG.save.data.glow;
						var ctrl:Alphabet = new Alphabet(0, (70 * curSelected) + 30, (FlxG.save.data.glow ? "Note Glow On" : "Note Glow Off"), true, false);
						ctrl.isMenuItem = true;
						ctrl.targetY = curSelected - 3;
						grpControls.add(ctrl);
					case 4:
						FlxG.save.data.zoom = !FlxG.save.data.zoom;
						var ctrl:Alphabet = new Alphabet(0, (70 * curSelected) + 30, (FlxG.save.data.zoom ? 'Camera zooms per beat' : 'Camera zooms per measure'), true, false);
						ctrl.isMenuItem = true;
						ctrl.targetY = curSelected - 4;
						grpControls.add(ctrl);
					case 5:
						FlxG.save.data.splash = !FlxG.save.data.splash;
						var ctrl:Alphabet = new Alphabet(0, (70 * curSelected) + 30, (FlxG.save.data.splash ? 'Note Splashes On' : 'Note Splashes Off'), true, false);
						ctrl.isMenuItem = true;
						ctrl.targetY = curSelected - 5;
						grpControls.add(ctrl);
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