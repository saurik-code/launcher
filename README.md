# AutoCAD 2026 Mac Launcher

🎨 **AutoCAD 2026 Launcher with License Server Management for macOS**

A launcher application for AutoCAD 2026 on Mac with automatic license server management.

## 📁 Repository Contents

| File/Folder | Description |
|-------------|-------------|
| `AutoCAD 2026 Launcher.app` | 🚀 Main launcher application |
| `Kill AutoCAD.app` | 💀 Emergency kill application |
| `launch_autocad_server.sh` | 🔧 Launcher shell script |
| `kill_autocad.sh` | 🔧 Kill shell script |
| `src/` | 📂 Source files for compilation |
| `README.md` | 📘 Documentation (English) |
| `README_ID.md` | 📘 Documentation (Indonesian) |

## 🚀 Features

### AutoCAD 2026 Launcher
- ✅ Auto-start license server if not running
- ✅ Detect & cleanup duplicate processes
- ✅ Smart health check (process + port + TCP)
- ✅ Retry mechanism (3 attempts)
- ✅ Automatic environment variables

### Kill AutoCAD
- 💀 Force kill AutoCAD and License Server
- 🔄 Kill 3x times to ensure termination
- 📊 Display running processes detail
- ✅ Verify result after kill

## 📦 Installation

### 1. Copy Apps to Applications
```bash
# Copy to Applications folder
cp -R "AutoCAD 2026 Launcher.app" /Applications/
cp -R "Kill AutoCAD.app" /Applications/
```

### 2. Setup License Server
```bash
# Ensure flexnetserver folder exists
sudo mkdir -p /usr/local/flexnetserver

# Copy license file (if not exists)
sudo cp license_backup_working.dat /usr/local/flexnetserver/license.dat

# Set permissions
sudo chmod 755 /usr/local/flexnetserver
sudo chmod 644 /usr/local/flexnetserver/license.dat
```

### 3. Setup Password
```bash
# Edit config file
nano "/Applications/AutoCAD 2026 Launcher.app/Contents/Resources/password.conf"
# Change: PASSWORD=your_mac_password

# Edit Kill AutoCAD config  
nano "/Applications/Kill AutoCAD.app/Contents/Resources/kill_password.conf"
# Change: PASSWORD=your_mac_password
```

## 🖥️ Usage

### Launch AutoCAD
1. Double-click **AutoCAD 2026 Launcher** in Applications
2. Wait for notification "License server running"
3. AutoCAD will open automatically

### Emergency Kill (Freeze/Error)
1. Double-click **Kill AutoCAD** in Applications
2. View running processes detail
3. Click **Continue**
4. Enter Mac password (first time)
5. Wait for success confirmation
6. Relaunch with Launcher

## 🔧 Source Code & Compilation

### Source Files Location
```
src/
├── launcher.applescript      # AutoCAD Launcher source
├── kill.applescript          # Kill AutoCAD source
└── compile.sh                # Compilation script
```

### Modifying & Recompiling

#### 1. Edit Source
```bash
# Edit launcher source
nano src/launcher.applescript

# Edit kill source
nano src/kill.applescript
```

#### 2. Compile
```bash
# Make compile script executable
chmod +x src/compile.sh

# Run compilation
./src/compile.sh

# Or compile manually:

# Compile Launcher
rm -rf "/Applications/AutoCAD 2026 Launcher.app"
osacompile -o "/Applications/AutoCAD 2026 Launcher.app" src/launcher.applescript

# Copy icon
cp "/Applications/Autodesk/AutoCAD 2026/AutoCAD 2026.app/Contents/Resources/acadlogo.icns" \
    "/Applications/AutoCAD 2026 Launcher.app/Contents/Resources/applet.icns"

# Compile Kill
rm -rf "/Applications/Kill AutoCAD.app"
osacompile -o "/Applications/Kill AutoCAD.app" src/kill.applescript

# Copy icon
cp "/System/Library/CoreServices/CoreTypes.bundle/Contents/Resources/AlertStopIcon.icns" \
    "/Applications/Kill AutoCAD.app/Contents/Resources/applet.icns"
```

