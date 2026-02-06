# Build Instructions

## Prerequisites

- macOS with AppleScript support
- `osacompile` command (included in macOS)
- AutoCAD 2026 installed (for icon extraction)
- Terminal access

## Source Files

```
src/
├── launcher.applescript    # Main launcher source
├── kill.applescript        # Kill app source
└── compile.sh              # Build script
```

## Building

### Method 1: Using compile.sh (Recommended)

```bash
cd src
./compile.sh
```

This will:
1. Compile `launcher.applescript` → `AutoCAD 2026 Launcher.app`
2. Compile `kill.applescript` → `Kill AutoCAD.app`
3. Copy icons
4. Create default config files

### Method 2: Manual Compilation

#### Step 1: Compile Launcher

```bash
# Remove old app
rm -rf "/Applications/AutoCAD 2026 Launcher.app"

# Compile
osacompile -o "/Applications/AutoCAD 2026 Launcher.app" src/launcher.applescript

# Copy icon (optional)
cp "/Applications/Autodesk/AutoCAD 2026/AutoCAD 2026.app/Contents/Resources/acadlogo.icns" \
    "/Applications/AutoCAD 2026 Launcher.app/Contents/Resources/applet.icns"
```

#### Step 2: Compile Kill App

```bash
# Remove old app
rm -rf "/Applications/Kill AutoCAD.app"

# Compile
osacompile -o "/Applications/Kill AutoCAD.app" src/kill.applescript

# Copy icon (optional)
cp "/System/Library/CoreServices/CoreTypes.bundle/Contents/Resources/AlertStopIcon.icns" \
    "/Applications/Kill AutoCAD.app/Contents/Resources/applet.icns"
```

#### Step 3: Create Config Files

```bash
# Launcher config
mkdir -p "/Applications/AutoCAD 2026 Launcher.app/Contents/Resources"
echo "PASSWORD=your_password" > "/Applications/AutoCAD 2026 Launcher.app/Contents/Resources/password.conf"
chmod 600 "/Applications/AutoCAD 2026 Launcher.app/Contents/Resources/password.conf"

# Kill app config
mkdir -p "/Applications/Kill AutoCAD.app/Contents/Resources"
echo "PASSWORD=your_password" > "/Applications/Kill AutoCAD.app/Contents/Resources/kill_password.conf"
chmod 600 "/Applications/Kill AutoCAD.app/Contents/Resources/kill_password.conf"
```

## Modifying Source

### Edit Launcher

```bash
nano src/launcher.applescript
```

Common modifications:
- Change notification text
- Adjust delays
- Modify process checking

### Edit Kill App

```bash
nano src/kill.applescript
```

Common modifications:
- Change dialog text
- Adjust kill patterns
- Modify password handling

### Rebuild After Changes

```bash
cd src
./compile.sh
```

## Testing

After compilation:

1. **Test Launcher:**
   ```bash
   open "/Applications/AutoCAD 2026 Launcher.app"
   ```

2. **Test Kill:**
   ```bash
   open "/Applications/Kill AutoCAD.app"
   ```

## Troubleshooting

### "osacompile: command not found"

This command is part of macOS. If missing:
- Install Xcode Command Line Tools: `xcode-select --install`

### Permission Denied

```bash
chmod +x src/compile.sh
```

### Icon Not Found

If AutoCAD is not installed in default location:
- Manually specify icon path
- Or skip icon copying (will use default)

## AppleScript Syntax

### Dialog
```applescript
display dialog "Message" buttons {"Cancel", "OK"} default button "OK"
```

### Shell Script
```applescript
do shell script "command" with administrator privileges
```

### Notification
```applescript
display notification "Message" with title "Title"
```

### Alert
```applescript
display alert "Title" message "Message" buttons {"OK"}
```

## Resources

- [AppleScript Language Guide](https://developer.apple.com/library/archive/documentation/AppleScript/Conceptual/AppleScriptLangGuide/introduction/ASLR_intro.html)
- [osascript man page](https://ss64.com/osx/osascript.html)
- [osacompile man page](https://ss64.com/osx/osacompile.html)
