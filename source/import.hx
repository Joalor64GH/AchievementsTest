#if !macro
// Default Imports
import flixel.*;
import flixel.util.*;
import flixel.math.*;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

import openfl.Lib;
import openfl.Assets;
import openfl.system.System;
import openfl.display.BitmapData;

import lime.app.Application;

import haxe.*;
import haxe.io.Path;

#if (sys || desktop)
import sys.io.File;
import sys.FileSystem;
#end

using StringTools;

#if !debug
@:noDebug
#end
#end