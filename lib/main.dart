import 'package:flutter/material.dart';
import 'package:rm_front_end/views/conversion_tab.dart';
import 'package:rm_front_end/views/introduction_tab.dart';

void main() {
  runApp(const MyApp());
}

final theme = ThemeData.dark().copyWith(
  colorScheme: ColorScheme.fromSwatch(
    primarySwatch: Colors.blue,
    brightness: Brightness.dark,
    accentColor: Colors.white,
  ),
  inputDecorationTheme: const InputDecorationTheme(
    border: OutlineInputBorder(),
    contentPadding: EdgeInsets.symmetric(
      vertical: 12.0,
      horizontal: 20.0,
    ),
  ),
  textTheme: TextTheme(
    headlineSmall: TextStyle(
      fontSize: 36.0,
      color: Colors.grey.shade100,
      fontWeight: FontWeight.bold,
      height: 1.5,
    ),
    titleLarge: TextStyle(
      fontSize: 28.0,
      color: Colors.grey.shade100,
      fontWeight: FontWeight.bold,
      height: 1.5,
    ),
    titleMedium: TextStyle(
      fontSize: 16.0,
      color: Colors.grey.shade100,
      height: 1.5,
    ),
    bodyMedium: TextStyle(
      fontSize: 16.0,
      color: Colors.grey.shade50,
      height: 1.5,
    ),
  ),
);

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Register Machine Simulator',
      theme: theme,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late final TabController _tabController = TabController(
    length: 3,
    vsync: this,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register Machine Simulator'),
        bottom: TabBar(
          physics: const NeverScrollableScrollPhysics(),
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.book_outlined), text: 'Introduction'),
            Tab(
              icon: Icon(Icons.settings_outlined),
              text: 'Gödel Number Conversion',
            ),
            Tab(icon: Icon(Icons.computer_outlined), text: 'Simulation'),
          ],
        ),
      ),
      body: Center(
        child: TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          controller: _tabController,
          children: const [
            IntroductionTab(),
            ConversionTab(),
            Center(child: Text('TODO: There will be examples!')),
          ],
        ),
      ),
    );
  }
}
