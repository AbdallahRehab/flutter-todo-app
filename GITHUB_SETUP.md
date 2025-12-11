# 🚀 GitHub Setup Guide

Complete step-by-step instructions for uploading your Flutter To-Do App to GitHub.

---

## 📋 Prerequisites

Before you begin, make sure you have:

- ✅ Git installed on your computer
- ✅ A GitHub account
- ✅ Your project ready with all changes committed
- ✅ Screenshots added to `assets/screenshots/`
- ✅ Demo GIF/video added to `assets/demo/`
- ✅ Personal information updated in README.md

---

## 🔧 Step 1: Initialize Git Repository (if not already done)

If your project doesn't have Git initialized yet:

```bash
# Navigate to your project directory
cd /Users/abdallahrehab/projects/riverpod_demo

# Initialize Git repository
git init

# Check git status
git status
```

---

## 📝 Step 2: Configure Git (First Time Setup)

If you haven't configured Git before:

```bash
# Set your name
git config --global user.name "AbdallahRehab"

# Set your email (use your GitHub email)
git config --global user.email "abdorehab95@gmail.com"

# Verify configuration
git config --list
```

---

## 📁 Step 3: Stage All Files

Add all your project files to Git:

```bash
# Add all files to staging area
git add .

# Verify what will be committed
git status
```

---

## 💬 Step 4: Create Initial Commit

Commit your changes with a descriptive message:

```bash
# Initial commit with conventional commit format
git commit -m "chore: initialize Flutter To-Do app with Riverpod state management

- Complete task management with CRUD operations
- Smart notification system with reminders
- Beautiful UI with animations and gradients
- Hive local storage for persistence
- GoRouter navigation with deep linking
- RTL support with Arabic locale
- Motivational UX with celebration effects"
```

Or use a simpler commit message:

```bash
git commit -m "feat: initial release of Smart To-Do App v1.0.0"
```

---

## 🌐 Step 5: Create GitHub Repository

### Option A: Using GitHub Website

