# 🎨 Design Specifications - Quick Reference

## Color Palette

### Primary Gradient
```dart
LinearGradient(
  colors: [
    Color(0xFF9D50BB), // Purple
    Color(0xFFFF6B9D), // Pink  
    Color(0xFF4E8FFF), // Blue
  ],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
)
```

### Semantic Colors
| Color | Hex | Usage |
|-------|-----|-------|
| Success Green | `#4CAF50` | Completed tasks, success messages |
| Warning Amber | `#FF9800` | High priority, warnings |
| Error Red | `#EF5350` | Urgent priority, delete actions |
| Playful Orange | `#FF7043` | Medium priority |
| Calm Lavender | `#B39DDB` | Low priority, category tags |

### Neutral Colors
| Color | Hex | Usage |
|-------|-----|-------|
| Background Light | `#F8F9FA` | Page background |
| Card Background | `#FFFFFF` | Cards, modals |
| Text Primary | `#1A1A1A` | Main text |
| Text Secondary | `#757575` | Hints, labels |
| Divider | `#E0E0E0` | Separators |

---

## Typography

### Font Families
- **Headings**: Poppins
- **Body**: Inter
- **Locale**: Arabic with RTL support

### Text Styles
```dart
// Large Title
GoogleFonts.poppins(
  fontSize: 32,
  fontWeight: FontWeight.bold,
  color: AppTheme.textPrimary,
)

// Title
GoogleFonts.poppins(
  fontSize: 20,
  fontWeight: FontWeight.w600,
  color: AppTheme.textPrimary,
)

// Body
GoogleFonts.inter(
  fontSize: 16,
  fontWeight: FontWeight.normal,
  color: AppTheme.textPrimary,
)

// Caption
GoogleFonts.inter(
  fontSize: 14,
  fontWeight: FontWeight.normal,
  color: AppTheme.textSecondary,
)
```

---

## Spacing System

### Padding/Margin
- **Tiny**: 4px
- **Small**: 8px
- **Medium**: 16px
- **Large**: 24px
- **XLarge**: 32px

### Border Radius
```dart
const BorderRadius.all(Radius.circular(20)); // Cards
const BorderRadius.all(Radius.circular(16)); // Buttons
const BorderRadius.all(Radius.circular(12)); // Chips
```

---

## Shadows

### Card Shadow
```dart
BoxShadow(
  color: Colors.black.withOpacity(0.08),
  blurRadius: 20,
  offset: Offset(0, 4),
)
```

### Floating Button Shadow
```dart
BoxShadow(
  color: AppTheme.gradientMiddle.withOpacity(0.3),
  blurRadius: 20,
  offset: Offset(0, 8),
)
```

---

## Animation Durations

| Animation | Duration | Curve |
|-----------|----------|-------|
| Page Transition | 300ms | easeInOut |
| List Item Fade | 375ms | easeOut |
| Button Scale | 200ms | easeInOut |
| Checkbox Toggle | 600ms | elasticOut |
| Progress Ring | 500ms | easeInOut |
| Confetti | 3000ms | linear |
| Bottom Sheet | 250ms | easeOut |

---

## Component Specs

### Task Card
```
Height: Auto (min 80px)
Padding: 16px
Margin: 8px horizontal, 8px vertical
Background: White
Border Radius: 20px
Shadow: 0px 4px 20px rgba(0,0,0,0.08)
```

### Progress Ring
```
Radius: 28px
Line Width: 4px
Animation: 500ms
Colors: Priority-based
  - Green: Completed
  - Red: Overdue
  - Amber: <25% time remaining
  - Purple: Normal
```

### Priority Badge
```
Padding: 8px horizontal, 4px vertical
Border Radius: 8px
Font Size: 11px
Font Weight: 600
Colors:
  - Urgent: Red (#EF5350)
  - High: Amber (#FF9800)
  - Medium: Orange (#FF7043)
  - Low: Lavender (#B39DDB)
```

### Motivational Card
```
Padding: 16px
Margin: 16px
Background: Primary Gradient
Border Radius: 20px
Shadow: Card Shadow
Icon Size: 28px
Text Color: White
Font Size: 16px
Font Weight: 600
```

### Floating Action Button
```
Background: Gradient Middle (#FF6B9D)
Foreground: White
Elevation: 8
Padding: 16px vertical
Border Radius: 16px
Shadow: Floating Button Shadow
Icon: 24px
```

