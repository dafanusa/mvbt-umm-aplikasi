class NotificationModel {
  final String title;
  final String body;
  final String route;
  final Map<String, dynamic> data;

  NotificationModel({
    required this.title,
    required this.body,
    required this.route,
    required this.data,
  });

  factory NotificationModel.fromFCM(Map<String, dynamic> payload) {
    return NotificationModel(
      title: payload['title'] ?? 'Notifikasi',
      body: payload['body'] ?? '',
      route: payload['route'] ?? '/notification',
      data: payload,
    );
  }
}