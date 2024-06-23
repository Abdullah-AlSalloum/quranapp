import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quranapp/colors.dart';
import 'package:quranapp/screens/details.dart';


class SurahTab extends StatefulWidget {
  const SurahTab({super.key});

  @override
  State<SurahTab> createState() => _SurahTabState();
}

class _SurahTabState extends State<SurahTab> {
  List<dynamic> quraninfo = [];

  @override
  void initState() {
    super.initState();
    fetchQuranInfo(); // Fetch Quran information when the widget initializes
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: quraninfo
          .isEmpty // Display loading indicator if data is not yet loaded
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: surahnames(), // Display the list of surahs
      ),
    );
  }

  ListView surahnames() {
    return ListView.builder(
      itemCount: quraninfo.length,
      itemBuilder: (context, index) {
        final surahData = quraninfo[index];
        String wordToRemove =
            'سُورَةُ'; // Arabic word to remove from surah name
        final surahName = surahData['name'].toString().replaceAll(
            wordToRemove, ''); // Remove the Arabic word from surah name
        final surahNumber = surahData['number'].toString();
        final englishName = surahData['englishName'].toString();
        final revelationType = surahData['revelationType'].toString();
        final TranslatedName = surahData['englishNameTranslation'].toString();
        final numberOfAyahs = surahData['numberOfAyahs'].toString();

        return GestureDetector(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => DetailScreen(
                  nameOfSurah: englishName,
                  TranslatedNsme: TranslatedName,
                  revelationType: revelationType,
                  numberOfAyahs:
                  numberOfAyahs,
                  surahNumber: surahNumber,))); // Navigate to detail screen on tap
          },
          child: ListTile(
            title: Row(
              children: [
                Stack(
                  children: [
                    SvgPicture.asset(
                        'assets/svgs/nomor-surah.svg'), // SVG icon for surah number
                    SizedBox(
                      height: 36,
                      width: 36,
                      child: Center(
                        child: Text(
                          surahNumber,
                          style: GoogleFonts.poppins(
                              color: Colors.white, fontWeight: FontWeight.w500),
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        englishName,
                        style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 16),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            revelationType,
                            style: GoogleFonts.poppins(
                                color: text,
                                fontWeight: FontWeight.w500,
                                fontSize: 12),
                          ),
                          const SizedBox(width: 5),
                          Container(
                            width: 4,
                            height: 4,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(2),
                                color: text),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            '$numberOfAyahs VERSES',
                            style: GoogleFonts.poppins(
                                color: text,
                                fontWeight: FontWeight.w500,
                                fontSize: 12),
                          ),
                        ],
                      ),
                      Divider(
                          color: const Color(0xFF7B80AD)
                              .withOpacity(.35)), // Divider
                    ],
                  ),
                ),
                Text(
                  surahName, // Display the name of the surah
                  style: GoogleFonts.amiri(
                      color: primary,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                Divider(
                    color: const Color(0xFF7B80AD).withOpacity(.35)), // Divider
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> fetchQuranInfo() async {
    final response = await http.get(Uri.parse(
        'http://api.alquran.cloud/v1/meta')); // Fetch Quran information from API

    if (response.statusCode == 200) {
      final decodedResponse = jsonDecode(response.body);
      if (decodedResponse != null &&
          decodedResponse['data'] != null &&
          decodedResponse['data']['surahs'] != null &&
          decodedResponse['data']['surahs']['references'] != null) {
        setState(() {
          quraninfo = decodedResponse['data']['surahs']
          ['references']; // Set Quran information in the state
        });
      } else {
        throw Exception('Surah data not found in response');
      }
    } else {
      throw Exception(
          'Failed to load data. Status code: ${response.statusCode}');
    }
  }
}
