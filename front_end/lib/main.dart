import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './screens/authenticate/wrapper.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';


Future<void> main() async {
  await dotenv.load(fileName: "lib/.env"); // Load .env file
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return MaterialApp(
        title: 'My_street',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const Wrapper(), // Authentication wrapper
    );
  }
}
