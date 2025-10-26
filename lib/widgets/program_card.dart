import 'package:flutter/material.dart';
import '../../models/program_model.dart';

class ProgramCard extends StatelessWidget {
  final ProgramModel item;
  final Color maroon;

  const ProgramCard({
    super.key,
    required this.item,
    required this.maroon,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWide = screenWidth > 900;

    // Penyesuaian tampilan berdasarkan lebar layar
    final double titleSize = isWide ? 18 : screenWidth < 400 ? 14 : 16;
    final double descSize = isWide ? 14 : 12.5;
    final double paddingScale = isWide ? 18 : screenWidth < 400 ? 12 : 14;

    // Warna status otomatis
    Color statusColor;
    switch (item.status) {
      case "Sedang Berlangsung":
        statusColor = Colors.green;
        break;
      case "Selesai":
        statusColor = Colors.grey;
        break;
      case "Akan Datang":
        statusColor = Colors.orange;
        break;
      default:
        statusColor = Colors.blueGrey;
    }

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: isWide ? 900 : double.infinity, // 🔹 Full di laptop
        ),
        child: Card(
          elevation: 3,
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          child: Padding(
            padding: EdgeInsets.all(paddingScale),
            child: IntrinsicHeight(
              child: Column(
                mainAxisSize: MainAxisSize.min, // 🔹 Menyesuaikan isi card
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 🔸 Judul
                  Text(
                    item.title,
                    style: TextStyle(
                      color: maroon,
                      fontWeight: FontWeight.bold,
                      fontSize: titleSize,
                    ),
                  ),

                  const SizedBox(height: 6),

                  // 🔸 Deskripsi
                  Text(
                    item.description,
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: descSize,
                      height: 1.4,
                    ),
                  ),

                  const SizedBox(height: 10),

                  // 🔸 Baris bawah (Tanggal dan Status)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // 📅 Tanggal
                      Flexible(
                        child: Text(
                          "📅 ${item.date}",
                          style: const TextStyle(
                            color: Colors.black54,
                            fontSize: 12,
                            fontStyle: FontStyle.italic,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),

                      const SizedBox(width: 8),

                      // 🟩 Status (otomatis sesuai tanggal)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: statusColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          item.status,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
