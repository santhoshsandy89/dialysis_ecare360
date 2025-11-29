/// Application route constants
class AppRoutes {
  // Auth Routes
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String resetPassword = '/reset-password';
  static const String usernameLogin = '/login';
  static const String password = '/password';
  static const String combinedLogin = '/login';

  // Main App Routes
  static const String home = '/home';
  static const String profile = '/profile';
  static const String settings = '/settings';
  static const String notifications = '/notifications';
  static const String floorSelection = '/floor-selection';
  static const String bookAppointment = '/book-appointment';

  // Feature Routes
  static const String dashboard = '/dashboard';
  static const String patients = '/patients';
  static const String appointments = '/appointments';
  static const String reports = '/reports';
  static const String billing = '/billing';
  static const String scheduleTreatment = '/schedule-treatment';

  // Nested Routes
  static const String patientDetails = '/patients/:id';
  static const String appointmentDetails = '/appointments/:id';
  static const String reportDetails = '/reports/:id';

  // Settings Routes
  static const String accountSettings = '/settings/account';
  static const String privacySettings = '/settings/privacy';
  static const String notificationSettings = '/settings/notifications';
  static const String about = '/settings/about';

  // Error Routes
  static const String notFound = '/404';
  static const String serverError = '/500';
  static const String networkError = '/network-error';
}
