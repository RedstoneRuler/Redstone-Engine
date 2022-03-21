package;

import Controls.KeyboardScheme;
import Controls.Control;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.input.keyboard.FlxKey;
import flixel.util.FlxColor;

class LatencyState extends FlxState
{
	var offsetText:FlxText;
	var noteGrp:FlxTypedGroup<Note>;
	var strumLine:FlxSprite;
	var extra:FlxText = new FlxText(5, FlxG.height, 0, "Space: Reset, Backspace: Return", 12);
	override function create()
	{
		FlxG.sound.playMusic('assets/music/optionsMenu' + TitleState.soundExt, 0);
		FlxG.sound.play('assets/sounds/soundTest' + TitleState.soundExt);

		noteGrp = new FlxTypedGroup<Note>();
		add(noteGrp);

		offsetText = new FlxText();
		offsetText.screenCenter();
		add(offsetText);

		strumLine = new FlxSprite(FlxG.width / 2, 100).makeGraphic(FlxG.width, 5);
		add(strumLine);

		Conductor.changeBPM(120);

		for (i in 0...32)
		{
			var note:Note = new Note(Conductor.crochet * i, 1);
			noteGrp.add(note);
		}
		extra.scrollFactor.set();
		extra.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(extra);
		super.create();
	}

	override function update(elapsed:Float)
	{
		offsetText.text = "Offset: " + FlxG.save.data.offset + "ms (Left, Right, Shift)";

		Conductor.songPosition = FlxG.sound.music.time - FlxG.save.data.offset;

		var multiply:Float = 1;

		if (FlxG.keys.pressed.SHIFT)
			multiply = 10;

		if (FlxG.keys.justPressed.RIGHT)
			FlxG.save.data.offset += 1 * multiply;
		if (FlxG.keys.justPressed.LEFT)
			FlxG.save.data.offset -= 1 * multiply;

		if (FlxG.keys.justPressed.SPACE)
		{
			FlxG.sound.music.stop();
			FlxG.resetState();
		}
		if(FlxG.keys.justPressed.BACKSPACE)
		{
			FlxG.sound.music.stop();
			FlxG.switchState(new SettingsGameplay());
			FlxG.sound.playMusic('assets/music/optionsMenu' + TitleState.soundExt, 4);
		}
		noteGrp.forEach(function(daNote:Note)
		{
			daNote.y = (strumLine.y - (Conductor.songPosition - daNote.strumTime) * 0.45);
			daNote.x = strumLine.x + 30;

			if (daNote.y < strumLine.y)
				daNote.kill();
		});

		super.update(elapsed);
	}
}
