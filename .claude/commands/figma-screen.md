Fetch and describe a Figma screen design.

Usage: `/figma-screen <node-id or screen-name>`

Screen name shortcuts:
- `blue` or `step0-blue` → node `8:89` (Character select — Blue)
- `budgie` or `step0-budgie` → node `15:256` (Character select — Budgie)
- `pabu` or `step0-pabu` → node `15:332` (Character select — Pabu)
- `step1-blue` → node `21:466` (First reminder — Blue)
- `step1-budgie` → node `21:569` (First reminder — Budgie)
- `step1-pabu` → node `21:636` (First reminder — Pabu)
- `after-select` → node `106:1197` (After character selection)
- `after-reminder` → node `92:1194` (After adding a reminder)
- `uat` → node `87:785` (UAT page)

Figma file key: `4Hjq9g7eLr2XTNMmon4oQD`

1. Resolve the argument to a node ID using the shortcuts above (or use it directly if it looks like a node ID)
2. Fetch the node using `mcp__figma__get_figma_data`
3. Describe the screen layout: what elements are present, their positions, colors, fonts, and sizes
4. Compare against the current SwiftUI implementation if relevant files are mentioned
