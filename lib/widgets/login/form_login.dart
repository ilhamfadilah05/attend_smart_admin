// ignore_for_file: use_build_context_synchronously

import 'package:attend_smart_admin/bloc/login/login_bloc.dart';
import 'package:attend_smart_admin/bloc/login/obscure_cubit.dart';
import 'package:attend_smart_admin/components/global_button_component.dart';
import 'package:attend_smart_admin/components/global_loading_component.dart';
import 'package:attend_smart_admin/components/global_text_component.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FormLogin extends StatelessWidget {
  const FormLogin({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) async {
        SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
        if (state.formStatus is SubmissionLoading) {
          // loadingGlobal(context);
        } else if (state.formStatus is SubmissionSuccess) {
          // Navigator.of(context).pop();
          // sharedPrefs.setString('token', 'token');
          // context.go('/dashboard');
        } else if (state.formStatus is SubmissionFailed) {
          // Navigator.of(context).pop();
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text(state.errorMessage)));
        }
      },
      child: Theme(
        data: ThemeData(
          primaryColor: Colors.red,
          primaryColorDark: Colors.red,
        ),
        child: Form(
          key: formKey,
          child: Container(
            width: 400,
            margin: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextGlobal(message: 'Email'),
                    const SizedBox(
                      height: 5,
                    ),
                    BlocBuilder<LoginBloc, LoginState>(
                      builder: (context, state) {
                        return TextFormField(
                            style: GoogleFonts.quicksand(),
                            onChanged: (value) => context
                                .read<LoginBloc>()
                                .add(LoginEmailChanged(email: value)),
                            validator: (value) => state.isValidEmail
                                ? null
                                : 'Email Tidak Valid!',
                            decoration: InputDecoration(
                              errorStyle: GoogleFonts.quicksand(),
                              labelStyle: GoogleFonts.quicksand(),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5)),
                            ));
                      },
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextGlobal(message: 'Password'),
                    const SizedBox(
                      height: 5,
                    ),
                    BlocBuilder<LoginBloc, LoginState>(
                      builder: (context, loginState) {
                        return BlocBuilder<ObscureCubit, bool>(
                          builder: (context, isObscured) {
                            return TextFormField(
                              style: GoogleFonts.quicksand(),
                              onChanged: (value) => context
                                  .read<LoginBloc>()
                                  .add(LoginPasswordChanged(password: value)),
                              obscureText: isObscured,
                              validator: (value) => loginState.isValidPassword
                                  ? null
                                  : 'Password Tidak Valid!',
                              decoration: InputDecoration(
                                errorStyle: GoogleFonts.quicksand(),
                                suffixIcon: InkWell(
                                  borderRadius: BorderRadius.circular(100),
                                  onTap: () => context
                                      .read<ObscureCubit>()
                                      .changeObscure(),
                                  child: Container(
                                    child: isObscured
                                        ? const Icon(Iconsax.eye_slash_bold)
                                        : const Icon(Iconsax.eye_bold),
                                  ),
                                ),
                                labelStyle: GoogleFonts.quicksand(),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5)),
                              ),
                            );
                          },
                        );
                      },
                    )
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                BlocBuilder<LoginBloc, LoginState>(
                  builder: (context, state) {
                    return ButtonGlobal(
                      message: 'Login',
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          context.read<LoginBloc>().add(LoginSubmitted(
                              email: state.email, password: state.password));
                          // formKey.currentState!.reset();
                        }
                      },
                      colorBtn: Colors.blue,
                      colorText: Colors.white,
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
