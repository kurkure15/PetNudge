# Design Tokens Quick Reference

## Per-Character Colors

| Token | Blue (dog) | Budgie (cat) | Pabu (redPanda) | Property |
|-------|-----------|-------------|-----------------|----------|
| Gradient top (step 0) | `#051184` | `#5E3307` | `#0F6A43` | `gradientTopHex` |
| Gradient top (step 1) | `#061937` | `#5E3307` | `#0F6A43` | `step1GradientTopHex` |
| Button background | `#051184` | `#5E3307` | `#0F6A43` | `buttonHex` |
| Accent color | `#5B97F7` | `#FFB260` | `#60DCA6` | `accentHex` |
| Name gradient top | `#AFCDFF` | `#5E3307` | `#0F6A43` | `nameGradientTopHex` |
| Selected stroke | `#6B74BF` | `#A15D18` | `#0C804E` | `selectedStrokeHex` |
| Unselected stroke | `#2C3056` | `#3C2309` | `#073D22` | `unselectedStrokeHex` |

## Typography

| Element | Font | Weight | Size |
|---------|------|--------|------|
| Character name | Source Serif 4 (`SourceSerif4-Black`) | 900 | 208pt Blue, 160pt others |
| "Select a character" | SF Pro | 590 (Semibold) | 24pt |
| "Continue with [name]" | SF Pro | 590 (Semibold) | 16pt |
| "Hey [name]," / "Remind me to" | SF Pro | 860 (Heavy) | 20pt |
| Editable task/day/time | SF Pro | 1000 (Black) | 24pt |
| Hint text | SF Pro Rounded | 700 (Bold) | 10pt |

## Layout

| Element | Value |
|---------|-------|
| Onboarding window | 1200x640, radius 24px |
| Button width (step 0) | 604px |
| Character scene | 400x400 |
| Selected circle | 180x180 outer + 144x144 inner (stroke-only) |
| Circle gap | 32px |
| Settings icon | (1128, 24), 48x48 |
| Close/Back icon | (24, 24), 48x48 |
| Next icon | (1112, 568), 48x48 |
| Sentence builder | x:600 y:303, width 285 |
| Hint | ~(1040, 592) |
| Popover | 320x440 |

## Figma Screens

File key: `4Hjq9g7eLr2XTNMmon4oQD`

| Node ID | Screen |
|---------|--------|
| `8:89` | Character select — Blue |
| `15:256` | Character select — Budgie |
| `15:332` | Character select — Pabu |
| `21:466` | First reminder — Blue |
| `21:569` | First reminder — Budgie |
| `21:636` | First reminder — Pabu |
| `106:1197` | After character selection (all 3) |
| `92:1194` | After adding a reminder (all 3) |
| `87:785` | UAT page |

## Per-Character Step 1 Defaults

| Character | Task | Day | Time |
|-----------|------|-----|------|
| Blue | Drink Water | Today | 10:00 AM |
| Budgie | Water my Plants | Today | 06:00 PM |
| Pabu | Feed my Cat | Tomorrow | 11:30 AM |
