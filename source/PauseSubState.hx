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
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
class PauseSubState extends MusicBeatSubstate
{
	var grpMenuShit:FlxTypedGroup<Alphabet>;
	var versionShit:FlxText = new FlxText(5, FlxG.height - 18, 0, "Framerate: " + FlxG.save.data.fps + " (Left, Right, Shift)", 12);
	var menuItems:Array<String> = ['Resume', 'Restart Song', 'Change Difficulty', 'Toggle Practice Mode', 'Toggle Hit Sounds', 'Exit to menu'];
	var curSelected:Int = 0;

	var minFPS:Int = 10;
	var maxFPS:Int;

	var pauseMusic:FlxSound;
	var menuItemsOG:Array<String>;
	var updatedPractice:Bool = true;
	var updatedhitSounds:Bool = true;
	var practice:FlxText = new FlxText(20, 15 + 128, 0, "", 32);
	var hitSounds:FlxText = new FlxText(20, 15 + 96, 0, "", 32);
	var difficultyChoices = [
		"Easy", "Normal", "Hard"
	];
	public function new(x:Float, y:Float)
	{
		super();
		pauseMusic = new FlxSound().loadEmbedded('assets/music/breakfast' + TitleState.soundExt, true, true);
		pauseMusic.volume = 0;
		pauseMusic.play(false, FlxG.random.int(0, Std.int(pauseMusic.length / 2)));

		FlxG.sound.list.add(pauseMusic);
		difficultyChoices.push('BACK');
		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		bg.alpha = 0;
		bg.scrollFactor.set();
		add(bg);

		var levelInfo:FlxText = new FlxText(20, 15, 0, "", 32);
		levelInfo.text += PlayState.SONG.song;
		levelInfo.scrollFactor.set();
		levelInfo.setFormat('assets/fonts/vcr.ttf', 32);
		levelInfo.updateHitbox();
		add(levelInfo);

		var levelDifficulty:FlxText = new FlxText(20, 15 + 32, 0, "", 32);
		levelDifficulty.text += CoolUtil.difficultyString();
		levelDifficulty.scrollFactor.set();
		levelDifficulty.setFormat('assets/fonts/vcr.ttf', 32);
		levelDifficulty.updateHitbox();
		add(levelDifficulty);
		
		var deathCount:FlxText = new FlxText(20, 15 + 64, 0, "", 32);
		deathCount.text = "Blue Balled: " + PlayState.deathCount;
		deathCount.scrollFactor.set();
		deathCount.setFormat('assets/fonts/vcr.ttf', 32);
		deathCount.updateHitbox();
		add(deathCount);

		practice.text = "PRACTICE MODE";
		practice.scrollFactor.set();
		practice.setFormat('assets/fonts/vcr.ttf', 32);
		practice.updateHitbox();
		add(practice);

		hitSounds.text = "Hit Sounds On";
		hitSounds.scrollFactor.set();
		hitSounds.setFormat('assets/fonts/vcr.ttf', 32);
		hitSounds.updateHitbox();
		add(hitSounds);

		levelDifficulty.alpha = 0;
		levelInfo.alpha = 0;
		deathCount.alpha = 0;
		practice.alpha = 0;
		hitSounds.alpha = 0;

		levelInfo.x = FlxG.width - (levelInfo.width + 20);
		levelDifficulty.x = FlxG.width - (levelDifficulty.width + 20);
		deathCount.x = FlxG.width - (deathCount.width + 20);
		practice.x = FlxG.width - (practice.width + 20);
		hitSounds.x = FlxG.width - (hitSounds.width + 20);

		FlxTween.tween(bg, {alpha: 0.6}, 0.4, {ease: FlxEase.quartInOut});
		FlxTween.tween(levelInfo, {alpha: 1, y: 20}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.3});
		FlxTween.tween(levelDifficulty, {alpha: 1, y: levelDifficulty.y + 5}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.5});
		FlxTween.tween(deathCount, {alpha: 1, y: deathCount.y + 5}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.7});
		if(FlxG.save.data.hitSounds == true) {
			FlxTween.tween(hitSounds, {alpha: 1, y: hitSounds.y + 5}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.9});
		}
		if(PlayState.practiceMode == true) {
			FlxTween.tween(practice, {alpha: 1, y: practice.y + 5}, 0.4, {ease: FlxEase.quartInOut, startDelay: 1.1});
		}
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
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);
	}

	override function update(elapsed:Float)
	{
		if (pauseMusic.volume < 0.5)
			pauseMusic.volume += 0.01 * elapsed;

		super.update(elapsed);
		if(!updatedhitSounds) {
			if(FlxG.save.data.hitSounds == true) {
				FlxTween.tween(hitSounds, {alpha: 1, y: hitSounds.y + 5}, 0.4, {ease: FlxEase.quartInOut});
			}
			else {
				FlxTween.tween(hitSounds, {alpha: 0, y: hitSounds.y - 5}, 0.4, {ease: FlxEase.quartInOut});
			}
			updatedhitSounds = true;
		}
		if(!updatedPractice) {
			if(PlayState.practiceMode == true) {
				FlxTween.tween(practice, {alpha: 1, y: practice.y + 5}, 0.4, {ease: FlxEase.quartInOut});
			}
			else {
				FlxTween.tween(practice, {alpha: 0, y: practice.y - 5}, 0.4, {ease: FlxEase.quartInOut});
			}
			updatedPractice = true;
		}
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
		if (accepted)
		{
			var daSelected:String = menuItems[curSelected];
			if (menuItems == difficultyChoices)
				{
					if(menuItems.length - 1 != curSelected && difficultyChoices.contains(daSelected)) {
						var name:String = PlayState.SONG.song;
						var poop = Highscore.formatSong(name, curSelected);
						PlayState.SONG = Song.loadFromJson(poop, name);
						PlayState.storyDifficulty = curSelected;
						FlxG.resetState();
						FlxG.sound.music.volume = 0;
						PlayState.changedDifficulty = true;
						return;
					}
	
					menuItems = menuItemsOG;
					regenMenu();
				}
			switch (daSelected)
			{
				case "Resume":
					close();
				case "Restart Song":
					FlxG.resetState();
				case "Options":
					openSubState(new OptionsMenuSubstate());
				case "Change Difficulty":
					menuItemsOG = menuItems;
					menuItems = difficultyChoices;
					regenMenu();	
				case "Toggle Practice Mode":
					PlayState.practiceMode = !PlayState.practiceMode;
					updatedPractice = false;
				case "Toggle Hit Sounds":
					PlayState.hitSounds = !FlxG.save.data.hitSounds;
					updatedhitSounds = false;
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
	function regenMenu():Void {
		for (i in 0...grpMenuShit.members.length) {
			var obj = grpMenuShit.members[0];
			obj.kill();
			grpMenuShit.remove(obj, true);
			obj.destroy();
		}

		for (i in 0...menuItems.length) {
			var item = new Alphabet(0, 70 * i + 30, menuItems[i], true, false);
			item.isMenuItem = true;
			item.targetY = i;
			grpMenuShit.add(item);
		}
		curSelected = 0;
		changeSelection();
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