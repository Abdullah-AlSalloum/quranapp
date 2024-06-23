import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:quranapp/models/bookmark_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookmarkProvider with ChangeNotifier {
  List<BookmarkModel> _bookmarks = [];

  List<BookmarkModel> get bookmarks => _bookmarks;

  BookmarkProvider() {
    _loadBookmarks();
  }

  void addBookmark(BookmarkModel bookmark) {
    _bookmarks.add(bookmark);
    _saveBookmarks();
    notifyListeners();
  }

  void removeBookmark(BookmarkModel bookmark) {
    _bookmarks.removeWhere((item) => item.audio == bookmark.audio);
    _saveBookmarks();
    notifyListeners();
  }

  bool bookmarkExists(String audio) {
    return _bookmarks.any((bookmark) => bookmark.audio == audio);
  }

  Future<void> _loadBookmarks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? bookmarksString = prefs.getString('bookmarks');
    if (bookmarksString != null) {
      List<dynamic> bookmarkList = json.decode(bookmarksString);
      _bookmarks =
          bookmarkList.map((json) => BookmarkModel.fromJson(json)).toList();
      notifyListeners();
    }
  }

  Future<void> _saveBookmarks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> bookmarkList =
        _bookmarks.map((bookmark) => json.encode(bookmark.toJson())).toList();
    await prefs.setString('bookmarks', json.encode(bookmarkList));
  }
}
