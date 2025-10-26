import 'package:flutter/material.dart';
import '../widgets/event_card.dart';

class HomePage extends StatefulWidget {
  final String username;
  final Color maroon;
  const HomePage({required this.username, required this.maroon, super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class EventItem {
  String title;
  String date;
  String time;
  String location;
  bool expanded;

  EventItem({
    required this.title,
    required this.date,
    required this.time,
    required this.location,
    this.expanded = false,
  });
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  List<EventItem> events = [];
  late AnimationController headerController;
  late Animation<double> headerScale;

  @override
  void initState() {
    super.initState();
    events = [
      EventItem(
        title: 'Latihan Reguler',
        date: 'Sabtu, 18 Okt 2025',
        time: '07:00 - 09:00',
        location: 'Lapangan A',
      ),
      EventItem(
        title: 'Pertandingan Persahabatan',
        date: 'Minggu, 19 Okt 2025',
        time: '08:30 - 10:30',
        location: 'Lapangan B',
      ),
      EventItem(
        title: 'Seleksi Tim Kampus',
        date: 'Kamis, 23 Okt 2025',
        time: '15:00 - 17:00',
        location: 'Lapangan Indoor',
      ),
    ];

    headerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    headerScale = CurvedAnimation(
      parent: headerController,
      curve: Curves.easeOutBack,
    );
    headerController.forward();
  }

  @override
  void dispose() {
    headerController.dispose();
    super.dispose();
  }

  void toggleExpand(int index) {
    setState(() {
      events[index].expanded = !events[index].expanded;
    });
  }

  void _editEvent(int index) {
    final event = events[index];
    final titleController = TextEditingController(text: event.title);
    final dateController = TextEditingController(text: event.date);
    final timeController = TextEditingController(text: event.time);
    final locationController = TextEditingController(text: event.location);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Edit Event',
            style: TextStyle(color: widget.maroon, fontWeight: FontWeight.bold),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Judul Event'),
                ),
                TextField(
                  controller: dateController,
                  decoration: const InputDecoration(labelText: 'Tanggal'),
                ),
                TextField(
                  controller: timeController,
                  decoration: const InputDecoration(labelText: 'Waktu'),
                ),
                TextField(
                  controller: locationController,
                  decoration: const InputDecoration(labelText: 'Lokasi'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: widget.maroon),
              onPressed: () {
                setState(() {
                  event.title = titleController.text;
                  event.date = dateController.text;
                  event.time = timeController.text;
                  event.location = locationController.text;
                });
                Navigator.pop(context);
              },
              child: const Text(
                'Simpan',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Halo, ${widget.username}')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            ScaleTransition(scale: headerScale, child: _buildHeader()),
            const SizedBox(height: 12),
            _buildList(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: widget.maroon,
        onPressed: () {
          setState(() {
            events.insert(
              0,
              EventItem(
                title: 'Event Baru',
                date: 'Segera',
                time: 'Waktu belum ditentukan',
                location: 'TBD',
              ),
            );
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: widget.maroon.withOpacity(0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: widget.maroon.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: widget.maroon,
            child: const Icon(Icons.sports_volleyball, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'MVBT Activity Manager',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: widget.maroon,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Atur latihan, pertandingan, dan notifikasi tim Anda',
                  style: TextStyle(color: Colors.grey[700]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildList() {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: events.length,
      itemBuilder: (context, index) {
        final e = events[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: EventCard(
            item: e,
            maroon: widget.maroon,
            onTap: () => toggleExpand(index),
            onEdit: () => _editEvent(index),
          ),
        );
      },
    );
  }
}
