package;

typedef AchievementData = {
    public var name:String;
    public var desc:String;
    public var hint:String;
    public var save_tag:String;
    public var hidden:Bool;
}

typedef AchievementStats = {
    public var date:Date;
}

class Achievements {
    public static var achievements:Array<String> = [];

    public static var achievementsMap:Map<String, Bool> = new Map();
    public static var achievementStatsMap:Map<String, AchievementStats> = new Map();

    public static function load() {
        if (FlxG.save.data.achievementsMap != null)
			achievementsMap = FlxG.save.data.achievementsMap;
        if (FlxG.save.data.achievementStatsMap != null)
			achievementStatsMap = FlxG.save.data.achievementStatsMap;

        FlxG.save.flush();

        var path:String = Paths.txt('achievements/achList');
        if (FileSystem.exists(path)) {
			var listContent:String = File.getContent(path);
			var achievementsFound:Array<String> = listContent.split('\n');

			for (achievement in achievementsFound) {
                achievements.push(achievement.trim());
				Json.parse(File.getContent(Paths.json('achievements/' + achievement)));
                trace("achievement " + achievement + " loaded");
			}
		}
    }

    public static function unlock(ach:String, stats:AchievementStats, onFinish:Void->Void) {
        if (!isUnlocked(ach)) {
            showAchievement(ach, onFinish);

            achievementsMap.set(ach, true);
            achievementStatsMap.set(name, stats);
            FlxG.save.data.achievementsMap = achievementsMap;
            FlxG.save.flush();

            trace('achievement earned: $ach!\nmore info:\n $stats');
        }
    }

    public static function isUnlocked(ach:String):Bool {
        return achievementsMap.exists(ach) && achievementsMap.get(ach);
    }

    public static function forget(ach:String) {
        if (isUnlocked(ach)) {
            achievementsMap.remove(ach);
            achievementStatsMap.remove(ach);
            FlxG.save.data.achievementsMap = achievementsMap;
            FlxG.save.flush();
            trace('achievement $ach removed!');
        }
    }

    public function showAchievement(ach:String, onFinish:Void->Void) {
        var coolAchieve:AchievementData = cast Json.parse(File.getContent(Paths.json('achievements/' + ach)));

        var achBG:FlxSprite = new FlxSprite(60, 50).makeGraphic(420, 120, FlxColor.BLACK);
        achBG.alpha = 0;
        add(bg);

        var achIcon:FlxSprite = new FlxSprite(achBG.x + 10, achBG.y + 10); // placeholder for now
        achIcon.makeGraphic(Std.int(150 * (2 / 3)), 150, FlxColor.YELLOW);
        achIcon.alpha = 0;
        add(achIcon);

        var achName:FlxText = new FlxText(achIcon.x + achIcon.width + 20, achIcon.y + 16, 280, coolAchieve.name, 16);
		achName.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, LEFT);
        achName.alpha = 0;
        add(achName);

		var achTxt:FlxText = new FlxText(achName.x, achName.y + 32, 280, coolAchieve.desc, 16);
		achTxt.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, LEFT);
        achTxt.alpha = 0;
		add(achTxt);

        FlxTween.tween(achBG, {alpha: 0.65}, 1, {ease: FlxEase.quadOut});
        FlxTween.tween(achIcon, {alpha: 1}, 1, {ease: FlxEase.quadOut});
        FlxTween.tween(achName, {alpha: 1}, 1, {ease: FlxEase.quadOut});
        FlxTween.tween(achTxt, {alpha: 1}, 1, {ease: FlxEase.quadOut});

        new FlxTimer().start(2.5, function(tmr:FlxTimer) {
            FlxTween.tween(achBG, {alpha: 0}, 1, {ease: FlxEase.quadOut, onComplete: (twn:FlxTween) -> {
                achBG.kill();
            }});
            FlxTween.tween(achIcon, {alpha: 0}, 1, {ease: FlxEase.quadOut, onComplete: (twn:FlxTween) -> {
                achIcon.kill();
            }});
            FlxTween.tween(achName, {alpha: 0}, 1, {ease: FlxEase.quadOut, onComplete: (twn:FlxTween) -> {
                achName.kill();
            }});
            FlxTween.tween(achTxt, {alpha: 0}, 1, {ease: FlxEase.quadOut, onComplete: (twn:FlxTween) -> {
                achTxt.kill();
            }});

            if (onFinish != null)
                onFinish();
        });
    }
}