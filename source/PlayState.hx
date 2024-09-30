package;

class PlayState extends FlxState
{
	override function create()
	{
		super.create();

		add(new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.GRAY));

		Achievements.load();

		var text = new FlxText(0, 0, 0, "Hello World", 64);
		text.screenCenter();
		add(text);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.keys.justPressed.U) {
			Achievements.unlock('example', {
				date: Date.now()
			}, () -> {
				trace("finished showing achievement");
			});
		} else if (FlxG.keys.justPressed.F)
			Achievements.forget('example');

		if (FlxG.keys.justPressed.H) {
			Achievements.unlock('hello', {
				date: Date.now()
			}, () -> {
				trace("finished showing achievement");
			});
		} else if (FlxG.keys.justPressed.B)
			Achievements.forget('hello');

		// if (FlxG.keys.justPressed.A)
			// FlxG.switchState(new AchievementsState());
	}
}