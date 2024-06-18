// ignore_for_file: use_build_context_synchronously

import 'package:attend_smart_admin/bloc/login/login_bloc.dart';
import 'package:attend_smart_admin/components/global_button_component.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardPages extends StatelessWidget {
  const DashboardPages({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: ButtonGlobal(
              message: 'Logout',
              onPressed: () async {
                SharedPreferences sharedPrefs =
                    await SharedPreferences.getInstance();
                sharedPrefs.remove('token');
                context.pushReplacement('/login');
                context.read<LoginBloc>().add(LogoutSubmitted());
              })),
    );
  }
}
