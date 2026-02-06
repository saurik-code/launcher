# Release Guide

## Current Version: v1.0.0

## 📦 Download Pre-built Apps

### Option 1: Download Individual Apps

| App | Size | Download |
|-----|------|----------|
| AutoCAD 2026 Launcher | ~178 KB | `AutoCAD-2026-Launcher-v1.0.zip` |
| Kill AutoCAD | ~1.2 MB | `Kill-AutoCAD-v1.0.zip` |

### Option 2: Download Full Package

| Package | Size | Contents |
|---------|------|----------|
| Full Bundle | ~1.4 MB | Both apps + Documentation |

## 📥 Installation

### Step 1: Download
Download the zip file from releases page.

### Step 2: Extract
```bash
# Double-click zip file to extract
# Or use terminal:
unzip AutoCAD-2026-Mac-Launcher-v1.0-Full.zip
```

### Step 3: Move to Applications
```bash
# Drag apps to Applications folder
# Or use terminal:
mv "AutoCAD 2026 Launcher.app" /Applications/
mv "Kill AutoCAD.app" /Applications/
```

### Step 4: Setup Password
```bash
# Edit config files
nano "/Applications/AutoCAD 2026 Launcher.app/Contents/Resources/password.conf"
nano "/Applications/Kill AutoCAD.app/Contents/Resources/kill_password.conf"

# Change PASSWORD=nafaru to your Mac password
```

### Step 5: Run
Double-click **AutoCAD 2026 Launcher** to start!

## 🏷️ Creating GitHub Release

### Step 1: Create Git Tag
```bash
# Navigate to repo
cd ~/Desktop/autocad-2026-mac-launcher

# Create tag
git tag -a v1.0.0 -m "Release version 1.0.0"

# Push tag
git push origin v1.0.0
```

### Step 2: Create Release on GitHub

1. Go to https://github.com/saurik-code/launcher/releases
2. Click "Create a new release"
3. Select tag: `v1.0.0`
4. Release title: `v1.0.0 - Initial Release`
5. Add description:

```markdown
## What's New
- AutoCAD 2026 Launcher with license server management
- Kill AutoCAD for emergency process termination
- Password manager with auto-save
- Duplicate process detection and cleanup

## Downloads
- [AutoCAD-2026-Launcher-v1.0.zip](link) - Launcher only
- [Kill-AutoCAD-v1.0.zip](link) - Kill app only  
- [AutoCAD-2026-Mac-Launcher-v1.0-Full.zip](link) - Full bundle

## Installation
See [README_EN.md](README_EN.md) for installation instructions.
```

6. Upload zip files to release attachments
7. Click "Publish release"

## 🔢 Versioning

We use [Semantic Versioning](https://semver.org/):

- **MAJOR**: Incompatible changes
- **MINOR**: New features (backward compatible)
- **PATCH**: Bug fixes

### Version History

| Version | Date | Changes |
|---------|------|---------|
| v1.0.0 | 2026-02-06 | Initial release |

## 📝 Release Checklist

Before creating a release:

- [ ] Test both apps work correctly
- [ ] Update version in README files
- [ ] Create git tag
- [ ] Build zip files
- [ ] Upload to GitHub releases
- [ ] Write release notes

## 🔄 Auto-Release Script (Optional)

Create `release.sh`:

```bash
#!/bin/bash
VERSION=$1

if [ -z "$VERSION" ]; then
    echo "Usage: ./release.sh v1.0.0"
    exit 1
fi

# Create tag
git tag -a $VERSION -m "Release $VERSION"
git push origin $VERSION

# Create zips
mkdir -p releases
zip -r "releases/AutoCAD-2026-Launcher-$VERSION.zip" "AutoCAD 2026 Launcher.app"
zip -r "releases/Kill-AutoCAD-$VERSION.zip" "Kill AutoCAD.app"

echo "Release $VERSION prepared!"
echo "Now go to GitHub and create the release."
```

Usage:
```bash
chmod +x release.sh
./release.sh v1.0.0
```
