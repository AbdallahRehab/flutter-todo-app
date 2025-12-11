# 📸 Screenshots Guide

This directory contains app screenshots for the README and documentation.

## 📋 Required Screenshots

Add the following screenshots to this directory:

### Core Screens (Required)
1. **splash.png** - Animated splash screen with gradient
2. **home.png** - Main task list view with active tasks
3. **add_task.png** - Bottom sheet for adding new tasks
4. **task_detail.png** - Task detail page with edit functionality

### Feature Screenshots (Recommended)
5. **active_filter.png** - Filtered view showing only active tasks
6. **completed.png** - View of completed tasks with checkmarks
7. **notification.png** - Screenshot of notification in action
8. **dark_mode.png** - App in dark theme mode
9. **empty_state.png** - Empty state with Lottie animation

### Optional Screenshots
10. **categories.png** - Different task categories
11. **priorities.png** - Priority levels visualization
12. **reminders.png** - Reminder selection interface
13. **swipe_actions.png** - Slidable list item actions
14. **celebration.png** - Confetti celebration effect

## 📐 Screenshot Specifications

### Recommended Dimensions
- **Mobile**: 1080x2400px or 1080x1920px
- **Tablet**: 1536x2048px
- **Aspect Ratio**: 9:16 or 9:19.5 (standard mobile)

### File Format
- **Format**: PNG (preferred) or JPG
- **Quality**: High resolution for clarity
- **Size**: Keep under 1MB per image (optimize if needed)

### Naming Convention
- Use lowercase with underscores
- Be descriptive: `task_detail.png`, not `screen1.png`
- Include variant suffix if needed: `home_dark.png`

## 📱 How to Take Screenshots

### Using Simulator/Emulator

**iOS Simulator:**
```bash
# Run app in simulator
flutter run -d "iPhone 15 Pro"

# Take screenshot with: Cmd + S
# Or: Device → Trigger Screenshot
```

**Android Emulator:**
```bash
# Run app in emulator
flutter run -d emulator-5554

# Take screenshot with: Cmd + S (Mac) or Ctrl + S (Windows)
# Or use Android Studio: View → Tool Windows → Device File Explorer
```

### Using Physical Device

**iOS:**
- Press Volume Up + Side Button simultaneously
- Find in Photos app

**Android:**
- Press Power + Volume Down simultaneously  
- Find in Gallery → Screenshots

### Using ADB (Android)
```bash
# Take screenshot via ADB
adb shell screencap -p /sdcard/screenshot.png
adb pull /sdcard/screenshot.png ./assets/screenshots/
```

## 🎨 Screenshot Best Practices

### Content Guidelines
- ✅ Show app in use with realistic data
- ✅ Include 3-5 tasks for context
- ✅ Demonstrate key features clearly
- ✅ Use consistent app theme across screenshots
- ✅ Capture various states (loading, empty, full)
- ❌ Avoid empty screens (except for "empty state")
- ❌ Don't include personal/sensitive information
- ❌ Avoid screenshots with system notifications

### Visual Quality
- Use high-resolution devices for capturing
- Ensure good lighting if photographing screen
- Crop out unnecessary UI (status bar optional)
- Maintain consistent dimensions across images
- Consider using device frames for polish

## 🖼️ Image Optimization

After adding screenshots, optimize them:

### Using ImageOptim (macOS)
```bash
# Install ImageOptim
brew install --cask imageoptim

# Optimize all screenshots
open -a ImageOptim assets/screenshots/*.png
```

### Using Online Tools
- [TinyPNG](https://tinypng.com/) - PNG compression
- [Squoosh](https://squoosh.app/) - Image optimizer
- [Compressor.io](https://compressor.io/) - Multi-format

### Using Command Line (ImageMagick)
```bash
# Install ImageMagick
brew install imagemagick

# Resize and optimize
magick splash.png -resize 1080x2400 -quality 85 splash_optimized.png
```

## 📦 After Adding Screenshots

1. Verify images are in place:
```bash
ls -lh assets/screenshots/
```

2. Update README image paths if needed

3. Commit screenshots:
```bash
git add assets/screenshots/
git commit -m "assets: add app screenshots for documentation"
git push origin main
```

4. Check GitHub to ensure images display correctly

## 🎯 Alternative: Use Mockup Tools

Create professional device mockups:

### Online Tools
- **Mockuphone**: https://mockuphone.com/
- **Smartmockups**: https://smartmockups.com/
- **Placeit**: https://placeit.net/
- **Screely**: https://screely.com/

### Design Tools
- **Figma**: Import screenshots and add device frames
- **Sketch**: Use device frame templates
- **Adobe XD**: Device mockup tools

## 📝 Checklist

Before pushing to GitHub:

- [ ] All required screenshots added (splash, home, add_task, detail)
- [ ] Images are high resolution and clear
- [ ] File sizes optimized (under 1MB each)
- [ ] Naming convention followed (lowercase, descriptive)
- [ ] No personal/sensitive information visible
- [ ] Screenshots show app in best state (good data)
- [ ] Images display correctly in README preview
- [ ] Committed and pushed to GitHub

---

**Need help? Check the GITHUB_SETUP.md for full upload instructions!**
