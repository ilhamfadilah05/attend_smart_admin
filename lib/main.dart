import 'package:attend_smart_admin/bloc/login/login_bloc.dart';
import 'package:attend_smart_admin/bloc/login/obscure_cubit.dart';
import 'package:attend_smart_admin/bloc/session/session_cubit.dart';
import 'package:attend_smart_admin/bloc/theme/theme_cubit.dart';
import 'package:attend_smart_admin/repository/login/login_repository.dart';
import 'package:attend_smart_admin/routes/router.dart';
import 'package:attend_smart_admin/themes/global_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_strategy/url_strategy.dart';

Future<void> main() async {
  setPathUrlStrategy();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
    apiKey: "",
    authDomain: "attend-smart-01.firebaseapp.com",
    databaseURL:
        "https://attend-smart-01-default-rtdb.asia-southeast1.firebasedatabase.app",
    projectId: "attend-smart-01",
    storageBucket: "attend-smart-01.appspot.com",
    messagingSenderId: "409310483642",
    appId: "1:409310483642:web:8e22c83d5a1283c8039e83",
  ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => SessionCubit()..init()),
          BlocProvider(create: (context) => ThemeCubit()),
          BlocProvider(create: (context) => ObscureCubit()),
          BlocProvider(
              create: (context) => LoginBloc(loginRepo: LoginRepository())),
        ],
        child: BlocBuilder<ThemeCubit, bool>(
          builder: (context, state) {
            return BlocBuilder<SessionCubit, SessionState>(
              builder: (context, stateSession) {
                return MaterialApp.router(
                  debugShowCheckedModeBanner: false,
                  routerConfig: AppRouter(sessionCubit: stateSession).router,
                  themeMode: state ? ThemeMode.dark : ThemeMode.light,
                  theme: GlobalThemData.lightThemeData,
                  darkTheme: GlobalThemData.darkThemeData,
                );
              },
            );
          },
        ));
  }
}
