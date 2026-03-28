class AppConstants {
  static const String appName = 'PS-CRM';
  static const String appVersion = '1.0.0';

  // API Configuration
  // Use 10.0.2.2 for Android emulator, localhost for desktop
  static const String baseUrl = 'http://localhost:5000/api';
  static const int connectTimeout = 15000; // ms
  static const int receiveTimeout = 15000; // ms

  // Endpoints
  static const String authRegister = '/auth/register';
  static const String authLogin = '/auth/login';
  static const String authLogout = '/auth/logout';
  static const String authOfficers = '/auth/officers';
  static const String authOfficersPending = '/auth/officers/pending';
  static const String authApproveOfficer = '/auth/officers/:id/approve';
  static const String authRejectOfficer = '/auth/officers/:id/reject';

  static const String complaintsSubmit = '/complaints';
  static const String complaintsGetAll = '/complaints';
  static const String complaintsGetMy = '/complaints/my';
  static const String complaintsGetAssigned = '/complaints/assigned';
  static const String complaintsTrack = '/complaints/track';
  static const String complaintsClassify = '/complaints/classify';

  static const String dashboardPublic = '/dashboard/public';
  static const String dashboardStats = '/dashboard/stats';

  static const String feedbackSubmit = '/feedback';

  // Storage Keys
  static const String storageKeyUser = 'user';
  static const String storageKeyToken = 'token';
  static const String storageKeyTheme = 'theme';
  static const String storageKeyLanguage = 'language';

  // Roles
  static const String roleCitizen = 'citizen';
  static const String roleOfficer = 'officer';
  static const String roleAdmin = 'admin';

  // Complaint Status
  static const String statusPending = 'Pending';
  static const String statusInProgress = 'In Progress';
  static const String statusResolved = 'Resolved';
  static const String statusEscalated = 'Escalated';

  // Urgency Levels
  static const String urgencyHigh = 'High';
  static const String urgencyMedium = 'Medium';
  static const String urgencyLow = 'Low';

  // Categories
  static const List<String> categories = [
    'Sanitation',
    'Roads',
    'Water',
    'Electricity',
    'Health',
    'Education',
    'Infrastructure',
    'Environment',
    'Finance',
    'Administration',
    'Food Safety',
    'Safety',
    'Animal Welfare',
    'Encroachment',
    'Signage',
    'Other',
  ];

  // Default values
  static const int pageSize = 10;
  static const Duration tokenExpiry = Duration(days: 7);
}
