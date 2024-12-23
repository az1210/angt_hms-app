import 'package:flutter/material.dart';

class AppointmentScreen extends StatelessWidget {
  const AppointmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Text(
            "This is an appointment screen",
            style: TextStyle(
                fontFamily: "Inter", fontSize: 40, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}
