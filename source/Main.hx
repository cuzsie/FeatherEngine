package;

import openfl.display.Application;
import states.TitleState;
import states.SplashScreenState;
import utilities.CoolUtil;
import openfl.text.TextFormat;
import ui.SimpleInfoDisplay;
import flixel.FlxGame;
import openfl.display.Sprite;
import flixel.FlxG;
import openfl.display.BlendMode;
import openfl.text.TextFormat;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxState;
import openfl.Assets;
import openfl.Lib;
import openfl.display.FPS;
import openfl.display.Sprite;
import openfl.events.Event;
import utilities.ImageOutline;
import openfl.display.Bitmap;

class Main extends Sprite 
{
	public static var bitmapFPS:Bitmap;
	public static var instance:Main;
	var fpsCounter:SimpleInfoDisplay;

	public function new() 
	{
		instance = this;

		super();

		CoolUtil.haxe_trace = haxe.Log.trace;
		haxe.Log.trace = CoolUtil.haxe_print;
			
		addChild(new FlxGame(0, 0, SplashScreenState, 60, 60, true));

		var resolutionDebug:Array<String> = CoolUtil.coolTextFile(Paths.txt("debug/resolution"));

		stage.width = Std.parseFloat(resolutionDebug[0]);
		stage.height = Std.parseFloat(resolutionDebug[1]);
		FlxG.game.soundTray.volumeDownSound = Paths.sound("menu/volumeDown", "preload");
		FlxG.game.soundTray.volumeUpSound = Paths.sound("menu/volumeUp", "preload");

		#if !mobile
		fpsCounter = new SimpleInfoDisplay(10, 3, 0xFFFFFF);
		bitmapFPS = ImageOutline.renderImage(fpsCounter, 1, 0x000000, true);
		bitmapFPS.smoothing = true;
		addChild(fpsCounter);
		#end
	}

	public static function dumpCache()
	{
		@:privateAccess
		for (key in FlxG.bitmap._cache.keys())
		{
			var obj = FlxG.bitmap._cache.get(key);
			
			if (obj != null)
			{
				Assets.cache.removeBitmapData(key);
				FlxG.bitmap._cache.remove(key);
				obj.destroy();
			}
		}
		
		Assets.cache.clear("songs");
	}

	public static var display:SimpleInfoDisplay;
}
