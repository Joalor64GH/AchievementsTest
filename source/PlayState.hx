package;

class PlayState extends FlxState
{
	override public function create()
	{
		super.create();

		add(new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.WHITE));

		Achievements.load();

		var text = new FlxText(0, 0, 0, "Hello World", 64);
		text.color = FlxColor.BLACK;
		text.screenCenter();
		add(text);
	}

	override public function update(elapsed:Float)
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
	}
}