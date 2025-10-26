import 'package:flutter/material.dart';
import 'home_page.dart';
import 'gallery_page.dart';
import 'profile_page.dart';
import 'program_page.dart';
import 'jadwal_page.dart';

class MainNavigationPage extends StatefulWidget {
  final String username;
  final Color maroon;

  const MainNavigationPage({
    super.key,
    required this.username,
    required this.maroon,
  });

  @override
  _MainNavigationPageState createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      _wrapWithBottomPadding(
        HomePage(username: widget.username, maroon: widget.maroon),
      ),
      _wrapWithBottomPadding(ProgramPage(maroon: widget.maroon)),
      _wrapWithBottomPadding(JadwalPage(maroon: widget.maroon)),
      _wrapWithBottomPadding(GalleryPage(maroon: widget.maroon)),
      _wrapWithBottomPadding(
        ProfilePage(username: widget.username, maroon: widget.maroon),
      ),
    ];

    return Scaffold(
      extendBody: true,
      body: pages[_index],
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _buildFloatingNavBar(),
    );
  }

  // 🔹 Tambahkan padding bawah agar tidak ketutup oleh nav bar
  Widget _wrapWithBottomPadding(Widget page) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 90), // ruang di bawah nav bar
      child: page,
    );
  }

  Widget _buildFloatingNavBar() {
    final icons = [
      Icons.home,
      Icons.assignment,
      Icons.calendar_month,
      Icons.photo_album,
      Icons.person,
    ];

    final labels = ["Home", "Program", "Jadwal", "Gallery", "Profil"];

    return SafeArea(
      minimum: const EdgeInsets.only(bottom: 10),
      child: Padding(
        // 🔹 Jarak kanan-kiri biar gak mepet
        padding: const EdgeInsets.symmetric(horizontal: 22),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          height: 62, // 🔹 agak dibesarin
          decoration: BoxDecoration(
            color: widget.maroon,
            borderRadius: BorderRadius.circular(40),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 3,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(icons.length, (i) {
              final isActive = _index == i;

              return GestureDetector(
                onTap: () => setState(() => _index = i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeInOut,
                  padding: EdgeInsets.symmetric(
                    horizontal: isActive ? 12 : 6,
                    vertical: isActive ? 6 : 4,
                  ),
                  decoration: BoxDecoration(
                    color: isActive
                        ? Colors.white.withOpacity(0.2)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(60),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimatedScale(
                        scale: isActive ? 1.2 : 1.0,
                        duration: const Duration(milliseconds: 100),
                        curve: Curves.easeOutBack,
                        child: Icon(
                          icons[i],
                          color: Colors.white,
                          size: isActive ? 30 : 26, // 🔹 dibesarin dikit
                        ),
                      ),
                      const SizedBox(height: 3),
                      AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 250),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: isActive
                              ? 13
                              : 11, // 🔹 font sedikit lebih besar
                          fontWeight: isActive
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                        child: Text(labels[i]),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
