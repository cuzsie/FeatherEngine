package game;

import utilities.NoteVariables;
import flixel.FlxG;
import states.PlayState;
import flixel.FlxSprite;

class NoteSplash extends FlxSprite
{
    var target:FlxSprite;

    public function new(x:Float = 0, y:Float = 0, noteData:Int, target:FlxSprite) {
        super(x, y);

        this.target = target;

        alpha = 0.7;
        frames = PlayState.instance.splash_Texture;

        animation.addByPrefix("default", "note splash " + NoteVariables.Other_Note_Anim_Stuff[PlayState.SONG.keyCount - 1][noteData] + "0", 28, false);
        animation.play("default", true);

        setGraphicSize(Std.int(target.width * 2.5));
        updateHitbox();
    }

    override function update(elapsed:Float)
    {
        if(animation.curAnim.finished)
        {
            kill();
            alpha = 0;
        }
        
        x = target.x - (target.width / 1.35);
        y = target.y - (target.height / 1.35);

        color = target.color;
        
        flipX = target.flipX;
        flipY = target.flipY;

        angle = target.angle;

        super.update(elapsed);
    }
}