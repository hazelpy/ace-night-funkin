package;

import Controls.KeyboardScheme;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import io.newgrounds.NG;
import lime.app.Application;

#if windows
import Discord.DiscordClient;
#end

using StringTools;

class MainMenuState extends MusicBeatState
{
	var curSelected:Int = 0;

	var menuItems:FlxTypedGroup<FlxSprite>;

	var optionShit:Array<String> = ['story mode', 'freeplay', 'options'];

	var newGaming:FlxText;
	var newGaming2:FlxText;
	public static var firstStart:Bool = true;

	public static var nightly:String = "";

	var logoBumpin:FlxSprite;
	var textBump:FlxTimer;

	public static var kadeEngineVer:String = "1.4.2" + nightly;
	public static var gameVer:String = "0.2.7.1";

	var magenta:FlxSprite;
	var bgBump:FlxTimer;

	var camFollow:FlxObject;
	public static var finishedFunnyMove:Bool = false;

	override function create()
	{
		#if windows
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		if (!FlxG.sound.music.playing)
		{
			FlxG.sound.playMusic(Paths.music('freakyMenu'));
		}

		
		persistentUpdate = persistentDraw = true;

		var bg:FlxSprite = new FlxSprite(-(FlxG.width/10), -(FlxG.height/10)).loadGraphic(Paths.image('menuBG'));
		bg.scrollFactor.x = 0;
		bg.scrollFactor.y = 0;
		bg.setGraphicSize(Std.int(bg.width * 1.1));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = true;
		add(bg);

		magenta = new FlxSprite(-(FlxG.width/10), -(FlxG.height/10)).loadGraphic(Paths.image('menuDesat'));
		magenta.scrollFactor.x = 0;
		magenta.scrollFactor.y = 0;
		magenta.setGraphicSize(Std.int(magenta.width * 1.1));
		magenta.updateHitbox();
		magenta.screenCenter();
		magenta.visible = false;
		magenta.antialiasing = true;
		magenta.color = 0xFFFFFFFF;
		add(magenta);
		// magenta.scrollFactor.set();

		bgBump = new FlxTimer().start(0.5882, function onComplete(timer:FlxTimer) {
			var scaleX = bg.scale.x;
			var scaleY = bg.scale.y;

			bg.scale.set(scaleX * 1.05, scaleY * 1.05);
			bg.updateHitbox();
			bg.screenCenter();
			magenta.screenCenter();

			magenta.scale.set(scaleX * 1.05, scaleY * 1.05);
			magenta.updateHitbox();
			
			FlxTween.tween(bg, {"scale.x": scaleX, "scale.y": scaleY}, 0.2, {
				ease: FlxEase.expoOut
			});

			FlxTween.tween(magenta, {"scale.x": scaleX, "scale.y": scaleY}, 0.2, {
				ease: FlxEase.expoOut
			});
		}, 0);

		logoBumpin = new FlxSprite((FlxG.width / 2.4), (FlxG.height * -1.4)).loadGraphic(Paths.image('logoText'));
		logoBumpin.antialiasing = true;
		logoBumpin.setGraphicSize(Std.int(logoBumpin.width/2.8));
		logoBumpin.updateHitbox();
		add(logoBumpin);

		FlxTween.tween(logoBumpin, {y: 0}, 2, {
			ease: FlxEase.expoOut
		});

		textBump = new FlxTimer().start(0.5882, function onComplete(timer:FlxTimer) {
			var scaleX = logoBumpin.scale.x;
			var scaleY = logoBumpin.scale.y;

			logoBumpin.scale.set(scaleX * 1.2, scaleY * 1.2);
			logoBumpin.updateHitbox();
			logoBumpin.x = (FlxG.width / 2.4);
			logoBumpin.y = 0;
			
			FlxTween.tween(logoBumpin, {"scale.x": scaleX, "scale.y": scaleY}, 0.2, {
				ease: FlxEase.expoOut
			});
		}, 0);


		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		var tex = Paths.getSparrowAtlas('FNF_main_menu_assets');

		for (i in 0...optionShit.length)
		{
			var menuItem:FlxSprite = new FlxSprite(0, FlxG.height * 1);
			menuItem.frames = tex;
			menuItem.animation.addByPrefix('idle', optionShit[i] + " basic", 24);
			menuItem.animation.addByPrefix('selected', optionShit[i] + " white", 24);
			menuItem.animation.play('idle');
			menuItem.setGraphicSize( Std.int(menuItem.height * 3) );
			bg.updateHitbox();
			menuItem.ID = i;
			menuItems.add(menuItem);
			menuItem.scrollFactor.set();
			menuItem.antialiasing = true;

			menuItem.x = -FlxG.width;
			menuItem.y = 0;

			switch(optionShit[i]) {
				case 'donate':
					menuItem.y += menuItem.height / 4;

					FlxTween.tween(menuItem, {x: FlxG.width - (menuItem.width * 12)}, 1, {
						ease: FlxEase.expoOut
					});
				default:
					menuItem.y += (FlxG.height / 10) + (((FlxG.height / 6) + menuItem.height) * i);

					FlxTween.tween(menuItem, {x: menuItem.width / 12}, 1, {
						ease: FlxEase.expoOut
					});
			}

			// Since Kade implemented this dumb trigger, gotta make it true by default ;/
			finishedFunnyMove = true;
		}

		firstStart = false;

		var versionShit:FlxText = new FlxText(5, FlxG.height - 18, 0, gameVer +  (Main.watermarks ? " FNF Advanced Aberrations - " + kadeEngineVer + " Kade Engine" : ""), 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);

		// NG.core.calls.event.logEvent('swag').send();


		if (FlxG.save.data.dfjk)
			controls.setKeyboardScheme(KeyboardScheme.Solo, true);
		else
			controls.setKeyboardScheme(KeyboardScheme.Duo(true), true);

		changeItem();

		super.create();
	}

