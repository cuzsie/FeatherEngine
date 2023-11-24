package substates;

import states.TitleState;
import utilities.CoolUtil;
import states.MainMenuState;
import states.MusicBeatState;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.app.Application;

class OutdatedSubState extends MusicBeatState
{
	public static var leftState:Bool = false;

	override function create()
	{
		var ver = "v" + Application.current.meta.get('version');

		super.create();

		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		add(bg);

		var txt:FlxText = new FlxText(0, 0, FlxG.width,

		"Hey!\n" + 
		"This mod is powered by FEATHER ENGINE." +
		"\nThe current version that you are running is outdated!\nYou are running " + ver + " while the most recent version is " + TitleState.version_New + "!\n" + 
		"Press Enter to dismiss this message, or ESCAPE to download the newest version!",

		32);
		
		txt.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, CENTER);
		txt.screenCenter();
		txt.color = FlxColor.RED;
		add(txt);
	}

	override function update(elapsed:Float)
	{
		if (controls.BACK)
			CoolUtil.openURL("https://github.com/cuzsie/Feather-Engine/releases");

		if (controls.ACCEPT)
		{
			leftState = true;
			FlxG.switchState(new MainMenuState());
		}

		super.update(elapsed);
	}
}
