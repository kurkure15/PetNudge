Build the PetNudge Xcode project and report results.

Run this build command:
```bash
/Applications/Xcode.app/Contents/Developer/usr/bin/xcodebuild -project PetNudge.xcodeproj -scheme PetNudge -configuration Debug -quiet 2>&1
```

If the build succeeds, report "Build OK" with zero errors/warnings.

If the build fails:
1. Show each error with file path and line number
2. Suggest a fix for each error
3. Ask if you should apply the fixes

Do NOT automatically fix errors — report them first and wait for confirmation.
