package featherengine;

import flixel.FlxG;
import flixel.math.FlxMath;
import lime.utils.Assets;

class FeatherUtil
{
	public static function chartExists(songName:String, diff:String):Bool
    {
        return Assets.exists(Paths.chart(songName.toLowerCase() + "/" + diff.toLowerCase()));
    }
}
