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
class OptionsMenuSubstate extends MusicBeatSubstate
{
	var selector:FlxText;
	var curSelected:Int = 0;
	var controlsStrings:Array<String> = [];

	private var grpControls:FlxTypedGroup<Alphabet>;
	var versionShit:FlxText = new FlxText(5, FlxG.height - 18, 0, "Note Hitbox: " + FlxG.save.data.noteframe + " (Left, Right, Shift, Higher value = Bigger hitbox)", 12);

	override function create()
	{
		if (FlxG.save.data.bot == null) {
			FlxG.save.data.bot = false;
		}
		if (FlxG.save.data.ghost == null) {
			FlxG.save.data.ghost = false;
		}
		if (FlxG.save.data.optimize == null) {
			FlxG.save.data.optimize = false;
		}
		if (FlxG.save.data.noteframe == null) {
			FlxG.save.data.noteframe = 10;
		}
		controlsStrings = CoolUtil.coolStringFile((FlxG.save.data.ghost ? "Ghost Tapping On" : "Ghost Tapping Off") + "\n" + (FlxG.save.data.glow ? "Note Glow On" : "Note Glow Off") + "\n" + (FlxG.save.data.optimize ?  "Optimization On" : "Optimization Off") + "\n" +(FlxG.save.data.bot ? "Autoplay on" : "Autoplay off"));
		
		trace(controlsStrings);

		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		bg.alpha = 0.6;
		bg.scrollFactor.set();
		add(bg);

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


		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);
		
		super.create();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		if (FlxG.keys.pressed.SHIFT) {
			if(FlxG.keys.pressed.RIGHT)
				{
					FlxG.save.data.noteframe += 1;
					if (FlxG.save.data.noteframe >= 40) { FlxG.save.data.noteframe = 40; }
					versionShit.text = "Note Hitbox: " + FlxG.save.data.noteframe;
				}
			
				if(FlxG.keys.pressed.LEFT)
				{
					FlxG.save.data.noteframe -= 1;
					if (FlxG.save.data.noteframe <= 1) { FlxG.save.data.noteframe = 1; }
					versionShit.text = "Note Hitbox: " + FlxG.save.data.noteframe;
				}
		}
		else {
			if(FlxG.keys.justPressed.RIGHT)
				{
					FlxG.save.data.noteframe += 1;
					if (FlxG.save.data.noteframe >= 30) { FlxG.save.data.noteframe = 30; }
					versionShit.text = "Note Hitbox: " + FlxG.save.data.noteframe;
				}
			
				if(FlxG.keys.justPressed.LEFT)
				{
					FlxG.save.data.noteframe -= 1;
					if (FlxG.save.data.noteframe <= 1) { FlxG.save.data.noteframe = 1; }
					versionShit.text = "Note Hitbox: " + FlxG.save.data.noteframe;
				}
		}
		if (controls.BACK) {
			close();
		}
			if (controls.UP_P)
				changeSelection(-1);
			if (controls.DOWN_P)
				changeSelection(1);

			if (controls.ACCEPT)
			{
				if (curSelected != 3)
					grpControls.remove(grpControls.members[curSelected]);
				switch(curSelected)
				{
					case 0:
						FlxG.save.data.ghost = !FlxG.save.data.ghost;
						var ctrl:Alphabet = new Alphabet(0, (70 * curSelected) + 30, (FlxG.save.data.ghost ? 'ghost tapping on' : 'ghost tapping off'), true, false);
						ctrl.isMenuItem = true;
						ctrl.targetY = curSelected;
						grpControls.add(ctrl);
					case 1:
						FlxG.save.data.glow = !FlxG.save.data.glow;
						var ctrl:Alphabet = new Alphabet(0, (70 * curSelected) + 30, (FlxG.save.data.glow ? 'note glow on' : 'note glow off'), true, false);
						ctrl.isMenuItem = true;
						ctrl.targetY = curSelected - 1;
						grpControls.add(ctrl);
					case 2:
						//For Luna :)
						FlxG.save.data.optimize = !FlxG.save.data.optimize;
						#if html5
						if(FlxG.save.data.optimize == true) {
							FlxG.updateFramerate = 30;
							FlxG.drawFramerate = (FlxG.updateFramerate);
						}
						else {
							FlxG.updateFramerate = 60;
							FlxG.drawFramerate = (FlxG.updateFramerate);
						}
						#end
						var ctrl:Alphabet = new Alphabet(0, (70 * curSelected) + 30, (FlxG.save.data.optimize ? 'optimization on' : 'optimization off'), true, false);
						ctrl.isMenuItem = true;
						ctrl.targetY = curSelected - 2;
						grpControls.add(ctrl);
					case 3:
						FlxG.save.data.bot = !FlxG.save.data.bot;
						var ctrl:Alphabet = new Alphabet(0, (70 * curSelected) + 30, (FlxG.save.data.bot ? 'autoplay on' : 'autoplay off'), true, false);
						ctrl.isMenuItem = true;
						ctrl.targetY = curSelected - 3;
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