#### 3. Copy Resources
```bash
# Copy scripts
cp launch_autocad_server.sh "/Applications/AutoCAD 2026 Launcher.app/Contents/Resources/"
cp kill_autocad.sh "/Applications/Kill AutoCAD.app/Contents/Resources/"

# Create config files
echo "PASSWORD=nafaru" > "/Applications/AutoCAD 2026 Launcher.app/Contents/Resources/password.conf"
chmod 600 "/Applications/AutoCAD 2026 Launcher.app/Contents/Resources/password.conf"

echo "PASSWORD=nafaru" > "/Applications/Kill AutoCAD.app/Contents/Resources/kill_password.conf"
chmod 600 "/Applications/Kill AutoCAD.app/Contents/Resources/kill_password.conf"
```

### AppleScript Syntax Reference

#### Basic Dialog
```applescript
display dialog "Message" buttons {"Cancel", "OK"} default button "OK"
```

#### Run Shell Script
```applescript
do shell script "command" with administrator privileges
```

#### Display Notification
```applescript
display notification "Message" with title "Title"
```

#### Alert
```applescript
display alert "Title" message "Message" buttons {"OK"}
```

## 🔄 Workflow

### Normal Flow
```
User → Launch AutoCAD 2026 Launcher.app
     → Check license server health
     → If not running: start server
     → Set environment variables
     → Launch AutoCAD 2026
     → Done ✅
```

### Emergency Flow
```
AutoCAD Freeze/Error
     → Launch Kill AutoCAD.app
     → Show running processes
     → User clicks "Continue"
     → Kill all processes (with sudo)
     → Verify all killed
     → Show success message
     → User relaunch with Launcher
     → Done ✅
```

## 🔧 Troubleshooting

### License Server Won't Start
```bash
# Kill manually
sudo pkill -9 -x lmgrd
sudo pkill -9 -x adskflex

# Start manually
cd /usr/local/flexnetserver
sudo ./lmgrd -c ./license.dat
```

### Port 27080 Already in Use
```bash
# Check what's using the port
sudo lsof -i :27080

# Kill process using the port
sudo kill -9 <PID>
```

### Reset Everything
```bash
# Kill all
sudo pkill -9 -f autocad
sudo pkill -9 -x lmgrd
sudo pkill -9 -x adskflex

# Clear port
for pid in $(sudo lsof -t -i :27080); do sudo kill -9 $pid; done

# Restart
/Applications/AutoCAD\ 2026\ Launcher.app/Contents/Resources/launch_autocad_server.sh
```

## 📋 Requirements

- macOS (tested on macOS Sonoma+)
- AutoCAD 2026 for Mac
- FlexNet License Server (`/usr/local/flexnetserver/`)
- Administrator privileges (for sudo)

## 🔒 Security

- Password stored in `password.conf` with 600 permissions
- Only user can read password
- Script uses sudo with validation

## 📝 Configuration Files

### Launcher Config
```
/Applications/AutoCAD 2026 Launcher.app/Contents/Resources/password.conf
```

### Kill App Config
```
/Applications/Kill AutoCAD.app/Contents/Resources/kill_password.conf
```

### License File
```
/usr/local/flexnetserver/license.dat
```

## 🛠️ Technical Details

### Ports Used
- **27080**: License Server (lmgrd)

### Running Processes
- `lmgrd`: License Manager Daemon
- `adskflex`: Autodesk Vendor Daemon
- `AutoCAD 2026.app/Contents/MacOS/AutoCAD`: AutoCAD main

### Environment Variables
```bash
LM_LICENSE_FILE=27080@127.0.0.1
ADSKFLEX_LICENSE_FILE=27080@127.0.0.1
```

## 📄 License

MIT License - See LICENSE file

Note: AutoCAD is a trademark of Autodesk, Inc.
FlexNet is a trademark of Flexera Software LLC.
This project is not affiliated with Autodesk or Flexera.

## 🤝 Contributing

Feel free to fork and modify for your own use.

## 🐛 Issues

If you have problems:
1. Run diagnostic: Check `diagnose.sh`
2. Check logs: `tail -f /tmp/autocad_launcher.log`
3. Read manual: `README.txt`

---

**Created:** February 6, 2026  
**Language:** English / Indonesian  
**Platform:** macOS
