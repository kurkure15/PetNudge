Reset onboarding state and relaunch the app for testing.

Run these commands in sequence:
```bash
defaults write com.ankuryadav.PetNudge hasCompletedOnboarding -bool false
pkill -x PetNudge 2>/dev/null
sleep 0.5
open /Users/kurkure/Library/Developer/Xcode/DerivedData/PetNudge-*/Build/Products/Debug/PetNudge.app
```

Report: "Onboarding reset. App relaunched — you should see the character selection screen."
