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
    public static var achievementsMap:Map<String, Bool> = new Map<String, Bool>();

    public static function load() {
        if (FlxG.save.data.achievementsMap != null)
			achievementsMap = FlxG.save.data.achievementsMap;

        var path:String = Paths.txt('achievements/achList.txt');
        if (FileSystem.exists(path)) {
			var listContent:String = File.getContent(path);
			var achievementsFound:Array<String> = listContent.split('\n');

			for (achievement in achievementsFound) {
				Json.parse(File.getContent(Paths.json('achievements/' + achievement)));
                trace("achievement " + achievement + " loaded");
			}
		}
    }

    public static function unlock(ach:String) {
        if (!isUnlocked(ach)) {
            achievementsMap.set(ach, true);
            FlxG.save.data.achievementsMap = achievementsMap;
            FlxG.save.flush();
            trace('achievement earned: $ach!');
        }
    }

    public static function isUnlocked(ach:String):Bool {
        return achievementsMap.exists(ach);
    }

    public static function forget(ach:String) {
        if (isUnlocked(ach)) {
            achievementsMap.remove(ach);
            FlxG.save.data.achievementsMap = achievementsMap;
            FlxG.save.flush();
            trace('achievement $ach removed!');
        }
    }

    public function showAchievement(ach:String) {
        // to-do: show the achievement idk
    }
}