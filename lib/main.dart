import 'package:flutter/material.dart';
//import 'package:promodeal/debug/test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'http://192.168.224.1:8000',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyAgCiAgICAicm9sZSI6ICJhbm9uIiwKICAgICJpc3MiOiAic3VwYWJhc2UtZGVtbyIsCiAgICAiaWF0IjogMTY0MTc2OTIwMCwKICAgICJleHAiOiAxNzk5NTM1NjAwCn0.dc_X5iR_VP_qT0zsiyj_I_OZ2T9FtRU2BBNWN8Bu4GE',
  );
  runApp(const PromoDealApp());
}

class PromoDealApp extends StatelessWidget {
  const PromoDealApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PromoDeal',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      initialRoute: Routes.login,
      onGenerateRoute: Routes.onGenerateRoute,
    );
  }
}
