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
//I stole this whole system from KE lmao
class SettingsGraphics extends MusicBeatState
{
	var zoomText:String;
	var selector:FlxText;
	var curSelected:Int = 0;
	var controlsStrings:Array<String> = [];
	#if !html5
	var versionShit:FlxText = new FlxText(5, FlxG.height - 18, 0, "Framerate: " + FlxG.save.data.fps + " (Left, Right, Shift)", 12);
	#end
	private var grpControls:FlxTypedGroup<Alphabet>;

	override function create()
	{
		if (FlxG.save.data.zoom == null) {
			FlxG.save.data.zoom = false;
		}
		if (FlxG.save.data.glow == null) {
			FlxG.save.data.glow = false;
		}
		// this used to be an integer but i couldn't get it to work so... yeah
		switch(FlxG.save.data.zoom) {
			case false:
				zoomText = "Camera zooms per measure";
			case true:
				zoomText = "Camera zooms per beat";
		}
		var menuBG:FlxSprite = new FlxSprite().loadGraphic('assets/images/menuDesat.png');
		controlsStrings = CoolUtil.coolStringFile((FlxG.save.data.glow ? "Note Glow On" : "Note Glow Off") + "\n" + (zoomText));
		
		trace(controlsStrings);
		menuBG.color = 0xFFea71fd;
		menuBG.setGraphicSize(Std.int(menuBG.width * 1.1));
		menuBG.updateHitbox();
		menuBG.screenCenter();
		menuBG.antialiasing = true;
		add(menuBG);

		grpControls = new FlxTypedGroup<Alphabet>();
		add(grpControls);

		#if !html5
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);
		#end
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
		#if !html5
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		#end
		super.update(elapsed);
		#if !html5
		if (FlxG.keys.pressed.SHIFT) {
			if(FlxG.keys.pressed.RIGHT)
				{
					FlxG.updateFramerate += 1;
					if (FlxG.updateFramerate >= 360) { FlxG.updateFramerate = 360; }
					FlxG.drawFramerate = (FlxG.updateFramerate);
					FlxG.save.data.fps = FlxG.drawFramerate;
					versionShit.text = "Framerate: " + FlxG.save.data.fps;
				}
			
				if(FlxG.keys.pressed.LEFT)
				{
					FlxG.updateFramerate -= 1;
					if (FlxG.updateFramerate <= 10) { FlxG.updateFramerate = 10; }
					FlxG.drawFramerate = (FlxG.updateFramerate);
					FlxG.save.data.fps = FlxG.drawFramerate;
					versionShit.text = "Framerate: " + FlxG.save.data.fps;
				}
		}
		else {
			if(FlxG.keys.justPressed.RIGHT)
			{
				FlxG.updateFramerate += 1;
				if (FlxG.updateFramerate >= 360) { FlxG.updateFramerate = 360; }
				FlxG.drawFramerate = (FlxG.updateFramerate);
				FlxG.save.data.fps = FlxG.drawFramerate;
				versionShit.text = "Framerate: " + FlxG.save.data.fps;
			}

			if(FlxG.keys.justPressed.LEFT)
			{
				FlxG.updateFramerate -= 1;
				if (FlxG.updateFramerate <= 10) { FlxG.updateFramerate = 10; }
				FlxG.drawFramerate = (FlxG.updateFramerate);
				FlxG.save.data.fps = FlxG.drawFramerate;
				versionShit.text = "Framerate: " + FlxG.save.data.fps;
			}
		}
		#end
		if (controls.BACK) {
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