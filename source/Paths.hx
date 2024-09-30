package;

#if sys
import sys.FileSystem;
import sys.io.File;
#end
import flixel.FlxG;
import flixel.graphics.frames.FlxAtlasFrames;

class Paths
{
	inline public static final DEFAULT_FOLDER:String = 'assets';

	static public function getPath(folder:Null<String>, file:String)
	{
		if (folder == null)
			folder = DEFAULT_FOLDER;
		return folder + '/' + file;
	}

	static public function file(file:String, folder:String = DEFAULT_FOLDER)
	{
		if (#if sys FileSystem.exists(folder) && #end (folder != null && folder != DEFAULT_FOLDER))
		{
			return getPath(folder, file);
		}
		return getPath(null, file);
	}

	inline public static function getText(path:String):Array<String>
		return Assets.exists(path) ? [for (i in Assets.getText(path).trim().split('\n')) i.trim()] : [];

	inline static public function txt(key:String)
	{
		return file('$key.txt');
	}

	inline static public function xml(key:String)
	{
		return file('$key.xml');
	}

	inline static public function json(key:String)
	{
		return file('$key.json');
	}

	#if yaml
	inline static public function yaml(key:String)
	{
		return file('$key.yaml');
	}
	#end

	inline static public function sound(key:String)
	{
		return file('sounds/$key.ogg');
	}

	inline static public function soundRandom(key:String, min:Int, max:Int)
	{
		return file('sounds/$key${FlxG.random.int(min, max)}.ogg');
	}

	inline static public function music(key:String)
	{
		return file('music/$key.ogg');
	}

	inline static public function image(key:String)
	{
		return file('images/$key.png');
	}

	inline static public function font(key:String)
	{
		return file('fonts/$key');
	}

	inline static public function getSparrowAtlas(key:String)
	{
		return FlxAtlasFrames.fromSparrow(image(key), file('images/$key.xml'));
	}

	inline static public function getPackerAtlas(key:String)
	{
		return FlxAtlasFrames.fromSpriteSheetPacker(image(key), file('images/$key.txt'));
	}
}