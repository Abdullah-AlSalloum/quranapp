import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

class HizbTab extends StatelessWidget {
  const HizbTab({super.key});

  @override
  Widget build(BuildContext context) {
    return  Container(
      child: Text('hizb',
        style: GoogleFonts.poppins(
          color : const Color(0xFFF9B091),
        ),),
    );
  }
}
