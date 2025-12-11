# 🎬 Demo Files

This directory contains demo videos and GIFs for the README and documentation.

## 📋 Required Files

Add the following demo files to showcase your app:

### Main Demo (Required)
- **demo.gif** - 10-30 second GIF showing key features
  - Task creation
  - Task completion with celebration
  - Swipe actions
  - Filter switching
  - Notification example

### Optional Videos
- **demo.mp4** - Full video demo (1-2 minutes)
- **features.gif** - Specific feature highlights
- **animations.gif** - UI animations showcase

## 🎥 How to Create Demo GIF/Video

### Option 1: Screen Recording → GIF Conversion

#### iOS Simulator (macOS)
```bash
# 1. Start recording
xcrun simctl io booted recordVideo demo.mov

# 2. Use the app (perform key actions)

# 3. Stop recording (Ctrl+C in terminal)

# 4. Convert to GIF using ffmpeg
brew install ffmpeg
ffmpeg -i demo.mov -vf "fps=10,scale=320:-1:flags=lanczos" -c:v gif demo.gif

# Or use higher quality
ffmpeg -i demo.mov -vf "fps=15,scale=480:-1:flags=lanczos" demo.gif
```

#### Android Emulator
```bash
# Start recording (max 3 minutes)
adb shell screenrecord /sdcard/demo.mp4

# Stop with Ctrl+C

# Pull the file
adb pull /sdcard/demo.mp4 ./demo.mp4

# Convert to GIF with ffmpeg
ffmpeg -i demo.mp4 -vf "fps=10,scale=320:-1:flags=lanczos" demo.gif
```

### Option 2: QuickTime Player (macOS)
1. Open QuickTime Player
2. File → New Screen Recording
3. Select iOS Simulator or Android Emulator
4. Click Record
5. Demonstrate app features
6. Stop recording and save as .mov
7. Convert to GIF using online tools or ffmpeg

### Option 3: Android Studio Recording
1. Run app on emulator
2. Click Screen Record button in emulator toolbar
3. Perform actions in app
4. Stop recording
5. Save video file
6. Convert to GIF

### Option 4: Xcode Simulator
1. Simulator → File → Record Screen
2. Demonstrate features
3. Stop recording
4. Save video
5. Convert to GIF

## 🛠️ GIF Creation Tools

### Online Tools (Easiest)
- **EZGIF**: https://ezgif.com/video-to-gif
  - Upload MP4/MOV
  - Set FPS (10-15 recommended)
  - Resize if needed
  - Convert to GIF

- **CloudConvert**: https://cloudconvert.com/mov-to-gif
  - High-quality conversion
  - Multiple format support

- **Kapwing**: https://www.kapwing.com/tools/make-a-gif
  - Video to GIF converter
  - Built-in editing tools

### Desktop Tools
- **LICEcap** (Free): http://www.cockos.com/licecap/
  - Simple GIF recorder
  - Cross-platform

- **Kap** (Free, macOS): https://getkap.co/
  - Beautiful GIF recorder
  - Export to GIF, MP4, WebM

- **ScreenToGif** (Free, Windows): https://www.screentogif.com/
  - Record and edit GIFs
  - Built-in editor

- **Gifski** (macOS): https://gif.ski/
  - High-quality GIF converter
  - Command line or GUI

### Command Line Tools

**FFmpeg (Best Quality)**
```bash
# Install
brew install ffmpeg  # macOS
apt-get install ffmpeg  # Linux

# Basic conversion
ffmpeg -i demo.mov -vf "fps=10,scale=360:-1" demo.gif

# High quality with better compression
ffmpeg -i demo.mov -vf "fps=15,scale=480:-1:flags=lanczos,split[s0][s1];[s0]palettegen[p];[s1][p]paletteuse" demo.gif

# Add slight speedup (1.5x)
ffmpeg -i demo.mov -filter:v "setpts=0.67*PTS,fps=15,scale=480:-1" demo.gif
```

**Gifsicle (Optimization)**
```bash
# Install
brew install gifsicle

# Optimize existing GIF
gifsicle -O3 --colors 256 demo.gif -o demo_optimized.gif

# Reduce file size
gifsicle -O3 --lossy=80 --colors 128 demo.gif -o demo_compressed.gif
```

## 📐 Specifications

### GIF Specifications
- **Duration**: 10-30 seconds (keep it short!)
- **FPS**: 10-15 (smooth but not too large)
- **Dimensions**: 360-600px width (mobile)
- **File Size**: Under 5MB (preferably under 2MB)
- **Format**: GIF or animated WebP
- **Colors**: 128-256 colors

### Video Specifications (if using MP4)
- **Duration**: 30-60 seconds
- **Resolution**: 720p (1280x720) or 1080p
- **Format**: MP4 (H.264)
- **File Size**: Under 10MB

## 🎬 Demo Content Guidelines

