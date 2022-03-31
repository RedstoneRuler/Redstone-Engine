package;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.graphics.atlas.FlxAtlas;
import flixel.graphics.frames.FlxAtlasFrames;

class NoteSplash extends FlxSprite {
    var animAdd:String;
    //You do not want to know how long I was going through Week 7's code to find all this.
    //I used a JS beautifier and a lot of CTRL-F to get everything I needed.
    //Then I took that minified JavaScript code from Funkin.js and turned it back into Haxe code.
    //That was fun.

    //I got so desprate I once even made an attempt to code it in myself.
    //That went well.
    public function new(xPos:Float,yPos:Float,?splashType:Int) {
        if(FlxG.save.data.splash == true) {
            if (splashType == null) splashType = 0;
            super(xPos, yPos);
            setupSprites();
            setupNoteSplash(xPos, xPos, splashType);
        }
    }
    public function setupNoteSplash(xPos:Float, yPos:Float, ?splashType:Int) {
        if(PlayState.curSong.toLowerCase() == 'senpai' || PlayState.curSong.toLowerCase() == 'roses' || PlayState.curSong.toLowerCase() == 'thorns')
            animAdd = "-pixel";
        else {
            animAdd = "";
        }
        if (splashType == null) splashType = 0;
        setPosition(xPos, yPos);
        if(animAdd != "-pixel")
            alpha = 0.6;
        else {
            alpha = 1;
        }
        if(animAdd != "-pixel")
            antialiasing = true;
        animation.play("splash" + splashType + "-" + FlxG.random.int(0,1) + animAdd, true);
		animation.curAnim.frameRate = FlxG.random.int(22, 26);
        updateHitbox();
        offset.set(0.3 * width, 0.3 * height);
    }
    override public function update(elapsed) {
        if(FlxG.save.data.splash == true) {
            if (animation.curAnim.finished) {
                kill();
            }
        }
        super.update(elapsed);
    }
    function setupSprites():Void
    {
        frames = FlxAtlasFrames.fromSparrow('assets/images/noteSplashesFull.png', 'assets/images/noteSplashesFull.xml');
        animation.addByPrefix("splash0-0", "note impact 1 purple0", 24, false);
        animation.addByPrefix("splash1-0", "note impact 1  blue0", 24, false);
        animation.addByPrefix("splash2-0", "note impact 1 green0", 24, false);
        animation.addByPrefix("splash3-0", "note impact 1 red0", 24, false);

        animation.addByPrefix("splash0-1", "note impact 2 purple0", 24, false);
        animation.addByPrefix("splash1-1", "note impact 2 blue0", 24, false);
        animation.addByPrefix("splash2-1", "note impact 2 green0", 24, false);
        animation.addByPrefix("splash3-1", "note impact 2 red0", 24, false);

        animation.addByPrefix("splash0-0-pixel", "note impact 1 purple pixel", 24, false);
        animation.addByPrefix("splash1-0-pixel", "note impact 1  blue pixel", 24, false);
        animation.addByPrefix("splash2-0-pixel", "note impact 1 green pixel", 24, false);
        animation.addByPrefix("splash3-0-pixel", "note impact 1 red pixel", 24, false);

        animation.addByPrefix("splash0-1-pixel", "note impact 2 purple pixel", 24, false);
        animation.addByPrefix("splash1-1-pixel", "note impact 2 blue pixel", 24, false);
        animation.addByPrefix("splash2-1-pixel", "note impact 2 green pixel", 24, false);
        animation.addByPrefix("splash3-1-pixel", "note impact 2 red pixel", 24, false);
    }
}