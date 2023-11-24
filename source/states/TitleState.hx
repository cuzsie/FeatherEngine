package states;

#if discord_rpc
import utilities.Discord.DiscordClient;
#end
import utilities.Options;
import utilities.NoteVariables;
import substates.OutdatedSubState;
import modding.PolymodHandler;
import utilities.SaveData;
import utilities.MusicUtilities;
import utilities.CoolUtil;
import game.Conductor;
import ui.Alphabet;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
import flixel.graphics.FlxGraphic;
import flixel.group.FlxGroup;
import flixel.input.gamepad.FlxGamepad;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.app.Application;
import openfl.Assets;
import flixel.math.FlxMath;

using StringTools;

class TitleState extends MusicBeatState {
	static var initialized:Bool = false;

	var blackScreen:FlxSprite;
	var credGroup:FlxGroup;
	var textGroup:FlxGroup;
	var ngSpr:FlxSprite;

	var defaultCamZoom:Float;

	var curWacky:Array<String> = [];

	var wackyImage:FlxSprite;

	static var firstTimeStarting:Bool = false;
	static var doneFlixelSplash:Bool = false;

	override public function create():Void 
	{
		MusicBeatState.windowNameSuffix = "";

		defaultCamZoom = FlxG.camera.zoom;

		// Initiate the discord RPC client
		#if discord_rpc
		if (!DiscordClient.started && utilities.Options.getData("discordRPC"))
			DiscordClient.initialize();

		Application.current.onExit.add(function(exitCode) 
		{
			DiscordClient.shutdown();

			for (key in Options.saves.keys()) 
			{
				if (key != null)
					Options.saves.get(key).close();
			}
		}, false, 100);
		#end

		if (!firstTimeStarting) {
			persistentUpdate = true;
			persistentDraw = true;

			FlxG.fixedTimestep = false;

			utilities.SaveData.init();

			#if polymod
			PolymodHandler.loadMods();
			#end

			MusicBeatState.windowNamePrefix = Assets.getText(Paths.txt("windowTitleBase", "preload"));

			if (utilities.Options.getData("flashingLights") == null)
				FlxG.switchState(new FlashingLightsMenu());

			curWacky = FlxG.random.getObject(getIntroTextShit());

			super.create();

			firstTimeStarting = true;
		}

		new FlxTimer().start(1, function(tmr:FlxTimer) startIntro());
	}

	var old_logo:FlxSprite;
	var old_logo_black:FlxSprite;

	var logoBl:FlxSprite;
	var gfDance:FlxSprite;
	var danceLeft:Bool = false;
	var titleText:FlxSprite;

	public static var version:String = "v0.3";

	public static var version_New:String = "v0.3";

	public static function playTitleMusic() {
		FlxG.sound.playMusic(Paths.music('freakyNightMenu'), 0);
	}

	function startIntro() {
		if (!initialized) {
			var diamond:FlxGraphic = FlxGraphic.fromClass(GraphicTransTileDiamond);
			diamond.persist = true;
			diamond.destroyOnNoUse = false;

			FlxTransitionableState.defaultTransIn = new TransitionData(FADE, FlxColor.BLACK, 1, new FlxPoint(0, -1), {asset: diamond, width: 32, height: 32},
				new FlxRect(-200, -200, FlxG.width * 1.4, FlxG.height * 1.4));
			FlxTransitionableState.defaultTransOut = new TransitionData(FADE, FlxColor.BLACK, 0.7, new FlxPoint(0, 1),
				{asset: diamond, width: 32, height: 32}, new FlxRect(-200, -200, FlxG.width * 1.4, FlxG.height * 1.4));

			transIn = FlxTransitionableState.defaultTransIn;
			transOut = FlxTransitionableState.defaultTransOut;

			if (utilities.Options.getData("oldTitle"))
				playTitleMusic();
			else 
			{
				playTitleMusic();
				Conductor.changeBPM(117);
			}

			FlxG.sound.music.fadeIn(4, 0, 0.7);
		}

		version = 'v${Assets.getText("version.txt")}';

		persistentUpdate = true;

		var bg:FlxSprite = new FlxSprite();

		if (utilities.Options.getData("oldTitle")) {
			bg.loadGraphic(Paths.image("title/stageback"));
			bg.antialiasing = true;
			bg.setGraphicSize(Std.int(FlxG.width * 1.1));
			bg.updateHitbox();
			bg.screenCenter();
		} else
			bg.makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);

