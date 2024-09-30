package;

typedef AchievementData = {
    public var name:String;
    public var desc:String;
    public var hint:String;
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
        try {
            if (FileSystem.exists(path)) {
			    var listContent:String = File.getContent(path);
			    var achievementsFound:Array<String> = listContent.split('\n');

			    for (achievement in achievementsFound) {
                    achievements.push(achievement.trim());
				    Json.parse(File.getContent(Paths.json('achievements/' + achievement.trim())));
                    trace("achievement " + achievement + " loaded");
			    }
		    }
        } catch (e:Dynamic) {
            trace(e);
        }
    }

    public static function unlock(ach:String, stats:AchievementStats, onFinish:Void->Void) {
        if (!isUnlocked(ach)) {
            showAchievement(ach, onFinish);

            achievementsMap.set(ach, true);
            achievementStatsMap.set(ach, stats);
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

    public static function showAchievement(ach:String, onFinish:Void->Void) {
        var sprGroup:FlxSpriteGroup = new FlxSpriteGroup();
        var coolAchieve:AchievementData = cast Json.parse(File.getContent(Paths.json('achievements/' + ach)));
        var where = FlxG.state.subState != null ? FlxG.state.subState : FlxG.state;

        var achBG:FlxSprite = new FlxSprite(60, 50).makeGraphic(420, 120, FlxColor.BLACK);
        sprGroup.add(achBG);

        var achIcon:FlxSprite = new FlxSprite(achBG.x + 10, achBG.y + 10); // placeholder for now
        achIcon.makeGraphic(150, 150, FlxColor.YELLOW);
        sprGroup.add(achIcon);

        var achName:FlxText = new FlxText(achIcon.x + achIcon.width + 20, achIcon.y + 16, 280, coolAchieve.name, 16);
		achName.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, LEFT);
        sprGroup.add(achName);

		var achTxt:FlxText = new FlxText(achName.x, achName.y + 32, 280, coolAchieve.desc, 16);
		achTxt.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, LEFT);
		sprGroup.add(achTxt);

        var flash = new FlxSprite().makeGraphic(Std.int(sprGroup.width), Std.int(sprGroup.height), FlxColor.WHITE);
		sprGroup.add(flash);

        where.add(sprGroup);

        FlxTween.tween(flash, {alpha: 0}, 0.65, {
			onComplete: (twn:FlxTween) -> {
				sprGroup.remove(flash);
			}
		});

        new FlxTimer().start(2.5, function(tmr:FlxTimer) {
            FlxTween.tween(sprGroup, {alpha: 0}, 1, {
			    onComplete: function(twn:FlxTween)  {
				    sprGroup.kill();
				    sprGroup.destroy();
			    }
		    });

            if (onFinish != null)
                onFinish();
        });
    }
}