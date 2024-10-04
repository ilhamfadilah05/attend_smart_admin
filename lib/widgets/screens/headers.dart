import 'package:attend_smart_admin/bloc/theme/theme_cubit.dart';
import 'package:attend_smart_admin/components/global_color_components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icons_plus/icons_plus.dart';

class HeadersScreen extends StatelessWidget {
  const HeadersScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, bool>(
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
              color: state ? blueDefaultDark : blueDefaultLight,
              border: Border(
                  bottom: BorderSide(color: Colors.white.withOpacity(0.5)))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MediaQuery.of(context).size.width <= 800
                  ? InkWell(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: AlertDialog(
                                  scrollable: true,
                                  content: Column(
                                    children: [
                                      SizedBox(
                                        width: 100,
                                        child: Image.asset(
                                          'assets/images/logo_attend.png',
                                          color: state ? Colors.white : null,
                                        ),
                                      ),
                                      // const NavbarWidget()
                                    ],
                                  ),
                                ),
                              );
                            });
                      },
                      child: const Icon(Iconsax.menu_outline))
                  : SizedBox(
                      width: 100,
                      child: Image.asset(
                        'assets/images/logo_attend.png',
                        color: state ? Colors.white : null,
                      ),
                    ),
              Row(
                children: [
                  Switch(
                      thumbIcon: WidgetStateProperty.resolveWith<Icon?>(
                          (Set<WidgetState> states) {
                        return Icon(
                          state ? Icons.dark_mode : Icons.light_mode,
                          color: Colors.amber,
                        );
                      }),
                      value: state,
                      onChanged: (value) =>
                          context.read<ThemeCubit>().changeTheme()),
                  const SizedBox(width: 20),
                  const Icon(
                    Iconsax.profile_circle_outline,
                    color: Colors.white,
                  )
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
