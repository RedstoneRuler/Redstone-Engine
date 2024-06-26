package;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.graphics.atlas.FlxAtlas;
import flixel.graphics.frames.FlxAtlasFrames;

class NoteSplash extends FlxSprite {
    var initialized:Bool = false;
    
    public function new(xPos:Float,yPos:Float,?splashType:Int) {
        if (splashType == null) splashType = 0;
        super(xPos, yPos);
        if(!initialized) {
            setupSprites();
            initialized = true;
        }
        
        setupNoteSplash(xPos, xPos, splashType);
    }
    public function setupNoteSplash(xPos:Float, yPos:Float, ?splashType:Int) {
        if (splashType == null) splashType = 0;
        setPosition(xPos, yPos);
        
        alpha = 0.6;

        antialiasing = true;

        animation.play("splash" + splashType + "-" + FlxG.random.int(0,1), true);

		animation.curAnim.frameRate += FlxG.random.int(-2, 2);
        
        updateHitbox();
        offset.set(0.3 * width, 0.3 * height);
    }
    override public function update(elapsed) {
        if (animation.curAnim.finished) {
            kill();
        }
        super.update(elapsed);
    }
    function setupSprites():Void
    {
        //using the save data directly so it doesn't try to load it from pixel
        frames = UILoader.loadSparrowDirect('noteSplashes');
        animation.addByPrefix("splash0-0", "note impact 1 purple0", 24, false);
        animation.addByPrefix("splash1-0", "note impact 1  blue0", 24, false);
        animation.addByPrefix("splash2-0", "note impact 1 green0", 24, false);
        animation.addByPrefix("splash3-0", "note impact 1 red0", 24, false);

        animation.addByPrefix("splash0-1", "note impact 2 purple0", 24, false);
        animation.addByPrefix("splash1-1", "note impact 2 blue0", 24, false);
        animation.addByPrefix("splash2-1", "note impact 2 green0", 24, false);
        animation.addByPrefix("splash3-1", "note impact 2 red0", 24, false);
    }
}