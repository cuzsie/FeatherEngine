package states;

import flixel.addons.display.FlxBackdrop;
import utilities.Options;
import utilities.CoolUtil;
import substates.UISkinSelect;
import substates.ControlMenuSubstate;
import modding.CharacterCreationState;
import utilities.MusicUtilities;
import ui.Option;
import ui.Checkbox;
import flixel.FlxState;
import flixel.group.FlxGroup;
import debuggers.ChartingState;
import debuggers.StageMakingState;
import flixel.system.FlxSound;
import debuggers.AnimationDebug;
import utilities.Controls.Control;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;
import ui.Alphabet;
import game.Song;
import debuggers.StageMakingState;
import game.Highscore;
import openfl.utils.Assets as OpenFLAssets;
import debuggers.ChartingStateDev;

class OptionsMenu extends MusicBeatState {
	var curSelected:Int = 0;
	var ui_Skin:Null<String>;

	public static var inMenu = false;

	public var pages:Map<String, Array<Dynamic>> = [
		"Categories" => [
			new PageOption("Gameplay", 0, "Gameplay"),
			new PageOption("Graphics", 1, "Graphics"),
			new PageOption("Modding", 2, "Tools"),
			new PageOption("Game Modifiers", 3, "Modifiers"),
			new PageOption("Misc", 4, "Misc")
		],
		"Gameplay" => [
			new PageOption("Back", 0, "Categories"),
			new GameSubstateOption("Binds", 1, substates.ControlMenuSubstate),
			new BoolOption("Key Bind Reminders", "extraKeyReminders", 2),
			new GameSubstateOption("Song Offset", 2, substates.SongOffsetMenu),
			new PageOption("Judgements", 3, "Judgements"),
			new PageOption("Input Options", 4, "Input Options"),
			new BoolOption("Downscroll", "downscroll", 4),
			new BoolOption("Middlescroll", "middlescroll", 5),
			new BoolOption("Bot", "botplay", 8),
			new BoolOption("Quick Restart", "quickRestart", 9),
			new BoolOption("No Death", "noDeath", 10),
			new BoolOption("Use Custom Scrollspeed", "useCustomScrollSpeed", 11),
			new GameSubstateOption("Custom Scroll Speed", 12, substates.ScrollSpeedMenu),
			new StringSaveOption("Hitsound", CoolUtil.coolTextFile(Paths.txt("hitsoundList")), 13, "hitsound")
		],
		"Graphics" => [
			new PageOption("Back", 0, "Categories"),
			new PageOption("Note Options", 1, "Note Options"),
			new PageOption("Info Display", 2, "Info Display"),
			new PageOption("Optimizations", 3, "Optimizations"),
			new GameSubstateOption("Max FPS", 4, substates.MaxFPSMenu),
			new BoolOption("Bigger Score Text", "biggerScoreInfo", 5),
			new BoolOption("Bigger Info Text", "biggerInfoText", 6),
			new StringSaveOption("Time Bar Style", ["leather engine", "psych engine", "old kade engine"], 7, "timeBarStyle"),
			new PageOption("Screen Effects", 8, "Screen Effects")
		],
		"Tools" => [
			new PageOption("Back", 0, "Categories"),
			new GameStateOption("Charter", 1, new ChartingState()),
			#if debug
			new GameStateOption("Charter Dev", 1, new ChartingStateDev()),
			#end
			new GameStateOption("Animation Debug", 2, new AnimationDebug("dad")),
			new GameStateOption("Stage Editor", 3, new StageMakingState("stage")),
			#if MODCHARTING_TOOLS
			new GameStateOption("Modchart Editor", 4, new modcharting.ModchartEditorState()),
			#end
			// new GameStateOption("Character Creator", 4, new CharacterCreationState("bf")),
			new GameSubstateOption("Import Old Scores", 5, substates.ImportHighscoresSubstate)
		],
		"Misc" => [
			new PageOption("Back", 0, "Categories"),
			new BoolOption("Prototype Title Screen", "oldTitle", 1),
			new BoolOption("Freeplay Music", "freeplayMusic", 4),
			#if discord_rpc
			new BoolOption("Discord Presence", "discordRPC", 5),
			#end
			new StringSaveOption("Cutscenes Play On", ["story", "freeplay", "both"], 6, "cutscenePlaysOn"),
			new BoolOption("Disable Debug Menus", "disableDebugMenus", 10),
			new BoolOption("Auto Pause", "autoPause", 12),
			new BoolOption("Skip Results", "skipResultsScreen", 15),
			new BoolOption("Show Score", "showScore", 16),
		],
		"Modifiers" => [
			new PageOption("Back", 0, "Categories"),
			new StringSaveOption("Play As", ["bf", "opponent"], 1, "playAs"),
			new BoolOption("Invisible Notes", "invisibleNotes", 2)
		],
		"Optimizations" => [
			new PageOption("Back", 0, "Graphics"),
			new BoolOption("Antialiasing", "antialiasing", 1),
			new BoolOption("Health Icons", "healthIcons", 2),
			new BoolOption("Health Bar", "healthBar", 3),
			new BoolOption("Ratings and Combo", "ratingsAndCombo", 3),
			new BoolOption("Chars And BGs", "charsAndBGs", 3),
			new BoolOption("Menu Backgrounds", "menuBGs", 4),
			new BoolOption("Optimized Characters", "optimizedChars", 5),
			new BoolOption("Animated Backgrounds", "animatedBGs", 6),
			new BoolOption("Preload Stage Events", "preloadChangeBGs", 7),
			new BoolOption("Memory Leaks", "memoryLeaks", 8),
		],
		"Judgements" => [
			new PageOption("Back", 0, "Gameplay"),
			new GameSubstateOption("Timings", 1, substates.JudgementMenu),
			new StringSaveOption("Rating Mode", ["psych", "simple", "complex"], 2, "ratingType"),
			new BoolOption("Marvelous Ratings", "marvelousRatings", 3),
			new BoolOption("Show Rating Count", "sideRatings", 4)
		],
		"Input Options" => [
			new PageOption("Back", 0, "Gameplay"),
			new StringSaveOption("Input Mode", ["standard", "rhythm"], 3, "inputSystem"),
			new BoolOption("Anti Mash", "antiMash", 4),
			new BoolOption("Shit gives Miss", "missOnShit", 5),
			new BoolOption("Ghost Tapping", "ghostTapping", 9),
			new BoolOption("Gain Misses on Sustains", "missOnHeldNotes", 10),
			new BoolOption("No Miss", "noHit", 6),
			new BoolOption("Reset Button", "resetButton", 7)
		],
		"Note Options" => [
			new PageOption("Back", 0, "Graphics"),
			new GameSubstateOption("Note BG Alpha", 1, substates.NoteBGAlphaMenu),
			new BoolOption("Enemy Note Glow", "enemyStrumsGlow", 2),
			new BoolOption("Player Note Splashes", "playerNoteSplashes", 3),
			new BoolOption("Enemy Note Splashes", "opponentNoteSplashes", 3),
			new BoolOption("Note Accuracy Text", "displayMs", 4),
			new GameSubstateOption("Note Colors", 5, substates.NoteColorSubstate),
			new GameSubstateOption("UI Skin", 6, substates.UISkinSelect)
		],
		"Screen Effects" => [
			new PageOption("Back", 0, "Graphics"),
			new BoolOption("Camera Tracks Direction", "cameraTracksDirections", 1),
			new BoolOption("Camera Bounce", "cameraZooms", 2),
			new BoolOption("Flashing Lights", "flashingLights", 3),
			new BoolOption("Screen Shake", "screenShakes", 4)
		]
	];

