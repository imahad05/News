import 'package:flutter/material.dart';
import 'package:news_app/model/news_model.dart';
import 'package:news_app/model/theme_model.dart';
import 'package:news_app/screens/news_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeModel()),
        ChangeNotifierProvider(create: (context) => NewsModel()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeModel>(
      builder: (context, theme, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: theme.theme,
          home: NewsScreen(),
        );
      },
    );
  }
}