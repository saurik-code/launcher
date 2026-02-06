#!/bin/bash
# Make Release Script for AutoCAD 2026 Mac Launcher
# Usage: ./make-release.sh [version]

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Get version from argument or use default
VERSION=${1:-v1.0.0}
VERSION_NUM=$(echo $VERSION | sed 's/^v//')

echo -e "${GREEN}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}  📦 Creating Release: $VERSION${NC}"
echo -e "${GREEN}═══════════════════════════════════════════════════════════════${NC}"
echo ""

# Verify we're in the right directory
if [ ! -f "README.md" ]; then
    echo -e "${RED}Error: Not in repository root directory${NC}"
    exit 1
fi

# Create releases directory
mkdir -p releases

echo -e "${YELLOW}1. Cleaning old releases...${NC}"
rm -f releases/*.zip

echo ""
echo -e "${YELLOW}2. Creating release packages...${NC}"

# Package 1: Launcher only
echo "   📦 AutoCAD-2026-Launcher-$VERSION.zip"
zip -qr "releases/AutoCAD-2026-Launcher-$VERSION.zip" \
    "AutoCAD 2026 Launcher.app" \
    -x "*.DS_Store" "*/.git/*" "*.zip"

# Package 2: Kill AutoCAD only
echo "   📦 Kill-AutoCAD-$VERSION.zip"
zip -qr "releases/Kill-AutoCAD-$VERSION.zip" \
    "Kill AutoCAD.app" \
    -x "*.DS_Store" "*/.git/*" "*.zip"

# Package 3: Full bundle
echo "   📦 AutoCAD-2026-Mac-Launcher-$VERSION-Full.zip"
zip -qr "releases/AutoCAD-2026-Mac-Launcher-$VERSION-Full.zip" \
    "AutoCAD 2026 Launcher.app" \
    "Kill AutoCAD.app" \
    "README_EN.md" \
    "BUILD.md" \
    "LICENSE" \
    "RELEASE.md" \
    -x "*.DS_Store" "*/.git/*" "*.zip"

# Package 4: Source code
echo "   📦 Source-Code-$VERSION.zip"
zip -qr "releases/Source-Code-$VERSION.zip" \
    "src/" \
    "README_EN.md" \
    "BUILD.md" \
    "LICENSE" \
    "Makefile" \
    -x "*.DS_Store" "*/.git/*" "*.zip"

echo ""
echo -e "${YELLOW}3. Verifying packages...${NC}"
for file in releases/*.zip; do
    if unzip -t "$file" > /dev/null 2>&1; then
        echo -e "   ${GREEN}✓${NC} $(basename "$file")"
    else
        echo -e "   ${RED}✗${NC} $(basename "$file") - CORRUPTED"
    fi
done

echo ""
echo -e "${YELLOW}4. Generating checksums...${NC}"
cd releases
shasum -a 256 *.zip > checksums.txt
cat checksums.txt

echo ""
echo -e "${YELLOW}5. Creating release notes...${NC}"
cd ..
cat > "releases/RELEASE_NOTES-$VERSION.txt" << EOL
AutoCAD 2026 Mac Launcher $VERSION
================================

Release Date: $(date '+%Y-%m-%d')

What's New:
-----------
- Initial release
- AutoCAD 2026 Launcher with license server management
- Kill AutoCAD for emergency process termination
- Password manager with auto-save
- Duplicate process detection and cleanup
- Health monitoring and retry logic

Downloads:
----------
1. AutoCAD-2026-Launcher-$VERSION.zip (178 KB)
   - Launcher app only
   
2. Kill-AutoCAD-$VERSION.zip (1.2 MB)
   - Kill app only
   
3. AutoCAD-2026-Mac-Launcher-$VERSION-Full.zip (1.4 MB)
   - Complete bundle with both apps and documentation
   
4. Source-Code-$VERSION.zip
   - Source code for developers

Installation:
-------------
1. Download the zip file
2. Extract (double-click)
3. Move apps to Applications folder
4. Edit password config files
5. Launch AutoCAD 2026 Launcher

Checksums:
----------
See checksums.txt for SHA256 hashes

Requirements:
-------------
- macOS (tested on Sonoma+)
- AutoCAD 2026 for Mac
- Administrator privileges

Support:
--------
See README_EN.md for troubleshooting
EOL

echo ""
echo -e "${GREEN}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}  ✅ Release $VERSION Created Successfully!${NC}"
echo -e "${GREEN}═══════════════════════════════════════════════════════════════${NC}"
echo ""
echo "Package Summary:"
echo "─────────────────────────────────────────────────────────────────"
ls -lh releases/*.zip
echo ""
echo "Total size: $(du -sh releases/ | cut -f1)"
echo ""
echo -e "${YELLOW}Next Steps:${NC}"
echo ""
echo "1. Commit changes:"
echo "   git add releases/"
echo "   git commit -m 'Release $VERSION'"
echo ""
echo "2. Create tag:"
echo "   git tag -a $VERSION -m 'Release $VERSION'"
echo "   git push origin $VERSION"
echo ""
echo "3. Upload to GitHub:"
echo "   - Go to https://github.com/saurik-code/launcher/releases"
echo "   - Click 'Create a new release'"
echo "   - Select tag: $VERSION"
echo "   - Upload all files from releases/ folder"
echo "   - Publish"
echo ""
echo -e "${GREEN}═══════════════════════════════════════════════════════════════${NC}"
