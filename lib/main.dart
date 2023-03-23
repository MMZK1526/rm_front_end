import 'package:flutter/material.dart';
import 'package:rm_front_end/constants/my_text.dart';
import 'package:rm_front_end/views/conversion_tab.dart';
import 'package:rm_front_end/views/introduction_tab.dart';
import 'package:rm_front_end/views/simulation_tab.dart';

void main() {
  runApp(const MyApp());
}

final theme = ThemeData.dark(useMaterial3: true).copyWith(
  appBarTheme: AppBarTheme(
    toolbarHeight: 80.0,
    backgroundColor: Colors.grey.shade900,
    titleTextStyle: TextStyle(
      fontSize: 36.0,
      color: Colors.grey.shade200,
      fontWeight: FontWeight.bold,
    ),
  ),
  cardTheme: CardTheme(color: Colors.grey.shade800),
  inputDecorationTheme: const InputDecorationTheme(
    hintStyle: TextStyle(fontSize: 16.0, color: Colors.grey, height: 1.5),
    border: OutlineInputBorder(),
    contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
  ),
  tabBarTheme: TabBarTheme(unselectedLabelColor: Colors.grey.shade50),
  textTheme: TextTheme(
    headlineSmall: TextStyle(
      fontSize: 32.0,
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
      fontSize: 24.0,
      color: Colors.grey.shade100,
      fontWeight: FontWeight.bold,
      height: 1.5,
    ),
    bodyLarge: TextStyle(
      fontSize: 18.0,
      color: Colors.grey.shade50,
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
      title: MyText.title.text,
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
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(MyText.title.text),
        bottom: TabBar(
          physics: const NeverScrollableScrollPhysics(),
          controller: _tabController,
          tabs: [
            Tab(
              icon: const Icon(Icons.book_outlined),
              text: MyText.introTab.text,
            ),
            Tab(
              icon: const Icon(Icons.settings_outlined),
              text: MyText.convTab.text,
            ),
            Tab(
              icon: const Icon(Icons.computer_outlined),
              text: MyText.simTab.text,
            ),
          ],
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: TabBarView(
            physics: const NeverScrollableScrollPhysics(),
            controller: _tabController,
            children: const [
              IntroductionTab(),
              ConversionTab(),
              SimulationTab(),
            ],
          ),
        ),
      ),
    );
  }
}
