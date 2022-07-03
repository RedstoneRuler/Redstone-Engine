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
import Note;
class SettingsGraphics extends MusicBeatState
{
	var zoomText:String;
	var splashText:String;
	var selector:FlxText;
	var curSelected:Int = 0;
	var controlsStrings:Array<String> = [];
	var versionShit:FlxText = new FlxText(5, FlxG.height - 18, 0, "Framerate: " + FlxG.save.data.fps + " (Left, Right, Shift)", 12);
	private var grpControls:FlxTypedGroup<Alphabet>;

	override function create()
	{
		switch(FlxG.save.data.splash) {
			case false:
				splashText = "Note Splashes off";
			case true:
				splashText = "Note Splashes on";
		}
		// this used to be an integer but i couldn't get it to work so... yeah
		switch(FlxG.save.data.zoom) {
			case false:
				zoomText = "Camera zooms per measure";
			case true:
				zoomText = "Camera zooms per beat";
		}
		var menuBG:FlxSprite = new FlxSprite().loadGraphic('assets/images/menuDesat.png');
		controlsStrings = CoolUtil.coolStringFile((
			FlxG.save.data.glow ? "Note Glow On" : "Note Glow Off")
			+ "\n" + (zoomText)
			+ "\n" + (splashText));
			
		versionShit.text = "Framerate: " + FlxG.save.data.fps + " (Left, Right, Shift)";
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
		var minFPS:Int = 10;
		var maxFPS:Int;
		#if html5
		maxFPS = 60;
		#else
		maxFPS = 360;
		#end
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		super.update(elapsed);
		if (FlxG.keys.pressed.SHIFT) {
			if(FlxG.keys.pressed.RIGHT)
				{
					FlxG.updateFramerate += 1;
					if (FlxG.updateFramerate >= maxFPS) { FlxG.updateFramerate = maxFPS; }
					FlxG.drawFramerate = (FlxG.updateFramerate);
					FlxG.save.data.fps = FlxG.drawFramerate;
					versionShit.text = "Framerate: " + FlxG.save.data.fps;
				}
			
				if(FlxG.keys.pressed.LEFT)
				{
					FlxG.updateFramerate -= 1;
					if (FlxG.updateFramerate <= minFPS) { FlxG.updateFramerate = minFPS; }
					FlxG.drawFramerate = (FlxG.updateFramerate);
					FlxG.save.data.fps = FlxG.drawFramerate;
					versionShit.text = "Framerate: " + FlxG.save.data.fps;
				}
		}
		else {
			if(FlxG.keys.justPressed.RIGHT)
			{
				FlxG.updateFramerate += 1;
				if (FlxG.updateFramerate >= maxFPS) { FlxG.updateFramerate = maxFPS; }
				FlxG.drawFramerate = (FlxG.updateFramerate);
				FlxG.save.data.fps = FlxG.drawFramerate;
				versionShit.text = "Framerate: " + FlxG.save.data.fps;
			}

			if(FlxG.keys.justPressed.LEFT)
			{
				FlxG.updateFramerate -= 1;
				if (FlxG.updateFramerate <= minFPS) { FlxG.updateFramerate = minFPS; }
				FlxG.drawFramerate = (FlxG.updateFramerate);
				FlxG.save.data.fps = FlxG.drawFramerate;
				versionShit.text = "Framerate: " + FlxG.save.data.fps;
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
					grpControls.remove(grpControls.members[curSelected]);
				switch(curSelected)
				{
					case 0:
						FlxG.save.data.glow = !FlxG.save.data.glow;
						var ctrl:Alphabet = new Alphabet(0, (70 * curSelected) + 30, (FlxG.save.data.glow ? 'note glow on' : 'note glow off'), true, false);
						ctrl.isMenuItem = true;
						ctrl.targetY = curSelected;
						grpControls.add(ctrl);
					case 1:
						FlxG.save.data.zoom = !FlxG.save.data.zoom;
						var ctrl:Alphabet = new Alphabet(0, (70 * curSelected) + 30, (FlxG.save.data.zoom ? 'camera zooms per beat' : 'camera zooms per measure'), true, false);
						ctrl.isMenuItem = true;
						ctrl.targetY = curSelected - 1;
						grpControls.add(ctrl);
					case 2:
						FlxG.save.data.splash = !FlxG.save.data.splash;
						var ctrl:Alphabet = new Alphabet(0, (70 * curSelected) + 30, (FlxG.save.data.splash ? 'note splashes on' : 'note splashes off'), true, false);
						ctrl.isMenuItem = true;
						ctrl.targetY = curSelected - 2;
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