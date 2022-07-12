package;
#if sys
import sys.FileSystem;
import sys.io.File;
#end
import openfl.display.BitmapData;
import flixel.graphics.FlxGraphic;
import flixel.FlxSprite;

class HealthIcon extends FlxSprite
{
	public var sprTracker:FlxSprite;
	
	public function new(char:String = 'face', isPlayer:Bool = false)
	{
		super();
		changeIcon(char, isPlayer);
		scrollFactor.set();
	}
	public function changeIcon(char:String, isPlayer:Bool = false)
	{
		var icon:String;

		switch(char)
		{
			case 'bf-car':
				icon = 'bf';
			case 'bf-christmas':
				icon = 'bf';
			case 'bf-holding-gf':
				icon = 'bf';
			case 'mom-car':
				icon = 'mom';
			case 'monster-christmas':
				icon = 'monster';
			case 'senpai-angry':
				icon = 'senpai';		
			default:
				icon = char;
		}

		loadGraphic(loadIcon(icon));
		loadGraphic(loadIcon(icon), true, Math.floor(width / 2), Math.floor(height));

		antialiasing = true;

		if(width >= (width + (width / 2))) //check if there's room for a winning icon and add it to the animation if there is
			animation.add('face', [0, 1, 2], 0, false, isPlayer);
		else 
			animation.add('face', [0, 1, 0], 0, false, isPlayer);

		animation.play('face');
	}
	override function update(elapsed:Float)
	{
		super.update(elapsed);
		if (sprTracker != null)
			setPosition(sprTracker.x + sprTracker.width + 10, sprTracker.y - 30);
	}
	static public function loadIcon(char:String, isPlayer:Bool = false)
	{
		//COPIED FROM UI LOADER CUZ I'M LAZY LMFAO
		#if sys
		if(FileSystem.exists(FileSystem.absolutePath('assets/images/icons/icon-${char}.png'))) {
			var image:BitmapData = BitmapData.fromFile(FileSystem.absolutePath('assets/images/icons/icon-${char}.png'));
			return FlxGraphic.fromBitmapData(image);
		}
		else {
			return FlxGraphic.fromBitmapData(BitmapData.fromFile('assets/images/icons/icon-face.png'));
		}
		#else
		return FlxGraphic.fromBitmapData(BitmapData.fromFile('assets/images/icons/icon-${char}.png'));
		#end
	}
}