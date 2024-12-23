import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import './login_screen.dart';
import './home_screen.dart';
import './patient/patient_info.dart';
import './patient/clinical_data.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ANGT HMS',
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => HomeScreen(),
        '/patienInfo': (context) => const PatientProfileScreen(),
        '/clinicalData': (context) => ElectronicHealthRecordScreen(),
      },
    );
  }
}
