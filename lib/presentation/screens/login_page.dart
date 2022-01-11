import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:personal_expenses_app/presentation/screens/home_screen.dart';

class ClothesDetailsScreen extends StatefulWidget {
  @override
  State<ClothesDetailsScreen> createState() => _ClothesDetailsScreenState();
}

class _ClothesDetailsScreenState extends State<ClothesDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: false,
          backgroundColor: Colors.transparent,
        ),
        body: Center(
            child: Column(children: [
          Container(
            width: 20,
            height: 80,
          ),
          Image.asset(
            'lib/assets/images/log.png',
            height: 150,
            width: 150,
          ),
          SizedBox(
            height: 40,
            width: 150,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: Color(0xFFa8e3e8),
                  textStyle:
                      TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const HomeScreen())),
              child: Text('                                       ',
                  style: GoogleFonts.poppins(color: Colors.black)),
            ),
          ),
          Container(
            width: 20,
            height: 20,
          ),
          SizedBox(
            height: 40,
            width: 150,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: Color(0xFFa8e3e8),
                  textStyle:
                      TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const HomeScreen())),
              child: Text('LOGIN',
                  style: GoogleFonts.poppins(color: Colors.black)),
            ),
          ),
        ])));
  }
}
