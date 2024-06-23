import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:quranapp/models/Surah_en_response_model.dart';
import 'package:quranapp/models/Surah_response_model.dart';

class QuranApiService {
  static Future<SurahResponseModel> fetchQuranArabicInfo(
      String surahNumber) async {
    final response = await http.get(Uri.parse(
        'http://api.alquran.cloud/v1/surah/${surahNumber}/ar.abdulbasitmurattal'));
    if (response.statusCode == 200) {
      return surahResponseModelFromJson(response.body);
    } else {
      throw Exception(
          'Failed to load data. Status code: ${response.statusCode}');
    }
  }

  static Future<SurahEnResponseModel> fetchQuranEnglishInfo(
      String surahNumber) async {
    final response = await http.get(
        Uri.parse('http://api.alquran.cloud/v1/surah/${surahNumber}/en.asad'));
    if (response.statusCode == 200) {
      return surahEnResponseModelFromJson(response.body);
    } else {
      throw Exception(
          'Failed to load data. Status code: ${response.statusCode}');
    }
  }
}
