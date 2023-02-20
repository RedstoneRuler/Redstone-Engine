package;

import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.math.FlxMath;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import polymod.format.ParseRules.TargetSignatureElement;
import flixel.FlxG;
import flixel.util.FlxTimer;
import PlayState;

using StringTools;

class Note extends FlxSprite
{
	public var strumTime:Float = 0;

	public var mustPress:Bool = false;
	public var note:String = '';
	public var noteData:Int = 0;
	public var canBeHit:Bool = false;
	public var tooLate:Bool = false;
	public var wasGoodHit:Bool = false;
	public var prevNote:Note;
	public var altNote:Bool = false;
	var noteTimer:Float = 0;

	public var sustainLength:Float = 0;
	public var isSustainNote:Bool = false;

	public var noteScore:Float = 1;

	public static var swagWidth:Float = 160 * 0.7;
	public static var PURP_NOTE:Int = 0;
	public static var GREEN_NOTE:Int = 2;
	public static var BLUE_NOTE:Int = 1;
	public static var RED_NOTE:Int = 3;

	public function new(strumTime:Float, noteData:Int, ?prevNote:Note, ?sustainNote:Bool = false, ?altNote:Bool = false)
	{
		super();
		if (prevNote == null)
			prevNote = this;

		this.prevNote = prevNote;
		isSustainNote = sustainNote;
		this.altNote = altNote;
		x += 50;
		// MAKE SURE ITS DEFINITELY OFF SCREEN?
		y -= 999999;
		this.strumTime = strumTime;

		this.noteData = noteData;

		var daStage:String = PlayState.curStage;

		if(PlayState.isPixelStage)
		{
			loadGraphic('mods/ui_skins/pixel/arrows-pixels.png', true, 17, 17);
			animation.add('purpleScroll', [4]);
			animation.add('blueScroll', [5]);
			animation.add('greenScroll', [6]);
			animation.add('redScroll', [7]);

			animation.add('purpleScrollGlow', [20]);
			animation.add('blueScrollGlow', [21]);
			animation.add('greenScrollGlow', [22]);
			animation.add('redScrollGlow', [23]);
				
			if (isSustainNote)
			{
				loadGraphic('mods/ui_skins/pixel/arrowEnds.png', true, 7, 6);

				animation.add('purpleholdend', [4]);
				animation.add('greenholdend', [6]);
				animation.add('redholdend', [7]);
				animation.add('blueholdend', [5]);

				animation.add('purplehold', [0]);
				animation.add('greenhold', [2]);
				animation.add('redhold', [3]);
				animation.add('bluehold', [1]);
			}

			setGraphicSize(Std.int(width * PlayState.daPixelZoom));
			updateHitbox();
		}
		else
		{
			frames = PlayState.noteSprite;

			animation.addByPrefix('greenScroll', 'green0');
			animation.addByPrefix('redScroll', 'red0');
			animation.addByPrefix('blueScroll', 'blue0');
			animation.addByPrefix('purpleScroll', 'purple0');

			animation.addByPrefix('greenScrollGlow', 'Green Active');
			animation.addByPrefix('redScrollGlow', 'Red Active');
			animation.addByPrefix('blueScrollGlow', 'Blue Active');
			animation.addByPrefix('purpleScrollGlow', 'Purple Active');
			if (isSustainNote) {
				animation.addByPrefix('purpleholdend', 'pruple end hold');
				animation.addByPrefix('greenholdend', 'green hold end');
				animation.addByPrefix('redholdend', 'red hold end');
				animation.addByPrefix('blueholdend', 'blue hold end');
				animation.addByPrefix('purplehold', 'purple hold piece');
				animation.addByPrefix('greenhold', 'green hold piece');
				animation.addByPrefix('redhold', 'red hold piece');
				animation.addByPrefix('bluehold', 'blue hold piece');
			}
		
			setGraphicSize(Std.int(width * 0.7));
			updateHitbox();
			antialiasing = true;
		}

		switch (noteData) {
			case 0:
				note = 'purple';
			case 1:
				note = 'blue';
			case 2:
				note = 'green';
			case 3:
				note = 'red';
		}

		animation.play('${note}Scroll');
		x += swagWidth * noteData;

		// trace(prevNote);
		var daScroll:Bool = FlxG.save.data.downscroll;
		noteTimer = 0;
		if (isSustainNote && prevNote != null)
		{
			noteScore * 0.2;
			alpha = 0.6;

			x += width / 2;

			animation.play('${note}holdend');

			if(daScroll) {
				flipY = true;
			}

			updateHitbox();

			x -= width / 2;
			if(PlayState.isPixelStage)
				x += 30;
			if (prevNote.isSustainNote)
			{
				prevNote.animation.play('${note}hold');

				if (PlayState.isPixelStage) {
					prevNote.scale.y *= Conductor.stepCrochet / 100 * 1.5 * (PlayState.SONG.speed / 1.2);
				}
				else {
					prevNote.scale.y *= Conductor.stepCrochet / 100 * (1.5 * PlayState.SONG.speed);
				}
				prevNote.updateHitbox();
				// prevNote.setGraphicSize();
			}
		}
	}

	override function update(elapsed:Float)
	{
		var daScroll:Bool = FlxG.save.data.downscroll;
		var hitBox:Float;
		super.update(elapsed);
		if (mustPress && FlxG.save.data.bot != true)
		{
			if(!isSustainNote)
			{
				var glow:String = '';
				if(FlxG.save.data.glow && canBeHit) {
					glow = 'Glow';
				}

				animation.play('${note}Scroll${glow}');
			}

			// Hitting held notes really early looks weird with the clipping
			if (isSustainNote) {
				hitBox = 10;
			}
			else {
				hitBox = FlxG.save.data.noteframe;
			}

			// The * 0.5 is so that it's easier to hit them too late, instead of too early
			if (strumTime > Conductor.songPosition - (((hitBox / 60) * 1000) * FreeplayState.rate) && strumTime < Conductor.songPosition + (((hitBox / 60) * 1000) * FreeplayState.rate) * 0.5)
			{
				canBeHit = true;
			}
			else
			{
				canBeHit = false;
			}
			if (strumTime < Conductor.songPosition - (((hitBox / 60) * 1000) * FreeplayState.rate))
			{
				tooLate = true;
			}
		}
		else
		{
			canBeHit = false;

			if (strumTime <= Conductor.songPosition)
			{
				wasGoodHit = true;
			}
		}

		if (tooLate)
		{
			if (alpha > 0.3) {
				alpha = 0.3;
			}
		}
	}
}