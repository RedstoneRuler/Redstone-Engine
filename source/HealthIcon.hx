package;

import flixel.FlxSprite;

class HealthIcon extends FlxSprite
{
	public function new(char:String = 'bf', isPlayer:Bool = false)
	{
		super();
		loadGraphic('assets/images/iconGrid.png', true, 150, 150);

		antialiasing = true;
		animation.add('bf', [0, 1, 0], 0, false, isPlayer);
		animation.add('bf-holding-gf', [0, 1, 0], 0, false, isPlayer);
		animation.add('bf-optimized', [0, 1, 0], 0, false, isPlayer);
		animation.add('bf-car', [0, 1, 0], 0, false, isPlayer);
		animation.add('bf-christmas', [0, 1, 0], 0, false, isPlayer);
		animation.add('bf-pixel', [21, 21, 21], 0, false, isPlayer);
		animation.add('spooky', [2, 3, 2], 0, false, isPlayer);
		animation.add('pico', [4, 5, 4], 0, false, isPlayer);
		animation.add('mom', [6, 7, 6], 0, false, isPlayer);
		animation.add('mom-car', [6, 7, 6], 0, false, isPlayer);
		animation.add('tankman', [8, 9, 8], 0, false, isPlayer);
		animation.add('face', [10, 11, 10], 0, false, isPlayer);
		animation.add('dad', [12, 13, 12], 0, false, isPlayer);
		animation.add('senpai', [22, 22, 22], 0, false, isPlayer);
		animation.add('senpai-angry', [22, 22, 22], 0, false, isPlayer);
		animation.add('spirit', [23, 23, 23], 0, false, isPlayer);
		animation.add('bf-old', [14, 15, 14], 0, false, isPlayer);
		animation.add('gf', [16, 16, 16], 0, false, isPlayer);
		animation.add('gf-car', [16, 16, 16], 0, false, isPlayer);
		animation.add('gf-pixel', [16, 16, 16], 0, false, isPlayer);
		animation.add('gf-optimized', [16, 16, 16], 0, false, isPlayer);
		animation.add('parents-christmas', [17, 17, 17], 0, false, isPlayer);
		animation.add('monster', [19, 20, 19], 0, false, isPlayer);
		animation.add('monster-christmas', [19, 20, 19], 0, false, isPlayer);
		animation.add('tylo', [24, 25, 26], 0, false, isPlayer);
		// Avoids crashes if health head doesn't exist
		if(animation.getByName(char) != null) {
			animation.play(char);
		}
		else {
			animation.play("face");
		}
		scrollFactor.set();
	}
}
