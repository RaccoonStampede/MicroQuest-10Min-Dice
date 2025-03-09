# Micro Quest (10-Min Dice Edition)
A 10-minute D&D-style adventure with dice rolls, quirky heroes, and immersive tales, playable on mobile!

## Setup
1. Install Godot (https://godotengine.org/)
2. Clone this repo: `git clone https://github.com/RaccoonStampede/MicroQuest-10Min-Dice.git`
3. Open in Godot: File > Open > Select project folder
4. Set `scenes/Main.tscn` as main scene (Project > Project Settings > Application > Run)

## Play on Desktop
- Run: Press F5 or click "Play"

## Export to Mobile
### Android
1. Install Android SDK (via Android Studio or standalone).
2. In Godot: Editor > Editor Settings > Export > Android > Set SDK path.
3. Export > Add Android preset > Download export templates if prompted.
4. Export > Android > Save as `.apk` > Install on device via USB or sideload.

### iOS
1. Requires a Mac with Xcode installed.
2. In Godot: Export > Add iOS preset > Set Xcode path.
3. Export > iOS > Build `.ipa` > Deploy via Xcode to an iPhone.

## How to Play
- Guide the Sock Sage through "The Jam Princess Predicament."
- Tap choices, roll virtual d20/d6 dice, and shape the story.
- Collect items, face foes, and unlock one of 4+ endings.

## Features
- Mobile-optimized UI with touch input.
- Rich narrative with 4 stages, 12+ choices, and inventory use.
- ~10-minute immersive quest.

## Contribute
- Add quests in `data/QuestData.json`.
- Tweak `scripts/Main.gd` for more mechanics.
- Submit PRs with heroes or mobile tweaks!