### Bottom Sheet
```
Border Radius: 24px top corners
Background: White
Initial Size: 0.9
Max Size: 0.95
Min Size: 0.5
Padding: 24px
Handle Bar: 40px × 4px, 8px margin
```

---

## State Colors

### Task States
| State | Color | Icon |
|-------|-------|------|
| Active | Purple Gradient | schedule_rounded |
| Completed | Green | check_circle_rounded |
| Overdue | Red | warning_rounded |

### Priority Colors
| Priority | Background | Border | Text |
|----------|-----------|--------|------|
| Urgent | rgba(239,83,80,0.15) | rgba(239,83,80,1) | #EF5350 |
| High | rgba(255,152,0,0.15) | rgba(255,152,0,1) | #FF9800 |
| Medium | rgba(255,112,67,0.15) | rgba(255,112,67,1) | #FF7043 |
| Low | rgba(179,157,219,0.15) | rgba(179,157,219,1) | #B39DDB |

---

## Icons

### System Icons (Material)
- **Add Task**: `add_task_rounded`
- **Completed**: `check_circle_rounded`
- **Pending**: `pending_actions`
- **Delete**: `delete_rounded`
- **Edit**: `edit_calendar_rounded`
- **Priority**: `flag_rounded`
- **Time**: `schedule_rounded`
- **Start**: `play_circle_outline_rounded`
- **Warning**: `warning_rounded`
- **Success**: `celebration`
- **Motivational**: `auto_awesome`
- **Category**: `label_outline`

---

## Micro-Interactions

### Tap Feedback
```dart
InkWell(
  borderRadius: AppTheme.cardRadius,
  onTap: () {},
  child: widget,
)
```

### Haptic Feedback
- **Task Complete**: Medium impact
- **Delete**: Heavy impact
- **Add**: Light impact

### Success Snackbar
```dart
SnackBar(
  content: Text(message),
  backgroundColor: AppTheme.successGreen,
  behavior: SnackBarBehavior.floating,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(12),
  ),
  duration: Duration(seconds: 2),
)
```

---

## Responsive Breakpoints

### Screen Sizes
- **Mobile**: < 600px
- **Tablet**: 600px - 1200px
- **Desktop**: > 1200px

### Adaptive Layouts
```dart
// Mobile: Stack layout
// Tablet: 2-column grid
// Desktop: 3-column grid + sidebar
```

---

## Accessibility

### Color Contrast Ratios
- **Text Primary on White**: 12.63:1 (AAA)
- **Text Secondary on White**: 4.61:1 (AA)
- **White on Purple**: 4.5:1 (AA)

### Touch Targets
- **Minimum**: 48px × 48px
- **Recommended**: 56px × 56px for primary actions

### Screen Reader Labels
```dart
Semantics(
  label: 'عنوان المهمة',
  button: true,
  child: widget,
)
```

---

## Animation Examples

### List Item Entry
```dart
AnimationConfiguration.staggeredList(
  position: index,
  duration: Duration(milliseconds: 375),
  child: SlideAnimation(
    verticalOffset: 50.0,
    child: FadeInAnimation(
      child: TodoItem(),
    ),
  ),
)
```

### Button Bounce
```dart
ElevatedButton()
  .animate()
  .scale(
    delay: 100.ms,
    duration: 300.ms,
  )
```

### Confetti Burst
```dart
ConfettiWidget(
  confettiController: controller,
  blastDirectionality: BlastDirectionality.explosive,
  particleDrag: 0.05,
  emissionFrequency: 0.05,
  numberOfParticles: 50,
  gravity: 0.3,
  shouldLoop: false,
)
```

---

## Message Templates

### Motivational Quotes
```
أنت تقوم بعمل رائع! 🌟
خطوة واحدة أقرب للنجاح! 💪
استمر في التقدم! 🚀
أنت بطل حقيقي! 🏆
```

### Completion Messages
```
رائع! مهمة أخرى مكتملة! ✅
أحسنت! واصل التقدم! 🎉
ممتاز! أنت في النار! 🔥
```

### Celebration Messages
```
مذهل! أكملت جميع المهام! 🎉🎊
أنت بطل! جميع المهام منتهية! 🏆✨
رائع! يوم مثمر! 🌟💪
```

---

**Last Updated**: December 2025
