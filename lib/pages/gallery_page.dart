import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GalleryPage extends StatefulWidget {
  final Color maroon;
  const GalleryPage({super.key, required this.maroon});

  @override
  _GalleryPageState createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fade;
  late Animation<double> _scale;
  int? _selectedIndex;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _scale = Tween<double>(
      begin: 0.95,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onImageTap(int index) {
    setState(() {
      if (_selectedIndex == index) {
        _selectedIndex = null;
      } else {
        _selectedIndex = index;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final bool isPortrait = mq.orientation == Orientation.portrait;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: widget.maroon,
        elevation: 2,
        title: Text(
          'Gallery MVBT UMM',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final double spacing = constraints.maxWidth * 0.02;
            final int crossAxisCount = constraints.maxWidth > 600
                ? 4
                : (isPortrait ? 2 : 3);

            return FadeTransition(
              opacity: _fade,
              child: ScaleTransition(
                scale: _scale,
                child: GridView.builder(
                  padding: EdgeInsets.all(spacing),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: spacing,
                    mainAxisSpacing: spacing,
                  ),
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    final bool isZoomed = _selectedIndex == index;

                    return GestureDetector(
                      onTap: () => _onImageTap(index),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeInOut,
                        transform: Matrix4.identity()
                          ..scale(isZoomed ? 1.1 : 1.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: const Color.fromARGB(
                                255,
                                255,
                                255,
                                255,
                              ).withOpacity(0.2),
                              blurRadius: isZoomed ? 10 : 5,
                              offset: const Offset(2, 2),
                            ),
                          ],
                          image: DecorationImage(
                            image: AssetImage(
                              'assets/gallery${(index % 5) + 1}.jpg',
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
