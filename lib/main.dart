import 'package:chatbot/screen/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
  );
  try{
    await dotenv.load(fileName: '.env');
    runApp(const MainApp());
    
  }
  catch(e){
    debugPrint("❌ Failed to load .env file: $e");
    
  }
  
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color.from(alpha: 255, red: 17, green: 20, blue: 19),
          brightness: Brightness.dark,
        ),
        textTheme: TextTheme(
          bodyLarge: TextStyle(fontSize: 24, color: Colors.white),
          bodyMedium: TextStyle(fontSize: 18, color: Colors.grey),
          titleLarge: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        )
      ),
      home: Scaffold(body: LoginScreen()),
    );
  }
}
