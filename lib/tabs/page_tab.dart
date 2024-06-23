import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

class PageTab extends StatelessWidget {
  const PageTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('surah',
        style: GoogleFonts.poppins(
          color : const Color(0xFFF9B091),
        ),),
    );
  }
}
