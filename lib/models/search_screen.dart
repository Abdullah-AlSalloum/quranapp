import 'package:flutter/material.dart';
import 'package:quranapp/colors.dart';
import 'package:quranapp/models/quran_api_service.dart';
import 'package:quranapp/models/Surah_en_response_model.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<Data> _surahs = [];
  bool _isLoading = false;

  void _searchSurahs(String query) async {
    setState(() {
      _isLoading = true;
    });

    try {
      List<Data> surahs = (await quran_api_service.searchSurahs(query)).cast<Data>();
      setState(() {
        _surahs = surahs;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      // Handle the error appropriately
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 120, 23, 189),
        title: TextField(
          onChanged: _searchSurahs,
          decoration: const InputDecoration(
            hintText: 'Search Surahs...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.white),
          ),
          style: TextStyle(color: Colors.white, fontSize: 16.0),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _surahs.length,
              itemBuilder: (context, index) {
                final surah = _surahs[index];
                return ListTile(
                  title: Text(surah.name!),
                  subtitle: Text(surah.englishName!),
                  onTap: () {
                    // Navigate to the Surah detail screen if necessary
                  },
                );
              },
            ),
    );
  }
}