1. Go to [github.com](https://github.com)
2. Click the **+** icon in the top right
3. Select **New repository**
4. Fill in the details:
   - **Repository name**: `flutter-todo-app` or `smart-todo-app`
   - **Description**: "A beautiful Flutter task management app with smart notifications"
   - **Visibility**: Choose **Public** (for portfolio)
   - ⚠️ **DO NOT** initialize with README, .gitignore, or license (you already have these)
5. Click **Create repository**

### Option B: Using GitHub CLI (if installed)

```bash
# Install GitHub CLI (if not installed)
# macOS: brew install gh
# Then authenticate: gh auth login

# Create repository
gh repo create flutter-todo-app --public --source=. --remote=origin
```

---

## 🔗 Step 6: Connect Local Repository to GitHub

After creating the repository on GitHub, connect it:

```bash
# Add remote origin (replace YOUR_USERNAME with your GitHub username)
git remote add origin https://github.com/YOUR_USERNAME/flutter-todo-app.git

# Verify remote was added
git remote -v
```

**Example:**
```bash
git remote add origin https://github.com/abdallahrehab/flutter-todo-app.git
```

---

## 🚀 Step 7: Push to GitHub

### First Push (Main Branch)

```bash
# Rename branch to main (if currently master)
git branch -M main

# Push to GitHub
git push -u origin main
```

If you encounter authentication issues, you'll need to set up authentication:

### Authentication Options

#### Option 1: Personal Access Token (Recommended)

1. Go to GitHub → Settings → Developer settings → Personal access tokens → Tokens (classic)
2. Generate new token (classic)
3. Select scopes: `repo` (all permissions)
4. Copy the token
5. Use token as password when prompted

#### Option 2: SSH Key

```bash
# Generate SSH key
ssh-keygen -t ed25519 -C "your.email@example.com"

# Start SSH agent
eval "$(ssh-agent -s)"

# Add SSH key
ssh-add ~/.ssh/id_ed25519

# Copy public key
cat ~/.ssh/id_ed25519.pub

# Add to GitHub: Settings → SSH and GPG keys → New SSH key
```

Then update remote URL:
```bash
git remote set-url origin git@github.com:YOUR_USERNAME/flutter-todo-app.git
git push -u origin main
```

---

## 🎯 Step 8: Verify Upload

1. Visit your repository: `https://github.com/YOUR_USERNAME/flutter-todo-app`
2. Check that all files are present
3. Verify README displays correctly
4. Ensure images/screenshots are visible

---

## 📸 Step 9: Add Screenshots (If Not Already Done)

Before pushing, make sure you have screenshots:

```bash
# Create screenshots directory
mkdir -p assets/screenshots
mkdir -p assets/demo

# Add your screenshots to these folders
# Then commit and push:
git add assets/screenshots/ assets/demo/
git commit -m "assets: add app screenshots and demo GIF"
git push origin main
```

---

## ✏️ Step 10: Update Personal Information

Update README.md with your details:

```markdown
## 👨‍💻 Author

**Abdallah Rehab**

- 📧 Email: abdallah.rehab@example.com
- 💼 LinkedIn: [linkedin.com/in/abdallahrehab](https://linkedin.com/in/abdallahrehab)
- 🐱 GitHub: [@abdallahrehab](https://github.com/abdallahrehab)
- 🌐 Portfolio: [abdallahrehab.dev](https://abdallahrehab.dev)
```

Then commit and push:

```bash
git add README.md
git commit -m "docs: update author information in README"
git push origin main
```

---

## 🏷️ Step 11: Create a Release Tag (Optional)

Tag your first release:

```bash
# Create annotated tag
git tag -a v1.0.0 -m "Release version 1.0.0 - Initial public release"

# Push tag to GitHub
git push origin v1.0.0

# Or push all tags
git push origin --tags
```

---

## 📦 Step 12: Create GitHub Release (Optional)

1. Go to your repository on GitHub
2. Click **Releases** → **Create a new release**
3. Select tag: `v1.0.0`
4. Release title: `v1.0.0 - Smart To-Do App Initial Release`
5. Description:
```markdown
## 🎉 Initial Release

### Features
- ✅ Complete task management (CRUD operations)
- 🔔 Smart notification system with reminders
- 🎨 Beautiful gradient UI with animations
- 💾 Offline-first with Hive storage
- 🌍 RTL support with Arabic locale
- 🎉 Motivational UX with celebration effects

### Technologies
- Flutter 3.10+
- Riverpod State Management
- GoRouter Navigation
- Hive Local Storage
- Flutter Local Notifications

### Download
- APK: [Download here](#) (if you upload APK)
```
6. Attach APK file (optional)
7. Click **Publish release**

---

## 🔄 Future Updates Workflow

When you make changes:

```bash
# 1. Make your changes to the code

# 2. Check what changed
git status
git diff

# 3. Stage changes
git add .
# Or stage specific files: git add lib/features/new_feature.dart

# 4. Commit with conventional commit
git commit -m "feat(todos): add task search functionality"

# 5. Push to GitHub
git push origin main
```

---

## 🌿 Working with Branches (Recommended)

For new features:

```bash
# Create and switch to feature branch
git checkout -b feat/search-functionality

# Make your changes and commit
git add .
git commit -m "feat(search): implement task search with filters"

# Push branch to GitHub
git push origin feat/search-functionality

# Create Pull Request on GitHub (optional for personal projects)

# Merge to main
git checkout main
git merge feat/search-functionality
git push origin main

# Delete feature branch (optional)
git branch -d feat/search-functionality
git push origin --delete feat/search-functionality
```

---

## 📊 Step 13: Set Up GitHub Repository Settings

### Topics (Tags)
Go to repository → About (gear icon) → Topics and add:
- `flutter`
- `dart`
- `riverpod`
- `mobile-app`
- `todo-app`
- `state-management`
- `material-design`
- `notifications`
- `hive`
- `portfolio`

### Description
```
A beautiful Flutter task management app with smart notifications, animations, and offline-first storage
```

### Website (Optional)
Add link to deployed web version or app store listing

---

## 🎨 Step 14: Customize Repository

### Add Social Preview Image
1. Go to Settings → General
2. Scroll to "Social preview"
3. Upload an image (1280x640px recommended)
4. Use a screenshot or custom banner

### Enable GitHub Pages (For Web Build)
1. Build web version: `flutter build web --release`
2. Go to Settings → Pages
3. Source: Deploy from branch → `gh-pages`
4. Or use GitHub Actions for automatic deployment

---

## 🔍 Step 15: Verify Repository Quality

Check your repository has:
- ✅ Comprehensive README with screenshots
- ✅ LICENSE file (MIT)
- ✅ .gitignore configured properly
- ✅ Clear commit history
- ✅ Topics/tags added
- ✅ Repository description
- ✅ No sensitive data (API keys, tokens)
- ✅ All assets (screenshots, demo GIF)

---

## ⚠️ Troubleshooting

### "Remote origin already exists"
```bash
git remote remove origin
git remote add origin https://github.com/YOUR_USERNAME/flutter-todo-app.git
```

### "Failed to push some refs"
```bash
# Pull first (if remote has changes)
git pull origin main --rebase

# Then push
git push origin main
```

### "Authentication failed"
- Use Personal Access Token instead of password
- Or set up SSH authentication

### Large files error
```bash
# Check file sizes
find . -type f -size +50M

# Use Git LFS for large files
git lfs install
git lfs track "*.apk"
git add .gitattributes
```

---

## 📚 Useful Git Commands

```bash
# View commit history
git log --oneline --graph

# Undo last commit (keep changes)
git reset --soft HEAD~1

# Undo changes to a file
git checkout -- filename

# View changes
git diff

# View remote URL
git remote -v

# Update remote URL
git remote set-url origin NEW_URL

# Clone your repository
git clone https://github.com/YOUR_USERNAME/flutter-todo-app.git
```

---

## 🎯 Quick Reference

### Complete First-Time Setup
```bash
cd /Users/abdallahrehab/projects/riverpod_demo
git init
git add .
git commit -m "feat: initial release of Smart To-Do App v1.0.0"
git branch -M main
git remote add origin https://github.com/YOUR_USERNAME/flutter-todo-app.git
git push -u origin main
```

### Standard Update Workflow
```bash
git add .
git commit -m "type(scope): description"
git push origin main
```

---

## ✅ Post-Upload Checklist

- [ ] Repository is public
- [ ] README displays correctly with images
- [ ] LICENSE file is present
- [ ] All commits follow conventional format
- [ ] Screenshots are visible
- [ ] Demo GIF works
- [ ] Personal info is updated
- [ ] Topics/tags are added
- [ ] Repository description is set
- [ ] No sensitive data exposed
- [ ] Social preview image added (optional)
- [ ] Star your own repository 😄

---

## 🎉 You're Done!

Your Flutter To-Do App is now live on GitHub! 🚀

**Share your repository:**
- Add to LinkedIn projects
- Include in resume/CV
- Share on Twitter/X with #FlutterDev #Flutter
- Add to portfolio website

**Repository URL format:**
```
https://github.com/YOUR_USERNAME/flutter-todo-app
```

---

**Good luck with your portfolio! 💪**
