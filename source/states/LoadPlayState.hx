package states;

import lime.app.Promise;
import lime.app.Future;
import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.util.FlxTimer;
import flixel.addons.transition.FlxTransitionableState;

import openfl.utils.Assets;
import lime.utils.Assets as LimeAssets;
import lime.utils.AssetLibrary;
import lime.utils.AssetManifest;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.util.FlxColor;

import haxe.io.Path;

class LoadPlayState extends MusicBeatState
{	
	override function create()
	{
		MusicBeatState.windowNameSuffix = " is loading...";

		var realBG:FlxSprite = new FlxSprite();
		realBG.makeGraphic(1920, 1080, FlxColor.fromRGBFloat(79.2 / 100, 1, 30.2 / 100));
		realBG.screenCenter();
		add(realBG);

		var bg:FlxSprite = new FlxSprite(-150, -100);
		bg.loadGraphic(Paths.image("funkay", "preload"));
		bg.antialiasing = true;
		bg.screenCenter();
		bg.width = 1280;
		bg.height = 720;
		add(bg);

		FlxG.camera.zoom = 0.7;
		FlxG.camera.alpha = 0;

		FlxTween.tween(FlxG.camera, {alpha: 1}, 0.8);

		new FlxTimer().start(1.5, function(_) onLoad());
	}
	
	function onLoad()
	{
		FlxTransitionableState.skipNextTransIn = true;
		FlxTransitionableState.skipNextTransOut = true;
		FlxG.switchState(new PlayState());
	}
}