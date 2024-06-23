import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:quranapp/colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quranapp/models/QuranApiService.dart';
import 'package:quranapp/models/Surah_en_response_model.dart';
import 'package:quranapp/models/Surah_response_model.dart';
import 'package:quranapp/models/bookmark_model.dart';
import 'package:quranapp/models/bookmark_provider.dart';

class DetailScreen extends StatefulWidget {
  final String nameOfSurah;
  final String TranslatedNsme;
  final String numberOfAyahs;
  final String revelationType;
  final String surahNumber;
  const DetailScreen(
      {super.key,
      required this.nameOfSurah,
      required this.TranslatedNsme,
      required this.numberOfAyahs,
      required this.revelationType,
      required this.surahNumber});

  @override
  State<DetailScreen> createState() => _detailscreenState();
}

class _detailscreenState extends State<DetailScreen> {
  SurahResponseModel? surahArinfo;
  SurahEnResponseModel? surahEninfo;
  late AudioPlayer player = AudioPlayer();
  PlayerState? _playerState;
  int? _ayahid;
  bool isAudioLoading = false;
  bool get _isPlaying => _playerState == PlayerState.playing;
  StreamSubscription? _playerCompleteSubscription;
  StreamSubscription? _playerStateChangeSubscription;

  void _initStreams() {
    _playerCompleteSubscription = player.onPlayerComplete.listen((event) {
      setState(() {
        _playerState = PlayerState.stopped;
        _ayahid = null;
      });
    });

    _playerStateChangeSubscription =
        player.onPlayerStateChanged.listen((state) {
      setState(() {
        _playerState = state;
      });
    });
  }

  Future<void> _play(Ayah? ayah) async {
    setState(() {
      isAudioLoading = true;
      _ayahid = ayah?.number;
    });
    await player.play(UrlSource(ayah!.audio!));
    setState(() {
      _playerState = PlayerState.playing;
      isAudioLoading = false;
    });
  }

  Future<void> _playSura() async {
    setState(() {
      isAudioLoading = true;
      _ayahid = 0;
    });
    await player.play(UrlSource(
        'https://cdn.islamic.network/quran/audio-surah/128/ar.muhammadsiddiqalminshawimujawwad/${widget.surahNumber}.mp3'));
    setState(() {
      _playerState = PlayerState.playing;
      isAudioLoading = false;
    });
  }

  Future<void> _stop() async {
    await player.stop();
    setState(() {
      _playerState = PlayerState.stopped;
      _ayahid = null;
    });
  }

  @override
  void initState() {
    player = AudioPlayer();
    player.setReleaseMode(ReleaseMode.stop);
    _initStreams();
    super.initState();
    QuranApiService.fetchQuranArabicInfo(widget.surahNumber).then((arabicInfo) {
      setState(() {
        surahArinfo = arabicInfo;
      });
    });

    QuranApiService.fetchQuranEnglishInfo(widget.surahNumber)
        .then((englishInfo) {
      setState(() {
        surahEninfo = englishInfo;
      });
    });
  }

