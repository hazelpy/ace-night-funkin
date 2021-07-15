package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.text.FlxTypeText;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxSpriteGroup;
import flixel.input.FlxKeyManager;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

using StringTools;

class DialogueBox extends FlxSpriteGroup
{
	var box:FlxSprite;

	var curCharacter:String = '';

	var dialogue:Alphabet;
	var dialogueList:Array<String> = [];

	// SECOND DIALOGUE FOR THE PIXEL SHIT INSTEAD???
	var swagDialogue:FlxTypeText;

	var dropText:FlxText;

	public var finishThing:Void->Void;

	var leftPortraits:Array<FlxSprite> = [];
	var rightPortraits:Array<FlxSprite> = [];
	var currentPortrait:FlxSprite;

	var leftVisible:Bool;
	var rightVisible:Bool;

	var portraitLeft:FlxSprite;
	var portraitRight:FlxSprite;

	var handSelect:FlxSprite;
	var bgFade:FlxSprite;

	public function new(talkingRight:Bool = true, ?dialogueList:Array<String>)
	{
		super();

		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'senpai':
				FlxG.sound.playMusic(Paths.music('Lunchbox'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
			case 'thorns':
				FlxG.sound.playMusic(Paths.music('LunchboxScary'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
			case 'experiment'/*, 'system'*/:
				FlxG.sound.playMusic(Paths.music('LunchboxScary'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
			case 'crisis', 'crisis-old':
				FlxG.sound.playMusic(Paths.music('LunchboxScary'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
		}

		bgFade = new FlxSprite(-200, -200).makeGraphic(Std.int(FlxG.width * 1.3), Std.int(FlxG.height * 1.3), 0xFFB3DFd8);
		bgFade.scrollFactor.set();
		bgFade.alpha = 0;
		add(bgFade);

		new FlxTimer().start(0.83, function(tmr:FlxTimer)
		{
			bgFade.alpha += (1 / 5) * 0.7;
			if (bgFade.alpha > 0.7)
				bgFade.alpha = 0.7;
		}, 5);

		box = new FlxSprite(-20, 45);
		
		var hasDialog = false;
		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'senpai':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-pixel');
				box.animation.addByPrefix('normalOpen', 'Text Box Appear', 24, false);
				box.animation.addByIndices('normal', 'Text Box Appear', [4], "", 24);
			case 'roses':
				hasDialog = true;
				FlxG.sound.play(Paths.sound('ANGRY_TEXT_BOX'));

				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-senpaiMad');
				box.animation.addByPrefix('normalOpen', 'SENPAI ANGRY IMPACT SPEECH', 24, false);
				box.animation.addByIndices('normal', 'SENPAI ANGRY IMPACT SPEECH', [4], "", 24);

			case 'thorns':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-evil');
				box.animation.addByPrefix('normalOpen', 'Spirit Textbox spawn', 24, false);
				box.animation.addByIndices('normal', 'Spirit Textbox spawn', [11], "", 24);

				var face:FlxSprite = new FlxSprite(320, 170).loadGraphic(Paths.image('weeb/spiritFaceForward'));
				face.setGraphicSize(Std.int(face.width * 6));
				add(face);
			case 'experiment'/*, 'system'*/:
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('speech_bubble_talking', 'shared');
				box.animation.addByPrefix('normalOpen', 'Speech Bubble Normal Open', 24, false);
				box.animation.addByIndices('normal', 'speech bubble normal', [4], "", 24);

				box.width = 200;
				box.height = 200;
				box.x = -100;
				box.y = 375;
			case 'crisis', 'crisis-old':
				hasDialog = false; // set to false temporarily
				box.frames = Paths.getSparrowAtlas('speech_bubble_talking', 'shared');
				box.animation.addByPrefix('normalOpen', 'Speech Bubble Normal Open', 24, false);
				box.animation.addByIndices('normal', 'speech bubble normal', [4], "", 24);

				box.width = 200;
				box.height = 200;
				box.x = -100;
				box.y = 375;
		}

		this.dialogueList = dialogueList;
		
		switch(PlayState.SONG.song.toLowerCase()) {
			case 'experiment':
				portraitLeft = new FlxSprite(-20, 70);
				portraitLeft.frames = Paths.getSparrowAtlas('abberations/portraits/acePortraitCalm', 'shared');
				portraitLeft.animation.addByPrefix('enter', 'ace-enter instance 1', 24, false);
				portraitLeft.setGraphicSize(Std.int(portraitLeft.width * PlayState.daPixelZoom * 0.9));
				portraitLeft.updateHitbox();
				portraitLeft.scrollFactor.set();
				add(portraitLeft);
				portraitLeft.visible = false;
			default:
				portraitLeft = new FlxSprite(-20, 70);
				portraitLeft.frames = Paths.getSparrowAtlas('weeb/senpaiPortrait');
				portraitLeft.animation.addByPrefix('enter', 'Senpai Portrait Enter', 24, false);
				portraitLeft.setGraphicSize(Std.int(portraitLeft.width * PlayState.daPixelZoom * 0.9));
				portraitLeft.updateHitbox();
				portraitLeft.scrollFactor.set();
				add(portraitLeft);
				portraitLeft.visible = false;
		}

		if (!hasDialog)
			return;
		
		// Setup multiple portraits
		var Placeholder:FlxSprite;

		// BF portrait Right
		Placeholder = new FlxSprite(-50, 35);
		Placeholder.frames = Paths.getSparrowAtlas('abberations/portraits/bfOGPortrait', 'shared');
		Placeholder.animation.addByPrefix('enter', 'Boyfriend portrait enter instance 1', 24, false);
		Placeholder.setGraphicSize(Std.int(Placeholder.width * PlayState.daPixelZoom * 0.155));
		Placeholder.updateHitbox();
		Placeholder.scrollFactor.set();
		add(Placeholder);
		Placeholder.visible = false;

		// insert BF portrait Right to rightPortraits
		rightPortraits.insert(0, Placeholder);
		
		// Ace portrait Calm Left
		Placeholder = new FlxSprite(-20, 70);
		Placeholder.frames = Paths.getSparrowAtlas('abberations/portraits/acePortraitCalm', 'shared');
		Placeholder.animation.addByPrefix('enter', 'ace-enter instance 1', 24, false);
		Placeholder.setGraphicSize(Std.int(Placeholder.width * PlayState.daPixelZoom * 0.9));
		Placeholder.updateHitbox();
		Placeholder.scrollFactor.set();
		Placeholder.color = FlxColor.BLACK;
		add(Placeholder);
		Placeholder.visible = false;

		// insert Left ace portrait to leftPortraits
		leftPortraits.insert(0, Placeholder);

		// Ace portrait Calm Left
		Placeholder = new FlxSprite(-20, 70);
		Placeholder.frames = Paths.getSparrowAtlas('abberations/portraits/demo', 'shared');
		Placeholder.animation.addByPrefix('enter', 'ace-enter instance 1', 24, false);
		Placeholder.setGraphicSize(Std.int(Placeholder.width * PlayState.daPixelZoom * 0.9));
		Placeholder.updateHitbox();
		Placeholder.scrollFactor.set();
		Placeholder.color = FlxColor.BLACK;
		add(Placeholder);
		Placeholder.visible = false;

		// insert Left ace portrait to leftPortraits
		leftPortraits.insert(1, Placeholder);

		// reset Placeholder
		Placeholder = null;

		/* PLACEHOLDER GUIDE
		= LEFT PORTRAITS
		 - 0: ace calm
		= RIGHT PORTRAITS
		 - 0: bf right
		*/

		switch(PlayState.SONG.song.toLowerCase()) {
			default:
				portraitRight = new FlxSprite(0, 40);
				portraitRight.frames = Paths.getSparrowAtlas('weeb/bfPortrait');
				portraitRight.animation.addByPrefix('enter', 'Boyfriend portrait enter', 24, false);
				portraitRight.setGraphicSize(Std.int(portraitRight.width * PlayState.daPixelZoom * 0.9));
				portraitRight.updateHitbox();
				portraitRight.scrollFactor.set();
				add(portraitRight);
				portraitRight.visible = false;
		}
		
		box.animation.play('normalOpen');
		box.setGraphicSize(Std.int(box.width * PlayState.daPixelZoom * 0.9));
		box.updateHitbox();
		add(box);

		box.screenCenter(X);
		portraitLeft.screenCenter(X);

		handSelect = new FlxSprite(FlxG.width * 0.9, FlxG.height * 0.9).loadGraphic(Paths.image('weeb/pixelUI/hand_textbox'));
		add(handSelect);


		if (!talkingRight)
		{
			// box.flipX = true;
		}

		dropText = new FlxText(242, 502, Std.int(FlxG.width * 0.6), "", 32);
		dropText.font = 'Pixel Arial 11 Bold';
		dropText.color = 0xFFD89494;
		add(dropText);

		swagDialogue = new FlxTypeText(240, 500, Std.int(FlxG.width * 0.6), "", 32);
		swagDialogue.font = 'Pixel Arial 11 Bold';
		swagDialogue.color = 0xFF3F2021;
		swagDialogue.sounds = [FlxG.sound.load(Paths.sound('pixelText'), 0.6)];
		add(swagDialogue);

		dialogue = new Alphabet(0, 80, "", false, true);
		// dialogue.x = 90;
		// add(dialogue);
	}

	var dialogueOpened:Bool = false;
	var dialogueStarted:Bool = false;

	override function update(elapsed:Float)
	{
		// HARD CODING CUZ IM STUPDI
		if (PlayState.SONG.song.toLowerCase() == 'roses')
			portraitLeft.visible = false;
		if (PlayState.SONG.song.toLowerCase() == 'thorns')
		{
			portraitLeft.color = FlxColor.BLACK;
			swagDialogue.color = FlxColor.WHITE;
			dropText.color = FlxColor.BLACK;
		}

		dropText.text = swagDialogue.text;

		if (box.animation.curAnim != null)
		{
			if (box.animation.curAnim.name == 'normalOpen' && box.animation.curAnim.finished)
			{
				box.animation.play('normal');
				dialogueOpened = true;
			}
		}

		if (dialogueOpened && !dialogueStarted)
		{
			startDialogue();
			dialogueStarted = true;
		}

		if (FlxG.keys.justPressed.ANY  && dialogueStarted == true)
		{
			remove(dialogue);
				
			FlxG.sound.play(Paths.sound('clickText'), 0.8);

			if (dialogueList[1] == null && dialogueList[0] != null)
			{
				if (!isEnding)
				{
					isEnding = true;
					// FlxG.sound.music.fadeOut(2.2, 0);

					switch(PlayState.SONG.song.toLowerCase()) {
						case 'senpai', 'thorns':
							FlxG.sound.music.fadeOut(2.2, 0);
						case 'experiment', 'system':
							FlxG.sound.music.fadeOut(2.2, 0);
						default:
					}

					new FlxTimer().start(0.2, function(tmr:FlxTimer)
					{
						box.alpha -= 1 / 5;
						bgFade.alpha -= 1 / 5 * 0.7;
						portraitLeft.visible = false;
						portraitRight.visible = false;
						swagDialogue.alpha -= 1 / 5;
						dropText.alpha = swagDialogue.alpha;
					}, 5);

					new FlxTimer().start(1.2, function(tmr:FlxTimer)
					{
						finishThing();
						kill();
					});
				}
			}
			else
			{
				dialogueList.remove(dialogueList[0]);
				startDialogue();
			}
		}
		
		super.update(elapsed);
	}

	var isEnding:Bool = false;

	function portraitCheck():Void {
		leftVisible = false;
		rightVisible = false;

		for (v in leftPortraits) {
			if (v.visible) {
				leftVisible = true;
			}
		}

		if (leftVisible) return;

		for (v in rightPortraits) {
			if (v.visible) {
				rightVisible = true;
			}
		}

		if (rightVisible) return;
	}

	function resetPortraits(portrait:String = null):Void {
		switch(portrait.toLowerCase()) {
			case 'left':
				for (v in leftPortraits) {
					if (v.visible)
					v.visible = false;
				}

				portraitLeft.visible = false;
			case 'right':
				for (v in rightPortraits) {
					if (v.visible)
					v.visible = false;
				}

				portraitRight.visible = false;
			default:
				for (v in leftPortraits) {
					if (v.visible)
					v.visible = false;
				}

				for (v in rightPortraits) {
					if (v.visible)
					v.visible = false;
				}
				
				portraitLeft.visible = false;
				portraitRight.visible = false;
				return;
		}
	}

	function startDialogue():Void
	{
		cleanDialog();
		// var theDialog:Alphabet = new Alphabet(0, 70, dialogueList[0], false, true);
		// dialogue = theDialog;
		// add(theDialog);

		// swagDialogue.text = ;
		swagDialogue.resetText(dialogueList[0]);
		swagDialogue.start(0.04, true);

		switch (curCharacter)
		{
			case 'dad':
				resetPortraits();

				if (currentPortrait != portraitLeft) {
					portraitLeft.animation.play('enter');
					portraitLeft.visible = true;
				}

				currentPortrait = portraitLeft;
			case 'bf':
				resetPortraits();

				if (currentPortrait != portraitRight) {
					portraitRight.animation.play('enter');
					portraitRight.visible = true;
				}

				currentPortrait = portraitRight;
			case 'bf.og':
				var id:Int = 0;
				var side:String = "right";

				portraitCheck();
				resetPortraits();
				showPortrait(side, id);
				
				if (currentPortrait != getPortrait(side, id)) {
					enterPortrait(side, id);
				}

				currentPortrait = getPortrait(side, id);
				/*
				if (!portraitRight.visible && !rightVisible && !getPortrait(side, id).visible)
				{
					rightVisible = true;
				}
				*/
			case 'ace.calm':
				var id:Int = 0;
				var side:String = "left";

				portraitCheck();
				resetPortraits();
				showPortrait(side, id);
				
				if (currentPortrait != getPortrait(side, id)) {
					enterPortrait(side, id);
				}

				currentPortrait = getPortrait(side, id);
				/*
				if (!portraitLeft.visible && !leftVisible && !getPortrait(side, id).visible)
				{
					leftVisible = true;
				}
				*/
			case 'blank':
				var id:Int = 1;
				var side:String = "left";

				portraitCheck();
				resetPortraits();
				showPortrait(side, id);
				
				if (currentPortrait != getPortrait(side, id)) {
					enterPortrait(side, id);
				}

				currentPortrait = getPortrait(side, id);
				/*
				if (!portraitLeft.visible && !leftVisible && !getPortrait(side, id).visible)
				{
					leftVisible = true;
				}
				*/
		}
	}

	function getPortrait(side:String, id:Int):FlxSprite {
		switch(side) {
			case 'left':
				return leftPortraits[id];
			case 'right':
				return rightPortraits[id];
			default: return null;
		}
	}

	function showPortrait(side:String, id:Int) {
		switch(side) {
			case 'left':
				leftPortraits[id].visible = true;
			case 'right':
				rightPortraits[id].visible = true;
			default: return;
		}
	}

	function enterPortrait(side:String, id:Int) {
		switch(side) {
			case 'left':
				leftPortraits[id].animation.play('enter');
			case 'right':
				rightPortraits[id].animation.play('enter');
			default: return;
		}
	}

	function cleanDialog():Void
	{
		var splitName:Array<String> = dialogueList[0].split(":");
		curCharacter = splitName[1];
		dialogueList[0] = dialogueList[0].substr(splitName[1].length + 2).trim();
	}
}
