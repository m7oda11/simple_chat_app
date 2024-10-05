import 'package:educatly_task/BLOCs/Auth_Bloc/auth_bloc.dart';
import 'package:educatly_task/Services/auth_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'BLOCs/Chat_Bloc/chat_bloc.dart';
import 'Pages/chat_page.dart';
import 'Pages/login_screen.dart';
import 'Pages/register_page.dart';
import 'Services/chat_sevice.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ChatBloc(ChatService()),
        ),
        BlocProvider(
          create: (context) => AuthBloc(AuthService()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.deepPurple, brightness: Brightness.dark),
          scaffoldBackgroundColor: Colors.black,
        ),
        themeMode: ThemeMode.dark,
        initialRoute: '/',
        routes: {
          '/': (context) => LoginScreen(),
          '/register': (context) => RegisterScreen(),
          '/chat': (context) => ChatScreen(),
        },
      ),
    );
  }
}
