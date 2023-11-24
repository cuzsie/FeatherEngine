package utilities;

import flixel.system.FlxSound;
import states.PlayState;
import flixel.FlxG;
import flixel.graphics.FlxGraphic;
import lime.utils.Assets;

class PreloadUtil
{
    // Load assets for PlayState
	public static function LoadPlayStateAssets(instance:PlayState)
    {
        new FlxSound().loadEmbedded(Paths.music('breakfast'));

		if (instance.hitSoundString != "none")
			instance.hitsound = FlxG.sound.load(Paths.sound("hitsounds/" + Std.string(instance.hitSoundString).toLowerCase()));

		for (i in 0...2) 
		{
			var sound = FlxG.sound.load(Paths.sound('missnote' + Std.string((i + 1))), 0.2);
			instance.missSounds.push(sound);
		}

        instance.uiMap.set("marvelous", FlxGraphic.fromAssetKey(Paths.image("ui skins/" + PlayState.SONG.ui_Skin + "/ratings/" + "marvelous")));
		instance.uiMap.set("sick", FlxGraphic.fromAssetKey(Paths.image("ui skins/" + PlayState.SONG.ui_Skin + "/ratings/" + "sick")));
		instance.uiMap.set("good", FlxGraphic.fromAssetKey(Paths.image("ui skins/" + PlayState.SONG.ui_Skin + "/ratings/" + "good")));
		instance.uiMap.set("bad", FlxGraphic.fromAssetKey(Paths.image("ui skins/" + PlayState.SONG.ui_Skin + "/ratings/" + "bad")));
		instance.uiMap.set("shit", FlxGraphic.fromAssetKey(Paths.image("ui skins/" + PlayState.SONG.ui_Skin + "/ratings/" + "shit")));

		for (i in 0...10)
			instance.uiMap.set(Std.string(i), FlxGraphic.fromAssetKey(Paths.image("ui skins/" + PlayState.SONG.ui_Skin + "/numbers/num" + Std.string(i))));

        if (Assets.exists(Paths.txt("ui skins/" + PlayState.SONG.ui_Skin + "/maniagap"))) instance.mania_gap = CoolUtil.coolTextFile(Paths.txt("ui skins/" + PlayState.SONG.ui_Skin + "/maniagap"));
		else instance.mania_gap = CoolUtil.coolTextFile(Paths.txt("ui skins/default/maniagap"));

		instance.types = CoolUtil.coolTextFile(Paths.txt("ui skins/" + PlayState.SONG.ui_Skin + "/types"));

		instance.arrow_Configs.set("default", CoolUtil.coolTextFile(Paths.txt("ui skins/" + PlayState.SONG.ui_Skin + "/default")));
		instance.type_Configs.set("default", CoolUtil.coolTextFile(Paths.txt("arrow types/default")));
    }
}