import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:quranapp/models/Surah_en_response_model.dart' as en;
import 'package:quranapp/models/Surah_response_model.dart' as ar;

class quran_api_service {
  static Future<ar.SurahResponseModel> fetchQuranArabicInfo(String surahNumber) async {
    final response = await http.get(Uri.parse('http://api.alquran.cloud/v1/surah/$surahNumber/ar.abdulbasitmurattal'));
    if (response.statusCode == 200) {
      return ar.surahResponseModelFromJson(response.body);
    } else {
      throw Exception('Failed to load data. Status code: ${response.statusCode}');
    }
  }

  static Future<en.SurahEnResponseModel> fetchQuranEnglishInfo(String surahNumber) async {
    final response = await http.get(Uri.parse('http://api.alquran.cloud/v1/surah/$surahNumber/en.asad'));
    if (response.statusCode == 200) {
      return en.surahEnResponseModelFromJson(response.body);
    } else {
      throw Exception('Failed to load data. Status code: ${response.statusCode}');
    }
  }

  static Future<List<ar.SurahResponseModel>> searchSurahs(String query) async {
    final response = await http.get(Uri.parse('http://api.alquran.cloud/v1/surah'));
    if (response.statusCode == 200) {
      List<ar.SurahResponseModel> surahs = ar.surahResponseModelFromJson(response.body) as List<ar.SurahResponseModel>;
      return surahs.where((surah) => surah.data!.name!.contains(query) || surah.data!.englishName!.contains(query)).toList();
    } else {
      throw Exception('Failed to load data. Status code: ${response.statusCode}');
    }
  }
}
