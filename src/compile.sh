#!/bin/bash
# Compile script for AutoCAD 2026 Mac Launcher
# Usage: ./compile.sh

echo "=========================================="
echo "  AutoCAD 2026 Mac Launcher Compiler"
echo "=========================================="
echo ""

# Check if source files exist
if [ ! -f "launcher.applescript" ]; then
    echo "Error: launcher.applescript not found"
    exit 1
fi

if [ ! -f "kill.applescript" ]; then
    echo "Error: kill.applescript not found"
    exit 1
fi

echo "1. Compiling AutoCAD 2026 Launcher..."
rm -rf "/Applications/AutoCAD 2026 Launcher.app"
osacompile -o "/Applications/AutoCAD 2026 Launcher.app" launcher.applescript

if [ $? -eq 0 ]; then
    echo "   ✅ Launcher compiled successfully"
else
    echo "   ❌ Failed to compile launcher"
    exit 1
fi

echo ""
echo "2. Copying icon for Launcher..."
cp "/Applications/Autodesk/AutoCAD 2026/AutoCAD 2026.app/Contents/Resources/acadlogo.icns" \
    "/Applications/AutoCAD 2026 Launcher.app/Contents/Resources/applet.icns" 2>/dev/null || \
echo "   ⚠️  Warning: Could not copy AutoCAD icon, using default"

echo ""
echo "3. Compiling Kill AutoCAD..."
rm -rf "/Applications/Kill AutoCAD.app"
osacompile -o "/Applications/Kill AutoCAD.app" kill.applescript

if [ $? -eq 0 ]; then
    echo "   ✅ Kill app compiled successfully"
else
    echo "   ❌ Failed to compile kill app"
    exit 1
fi

echo ""
echo "4. Copying icon for Kill app..."
cp "/System/Library/CoreServices/CoreTypes.bundle/Contents/Resources/AlertStopIcon.icns" \
    "/Applications/Kill AutoCAD.app/Contents/Resources/applet.icns" 2>/dev/null || \
echo "   ⚠️  Warning: Could not copy Alert icon, using default"

echo ""
echo "5. Setting up resources..."

# Create config files
mkdir -p "/Applications/AutoCAD 2026 Launcher.app/Contents/Resources"
mkdir -p "/Applications/Kill AutoCAD.app/Contents/Resources"

echo "PASSWORD=nafaru" > "/Applications/AutoCAD 2026 Launcher.app/Contents/Resources/password.conf"
chmod 600 "/Applications/AutoCAD 2026 Launcher.app/Contents/Resources/password.conf"

echo "PASSWORD=nafaru" > "/Applications/Kill AutoCAD.app/Contents/Resources/kill_password.conf"
chmod 600 "/Applications/Kill AutoCAD.app/Contents/Resources/kill_password.conf"

echo "   ✅ Config files created"

echo ""
echo "=========================================="
echo "  Compilation Complete!"
echo "=========================================="
echo ""
echo "Apps installed to:"
echo "  /Applications/AutoCAD 2026 Launcher.app"
echo "  /Applications/Kill AutoCAD.app"
echo ""
echo "Next steps:"
echo "  1. Edit password config files"
echo "  2. Test the apps"
echo ""
