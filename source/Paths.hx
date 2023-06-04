package;

import lime.utils.Assets;
import flixel.FlxG;
import flixel.graphics.frames.FlxAtlasFrames;
import openfl.utils.AssetType;
import openfl.utils.Assets as OpenFlAssets;

class Paths 
{
	// File extentions to exclude if the game is not running on sys
	inline public static var SOUND_EXT = #if web "mp3" #else "ogg" #end;
	inline public static var VIDEO_EXT = "mp4";

	// Current level of asset loading (preload, shared)
	static var currentLevel:String = "preload";

	// Change the current level of asset loading
	inline static public function setCurrentLevel(name:String):Void
		currentLevel = name.toLowerCase();


	// Get general path
	static function getPath(file:String, type:AssetType, library:Null<String>):String 
	{
		// Get library if given library exists
		if (library != null)
			return getLibraryPath(file, library);

		// Change current asset loading level if it exists
		if (currentLevel != null) 
		{
			var levelPath = getLibraryPathForce(file, currentLevel);

			if (OpenFlAssets.exists(levelPath, type))
				return levelPath;

			levelPath = getLibraryPathForce(file, "shared");

			if (OpenFlAssets.exists(levelPath, type))
				return levelPath;
		}

		return getPreloadPath(file);
	}

	// Get library path (preload, shared)
	static public function getLibraryPath(file:String, library = "preload"):String
		return if (library == "preload" || library == "default") getPreloadPath(file); else getLibraryPathForce(file, library);

	// Force game to get library path (preload, shared)
	inline static function getLibraryPathForce(file:String, library:String):String
		return '$library:assets/$library/$file';

	// Get preload path ("assets/" in built, "assets/preload/" in source)
	inline static function getPreloadPath(file:String):String
		return 'assets/$file';

	// Get lua path ("data/*.lua")
	inline static public function lua(key:String, ?library:String):String
		return getPath('data/$key.lua', TEXT, library);

	// Get Haxe script path ("*.hx")
	inline static public function hx(key:String, ?library:String):String
		return getPath('$key.hx', TEXT, library);

	// Get general file path
	inline static public function file(file:String, type:AssetType = TEXT, ?library:String):String
		return getPath(file, type, library);

	// Get text file path ("data/*.txt")
	inline static public function txt(key:String, ?library:String):String
		return getPath('data/$key.txt', TEXT, library);

	// Get XML file path ("data/*.xml")
	inline static public function xml(key:String, ?library:String):String
		return getPath('data/$key.xml', TEXT, library);

	// Get JSON file path ("data/*.json")
	inline static public function json(key:String, ?library:String):String
		return getPath('data/$key.json', TEXT, library);

	// Get song chart file path ("songs/*.funkin")
	inline static public function chart(key:String):String
		return 'songs:assets/songs/$key.funkin';

	// Get video path ("videos/*.mp4")
	static public function video(key:String, ?ext:String = VIDEO_EXT):String
		return 'assets/videos/$key.$ext';

	// Get sound file path ("sounds/*.ogg" if sys, "sounds/*.mp3" if web)
	static public function sound(key:String, ?library:String):String
		return getPath('sounds/$key.$SOUND_EXT', SOUND, library);

	// Get random sound file path (random file from "sounds/*.ogg" if sys, "sounds/*.mp3" if web)
	inline static public function soundRandom(key:String, min:Int, max:Int, ?library:String):String
		return sound(key + FlxG.random.int(min, max), library);

	// Get music file path ("music/*.ogg" if sys, "music/*.mp3" if web)
	inline static public function music(key:String, ?library:String):String
		return getPath('music/$key.$SOUND_EXT', MUSIC, library);

	// Get image path ("images/*.png")
	inline static public function image(key:String, ?library:String):String
		return getPath('images/$key.png', IMAGE, library);

	// Get font path ("fonts/*")
	inline static public function font(key:String):String
		return 'assets/fonts/$key';

	// Get song vocal path ("songs/*/Voices.ogg" if sys, "songs/*/Voices.mp3" if web)
	static public function voices(song:String, ?difficulty:String):String 
	{
		if (difficulty != null) 
		{
			if (Assets.exists('songs:assets/songs/${song.toLowerCase()}/Voices-$difficulty.$SOUND_EXT'))
				return 'songs:assets/songs/${song.toLowerCase()}/Voices-$difficulty.$SOUND_EXT';
		}

		return 'songs:assets/songs/${song.toLowerCase()}/Voices.$SOUND_EXT';
	}

	// Get song insturmental path ("songs/*/Inst.ogg" if sys, "songs/*/Inst.mp3" if web)
	static public function inst(song:String, ?difficulty:String):String {
		if (difficulty != null) 
		{
			if (Assets.exists('songs:assets/songs/${song.toLowerCase()}/Inst-$difficulty.$SOUND_EXT'))
				return 'songs:assets/songs/${song.toLowerCase()}/Inst-$difficulty.$SOUND_EXT';
		}

		return 'songs:assets/songs/${song.toLowerCase()}/Inst.$SOUND_EXT';
	}
	
	// Get song events path ("songs/*/events.json")
	static public function songEvents(song:String, ?difficulty:String):String 
	{
		if (difficulty != null) 
		{
			if (Assets.exists(Paths.json("song data/" + song.toLowerCase() + '/events-${difficulty.toLowerCase()}')))
				return Paths.json("song data/" + song.toLowerCase() + '/events-${difficulty.toLowerCase()}');
		}

		return Paths.json("song data/" + song.toLowerCase() + "/events");
	}

	// Get animated spritesheet path ("images/*.png" paired with "images/*.xml")
	inline static public function getSparrowAtlas(key:String, ?library:String):FlxAtlasFrames 
	{
		if (Assets.exists(file('images/$key.xml', library)))
			return FlxAtlasFrames.fromSparrow(image(key, library), file('images/$key.xml', library));
		else
			return FlxAtlasFrames.fromSparrow(image("Bind_Menu_Assets", "preload"), file('images/Bind_Menu_Assets.xml', "preload"));
	}

	// Get packed spritesheet path ("images/*.png" paired with "images/*.txt")
	inline static public function getPackerAtlas(key:String, ?library:String):FlxAtlasFrames 
	{
		if (Assets.exists(file('images/$key.txt', library)))
			return FlxAtlasFrames.fromSpriteSheetPacker(image(key, library), file('images/$key.txt', library));
		else
			return FlxAtlasFrames.fromSparrow(image("Bind_Menu_Assets", "preload"), file('images/Bind_Menu_Assets.xml', "preload"));
	}
}
