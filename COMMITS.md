# 📝 Conventional Commit Messages

This file contains ready-to-use commit messages following the [Conventional Commits](https://www.conventionalcommits.org/) specification.

---

## 🎯 Initial Setup

### First Commit
```bash
git commit -m "chore: initialize Flutter To-Do app with Riverpod state management"
```

### Add Core Dependencies
```bash
git commit -m "chore(deps): add Riverpod, GoRouter, Hive, and notification packages"
```

---

## ✨ Feature Commits

### Task Management
```bash
git commit -m "feat(todos): implement task CRUD operations with Hive persistence"
git commit -m "feat(todos): add task categories and priority system"
git commit -m "feat(todos): implement task filtering (active, completed, all)"
git commit -m "feat(todos): add time tracking with start time and deadlines"
```

### Notifications
```bash
git commit -m "feat(notifications): integrate flutter_local_notifications with timezone support"
git commit -m "feat(notifications): add smart reminders (start, pre-deadline, deadline)"
git commit -m "feat(notifications): implement completion celebration notifications"
git commit -m "feat(notifications): add 'all tasks done' celebration alert"
```

### UI & UX
```bash
git commit -m "feat(ui): implement gradient theme with light and dark mode"
git commit -m "feat(ui): add animated splash screen with gradient transition"
git commit -m "feat(ui): integrate Lottie animations for loading and empty states"
git commit -m "feat(ui): add confetti celebration effect on task completion"
git commit -m "feat(ui): implement shimmer loading animation"
git commit -m "feat(ui): add slidable list items with swipe actions"
git commit -m "feat(ui): implement bottom sheet for task creation"
git commit -m "feat(ui): add circular progress indicators for time tracking"
```

### Navigation
```bash
git commit -m "feat(navigation): integrate GoRouter with type-safe routing"
git commit -m "feat(navigation): implement splash, home, and detail routes"
git commit -m "feat(navigation): add safe back navigation with canPop check"
```

### User Experience
```bash
git commit -m "feat(ux): add motivational messages system with contextual encouragement"
git commit -m "feat(ux): implement tappable pending badge to filter active tasks"
git commit -m "feat(ux): add RTL support with Arabic locale"
git commit -m "feat(ux): integrate Google Fonts (Poppins) typography"
```

---

## 🎨 Style Commits

```bash
git commit -m "style(ui): refine task card layout with improved spacing"
git commit -m "style(ui): update color palette for better contrast"
git commit -m "style(theme): enhance gradient theme colors"
git commit -m "style(icons): add custom app launcher icon"
```

---

## 🐛 Bug Fix Commits

```bash
git commit -m "fix(navigation): resolve GoRouter pop assertion error"
git commit -m "fix(persistence): ensure tasks persist across app restarts"
git commit -m "fix(notifications): resolve iOS foreground notification display"
git commit -m "fix(ui): correct reminder chip visibility logic"
git commit -m "fix(routing): remove unused imports and resolve analyzer warnings"
```

---

## 🔧 Refactor Commits

```bash
git commit -m "refactor(todos): separate data layer with repository pattern"
git commit -m "refactor(state): migrate to Riverpod StateNotifier pattern"
git commit -m "refactor(services): extract notification logic to service layer"
git commit -m "refactor(services): create Hive service for storage abstraction"
git commit -m "refactor(ui): extract reusable widgets from page components"
```

---

## 📚 Documentation Commits

```bash
git commit -m "docs: create comprehensive README with features and screenshots"
git commit -m "docs: add installation and build instructions"
git commit -m "docs: document project structure and architecture"
git commit -m "docs: add MIT license"
git commit -m "docs: create COMMITS.md with conventional commit examples"
git commit -m "docs: add inline code comments for complex logic"
```

---

## 🖼️ Assets Commits

```bash
git commit -m "assets: add app launcher icon and splash assets"
git commit -m "assets: add Lottie animation files for loading states"
git commit -m "assets: create screenshots directory structure"
git commit -m "assets: add demo GIF and app screenshots"
git commit -m "assets: add placeholder images for README"
```

---

## 🧪 Test Commits

```bash
git commit -m "test: add unit tests for TodosNotifier state management"
git commit -m "test: add widget tests for TodoItem component"
git commit -m "test: add integration tests for task CRUD flow"
git commit -m "test: add repository layer tests with mock data"
```

---

## 🚀 Build & Deploy Commits

```bash
git commit -m "build: configure flutter_launcher_icons for app icon generation"
git commit -m "build: update Android build configuration"
git commit -m "build: configure iOS deployment target and permissions"
git commit -m "build: add web build configuration"
git commit -m "ci: add GitHub Actions workflow for automated builds"
```

---

## 🔄 Chore Commits

```bash
git commit -m "chore: update dependencies to latest versions"
git commit -m "chore: run flutter pub upgrade"
git commit -m "chore: generate Hive type adapters"
git commit -m "chore: update .gitignore with Flutter best practices"
git commit -m "chore: clean up unused imports and files"
git commit -m "chore: format code with dart format"
```

---

## 🏷️ Release Commits

```bash
git commit -m "release: v1.0.0 - initial public release"
git commit -m "release: v1.1.0 - add notification system and animations"
git commit -m "release: v1.2.0 - add categories and priority system"
```

---

## 📦 Multi-Step Workflow Example

### Complete Feature Implementation
```bash
# 1. Create feature branch
git checkout -b feat/add-notifications

# 2. Commit feature implementation
git commit -m "feat(notifications): add notification service with timezone support"

# 3. Commit UI integration
git commit -m "feat(ui): add reminder selection chips to task form"

# 4. Commit tests
git commit -m "test(notifications): add unit tests for notification scheduling"

# 5. Commit documentation
git commit -m "docs(notifications): document notification permission setup"

# 6. Merge to main
git checkout main
git merge feat/add-notifications
```

---

## 🎯 Commit Message Best Practices

### Structure
```
<type>(<scope>): <subject>

<body> (optional)

<footer> (optional)
```

### Types
- **feat**: New feature
- **fix**: Bug fix
- **docs**: Documentation changes
- **style**: Code style changes (formatting, no logic change)
- **refactor**: Code refactoring
- **test**: Adding or updating tests
- **chore**: Maintenance tasks
- **build**: Build system or dependencies
- **ci**: CI/CD configuration
- **perf**: Performance improvements
- **revert**: Revert previous commit

### Scopes
- **todos**: Task management features
- **notifications**: Notification system
- **ui**: User interface components
- **navigation**: Routing and navigation
- **state**: State management
- **services**: Service layer
- **deps**: Dependencies
- **ux**: User experience improvements

### Subject Guidelines
- Use imperative mood ("add" not "added" or "adds")
- Don't capitalize first letter
- No period at the end
- Limit to 50 characters
- Be clear and concise

### Examples of Good Commits
✅ `feat(todos): add drag-and-drop reordering`  
✅ `fix(notifications): resolve timezone offset calculation`  
✅ `docs: update README with installation steps`  
✅ `refactor(ui): extract TaskCard widget component`  
✅ `test(todos): add unit tests for filtering logic`  

### Examples of Bad Commits
❌ `update stuff`  
❌ `fix bug`  
❌ `WIP`  
❌ `changes`  
❌ `Fixed the thing that was broken`  

---

## 🔄 Typical Development Workflow

```bash
# Initial setup
git init
git add .
git commit -m "chore: initialize Flutter To-Do app with Riverpod"

# Add features incrementally
git add lib/features/todos/
git commit -m "feat(todos): implement task CRUD with Hive persistence"

git add lib/core/services/notification_service.dart
git commit -m "feat(notifications): add smart notification system"

git add lib/features/todos/presentation/widgets/
git commit -m "feat(ui): add animated task cards with swipe actions"

# Add documentation
git add README.md
git commit -m "docs: create comprehensive README with setup instructions"

git add assets/screenshots/
git commit -m "assets: add app screenshots for documentation"

# Final polish
git add .
git commit -m "style(ui): refine spacing and typography"

git commit -m "chore: clean up unused imports and format code"

# Prepare for release
git commit -m "docs: finalize documentation for v1.0.0 release"
git tag -a v1.0.0 -m "Release version 1.0.0"
```

---

**Use these commit messages to maintain a clean, professional Git history! 🎯**
