package meta.data;

import flixel.FlxG;
import meta.state.*;
import meta.state.PlayState;

using StringTools;

class Highscore
{
	#if (haxe >= "4.0.0")
	public static var songScores:Map<String, Int> = new Map();
	#else
	public static var songScores:Map<String, Int> = new Map<String, Int>();
	#end

	public static var songRating:Map<String, Int> = new Map();

	public static function saveScore(song:String, score:Int = 0, ?diff:Int = 0):Void
	{
		var daSong:String = formatSong(song, diff);

		if (songScores.exists(daSong))
		{
			if (songScores.get(daSong) < score)
				setScore(daSong, score);
		}
		else
			setScore(daSong, score);
	}

	public static function saveRank(song:String, rating:Int = 0):Void
		{	// I hope I got this to work
			var daSong:String = formatSongNODIFF(song);
	
			if (songRating.exists(daSong))
			{
				rating = 0;
				switch (PlayState.fuckingRankText) {
				case 'd':
					rating = 1;
				case 'c':
					rating = 2;
				case 'b':
					rating = 3;
				case 'a':
					rating = 4;
				case 's':
					rating = 5;
				case 's+':
					rating = 6;
				case 'p':
					rating = 7;
				}
				if (songRating.get(daSong) < rating)
					setRating(daSong, rating);
			}
			else
				setRating(daSong, rating);
		}

	public static function saveWeekScore(week:Int = 1, score:Int = 0, ?diff:Int = 0):Void
	{
		var daWeek:String = formatSong('week' + week, diff);

		if (songScores.exists(daWeek))
		{
			if (songScores.get(daWeek) < score)
				setScore(daWeek, score);
		}
		else
			setScore(daWeek, score);
	}

	/**
	 * YOU SHOULD FORMAT SONG WITH formatSong() BEFORE TOSSING IN SONG VARIABLE
	 */
	static function setScore(song:String, score:Int):Void
	{
		// Reminder that I don't need to format this song, it should come formatted!
		songScores.set(song, score);
		FlxG.save.data.songScores = songScores;
		FlxG.save.flush();
	}

	static function setRating(song:String, rating:Int):Void
	{
		// Reminder that I don't need to format this song, it should come formatted!
		songRating.set(song, rating);
		FlxG.save.data.songRating = songRating;
		FlxG.save.flush();
	}

	public static function formatSong(song:String, diff:Int):String
	{
		var daSong:String = song;

		var difficulty:String = '-' + CoolUtil.difficultyFromNumber(diff).toLowerCase();
		difficulty = difficulty.replace('-normal', '');

		daSong += difficulty;

		return daSong;
	}

	public static function formatSongNODIFF(song:String):String
	{
		var daSong:String = song;

		return daSong;
	}

	public static function getScore(song:String, diff:Int):Int
	{
		if (!songScores.exists(formatSong(song, diff)))
			setScore(formatSong(song, diff), 0);

		return songScores.get(formatSong(song, diff));
	}

	public static function getRating(song:String):Int
	{
		if (!songRating.exists(formatSongNODIFF(song)))
			setRating(formatSongNODIFF(song), 0);

		return songRating.get(formatSongNODIFF(song));
	}

	public static function getWeekScore(week:Int, diff:Int):Int
	{
		if (!songScores.exists(formatSong('week' + week, diff)))
			setScore(formatSong('week' + week, diff), 0);

		return songScores.get(formatSong('week' + week, diff));
	}

	public static function load():Void
	{
		if (FlxG.save.data.songScores != null)
		{
			songScores = FlxG.save.data.songScores;
		}
		if (FlxG.save.data.songRating != null)
		{
			songRating = FlxG.save.data.songRating;
		}
	}
}