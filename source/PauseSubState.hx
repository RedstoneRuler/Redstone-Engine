package;

import Controls.Control;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.system.FlxSound;
import flixel.util.FlxColor;
import flixel.text.FlxText;
class PauseSubState extends MusicBeatSubstate
{
	var grpMenuShit:FlxTypedGroup<Alphabet>;
	#if !html5
	var versionShit:FlxText = new FlxText(5, FlxG.height - 18, 0, "Framerate: " + FlxG.save.data.fps + " (Left, Right, Shift)", 12);
	#end
	var menuItems:Array<String> = ['Resume', 'Restart Song', 'Toggle Practice Mode', 'Exit to menu'];
	var curSelected:Int = 0;

	var pauseMusic:FlxSound;

	public function new(x:Float, y:Float)
	{
		super();

		pauseMusic = new FlxSound().loadEmbedded('assets/music/breakfast' + TitleState.soundExt, true, true);
		pauseMusic.volume = 0;
		pauseMusic.play(false, FlxG.random.int(0, Std.int(pauseMusic.length / 2)));

		FlxG.sound.list.add(pauseMusic);

		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		bg.alpha = 0.6;
		bg.scrollFactor.set();
		add(bg);

		grpMenuShit = new FlxTypedGroup<Alphabet>();
		add(grpMenuShit);

		for (i in 0...menuItems.length)
		{
			var songText:Alphabet = new Alphabet(0, (70 * i) + 30, menuItems[i], true, false);
			songText.isMenuItem = true;
			songText.targetY = i;
			grpMenuShit.add(songText);
		}

		changeSelection();

		cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];
		#if !html5
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);
		#end
	}

	override function update(elapsed:Float)
	{
		if (pauseMusic.volume < 0.5)
			pauseMusic.volume += 0.01 * elapsed;

		super.update(elapsed);

		var upP = controls.UP_P;
		var downP = controls.DOWN_P;
		var accepted = controls.ACCEPT;

		if (upP)
		{
			changeSelection(-1);
		}
		if (downP)
		{
			changeSelection(1);
		}
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
		if (accepted)
		{
			var daSelected:String = menuItems[curSelected];

			switch (daSelected)
			{
				case "Resume":
					close();
				case "Restart Song":
					FlxG.resetState();
				case "Options":
					openSubState(new OptionsMenuSubstate());
				case "Toggle Practice Mode":
					// makin this save data cuz i don't know how to define a public var lmfao
					FlxG.save.data.practice = !FlxG.save.data.practice;
				case "Exit to menu":
					FlxG.switchState(new MainMenuState());
			}
		}

		if (FlxG.keys.justPressed.J)
		{
			// for reference later!
			// PlayerSettings.player1.controls.replaceBinding(Control.LEFT, Keys, FlxKey.J, null);
		}
	}

	override function destroy()
	{
		pauseMusic.destroy();

		super.destroy();
	}

	function changeSelection(change:Int = 0):Void
	{
		FlxG.sound.play('assets/sounds/scrollMenu' + TitleState.soundExt);
		curSelected += change;

		if (curSelected < 0)
			curSelected = menuItems.length - 1;
		if (curSelected >= menuItems.length)
			curSelected = 0;

		var bullShit:Int = 0;

		for (item in grpMenuShit.members)
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
