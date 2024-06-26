package;

import Song.SwagSong;
import flixel.FlxG;

/**
 * ...
 * @author
 */
 
typedef BPMChangeEvent =
{
	var stepTime:Int;
	var songTime:Float;
	var bpm:Float;
}

class Conductor
{
	public static var bpm:Float = 100;
	public static var crochet:Float = ((60 / bpm) * 1000) ; // beats in milliseconds
	public static var stepCrochet:Float = crochet / 4; // steps in milliseconds
	public static var songPosition:Float;
	public static var lastSongPos:Float;

	public static var bpmChangeMap:Array<BPMChangeEvent> = [];

	public static var holdCrochet:Float = ((60 / (bpm + 0.01)) * 1000); // making this slightly higher than the actual crochet fixes held note lengths????
	public static var holdStepCrochet:Float = holdCrochet / 4;

	public function new()
	{
	}

	public static function mapBPMChanges(song:SwagSong)
	{
		bpmChangeMap = [];

		var curBPM:Float = song.bpm;
		var totalSteps:Int = 0;
		var totalPos:Float = 0;
		for (i in 0...song.notes.length)
		{
			if(song.notes[i].changeBPM && song.notes[i].bpm != curBPM)
			{
				curBPM = song.notes[i].bpm;
				var event:BPMChangeEvent = {
					stepTime: totalSteps,
					songTime: totalPos,
					bpm: curBPM
				};
				bpmChangeMap.push(event);
			}

			var deltaSteps:Int = song.notes[i].lengthInSteps;
			totalSteps += deltaSteps;
			totalPos += ((((60 / curBPM) * 1000)) / 4) * deltaSteps;
		}
		trace("new BPM map BUDDY " + bpmChangeMap);
	}
		
	public static function changeBPM(newBpm:Float)
	{
		bpm = newBpm;
		crochet = ((60 / bpm) * 1000);
		stepCrochet = crochet / 4;
		holdCrochet = ((60 / (bpm + 0.01)) * 1000);
		holdStepCrochet = holdCrochet / 4;	
	}
}
