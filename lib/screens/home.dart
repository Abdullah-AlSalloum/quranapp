// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
// import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quranapp/colors.dart';
import 'package:quranapp/screens/bookmark.dart';
import 'package:quranapp/tabs/hizb_tab.dart';
import 'package:quranapp/tabs/page_tab.dart';
import 'package:quranapp/tabs/para_tab.dart';
import 'package:quranapp/tabs/surah_tab.dart';

TabBar _tab() {
  return TabBar(
      unselectedLabelColor: text,
      labelColor: Colors.white,
      indicatorColor: primary,
      indicatorWeight: 3,
      tabs: [
        _tabItem(label: 'Surah'),
        _tabItem(label: 'Para'),
        _tabItem(label: 'Page'),
        _tabItem(label: 'Hizb'),
      ]);
}

Tab _tabItem({required String label}) => Tab(
      child: Text(
        label,
        style: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
Stack _lastRoad() {
  return Stack(
    children: [
      Container(
        height: 131,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFDF98FA),
                  Color(0xFFB070FD),
                  Color(0xFF9055FF),
                ],
                stops: [
                  0,
                  .6,
                  1
                ])),
      ),
      Positioned(
          bottom: 0,
          right: 0,
          child: SvgPicture.asset('assets/svgs/quran.svg')),
      Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SvgPicture.asset('assets/svgs/book.svg'),
                const SizedBox(
                  width: 8,
                ),
                Text(
                  'Last Read',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              'Al-Fatiha',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
            const SizedBox(
              height: 4,
            ),
            Text(
              'Verse No : 1',
              style: GoogleFonts.poppins(
                color: Colors.white,
              ),
            ),
          ],
        ),
      )
    ],
  );
}

Column _greeting() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Alsalamualekum',
        style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: const Color(0xFFA19CC5)),
      ),
      const SizedBox(
        height: 4,
      ),
      Text(
        'Abdullah Al Salloum',
        style: GoogleFonts.poppins(
            fontSize: 24, fontWeight: FontWeight.w600, color: Colors.white),
      ),
      const SizedBox(height: 24),
      _lastRoad(),
    ],
  );
}

Widget home() {
  return DefaultTabController(
    length: 4,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
                SliverToBoxAdapter(
                  child: _greeting(),
                ),
                SliverAppBar(
                  pinned: true,
                  automaticallyImplyLeading: false,
                  backgroundColor: background,
                  shape: Border(
                      bottom: BorderSide(
                    width: 3,
                    color: const Color(0xFFAAAAAA).withOpacity(.1),
                  )),
                  bottom: PreferredSize(
                      preferredSize: const Size.fromHeight(0), child: _tab()),
                )
              ],
          body: const TabBarView(
            children: [SurahTab(), ParaTab(), PageTab(), HizbTab()],
          )),
    ),
  );
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _widgetOptions = <Widget>[
    home(),
    const Center(
      child: Text(
        'Tips',
        style: TextStyle(color: Colors.white),
      ),
    ),
    const Center(
      child: Text(
        'Prayer',
        style: TextStyle(color: Colors.white),
      ),
    ),
    const Center(
      child: Text(
        'Doa',
        style: TextStyle(color: Colors.white),
      ),
    ),
    const Bookmark(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: _appBar(),
      bottomNavigationBar: _bottomNavigationBar(),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
    );
  }

  AppBar _appBar() => AppBar(
        backgroundColor: background,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            IconButton(
                onPressed: () {},
                icon: SvgPicture.asset('assets/svgs/menu-icon.svg')),
            const SizedBox(
              width: 24,
            ),
            Text(
              'Quran App',
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

  BottomNavigationBar _bottomNavigationBar() => BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: gray,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          _bottomBarItem(icon: 'assets/svgs/quran-icon.svg', label: 'Quran'),
          _bottomBarItem(icon: 'assets/svgs/lamp-icon.svg', label: 'Tips'),
          _bottomBarItem(icon: 'assets/svgs/pray-icon.svg', label: 'Prayer'),
          _bottomBarItem(icon: 'assets/svgs/doa-icon.svg', label: 'Doa'),
          _bottomBarItem(
              icon: 'assets/svgs/bookmark-icon.svg', label: 'Bookmark'),
        ],
      );

  BottomNavigationBarItem _bottomBarItem(
          {required String icon, required String label}) =>
      BottomNavigationBarItem(
          icon: SvgPicture.asset(
            icon,
            color: text,
          ),
          activeIcon: SvgPicture.asset(
            icon,
            color: primary,
          ),
          label: label);
}