	var selectedSomethin:Bool = false;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		if (!selectedSomethin)
		{
			if (controls.UP_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(-1);
			}

			if (controls.DOWN_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(1);
			}

			if (controls.ACCEPT)
			{
				if (optionShit[curSelected] == 'donate')
				{
					#if linux
					Sys.command('/usr/bin/xdg-open', ["https://www.youtube.com/watch?v=dQw4w9WgXcQ", "&"]);
					#else
					FlxG.openURL('https://www.youtube.com/watch?v=dQw4w9WgXcQ');
					#end
				}
				else
				{
					selectedSomethin = true;
					FlxG.sound.play(Paths.sound('confirmMenu'));

					FlxTween.tween(logoBumpin, {alpha: 0, y: -FlxG.height}, 0.8, {
						ease: FlxEase.sineIn,
						onComplete: function(twn:FlxTween)
						{
							logoBumpin.kill();
						}
					});
					
					if (FlxG.save.data.flashing)
						FlxFlicker.flicker(magenta, 1.1, 0.15, false);

					menuItems.forEach(function(spr:FlxSprite)
					{
						if (curSelected != spr.ID)
						{
							// Tween Out Left
							FlxTween.tween(spr, {alpha: 0, x: -spr.width}, 0.8, {
								ease: FlxEase.sineIn,
								onComplete: function(twn:FlxTween)
								{
									spr.kill();
								}
							});
						}
						else
						{
							if (FlxG.save.data.flashing)
							{
								FlxFlicker.flicker(spr, 1, 0.06, false, false, function(flick:FlxFlicker)
								{
									goToState();
								});
							}
							else
							{
								new FlxTimer().start(1, function(tmr:FlxTimer)
								{
									goToState();
								});
							}

							FlxTween.tween(spr, {x: spr.x + spr.width * 2, alpha: 0}, 1.3, {
								ease: FlxEase.sineIn,
								onComplete: function(twn:FlxTween) {
									spr.kill();
								}
							});
						}
					});
				}
			}
		}

		super.update(elapsed);
	}
	
	function goToState()
	{
		var daChoice:String = optionShit[curSelected];

		switch (daChoice)
		{
			case 'story mode':
				FlxG.switchState(new StoryMenuState());
				trace("Story Menu Selected");
			case 'freeplay':
				FlxG.switchState(new FreeplayState());
				trace("Freeplay Menu Selected");
			case 'options':
				FlxG.switchState(new OptionsMenu());
		}
	}

	function changeItem(huh:Int = 0)
	{
		if (finishedFunnyMove)
		{
			curSelected += huh;

			if (curSelected >= menuItems.length)
				curSelected = 0;
			if (curSelected < 0)
				curSelected = menuItems.length - 1;
		}
		
		menuItems.forEach(function(spr:FlxSprite)
		{
			var curX = spr.x;
			spr.animation.play('idle');

			if (spr.ID == 3) {
				spr.x = FlxG.width - (spr.width / 11);
				spr.y = 0 + spr.height / 4;
			}

			if (spr.ID == curSelected)
			{
				spr.animation.play('selected');
			}

			spr.updateHitbox();
		});
	}
}