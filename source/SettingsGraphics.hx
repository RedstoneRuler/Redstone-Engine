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

using StringTools;
class SettingsGraphics extends MusicBeatState
{
	var selector:FlxText;
	var curSelected:Int = 0;
	var controlsStrings:Array<Array<Dynamic>> = [];

	private var grpControls:FlxTypedGroup<Alphabet>;
	private var grpChecks:Array<CheckboxThingie> = [];
	private var grpStrings:Array<String> = [];
	
	var leftHoldTimer:Float;
	var rightHoldTimer:Float;

	override function create()
	{
		var menuBG:FlxSprite = new FlxSprite(-80).loadGraphic(UILoader.loadImageDirect('menuDesat'));
		
		controlsStrings = [#if sys ['Framerate Cap', 'fps'], #end ['Shaders', 'shaders'], ['Note Splashes', 'splash'], ['Glowing Notes', 'glow'], ['Beat-Based Zooming', 'zoom'], ['Animate Opponent Strums', 'strumAnimDad'], ['Animate Player Strums', 'strumAnimBF']];
		
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
			var controlLabel:Alphabet = new Alphabet(90, 320, controlsStrings[i][0], true, false);
			controlLabel.isMenuItem = true;
			controlLabel.targetY = i - curSelected;
			controlLabel.visible = false;
			grpControls.add(controlLabel);

			if(Std.is(Reflect.field(FlxG.save.data, controlsStrings[i][1]), Bool)) {
				var checkBox:CheckboxThingie = new CheckboxThingie(controlLabel.x + 100, controlLabel.targetY, Reflect.field(FlxG.save.data, controlsStrings[i][1]));
				checkBox.sprTracker = controlLabel;
				checkBox.visible = false;
				grpChecks.push(checkBox);
				grpStrings.push(controlsStrings[i][1]);
				add(checkBox);
			} else {
				controlLabel.text = '${controlsStrings[i][0]} ${Reflect.field(FlxG.save.data, controlsStrings[i][1])}';
			}
		}
		
		super.create();
	}
	
	override function update(elapsed:Float)
	{
		grpControls.forEach(function(controlLabel:Alphabet) {
			if(controlLabel.visible == false) {
				controlLabel.visible = true;
			}
		});
		for(i in 0...grpChecks.length)
		{
			if(grpChecks[i].visible == false)
				grpChecks[i].visible = true;
		}
		super.update(elapsed);
		if(Std.is(Reflect.field(FlxG.save.data, controlsStrings[curSelected][1]), Bool))
		{
			if (controls.ACCEPT)
				{
					var setState = !Reflect.field(FlxG.save.data, controlsStrings[curSelected][1]);
					Reflect.setField(FlxG.save.data, controlsStrings[curSelected][1], setState);
					grpChecks[getCheckId(controlsStrings[curSelected][1])].daValue = setState;
					FlxG.log.add('SET VALUE TO ${setState}');
				}
		}
		else
		{	
			if(controls.LEFT) {
				if(leftHoldTimer == 0 || leftHoldTimer >= 0.5) {
					var ogVal = Reflect.field(FlxG.save.data, controlsStrings[curSelected][1]);
					SaveData.setFrameRate(FlxG.save.data.fps - 1);
					updateDisplay(ogVal);
				}
				leftHoldTimer += elapsed;
			} else {
				leftHoldTimer = 0;
			}
			if(controls.RIGHT) {
				if(rightHoldTimer == 0 || rightHoldTimer >= 0.5) {
					var ogVal = Reflect.field(FlxG.save.data, controlsStrings[curSelected][1]);
					SaveData.setFrameRate(FlxG.save.data.fps + 1);
					updateDisplay(ogVal);
				}
				rightHoldTimer += elapsed;
			} else {
				rightHoldTimer = 0;
			}
			FlxG.watch.addQuick('left hold timer', leftHoldTimer);
			FlxG.watch.addQuick('right hold timer', rightHoldTimer);
		}
		if (controls.BACK) {
			FlxG.save.flush();
			FlxG.switchState(new SettingsCategories());
		}
		if (controls.UP_P)
			changeSelection(-1);
		if (controls.DOWN_P)
			changeSelection(1);
	}

	function getCheckId(val:String)
	{
		for(i in 0...grpStrings.length)
		{
			if(grpStrings[i] == val)
				return i;
		}
		return -1; //why do i need this? i don't even know
	}

	function updateDisplay(ogVal:Dynamic)
	{
		// just bruteforce the right control label lmao
		grpControls.forEach(function(controlLabel:Alphabet)
		{
			if(controlLabel.text.contains(Std.string(ogVal)))
			{
				controlLabel.text = '${controlsStrings[curSelected][0]} ${Reflect.field(FlxG.save.data, controlsStrings[curSelected][1])}';
			}
		});
	}

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