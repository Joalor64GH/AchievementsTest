package;

class Main extends openfl.display.Sprite {
	public final config:Dynamic = {
		dimensions: [1280, 720],
		framerate: 60,
		initialState: PlayState,
		skipSplash: false,
		startFullscreen: false
	};

	public function new() {
		super();
		addChild(new FlxGame(config.width, config.height, config.initialState, config.framerate, config.framerate,
			config.skipSplash, config.startFullscreen));
	}
}