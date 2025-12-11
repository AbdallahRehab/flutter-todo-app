import 'dart:math';

class MotivationalService {
  static final MotivationalService _instance = MotivationalService._internal();
  factory MotivationalService() => _instance;
  MotivationalService._internal();

  final Random _random = Random();

  // Motivational quotes in Arabic
  final List<String> _quotes = [
    'أنت تقوم بعمل رائع! 🌟',
    'خطوة واحدة أقرب للنجاح! 💪',
    'استمر في التقدم! 🚀',
    'أنت بطل حقيقي! 🏆',
    'النجاح يبدأ بخطوة واحدة 🎯',
    'كل مهمة مكتملة هي إنجاز! ✨',
    'أنت تستحق النجاح! 🌈',
    'اليوم هو يومك! ☀️',
    'الإصرار هو مفتاح النجاح 🔑',
    'أنت أقوى مما تعتقد! 💎',
    'كل يوم فرصة جديدة! 🌸',
    'استمتع برحلة النجاح! 🎨',
    'أنت تصنع الفرق! ⭐',
    'الإنجازات الصغيرة تؤدي لنجاحات كبيرة! 🎪',
    'ثق بنفسك وقدراتك! 🦋',
    'اليوم أفضل من الأمس! 🌺',
    'أنت على الطريق الصحيح! 🛤️',
    'كل لحظة هي بداية جديدة! 🌅',
    'النجاح ينتظرك! 🎁',
    'أنت ملهم! 💫',
  ];

  // Completion messages
  final List<String> _completionMessages = [
    'رائع! مهمة أخرى مكتملة! ✅',
    'أحسنت! واصل التقدم! 🎉',
    'ممتاز! أنت في النار! 🔥',
    'عمل جيد! استمر! 💪',
    'مذهل! واحدة تلو الأخرى! ⚡',
    'أنت تسحقها! 🌟',
    'تمام! إنجاز آخر! ✨',
    'يا له من إنجاز! 🏆',
    'هذا رائع! 🎊',
    'أنت نجم! ⭐',
  ];

  // Celebration messages (when all tasks completed)
  final List<String> _celebrationMessages = [
    'مذهل! أكملت جميع المهام! 🎉🎊',
    'أنت بطل! جميع المهام منتهية! 🏆✨',
    'رائع! يوم مثمر! 🌟💪',
    'إنجاز كامل! أنت رائع! 🎯🔥',
    'مبروك! كل شيء مكتمل! 🎈🎁',
    'يوم نجاح مذهل! 🚀💫',
    'أنت آلة إنتاجية! 🤖✅',
    'إنجاز 100%! مذهل! 💯🌈',
  ];

  // Encouragement for overdue tasks
  final List<String> _overdueEncouragements = [
    'لا تقلق، يمكنك اللحاق! ⏰',
    'ابدأ الآن، ما زال هناك وقت! 🏃',
    'صغيرة خطوة بخطوة! 🐾',
    'ركز على الأهم! 🎯',
    'أنت قادر على ذلك! 💪',
  ];

  // Morning greetings
  final List<String> _morningGreetings = [
    'صباح الخير! لنبدأ يوماً رائعاً! ☀️',
    'صباح النشاط! أنت مستعد! 💪',
    'يوم جديد، فرص جديدة! 🌅',
    'صباح الإنجازات! 🚀',
  ];

  // Evening messages
  final List<String> _eveningMessages = [
    'وقت لإنهاء ما تبقى! 🌙',
    'اللحظات الأخيرة للإنتاجية! ⭐',
    'لنختم اليوم بإنجاز! ✨',
  ];

  // Get random motivational quote
  String getRandomQuote() {
    return _quotes[_random.nextInt(_quotes.length)];
  }

  // Get random completion message
  String getCompletionMessage() {
    return _completionMessages[_random.nextInt(_completionMessages.length)];
  }

  // Get random celebration message
  String getCelebrationMessage() {
    return _celebrationMessages[_random.nextInt(_celebrationMessages.length)];
  }

  // Get encouragement for overdue task
  String getOverdueEncouragement() {
    return _overdueEncouragements[_random.nextInt(
      _overdueEncouragements.length,
    )];
  }

  // Get greeting based on time of day
  String getGreeting() {
    final hour = DateTime.now().hour;

    if (hour >= 5 && hour < 12) {
      return _morningGreetings[_random.nextInt(_morningGreetings.length)];
    } else if (hour >= 17 && hour < 21) {
      return _eveningMessages[_random.nextInt(_eveningMessages.length)];
    } else {
      return getRandomQuote();
    }
  }

  // Get progress-based message
  String getProgressMessage(int completed, int total) {
    if (total == 0) return 'ابدأ بإضافة مهام! 📝';

    final percentage = (completed / total * 100).round();

    if (percentage == 0) {
      return 'لنبدأ! أول خطوة هي الأهم! 🚀';
    } else if (percentage < 25) {
      return 'انطلاقة جيدة! واصل! 🌱';
    } else if (percentage < 50) {
      return 'تقدم رائع! أنت في منتصف الطريق! 🎯';
    } else if (percentage < 75) {
      return 'ممتاز! أكثر من النصف! 💪';
    } else if (percentage < 100) {
      return 'تقريباً هناك! الدفعة الأخيرة! 🏁';
    } else {
      return getCelebrationMessage();
    }
  }

  // Get streak message (for future implementation)
  String getStreakMessage(int days) {
    if (days == 0) return 'ابدأ سلسلتك اليوم! 🔥';
    if (days == 1) return 'يوم واحد! استمر! 🔥';
    if (days < 7) return 'سلسلة $days أيام! رائع! 🔥';
    if (days < 30) return 'سلسلة $days يوم! مذهل! 🔥🔥';
    return 'سلسلة $days يوم! أسطوري! 🔥🔥🔥';
  }

  // Get priority-based encouragement
  String getPriorityMessage(String priority) {
    switch (priority.toLowerCase()) {
      case 'urgent':
      case 'عاجل':
        return 'عاجل! ركز على هذا أولاً! 🚨';
      case 'high':
      case 'عالي':
        return 'أولوية عالية! اهتم بها! ⚠️';
      case 'medium':
      case 'متوسط':
        return 'مهمة مهمة! لا تنساها! 📌';
      default:
        return 'خذها بروية! 😌';
    }
  }

  // Get time-based urgency message
  String getUrgencyMessage(Duration? remainingTime) {
    if (remainingTime == null) return '';

    if (remainingTime.isNegative) {
      return getOverdueEncouragement();
    }

    final hours = remainingTime.inHours;

    if (hours < 1) {
      return 'أقل من ساعة متبقية! أسرع! ⏰';
    } else if (hours < 3) {
      return 'وقت قصير متبقي! ركز! ⏱️';
    } else if (hours < 24) {
      return 'لا يزال لديك وقت، لكن ابدأ الآن! 🕐';
    } else {
      return 'لديك وقت كافٍ، خطط جيداً! 📅';
    }
  }

  // Get emoji based on priority
  String getPriorityEmoji(String priority) {
    switch (priority.toLowerCase()) {
      case 'urgent':
      case 'عاجل':
        return '🔴';
      case 'high':
      case 'عالي':
        return '🟠';
      case 'medium':
      case 'متوسط':
        return '🟡';
      default:
        return '🟢';
    }
  }

  // Get completion percentage emoji
  String getProgressEmoji(int percentage) {
    if (percentage == 0) return '⭕';
    if (percentage < 25) return '🌑';
    if (percentage < 50) return '🌓';
    if (percentage < 75) return '🌔';
    if (percentage < 100) return '🌕';
    return '✅';
  }
}
