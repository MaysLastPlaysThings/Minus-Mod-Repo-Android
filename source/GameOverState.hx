package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.input.gamepad.FlxGamepad;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;

class GameOverState extends FlxTransitionableState
{
	var bfX:Float = 0;
	var bfY:Float = 0;
	var bf:Boyfriend;
	var stageSuffix:String = "";

	public function new(x:Float, y:Float)
	{
		super();

		bfX = x;
		bfY = y;
	}

	override function create()
	{
		/* var loser:FlxSprite = new FlxSprite(100, 100);
			var loseTex = FlxAtlasFrames.fromSparrow(AssetPaths.lose.png, AssetPaths.lose.xml);
			loser.frames = loseTex;
			loser.animation.addByPrefix('lose', 'lose', 24, false);
			loser.animation.play('lose');
			// add(loser); */

		bf = new Boyfriend(bfX, bfY);
		// bf.scrollFactor.set();
		add(bf);
		bf.playAnim('firstDeath');

		FlxG.camera.follow(bf, LOCKON, 0.001);
		/* 
			var restart:FlxSprite = new FlxSprite(500, 50).loadGraphic(AssetPaths.restart.png);
			restart.setGraphicSize(Std.int(restart.width * 0.6));
			restart.updateHitbox();
			restart.alpha = 0;
			restart.antialiasing = true;
			// add(restart); */

		FlxG.sound.music.fadeOut(2, FlxG.sound.music.volume * 0.6);

		// FlxTween.tween(restart, {alpha: 1}, 1, {ease: FlxEase.quartInOut});
		// FlxTween.tween(restart, {y: restart.y + 40}, 7, {ease: FlxEase.quartInOut, type: PINGPONG});

		super.create();
	}

	private var fading:Bool = false;

	override function update(elapsed:Float)
	{
		var pressed:Bool = FlxG.keys.justPressed.ANY;

		#if mobile
		for (touch in FlxG.touches.list)
		{
			if (touch.justPressed)
			{
				pressedEnter = true;
			}
		}
		#end

		var pressedEnter:Bool = FlxG.keys.justPressed.ENTER;

		if (pressedEnter)
		{
			endBullshit();
		}

		if (#if android FlxG.android.justReleased.BACK #else controls.BACK #end)
		{
			FlxG.sound.music.stop();

			if (PlayState.isStoryMode)
				FlxG.switchState(new StoryMenuState());
			else
				FlxG.switchState(new FreeplayState());
		}

		var gamepad:FlxGamepad = FlxG.gamepads.lastActive;

		if (gamepad != null)
		{
			if (gamepad.justPressed.ANY)
				pressed = true;
		}

		pressed = false;

		if (pressed && !fading)
		{
			fading = true;
			FlxG.sound.music.fadeOut(0.5, 0, function(twn:FlxTween)
			{
				FlxG.sound.music.stop();
				FlxG.switchState(new PlayState());
			});
		}
		super.update(elapsed);
	}

		var isEnding:Bool = false;

	function endBullshit():Void
	{
		if (!isEnding)
		{
			isEnding = true;
			bf.playAnim('deathConfirm', true);
			FlxG.sound.music.stop();
			FlxG.sound.play('assets/music/gameOverEnd' + stageSuffix + TitleState.soundExt);
			new FlxTimer().start(0.7, function(tmr:FlxTimer)
			{
				FlxG.camera.fade(FlxColor.BLACK, 2, false, function()
				{
					FlxG.switchState(new PlayState());
				});
			});
		}
	}
}