  @override
  void dispose() {
    // Release all sources and dispose the player.
    player.dispose();
    _playerCompleteSubscription?.cancel();
    _playerStateChangeSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: background,
        appBar: _appBar(),
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverToBoxAdapter(
              child: _details(),
            )
          ],
          body: surahArinfo == null || surahEninfo == null
              ? const Center(
                  child:
                      CircularProgressIndicator()) // Show loading indicator while data is being fetched
              : ListView.builder(
                  itemCount: surahArinfo!.data!.ayahs!.length,
                  itemBuilder: (context, index) {
                    final arabicAyah =
                        surahArinfo!.data!.ayahs![index].text.toString();
                    final englishAyah =
                        surahEninfo!.data!.ayahs![index].text.toString();
                    final ayahNumber = index + 1;
                    return _ayatItem(
                        arabicAyah: arabicAyah,
                        englishAyah: englishAyah,
                        ayahNumber: ayahNumber,
                        ayah: surahArinfo!.data!.ayahs![index]);
                  },
                ),
        ));
  }

  Widget _ayatItem({
    required String arabicAyah,
    required String englishAyah,
    required int ayahNumber,
    Ayah? ayah,
  }) =>
      Padding(
        padding: const EdgeInsets.only(top: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: gray,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Container(
                    width: 27,
                    height: 27,
                    decoration: BoxDecoration(
                      color: primary,
                      borderRadius: BorderRadius.circular(27 / 2),
                    ),
                    child: Center(
                      child: Text(
                        '$ayahNumber',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.share_outlined,
                    color: Color(0xFF9055FF),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  _ayahid == ayahNumber && isAudioLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator())
                      : IconButton(
                          icon: _ayahid == ayahNumber
                              ? const Icon(
                                  Icons.pause_outlined,
                                  color: Color(0xFF9055FF),
                                )
                              : const Icon(
                                  Icons.play_arrow_outlined,
                                  color: Color(0xFF9055FF),
                                ),
                          onPressed: () async {
                            if (_ayahid == ayahNumber) {
                              if (_isPlaying) {
                                await _stop();
                              } else {
                                await _play(ayah);
                              }
                            } else {
                              if (_isPlaying) {
                                await _stop();
                                await _play(ayah);
                              } else {
                                await _play(ayah);
                              }
                            }
                          },
                        ),
                  const SizedBox(
                    width: 16,
                  ),
                  IconButton(
                    icon: Provider.of<BookmarkProvider>(context, listen: false)
                            .bookmarkExists(ayah!.audio!)
                        ? const Icon(
                            Icons.bookmark,
                            color: Color(0xFF9055FF),
                          )
                        : const Icon(
                            Icons.bookmark_outline,
                            color: Color(0xFF9055FF),
                          ),
                    onPressed: () {
                      BookmarkModel bookmark = BookmarkModel(
                        audio: ayah.audio!,
                        number: ayah.number,
                        text: ayah.text,
                        textEn: englishAyah,
                      );
                      if (Provider.of<BookmarkProvider>(context, listen: false)
                          .bookmarkExists(ayah.audio!)) {
                        Provider.of<BookmarkProvider>(context, listen: false)
                            .removeBookmark(bookmark);
                        print('remove');
                        setState(() {});
                      } else {
                        Provider.of<BookmarkProvider>(context, listen: false)
                            .addBookmark(bookmark);
                        setState(() {});
                      }
                    },
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            Text(
              arabicAyah,
              style: GoogleFonts.amiri(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              textAlign: TextAlign.right,
            ),
            const SizedBox(
              height: 16,
            ),
            Text(
              englishAyah,
              style: GoogleFonts.poppins(
                color: text,
                fontSize: 16,
              ),
            ),
          ],
        ),
      );

  Widget _details() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Stack(children: [
          Container(
            height: 298,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    stops: [
                      0,
                      .6,
                      1
                    ],
                    colors: [
                      Color(0xFFDF98FA),
                      Color(0xFFB070FD),
                      Color(0xFF9055FF)
                    ])),
          ),
          Positioned(
              bottom: 0,
              right: 0,
              child: Opacity(
                  opacity: .2,
                  child: SvgPicture.asset(
                    'assets/svgs/quran.svg',
                    width: 324 - 55,
                  ))),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(28),
            child: Column(
              children: [
                Text(
                  widget.nameOfSurah,
                  style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 26),
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  widget.TranslatedNsme,
                  style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 16),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.share_outlined,
                      color: Color(0xFF9055FF),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    _ayahid == 0 && isAudioLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator())
                        : IconButton(
                            icon: _ayahid == 0
                                ? const Icon(
                                    Icons.pause_outlined,
                                    color: Color(0xFF9055FF),
                                  )
                                : const Icon(
                                    Icons.play_arrow_outlined,
                                    color: Color(0xFF9055FF),
                                  ),
                            onPressed: () async {
                              if (_ayahid == 0) {
                                if (_isPlaying) {
                                  await _stop();
                                } else {
                                  await _playSura();
                                }
                              } else {
                                if (_isPlaying) {
                                  await _stop();
                                  await _playSura();
                                } else {
                                  await _playSura();
                                }
                              }
                            },
                          ),
                    const SizedBox(
                      width: 16,
                    ),
                  ],
                ),
                Divider(
                  color: Colors.white.withOpacity(.35),
                  thickness: 2,
                  height: 32,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.revelationType.toUpperCase(),
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Container(
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2),
                          color: Colors.white),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      '${widget.numberOfAyahs} VERSES',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 32,
                ),
                SvgPicture.asset('assets/svgs/bismillah.svg')
              ],
            ),
          )
        ]),
      );

  AppBar _appBar() {
    return AppBar(
      backgroundColor: background,
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: SvgPicture.asset('assets/svgs/back-icon.svg')),
          const SizedBox(
            width: 24,
          ),
          Text(
            widget.nameOfSurah,
            style: GoogleFonts.inter(
                textStyle: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
          ),
          const Spacer(),
          IconButton(
              onPressed: () {},
              icon: SvgPicture.asset('assets/svgs/search-icon.svg')),
        ],
      ),
    );
  }
}
