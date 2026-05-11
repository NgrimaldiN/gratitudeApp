# BREATHE Quest

BREATHE Quest is a rapid native iOS MVP for a mindfulness school project. Each day, the user spins a bright practice wheel, gets one task drawn from the course emails, completes it, and logs notes that can feed the final May 21 report.

## MVP Features

- Daily spin wheel with course-based mindfulness and gratitude practices
- One daily challenge persisted locally with `UserDefaults`
- Completion log with minutes and notes
- Streaks, XP, levels, and badges for lightweight gamification
- 30-day progress grid for the semester project
- Report Kit tab with the teacher's required reflection prompts and shareable draft text
- Tested reusable core logic in `GratitudeCore`

## Wheel Content

The wheel practices are pulled from the class mail chain:

- Breath focus meditation
- Slow body movement scan
- Mindful walk
- Five-minute gratitude writing
- Loving-kindness meditation
- Heart coherence breathing
- Emotion naming check-in
- Thoughts on paper
- Stress sort
- Rumi Guest House reflection
- Gratitude collage snapshot
- Five-minute silent sitting
- Directed senses scan
- Future self letter

## Design Direction

The UI is native SwiftUI with a friendly, glossy iOS feel: warm cream/peach background, colorful prize-wheel interaction, SF Symbols, large rounded type, and restrained gamification. Inspiration references included:

- [Bears Gratitude on Apple Developer](https://developer.apple.com/news/?id=i74v3f4r) for friendly, hand-made gratitude energy
- [Gratefully on the App Store](https://apps.apple.com/us/app/gratitude-journal-affirmation/id1645844107) for gratitude journaling, prompts, breathing, and stats
- [Gratitude Plus on the App Store](https://apps.apple.com/us/app/gratitude-plus-journal/id1447851477) for mood tracking, reminders, insights, and clean journaling
- [HappyTabs](https://happytabs.com/) for gamified positivity progress
- [Medito](https://github.com/meditohq/medito-app) for open-source mindfulness product structure

## Run It

Open `GratitudeApp.xcodeproj` in Xcode and run the `GratitudeApp` scheme on an iPhone simulator.

If the machine's active developer directory points to Command Line Tools, the shell build command can use full Xcode without changing the global setting:

```bash
DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer \
xcodebuild -project GratitudeApp.xcodeproj \
  -scheme GratitudeApp \
  -destination 'platform=iOS Simulator,name=iPhone 17' \
  build
```

## Tests

```bash
swift test
```

The core tests cover the course practice catalog, stable daily wheel selection, date keys, and gamified progress scoring.
