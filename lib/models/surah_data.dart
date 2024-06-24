import 'package:quranapp/models/Surah_response_model.dart' as SurahResponse;
import 'package:quranapp/models/Surah_en_response_model.dart' as SurahEnResponse;

class Surah {
  final int number;
  final String name;
  String englishName; // Changed to non-final to update later

  Surah({
    required this.number,
    required this.name,
    required this.englishName,
  });

  factory Surah.fromSurahResponseModel(SurahResponse.Data data) {
    return Surah(
      number: data.number ?? 0,
      name: data.name ?? '',
      englishName: '',
    );
  }

  factory Surah.fromSurahEnResponseModel(SurahEnResponse.Data data) {
    return Surah(
      number: data.number ?? 0,
      name: data.name ?? '',
      englishName: data.englishName ?? '',
    );
  }
}

// List to hold all Surahs
List<Surah> surahs = [];

// Initialize Surahs from API response
void initializeSurahs(List<SurahResponse.Data> arabicSurahs, List<SurahEnResponse.Data> englishSurahs) {
  surahs.clear(); // Clear previous surahs if any

  // Ensure both lists are of the same length
  if (arabicSurahs.length != englishSurahs.length) return;

  for (int i = 0; i < arabicSurahs.length; i++) {
    Surah surah = Surah.fromSurahResponseModel(arabicSurahs[i]);
    surah.englishName = englishSurahs[i].englishName ?? '';
    surahs.add(surah);
  }
}

// Function to search for surahs based on query
List<Surah> searchSurahs(String query) {
  final normalizedQuery = query.toLowerCase();

  return surahs.where((surah) =>
      surah.name.toLowerCase().contains(normalizedQuery) ||
      surah.englishName.toLowerCase().contains(normalizedQuery)).toList();
}
