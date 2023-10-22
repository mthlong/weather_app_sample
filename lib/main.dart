import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app_sample/ui/views/home_view.dart';
import 'package:weather_app_sample/view_models/home_view_model.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  static HomeViewModel homeViewModel = HomeViewModel();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomeViewModel>(
      create: (BuildContext context) => homeViewModel,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter weather app',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: HomeView(),
      ),

    );
  }
}
