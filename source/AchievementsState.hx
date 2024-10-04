package;

import Achievements;

class AchievementsState extends FlxState {
    var achievementArray:Array<AchievementData> = [];
	var achievementGrp:FlxTypedGroup<FlxText>;
	var iconArray:Array<AchievementIcon> = [];
	var description:FlxText;
	var curSelected:Int = 0;

	var camFollow:FlxObject;

	override function create() {
		super.create();

		camFollow = new FlxObject(80, 0, 0, 0);
		camFollow.screenCenter(X);

		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.GRAY);
		bg.scrollFactor.set();
		bg.screenCenter();
		add(bg);

		achievementGrp = new FlxTypedGroup<FlxText>();
		add(achievementGrp);

        Achievements.load();

		for (i in 0...Achievements.achievements.length) {
            var achievementName = Achievements.achievements[i];
            var coolAchieve:AchievementData = cast Json.parse(File.getContent(Paths.json('achievements/' + achievementName)));
            
            if (coolAchieve != null && Achievements.achievementsMap.exists(coolAchieve.name.toLowerCase())) {
                achievementArray.push(coolAchieve);

                var text:FlxText = new FlxText(20, 60 + (i * 60), Achievements.isUnlocked(coolAchieve.name.toLowerCase()) ? coolAchieve.name : '???', 32);
                text.setFormat(Paths.font('vcr.ttf'), 60, FlxColor.WHITE, LEFT);
                text.ID = i;
                achievementGrp.add(text);

                var icon:AchievementIcon = new AchievementIcon(0, 0, coolAchieve.name.toLowerCase());
                icon.sprTracker = text;
                iconArray.push(icon);
                add(icon);
            }
        }

		description = new FlxText(0, FlxG.height * 0.1, FlxG.width * 0.9, '', 28);
		description.setFormat(Paths.font("vcr.ttf"), 28, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		description.screenCenter(X);
		description.scrollFactor.set();
		add(description);

		changeSelection();

		FlxG.camera.follow(camFollow, LOCKON, 0.25);
	}

	override function update(elapsed:Float) {
		super.update(elapsed);

		if (FlxG.keys.justPressed.UP || FlxG.keys.justPressed.DOWN)
			changeSelection(FlxG.keys.justPressed.UP ? -1 : 1);

		if (FlxG.keys.justPressed.ESCAPE)
			FlxG.switchState(new PlayState());
	}

	function changeSelection(change:Int = 0) {
		curSelected = FlxMath.wrap(curSelected + change, 0, achievementArray.length - 1);

		achievementGrp.forEach(function(txt:FlxText) {
			txt.alpha = (txt.ID == curSelected) ? 1 : 0.6;
			if (txt.ID == curSelected)
				camFollow.y = txt.y;
		});

		if (achievementArray[curSelected].desc != null || achievementArray[curSelected].hint != null) {
			description.text = Achievements.isUnlocked(achievementArray[curSelected].name.toLowerCase()) ? 
                achievementArray[curSelected].desc + '\nHint: ' + achievementArray[curSelected].hint : 
                    'This achievement has not been unlocked yet!' + '\nHint: ' + achievementArray[curSelected].hint;
			description.screenCenter(X);
		}
	}
}

class AchievementIcon extends FlxSprite {
	public var sprTracker:FlxSprite;

	public function new(x:Float, y:Float, ach:String) {
		super(x, y);

		if (Achievements.isUnlocked(ach))
			loadGraphic(Paths.image('achievements/' + ach));
		else
			loadGraphic(Paths.image('achievements/locked'));
		setGraphicSize(75, 75);
		scrollFactor.set();
		updateHitbox();
	}

	override function update(elapsed:Float) {
		super.update(elapsed);

		if (sprTracker != null) {
			setPosition(sprTracker.x + sprTracker.width + 10, sprTracker.y);
			scrollFactor.set(sprTracker.scrollFactor.x, sprTracker.scrollFactor.y);
		}
	}
}