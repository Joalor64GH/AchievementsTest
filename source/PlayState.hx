package;

class PlayState extends FlxState
{
	override public function create()
	{
		super.create();

		Achievements.load();

		var text = new FlxText(0, 0, 0, "Hello World", 64);
		text.screenCenter();
		add(text);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.keys.justPressed.U)
			Achievements.unlock('example');
		else if (FlxG.keys.justPressed.F)
			Achievements.forget('example');
	}
}
