package;

class InitialState extends FlxState { // so that the achievements won't clone for some reason
    override function create() {
        super.create();

        Achievements.load();
        FlxG.switchState(new PlayState());
    }
}