	public var page:FlxTypedGroup<Option> = new FlxTypedGroup<Option>();
	public static var instance:OptionsMenu;
	public static var lastState:FlxState;

	override function create():Void 
	{
		super.create();
		
		if (ui_Skin == null || ui_Skin == "default")
			ui_Skin = Options.getData("uiSkin");

		if (PlayState.instance == null) {
			pages["Tools"][1] = null;
			#if debug
			pages["Tools"][2] = null;
			#end
		}

		MusicBeatState.windowNameSuffix = "";
		instance = this;

		var bg:FlxSprite = new FlxSprite(-600, -200);
		bg.loadGraphic(Paths.image("stage/stageback", "stages"));
		bg.scrollFactor.set(0.9, 0.9);
		add(bg);

		var stageFront:FlxSprite = new FlxSprite(-650, 600);
		stageFront.loadGraphic(Paths.image("stage/stagefront", "stages"));
		stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
		stageFront.scrollFactor.set(1, 1);
		stageFront.updateHitbox();
		add(stageFront);

		bgScroller = new FlxBackdrop(Paths.image("endChecker", "preload"));
		add(bgScroller);

		add(page);

		LoadPage("Categories");

		if (FlxG.sound.music == null)
			FlxG.sound.playMusic(MusicUtilities.GetOptionsMenuMusic(), 0.7, true);

		FlxG.camera.zoom = 0.9;
	}

	var bgScroller:FlxBackdrop;
	public var curPageName:String = "";

	public static function LoadPage(Page_Name:String):Void {
		inMenu = true;
		instance.curSelected = 0;

		var curPage:FlxTypedGroup<Option> = instance.page;
		curPage.clear();

		for (x in instance.pages.get(Page_Name).copy()) {
			curPage.add(x);

			instance.curPageName = Page_Name;
		}

		inMenu = false;
		var bruh:Int = 0;

		for (x in instance.page.members) {
			x.Alphabet_Text.targetY = bruh - instance.curSelected;
			bruh++;
		}
	}

	override function update(elapsed:Float) {
		super.update(elapsed);

		bgScroller.x -= 0.3;
		bgScroller.y -= 0.4;

		if (!inMenu) {
			if (-1 * Math.floor(FlxG.mouse.wheel) != 0) {
				curSelected -= 1 * Math.floor(FlxG.mouse.wheel);
				FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
			}

			if (controls.UP_P) {
				curSelected -= 1;
				FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
			}

			if (controls.DOWN_P) {
				curSelected += 1;
				FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
			}

			if (controls.BACK)
			{
				if (curPageName != "Categories")
					LoadPage("Categories");
				else
					FlxG.switchState(OptionsMenu.lastState);
			}
		} 
		else 
		{
			if (controls.BACK)
				inMenu = false;
		}

		if (curSelected < 0)
			curSelected = page.length - 1;

		if (curSelected >= page.length)
			curSelected = 0;

		var bruh = 0;

		for (x in page.members) {
			x.Alphabet_Text.targetY = bruh - curSelected;
			bruh++;
		}

		for (x in page.members) {
			if (x.Alphabet_Text.targetY != 0) {
				for (item in x.members) {
					item.alpha = 0.6;
				}
			} else {
				for (item in x.members) {
					item.alpha = 1;
				}
			}
		}
	}
}
