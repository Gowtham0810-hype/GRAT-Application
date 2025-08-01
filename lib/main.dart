import 'package:dental_new/firebase_options.dart';
import 'package:dental_new/pages/authpage.dart';
import 'package:dental_new/utils/bleedingindexdata.dart';
import 'package:dental_new/utils/gingivalindexdata.dart';
import 'package:dental_new/utils/ohisdata.dart';
import 'package:dental_new/utils/personalinfodata.dart';
import 'package:dental_new/utils/plaqueindexdata.dart';
import 'package:dental_new/utils/probingdata.dart';
import 'package:dental_new/utils/stresscallandcomplaincedata.dart';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => PlaqueIndexData()),
        ChangeNotifierProvider(create: (context) => BleedingIndexData()),
        ChangeNotifierProvider(create: (context) => PersonalinfoData()),
        ChangeNotifierProvider(create: (context)=>OHISData()),
        ChangeNotifierProvider(create: (context)=>PeriodontalProbingProvider()),
        ChangeNotifierProvider(create: (context)=>PatientAssessmentData()),
         ChangeNotifierProvider(create: (context)=>Gingivalindexdata())
      ],
    child:  MyApp()
      )
    );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      theme: ThemeData(
        
        
        // Primary color (app bar, buttons, etc.)
        primaryColor: Colors.lightBlue[600]!, // or use your exact color code
       // creates material color shades
        
        // Color scheme
        colorScheme: ColorScheme.light(
          primary: Colors.lightBlue[600]!,
          secondary: Colors.lightBlue[400]!, // accent color
        ),
        
        // App bar theme
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.lightBlue[600],
          foregroundColor: Colors.grey[400], // text/icons color
        ),
        
        // Floating action button theme
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.lightBlue[600],
        ),
        
        // Button themes
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.lightBlue[600],
            foregroundColor: Colors.white,
          ),
        ),
        
        // Chip theme
        chipTheme: ChipThemeData(
          selectedColor: Colors.lightBlue[200],
          secondarySelectedColor: Colors.lightBlue[200],
          labelStyle: const TextStyle(color: Colors.black),
          secondaryLabelStyle: const TextStyle(color: Colors.black),
          brightness: Brightness.light,
        ),
        
        // Radio and checkbox theme
        radioTheme: RadioThemeData(
          fillColor: WidgetStateProperty.resolveWith<Color>((states) {
            if (states.contains(WidgetState.selected)) {
              return Colors.lightBlue[600]!;
            }
            return Colors.grey;
          }),
        ),
        checkboxTheme: CheckboxThemeData(
          fillColor: WidgetStateProperty.resolveWith<Color>((states) {
            if (states.contains(WidgetState.selected)) {
              return Colors.lightBlue[600]!;
            }
            return Colors.grey;
          }),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: Authpage(),
    );
  }
}
