import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:quranapp/models/bookmark_provider.dart';
import 'package:quranapp/screens/splash.dart';

// The main function is the entry point of the Flutter application.
void main() {
  runApp(const MyApp()); // Run the MyApp widget.
}

// MyApp is a stateless widget which acts as the root of the application.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Set the system UI overlay style to light mode.
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    return ChangeNotifierProvider(
      // Create an instance of BookmarkProvider and provide it to the widget tree.
      create: (context) => BookmarkProvider(),
      child: MaterialApp(
        // The title of the application.
        title: 'Flutter Demo',
        // The theme of the application.
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        // Hide the debug banner in the top right corner.
        debugShowCheckedModeBanner: false,
        // The first screen of the application.
        home: const SplashScreen(),
      ),
    );
  }
}
