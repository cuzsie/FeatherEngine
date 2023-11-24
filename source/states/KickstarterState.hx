package states;

import flixel.FlxG;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;

class KickstarterState extends MusicBeatState
{
    override function create()
    {
        super.create();

        FlxG.sound.music.stop();

        #if VIDEOS_ALLOWED
		var video_handler:VideoHandler = new VideoHandler();

		video_handler.finishCallback = () -> {
			onVideoEnd();
            videoEnded = true;
		};

		video_handler.playVideo(Paths.video("kickstarterTrailer", "mp4"));
		#else
		FlxG.switchState(new MainMenuState());
		#end
    }
    
    override function update(elapsed:Float)
    {
        super.update(elapsed);

        if (FlxG.keys.justPressed.ANY && !videoEnded)
        {
            videoEnded = true;
            onVideoEnd();
        }
    }

    private var videoEnded:Bool = false;

    function onVideoEnd()
    {
        FlxG.switchState(new MainMenuState());
    }
}