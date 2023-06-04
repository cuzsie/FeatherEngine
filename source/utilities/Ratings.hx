package utilities;

import game.Conductor;
import states.PlayState;

class Ratings {
	private static var scores:Array<Dynamic> = [['marvelous', 400], ['sick', 350], ['good', 200], ['bad', 50], ['shit', -150]];

	public static function getRating(time:Float) {
		var judges = utilities.Options.getData("judgementTimings");

		var timings:Array<Array<Dynamic>> = [
			[judges[0], "marvelous"],
			[judges[1], "sick"],
			[judges[2], "good"],
			[judges[3], "bad"]
		];

		var rating:String = 'bruh';

		for (x in timings) {
			if (x[1] == "marvelous" && utilities.Options.getData("marvelousRatings") || x[1] != "marvelous") {
				if (time <= x[0] * PlayState.songMultiplier && rating == 'bruh') {
					rating = x[1];
				}
			}
		}

		if (rating == 'bruh')
			rating = "shit";

		return rating;
	}

	public static var timingPresets:Map<String, Array<Int>> = [];
	public static var presets:Array<String> = [];

	public static function returnPreset(name:String = "leather engine"):Array<Int> {
		if (timingPresets.exists(name))
			return timingPresets.get(name);

		return [25, 50, 70, 100];
	}

	public static function loadPresets() {
		presets = [];
		timingPresets = [];

		var timingPresetsArray = CoolUtil.coolTextFile(Paths.txt("timingPresets"));

		for (array in timingPresetsArray) {
			var values = array.split(",");

			timingPresets.set(values[0], [
				Std.parseInt(values[1]),
				Std.parseInt(values[2]),
				Std.parseInt(values[3]),
				Std.parseInt(values[4])
			]);
			presets.push(values[0]);
		}
	}

	public static function getRank(accuracy:Float, ?misses:Int):String
	{
		var conditions:Array<Bool>;

		conditions = 
		[
			accuracy == 100, // Perfect!!
			accuracy >= 90, // Sick!
			accuracy >= 80, // Great
			accuracy >= 70, // Good
			accuracy >= 69, // Nice
			accuracy >= 60, // Meh
			accuracy >= 50, // Bruh
			accuracy >= 40, // Bad
			accuracy >= 20, // Shit
			accuracy >= 0 // You Suck!
		];

		var ratingsArray:Array<Int> = [
			PlayState.instance.ratings.get("marvelous"),
			PlayState.instance.ratings.get("sick"),
			PlayState.instance.ratings.get("good"),
			PlayState.instance.ratings.get("bad"),
			PlayState.instance.ratings.get("shit")
		];

		for (condition in 0...conditions.length) 
		{
			var rating_success = conditions[condition];

			if (rating_success)
			{
				switch (condition) 
				{
					case 0:
						return "Perfect!!";
					case 1:
						return "Sick!" ;
					case 2:
						return "Great" ;
					case 3:
						return "Good" ;
					case 4:
						return "Nice" ;
					case 5:
						return "Meh.." ;
					case 6:
						return "Bruh..." ;
					case 7:
						return "Bad..." ;
					case 8:
						return "Shit..." ;
					case 9:
						return "You Suck!" ;
					default:
						return "";
				}
			}
		}

		return "";
	}

	public static function getScore(rating:String) {
		var score:Int = 0;

		for (x in scores) {
			if (rating == x[0]) {
				score = x[1];
			}
		}

		return score;
	}
}
