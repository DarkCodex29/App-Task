import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:task/src/screens/home/tasks.page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://lejuekpzkkkgpxudhsth.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImxlanVla3B6a2trZ3B4dWRoc3RoIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDcxODYwNDUsImV4cCI6MjAyMjc2MjA0NX0.USoeXSi8n5xHVIM20iFHNFLbvkBtQspFnvVrylC6T9w');

  runApp(const MyApp());
}


class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tasks',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.cyan),
        useMaterial3: true,
        fontFamily: 'LilitaOne',
      ),
      home: const TasksPage(),
    );
  }
}
