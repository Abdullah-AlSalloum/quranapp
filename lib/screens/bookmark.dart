import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:quranapp/colors.dart';
import 'package:quranapp/models/bookmark_model.dart';
import 'package:quranapp/models/bookmark_provider.dart';

class Bookmark extends StatefulWidget {
  const Bookmark({super.key});

  @override
  State<Bookmark> createState() => _BookmarkState();
}

class _BookmarkState extends State<Bookmark> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: background,
        appBar: _appBar(),
        body: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
                  SliverToBoxAdapter(
                    child: Container(),
                  )
                ],
            body: Padding(
              padding: const EdgeInsets.all(4),
              child: Consumer<BookmarkProvider>(
                  builder: (context, provider, child) {
                return provider.bookmarks.isEmpty
                    ? const Center(
                        child: Text(
                        'No Bookmark',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      )) // Show loading indicator while data is being fetched
                    : ListView.builder(
                        itemCount: provider.bookmarks.length,
                        itemBuilder: (context, index) {
                          return _ayatItem(bookmark: provider.bookmarks[index]);
                        },
                      );
              }),
            )));
  }

  Widget _ayatItem({
    required BookmarkModel bookmark,
  }) =>
      Padding(
        padding: const EdgeInsets.all(24),
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
                        '${bookmark.number}',
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
                  IconButton(
                      icon:
                          Provider.of<BookmarkProvider>(context, listen: false)
                                  .bookmarkExists(bookmark.audio!)
                              ? const Icon(
                                  Icons.bookmark,
                                  color: Color(0xFF9055FF),
                                )
                              : const Icon(
                                  Icons.bookmark_outline,
                                  color: Color(0xFF9055FF),
                                ),
                      onPressed: () {
                        Provider.of<BookmarkProvider>(context, listen: false)
                            .removeBookmark(bookmark);
                        setState(() {});
                      })
                ],
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            Text(
              bookmark.text!,
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
              bookmark.textEn!,
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
              children: [SvgPicture.asset('assets/svgs/bismillah.svg')],
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
          Text(
            'Bookmark',
            style: GoogleFonts.inter(
                textStyle: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
