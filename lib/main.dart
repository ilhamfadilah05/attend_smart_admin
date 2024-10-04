import 'package:attend_smart_admin/bloc/account/account_cubit.dart';
import 'package:attend_smart_admin/bloc/branch/branch_bloc.dart';
import 'package:attend_smart_admin/bloc/broadcast/broadcast_bloc.dart';
import 'package:attend_smart_admin/bloc/department/department_bloc.dart';
import 'package:attend_smart_admin/bloc/employee/employee_bloc.dart';
import 'package:attend_smart_admin/bloc/history-attend/history_attend_bloc.dart';
import 'package:attend_smart_admin/bloc/login/login_bloc.dart';
import 'package:attend_smart_admin/bloc/login/obscure_cubit.dart';
import 'package:attend_smart_admin/bloc/session/session_cubit.dart';
import 'package:attend_smart_admin/bloc/sidebar/sidebar_bloc.dart';
import 'package:attend_smart_admin/bloc/submission/submission_bloc.dart';
import 'package:attend_smart_admin/bloc/theme/theme_cubit.dart';
import 'package:attend_smart_admin/repository/branch/branch_repository.dart';
import 'package:attend_smart_admin/repository/broadcast/broadcast_repository.dart';
import 'package:attend_smart_admin/repository/department/department_repository.dart';
import 'package:attend_smart_admin/repository/employee/employee_repository.dart';
import 'package:attend_smart_admin/repository/history-attend/history_attend_repository.dart';
import 'package:attend_smart_admin/repository/login/login_repository.dart';
import 'package:attend_smart_admin/repository/submission/submission_repository.dart';
import 'package:attend_smart_admin/routes/router.dart';
import 'package:attend_smart_admin/themes/global_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:intl/date_symbol_data_local.dart';

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
  await initializeDateFormatting('id_ID', null).then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => SessionCubit()..init()),
          BlocProvider(create: (context) => ThemeCubit()),
          BlocProvider(create: (context) => AccountCubit()),
          BlocProvider(create: (context) => ObscureCubit()),
          BlocProvider(
              create: (context) => LoginBloc(loginRepo: LoginRepository())),
          BlocProvider(create: (context) => EmployeeBloc(EmployeeRepository())),
          BlocProvider(create: (context) => SidebarBloc()),
          BlocProvider(
              create: (context) => CreateEmployeeBloc(EmployeeRepository())),
          BlocProvider(
              create: (context) => DepartmentBloc(DepartmentRepository())),
          BlocProvider(
              create: (context) =>
                  CreateDepartmentBloc(DepartmentRepository())),
          BlocProvider(
              create: (context) => BroadcastBloc(BroadcastRepository())),
          BlocProvider(
              create: (context) => CreateBroadcastBloc(BroadcastRepository())),
          BlocProvider(create: (context) => BranchBloc(BranchRepository())),
          BlocProvider(
              create: (context) => CreateBranchBloc(BranchRepository())),
          BlocProvider(
              create: (context) =>
                  HistoryAttendBloc(HistoryAttendRepository())),
          BlocProvider(
              create: (context) =>
                  CreateHistoryAttendBloc(HistoryAttendRepository())),
          BlocProvider(
              create: (context) => SubmissionBloc(SubmissionRepository())),
          BlocProvider(
              create: (context) =>
                  CreateSubmissionBloc(SubmissionRepository())),
        ],
        child: BlocBuilder<ThemeCubit, bool>(
          builder: (context, state) {
            return MaterialApp.router(
              debugShowCheckedModeBanner: false,
              routerConfig: AppRouter().router,
              themeMode: state ? ThemeMode.dark : ThemeMode.light,
              theme: GlobalThemData.lightThemeData,
              darkTheme: GlobalThemData.darkThemeData,
            );
          },
        ));
  }
}