		add(bg);

		gfDance = new FlxSprite(FlxG.width * 0.4, FlxG.height * 0.07);
		gfDance.frames = Paths.getSparrowAtlas('title/gfDanceTitle');
		gfDance.animation.addByIndices('danceLeft', 'gfDance', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
		gfDance.animation.addByIndices('danceRight', 'gfDance', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
		gfDance.antialiasing = true;

		if (utilities.Options.getData("oldTitle")) 
		{
			old_logo = new FlxSprite().loadGraphic(Paths.image('title/logo'));
			old_logo.screenCenter();
			old_logo.antialiasing = true;

			old_logo_black = new FlxSprite().loadGraphicFromSprite(old_logo);
			old_logo_black.screenCenter();
			old_logo_black.color = FlxColor.BLACK;
		} 
		else 
		{
			logoBl = new FlxSprite(0, 0);
				logoBl.frames = Paths.getSparrowAtlas('title/logoBumpin');

			logoBl.antialiasing = true;
			logoBl.animation.addByPrefix('bump', 'logo bumpin', 24);
			logoBl.animation.play('bump');
			logoBl.updateHitbox();
		}

		titleText = new FlxSprite(100, FlxG.height * 0.8);
		titleText.frames = Paths.getSparrowAtlas('title/titleEnter');
		titleText.animation.addByPrefix('idle', "Press Enter to Begin", 24);
		titleText.animation.addByPrefix('press', "ENTER PRESSED", 24);
		titleText.antialiasing = true;
		titleText.animation.play('idle');
		titleText.updateHitbox();

		if (!utilities.Options.getData("oldTitle")) {
			add(logoBl);
			add(gfDance);
			add(titleText);
		} else {
			add(old_logo_black);
			add(old_logo);

			FlxTween.tween(old_logo_black, {y: old_logo_black.y + 50}, 0.6, {ease: FlxEase.quadInOut, type: PINGPONG});
			FlxTween.tween(old_logo, {y: old_logo.y + 50}, 0.6, {ease: FlxEase.quadInOut, type: PINGPONG, startDelay: 0.1});
		}

		credGroup = new FlxGroup();
		add(credGroup);
		textGroup = new FlxGroup();

		blackScreen = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		credGroup.add(blackScreen);

		ngSpr = new FlxSprite(0, FlxG.height * 0.52).loadGraphic(Paths.image('title/polymod_logo'));
		add(ngSpr);
		ngSpr.visible = false;
		ngSpr.setGraphicSize(290); // aprox what newgrounds_logo.width * 0.8 was (289.6), only used cuz polymod_logo is different size than it lol!!!
		ngSpr.updateHitbox();
		ngSpr.screenCenter(X);
		ngSpr.antialiasing = true;

		FlxG.mouse.visible = false;
		
		titleTextData = CoolUtil.coolTextFile(Paths.txt("titleText", "preload"));

		if (initialized)
			skipIntro();
		else
			initialized = true;
	}

	function getIntroTextShit():Array<Array<String>> {
		var fullText:String = Assets.getText(Paths.txt('introText'));

		var firstArray:Array<String> = fullText.split('\n');
		var swagGoodArray:Array<Array<String>> = [];

		for (i in firstArray) {
			swagGoodArray.push(i.split('--'));
		}

		return swagGoodArray;
	}

	var transitioning:Bool = false;

	override function update(elapsed:Float) 
	{
		
		var camera_Zoom_Lerp = elapsed * 3;

		FlxG.camera.zoom = FlxMath.lerp(FlxG.camera.zoom, defaultCamZoom, camera_Zoom_Lerp);

		if (FlxG.sound.music != null)
			Conductor.songPosition = FlxG.sound.music.time;

		if (FlxG.keys.justPressed.F)
			FlxG.fullscreen = !FlxG.fullscreen;

		var pressedEnter:Bool = FlxG.keys.justPressed.ENTER;

		#if mobile
		for (touch in FlxG.touches.list) {
			if (touch.justPressed) {
				pressedEnter = true;
			}
		}
		#end

		var gamepad:FlxGamepad = FlxG.gamepads.lastActive;

		if (gamepad != null) {
			if (gamepad.justPressed.START)
				pressedEnter = true;

			#if switch
			if (gamepad.justPressed.B)
				pressedEnter = true;
			#end
		}

		if (pressedEnter && !transitioning && skippedIntro) {
			if (titleText != null)
				titleText.animation.play('press');

			if (utilities.Options.getData("flashingLights"))
				FlxG.camera.flash(FlxColor.WHITE, 1);

			if (utilities.Options.getData("oldTitle"))
				FlxG.sound.play(Paths.music("titleShoot"), 0.7);
			else
				FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);

			transitioning = true;

			new FlxTimer().start(2, function(tmr:FlxTimer) 
			{
				var http = new haxe.Http("https://raw.githubusercontent.com/Leather128/LeatherEngine/main/version.txt");

				http.onData = function(data:String) {
					trace(data, DEBUG);

					if (Assets.getText("version.txt") != data) {
						trace('Outdated Version Detected! ' + data + ' != ' + Assets.getText("version.txt"), WARNING);

						version_New = "v" + data;
						FlxG.switchState(new OutdatedSubState());
					} else
						FlxG.switchState(new MainMenuState());
				}

				http.onError = function(error) {
					trace('$error', ERROR);
					FlxG.switchState(new MainMenuState()); // fail so we go anyway
				}

				http.request();
			});
		}

		if (pressedEnter && !skippedIntro)
			skipIntro();

		super.update(elapsed);
	}

