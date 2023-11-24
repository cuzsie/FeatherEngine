package states;

import game.Song;
import utilities.Options;
import flixel.util.FlxTimer;
import utilities.MusicUtilities;
import lime.utils.Assets;
#if discord_rpc
import utilities.Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import flixel.math.FlxMath;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import lime.app.Application;
import modding.PolymodHandler;

using StringTools;

class MainMenuState extends MusicBeatState
{
	static var curSelected:Int = 0;

	var menuItems:FlxTypedGroup<FlxSprite>;

	var optionShit:Array<String> = ['story mode', 'freeplay'];

	var magenta:FlxSprite;
	var camFollow:FlxObject;
	var ui_Skin:Null<String>;
	var bg:FlxSprite;

	var hue:Float = 0;

	override function create()
	{
		if (ui_Skin == null || ui_Skin == "default")
			ui_Skin = Options.getData("uiSkin");
		
		if(PolymodHandler.metadataArrays.length > 0)
			optionShit.push('mods');

		optionShit.push("options");

		
		MusicBeatState.windowNameSuffix = "";
		
		#if discord_rpc
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		if (FlxG.sound.music == null || FlxG.sound.music.playing != true)
			TitleState.playTitleMusic();

		persistentUpdate = persistentDraw = true;

		if(utilities.Options.getData("menuBGs"))
			if (!Assets.exists(Paths.image('ui skins/' + ui_Skin + '/backgrounds' + '/menuBG')))
				bg = new FlxSprite(-80).loadGraphic(Paths.image('ui skins/default/backgrounds/menuBG'));
			else
				bg = new FlxSprite(-80).loadGraphic(Paths.image('ui skins/' + ui_Skin + '/backgrounds' + '/menuBG'));
		else
			bg = new FlxSprite(-80).makeGraphic(1286, 730, FlxColor.fromString("#FDE871"), false, "optimizedMenuBG");

		bg.scrollFactor.x = 0;
		bg.scrollFactor.y = 0.18;
		bg.setGraphicSize(Std.int(bg.width * 1.3));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = true;
		add(bg);

		defaultBGX = bg.scale.x;
		defaultBGY = bg.scale.y;

		camFollow = new FlxObject(0, 0, 1, 1);
		add(camFollow);

		if(utilities.Options.getData("menuBGs"))
			if (!Assets.exists(Paths.image('ui skins/' + ui_Skin + '/backgrounds' + '/menuDesat')))
				magenta = new FlxSprite(-80).loadGraphic(Paths.image('ui skins/default/backgrounds/menuDesat'));
			else
				magenta = new FlxSprite(-80).loadGraphic(Paths.image('ui skins/' + ui_Skin + '/backgrounds' + '/menuDesat'));
		else
			magenta = new FlxSprite(-80).makeGraphic(1286, 730, FlxColor.fromString("#E1E1E1"), false, "optimizedMenuDesat");

		magenta.scrollFactor.x = 0;
		magenta.scrollFactor.y = 0.18;
		magenta.setGraphicSize(Std.int(magenta.width * 1.3));
		magenta.updateHitbox();
		magenta.screenCenter();
		magenta.visible = false;
		magenta.antialiasing = true;
		magenta.color = 0xFFfd719b;
		add(magenta);

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		for (i in 0...optionShit.length)
			{
				var menuItem:FlxSprite = new FlxSprite(0, 60 + (i * 160));
				if (!Assets.exists(Paths.image('ui skins/' + Options.getData("uiSkin") + '/' + 'buttons/'+ optionShit[i], 'preload')))
					menuItem.frames = Paths.getSparrowAtlas('ui skins/' + 'default' + '/' + 'buttons/'+ optionShit[i], 'preload');
				else
					menuItem.frames = Paths.getSparrowAtlas('ui skins/' + Options.getData("uiSkin") + '/' + 'buttons/'+ optionShit[i], 'preload');
				menuItem.animation.addByPrefix('idle', optionShit[i] + " basic", 24);
				menuItem.animation.addByPrefix('selected', optionShit[i] + " white", 24);
				menuItem.animation.play('idle');
				menuItem.ID = i;
				menuItem.screenCenter(X);
				menuItems.add(menuItem);
				menuItem.scrollFactor.set(0.5, 0.5);
				menuItem.antialiasing = true;
			}

		FlxG.camera.follow(camFollow, null, 0.06);

		var sysName:String = "";

		#if sys
		sysName = "(" + Sys.systemName() + ")";
		#end

		var versionShit:FlxText = new FlxText(5, FlxG.height - 25, 0, "Feather Engine " + TitleState.version + " " + sysName, 16);
		versionShit.scrollFactor.set();	
		versionShit.setFormat(Paths.font("game.ttf"), 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		versionShit.antialiasing = true;
		add(versionShit);

		changeItem();

		super.create();
	}

	var selectedSomethin:Bool = false;
	var defaultBGX:Float = 0;
	var defaultBGY:Float = 0;

	override function update(elapsed:Float)
	{
		FlxG.camera.followLerp = elapsed * 3.6;

		if (FlxG.sound.music.volume < 0.8)
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;

		// THIS DIDN'T LOOK GOOD LOLOL
		/*hue += elapsed * 25;

		if (hue > 360)
			hue -= 360;

		var color = FlxColor.fromHSB(Std.int(hue), 1, 1);
		bg.color = color;*/

		if (!selectedSomethin)
		{
			if(-1 * Math.floor(FlxG.mouse.wheel) != 0)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(-1 * Math.floor(FlxG.mouse.wheel));
			}

			if (controls.UP_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(-1);
			}

			if (controls.DOWN_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(1);
			}
			
			if (FlxG.keys.justPressed.SEVEN)
			{
				// VERSUS MODE DEBUG
				PlayState.SONG = Song.loadFromJson("hard", "dad battle");
				PlayState.isStoryMode = false;
				PlayState.storyDifficultyStr = "HARD";

				PlayState.storyWeek = 1;
				PlayState.versusMode = true;
			}

			if (controls.ACCEPT)
			{
				selectedSomethin = true;
				FlxG.sound.play(Paths.sound('confirmMenu'));

				if(utilities.Options.getData("flashingLights"))
					FlxFlicker.flicker(magenta, 1.1, 0.15, false);

				menuItems.forEach(function(spr:FlxSprite)
				{
					if (curSelected != spr.ID)
					{
						FlxTween.tween(spr, {alpha: 0}, 0.4, {
							ease: FlxEase.quadOut,
							onComplete: function(twn:FlxTween)
							{
								spr.kill();
							}
						});
					}
					else
					{
						if(utilities.Options.getData("flashingLights"))
						{
							FlxFlicker.flicker(spr, 1, 0.06, false, false, function(_) { fard(); });
						}
						else
							new FlxTimer().start(1, function(_) { fard(); }, 1);
					}
				});
			}
		}

		var camera_Zoom_Lerp = elapsed * 3;

		bg.scale.set(FlxMath.lerp(bg.scale.x, defaultBGX, camera_Zoom_Lerp), FlxMath.lerp(bg.scale.y, defaultBGY, camera_Zoom_Lerp));

		super.update(elapsed);

		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.screenCenter(X);
		});
	}

	override function beatHit() 
	{
		super.beatHit();
	
		bg.scale.add(0.2, 0.2);
		bg.scale.add(0.2, 0.2);
	}

	function fard()
	{
		var daChoice:String = optionShit[curSelected];
		
		switch (daChoice)
		{
			case 'story mode':
				FlxG.switchState(new StoryMenuState());
				trace("Story Menu Selected");

			case 'freeplay':
				FlxG.switchState(new FreeplayState());

				trace("Freeplay Menu Selected");

			case 'options':
				FlxTransitionableState.skipNextTransIn = true;
				FlxTransitionableState.skipNextTransOut = true;
				OptionsMenu.lastState = new MainMenuState();
				FlxG.switchState(new OptionsMenu());

			#if sys
			case 'mods':
				FlxG.switchState(new ModsMenu());
			#end
		}
	}

	function changeItem(huh:Int = 0)
	{
		curSelected += huh;

		if (curSelected >= menuItems.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = menuItems.length - 1;

		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.animation.play('idle');

			if (spr.ID == curSelected)
			{
				spr.animation.play('selected');
				camFollow.setPosition(FlxG.width / 2, spr.getGraphicMidpoint().y);
			}

			spr.updateHitbox();
		});
	}
}
