import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../app/UI/home/views/home_view.dart';
import '../app/UI/home/controllers/home_controller.dart';

class EventCard extends StatelessWidget {
  final EventItem item;
  final Color maroon;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final String groupLink;

  const EventCard({
    super.key,
    required this.item,
    required this.maroon,
    required this.onTap,
    required this.onEdit,
    this.groupLink = "https://chat.whatsapp.com/LhGIftzcQYA8lXG4pr5KOn",
  });

  Future<void> _shareToWhatsApp(BuildContext context) async {
    final message =
        '*${item.title}*\n${item.date}\n${item.time}\n${item.location}\n\nYuk ikut kegiatan ini bersama tim!';

    Uri uriToLaunch;

    if (groupLink.isNotEmpty) {
      final encodedMessage = Uri.encodeComponent(message);
      final encodedGroupLink = Uri.encodeComponent(groupLink);
      uriToLaunch = Uri.parse(
        "https://wa.me/?text=$encodedMessage%0A$encodedGroupLink",
      );
    } else {
      uriToLaunch = Uri.parse(
        "https://wa.me/?text=${Uri.encodeComponent(message)}",
      );
    }

    if (await canLaunchUrl(uriToLaunch)) {
      await launchUrl(uriToLaunch, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Gagal membuka WhatsApp."),
          backgroundColor: maroon,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: maroon.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: maroon,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 6),
              Text(item.date, style: const TextStyle(color: Colors.black87)),
              Text(item.time, style: const TextStyle(color: Colors.grey)),
              const SizedBox(height: 4),
              Text(
                item.location,
                style: const TextStyle(color: Colors.black54),
              ),
              AnimatedCrossFade(
                duration: const Duration(milliseconds: 300),
                firstChild: const SizedBox.shrink(),
                secondChild: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: onEdit,
                            icon: const Icon(Icons.edit, size: 18),
                            label: const Text("Edit"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: maroon,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => _shareToWhatsApp(context),
                            icon: const Icon(Icons.share, size: 18),
                            label: const Text("Bagikan"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green[700],
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                crossFadeState: item.expanded
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