	function createCoolText(textArray:Array<String>) {
		for (i in 0...textArray.length) {
			addMoreText(textArray[i]);
		}
	}

	function addMoreText(text:String) {
		var coolText:Alphabet = new Alphabet(0, 0, text.toUpperCase(), true, false);
		coolText.screenCenter(X);
		coolText.y += (textGroup.length * 60) + 200;
		credGroup.add(coolText);
		textGroup.add(coolText);
	}

	function deleteCoolText() {
		while (textGroup.members.length > 0) {
			credGroup.remove(textGroup.members[0], true);
			textGroup.remove(textGroup.members[0], true);
		}
	}

	function textDataText(line:Int) {
		var lineText:Null<String> = titleTextData[line];

		if (lineText != null) {
			if (lineText.contains("~")) {
				var coolText = lineText.split("~");
				createCoolText(coolText);
			} else
				addMoreText(lineText);
		}
	}

	public var titleTextData:Array<String>;

	override function beatHit() 
	{
		super.beatHit();

		FlxG.camera.zoom += 0.015;

		if (!utilities.Options.getData("oldTitle")) {
			logoBl.animation.play('bump');
			danceLeft = !danceLeft;

			if (danceLeft)
				gfDance.animation.play('danceRight');
			else
				gfDance.animation.play('danceLeft');

			switch (curBeat) {
				case 1:
					textDataText(0);
				case 3:
					textDataText(1);
				case 4:
					deleteCoolText();
				case 5:
					textDataText(2);
				case 7:
					textDataText(3);
					ngSpr.visible = true;
				case 8:
					deleteCoolText();
					ngSpr.visible = false;
				case 9:
					createCoolText([curWacky[0]]);
				case 11:
					addMoreText(curWacky[1]);
				case 12:
					deleteCoolText();
				// yipee
				case 13 | 14 | 15:
					textDataText(4 + (curBeat - 13));
				case 16:
					skipIntro();
			}
		} else {
			remove(ngSpr);
			remove(credGroup);
			skippedIntro = true;
			MusicBeatState.windowNameSuffix = "";
		}
	}

	var skippedIntro:Bool = false;

	function skipIntro():Void {
		if (!skippedIntro) {
			MusicBeatState.windowNameSuffix = "";

			if (utilities.Options.getData("flashingLights"))
				FlxG.camera.flash(FlxColor.WHITE, 4);

			remove(ngSpr);
			remove(credGroup);
			skippedIntro = true;
		}
	}
}