### What to Show (Priority Order)
1. **Splash Screen** (2 seconds)
2. **Add Task** - Create a new task with details
3. **Task Completion** - Check off task, see confetti
4. **Swipe Actions** - Edit or delete via swipe
5. **Filtering** - Switch between All/Active/Completed
6. **Task Details** - Open task, show edit screen
7. **Notifications** - Show a notification (if possible)
8. **Categories** - Show different task categories
9. **Dark Mode** - Toggle theme (optional)

### Recording Tips
- 📱 Use clean, demo data (not real personal tasks)
- ⏱️ Keep it concise - highlight key features only
- 🎯 Show smooth, deliberate interactions
- 🌟 Demonstrate the best features
- 🎨 Use the app in its best state
- ⏩ Consider slight speed-up (1.2-1.5x) in editing
- 🔇 Mute any device sounds if recording audio
- ✨ Include wow moments (animations, celebrations)

### Avoid
- ❌ Too long (over 30 seconds)
- ❌ Rushed, jerky movements
- ❌ Empty or half-loaded screens
- ❌ Personal/sensitive information
- ❌ System notifications popping up
- ❌ Poor lighting or blurry screens
- ❌ Visible bugs or errors

## 🎨 Post-Processing

### Trim Video
```bash
# Trim first 5 seconds and last 3 seconds
ffmpeg -i demo.mov -ss 5 -to 27 trimmed.mov
```

### Speed Up
```bash
# 1.5x speed
ffmpeg -i demo.mov -filter:v "setpts=0.67*PTS" demo_fast.mov
```

### Add Text Overlay (Optional)
```bash
# Add title text
ffmpeg -i demo.mov -vf "drawtext=text='Smart To-Do App':fontsize=40:fontcolor=white:x=(w-text_w)/2:y=50" demo_titled.mov
```

### Crop to Focus Area
```bash
# Crop to mobile device area
ffmpeg -i demo.mov -filter:v "crop=1080:2400:0:0" demo_cropped.mov
```

## 📦 File Optimization

### Reduce GIF File Size

**Method 1: Reduce dimensions**
```bash
ffmpeg -i demo.gif -vf "scale=360:-1" demo_small.gif
```

**Method 2: Reduce FPS**
```bash
ffmpeg -i demo.gif -vf "fps=8" demo_slower.gif
```

**Method 3: Reduce colors**
```bash
gifsicle --colors 128 demo.gif > demo_fewer_colors.gif
```

**Method 4: Use lossy compression**
```bash
gifsicle -O3 --lossy=100 demo.gif -o demo_lossy.gif
```

## 📤 Uploading to GitHub

### Direct Upload
```bash
# Add demo files
git add assets/demo/demo.gif
git commit -m "assets: add demo GIF showcasing app features"
git push origin main
```

### Large Files (Over 50MB)
Use Git LFS (Large File Storage):
```bash
# Install Git LFS
brew install git-lfs
git lfs install

# Track large files
git lfs track "*.gif"
git lfs track "*.mp4"

# Commit .gitattributes
git add .gitattributes
git commit -m "chore: configure Git LFS for demo files"

# Add and commit large files
git add assets/demo/
git commit -m "assets: add demo video"
git push origin main
```

### Alternative: Use External Hosting
For very large files, host externally:
- **YouTube** - For full demo videos
- **Vimeo** - Professional video hosting
- **Imgur** - Free GIF hosting
- **Giphy** - GIF hosting with embeds

Then link in README:
```markdown
[![Demo Video](https://img.youtube.com/vi/VIDEO_ID/0.jpg)](https://www.youtube.com/watch?v=VIDEO_ID)
```

## ✅ Checklist

Before pushing to GitHub:

- [ ] Demo GIF created (10-30 seconds)
- [ ] File size under 5MB (optimized)
- [ ] Shows key features clearly
- [ ] No personal information visible
- [ ] Smooth playback without glitches
- [ ] Good quality and resolution
- [ ] Named correctly (demo.gif)
- [ ] Tests in README preview locally
- [ ] Committed and pushed successfully

## 🎯 Example File Structure

```
assets/demo/
├── README.md           # This file
├── demo.gif            # Main demo (Required)
├── demo.mp4            # Full video (Optional)
├── features.gif        # Feature highlights (Optional)
└── raw/                # Keep source files
    ├── demo.mov
    └── demo_uncut.mp4
```

## 🌟 Pro Tips

1. **Record in high quality** - You can always downscale
2. **Multiple takes** - Record several times, pick the best
3. **Use demo data** - Create beautiful sample tasks
4. **Test the GIF** - Make sure it loops smoothly
5. **Check file size** - GitHub has 100MB limit per file
6. **Preview in README** - Test locally before pushing
7. **Keep source files** - Save original video for re-editing

---

**Ready to record? Go showcase your amazing app! 🎬**
