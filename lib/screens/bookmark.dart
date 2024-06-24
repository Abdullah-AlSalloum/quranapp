import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:quranapp/colors.dart'; // Import custom colors
import 'package:quranapp/models/bookmark_model.dart'; // Import bookmark model
import 'package:quranapp/models/bookmark_provider.dart'; // Import bookmark provider

class Bookmark extends StatefulWidget {
  const Bookmark({super.key}); // Constructor for Bookmark widget

  @override
  State<Bookmark> createState() => _BookmarkState(); // Create state for Bookmark widget
}

class _BookmarkState extends State<Bookmark> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background, // Use custom background color
      appBar: _appBar(), // Display custom app bar
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverToBoxAdapter(
            child: Container(), // Empty container as a placeholder
          )
        ],
        body: Padding(
          padding: const EdgeInsets.all(4),
          child: Consumer<BookmarkProvider>( // Use Consumer to listen to changes in BookmarkProvider
            builder: (context, provider, child) {
              return provider.bookmarks.isEmpty
                  ? const Center(
                      child: Text(
                        'No Bookmark', // Display message if no bookmarks are present
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    )
                  : ListView.builder(
                      itemCount: provider.bookmarks.length,
                      itemBuilder: (context, index) {
                        return _ayatItem(bookmark: provider.bookmarks[index]); // Build list of bookmark items
                      },
                    );
            },
          ),
        ),
      ),
    );
  }

  Widget _ayatItem({
    required BookmarkModel bookmark, // Display each bookmark item
  }) =>
      Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: gray, // Use custom gray color
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Container(
                    width: 27,
                    height: 27,
                    decoration: BoxDecoration(
                      color: primary, // Use custom primary color
                      borderRadius: BorderRadius.circular(27 / 2),
                    ),
                    child: Center(
                      child: Text(
                        '${bookmark.number}', // Display bookmark number
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.share_outlined, // Share icon
                    color: Color(0xFF9055FF),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  IconButton(
                    icon: Provider.of<BookmarkProvider>(context, listen: false)
                            .bookmarkExists(bookmark.audio!)
                        ? const Icon(
                            Icons.bookmark, // Bookmark icon if exists
                            color: Color(0xFF9055FF),
                          )
                        : const Icon(
                            Icons.bookmark_outline, // Bookmark outline icon if not exists
                            color: Color(0xFF9055FF),
                          ),
                    onPressed: () {
                      Provider.of<BookmarkProvider>(context, listen: false)
                          .removeBookmark(bookmark); // Remove bookmark on button press
                      setState(() {});
                    },
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            Text(
              bookmark.text!, // Display bookmarked text
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
              bookmark.textEn!, // Display English translation of bookmarked text
              style: GoogleFonts.poppins(
                color: text, // Use custom text color
                fontSize: 16,
              ),
            ),
          ],
        ),
      );

  Widget _details() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Stack(
          children: [
            Container(
              height: 298,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  stops: [0, .6, 1],
                  colors: [
                    Color(0xFFDF98FA),
                    Color(0xFFB070FD),
                    Color(0xFF9055FF),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Opacity(
                opacity: .2,
                child: SvgPicture.asset(
                  'assets/svgs/quran.svg', // Display Quran SVG
                  width: 324 - 55,
                ),
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(28),
              child: Column(
                children: [
                  SvgPicture.asset('assets/svgs/bismillah.svg'), // Display Bismillah SVG
                ],
              ),
            )
          ],
        ),
      );

  AppBar _appBar() {
    return AppBar(
      backgroundColor: background, // Use custom background color
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          Text(
            'Bookmark', // Title of the screen
            style: GoogleFonts.inter(
              textStyle: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
