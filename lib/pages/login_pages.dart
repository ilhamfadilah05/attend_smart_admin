import 'package:attend_smart_admin/bloc/session/session_cubit.dart';
import 'package:attend_smart_admin/components/global_text_component.dart';
import 'package:attend_smart_admin/widgets/login/form_login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class LoginPages extends StatefulWidget {
  const LoginPages({super.key});

  @override
  State<LoginPages> createState() => _LoginPagesState();
}

class _LoginPagesState extends State<LoginPages> {
  @override
  void initState() {
    context.read<SessionCubit>().init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Row(
      children: [
        MediaQuery.of(context).size.width <= 800
            ? Container()
            : BlocListener<SessionCubit, SessionState>(
                listener: (context, state) {
                  if (state is UserAuthenticated) {
                    context.go('/dashboard');
                  }
                },
                child: SizedBox(
                  width: MediaQuery.of(context).size.width / 3,
                  height: double.infinity,
                  child: Stack(
                    children: [
                      Image.asset(
                        'assets/images/bg_login.jpg',
                        fit: BoxFit.cover,
                        height: double.infinity,
                        width: 500,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextGlobal(
                              message: "AttendSmart",
                              colorText: Colors.white,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextGlobal(
                                  message: "Selamat Datang",
                                  colorText: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 26,
                                ),
                                TextGlobal(
                                  message: "di AttendSmart Admin V.1.0",
                                  colorText: Colors.white,
                                )
                              ],
                            ),
                            TextGlobal(
                              message: "2024 © Muhamad Ilham Fadilah",
                              colorText: Colors.grey,
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
        Expanded(
          child: Column(
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: TextGlobal(
                      message: 'AttendSmart',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 40,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextGlobal(
                    message: "Selamat Datang!",
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    textAlign: TextAlign.center,
                  ),
                  TextGlobal(
                    message: "Masukkan Email dan Password Anda",
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  const FormLogin()
                ],
              )
            ],
          ),
        ),
      ],
    ));
  }
}
