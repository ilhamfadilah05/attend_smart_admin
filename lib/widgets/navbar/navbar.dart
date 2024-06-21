import 'package:attend_smart_admin/bloc/theme/theme_cubit.dart';
import 'package:attend_smart_admin/components/global_color_components.dart';
import 'package:attend_smart_admin/components/global_text_component.dart';
import 'package:attend_smart_admin/repository/navbar/navbar_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class NavbarWidget extends StatefulWidget {
  const NavbarWidget({super.key});

  @override
  State<NavbarWidget> createState() => _NavbarWidgetState();
}

class _NavbarWidgetState extends State<NavbarWidget> {
  int? _hoveredIndex;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, bool>(
      builder: (context, state) {
        return Container(
            width: 250,
            margin: const EdgeInsets.only(right: 20),
            decoration: BoxDecoration(
                color: state ? blueDefaultDark : Colors.white,
                borderRadius: BorderRadius.circular(5),
                boxShadow: [
                  BoxShadow(color: Colors.grey.withOpacity(0.5), blurRadius: 10)
                ]),
            child: Column(
              children: List.generate(listNavbar().length, (index) {
                final navbar = listNavbar()[index];
                final bool isHovered = _hoveredIndex == index;

                return MouseRegion(
                  onEnter: (_) => setState(() => _hoveredIndex = index),
                  onExit: (_) => setState(() => _hoveredIndex = null),
                  child: InkWell(
                    onTap: () {
                      context.go("${navbar.href}/page");
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isHovered
                            ? GoRouterState.of(context)
                                    .matchedLocation
                                    .contains(navbar.href)
                                ? state
                                    ? Colors.white
                                    : Colors.black
                                : blueDefaultLight.withOpacity(0.4)
                            : GoRouterState.of(context)
                                    .matchedLocation
                                    .contains(navbar.href)
                                ? state
                                    ? Colors.white
                                    : blueDefaultDark
                                : null,
                        borderRadius: BorderRadius.circular(5),
                        border: Border(
                          bottom:
                              BorderSide(color: Colors.grey.withOpacity(0.2)),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            navbar.icon,
                            color: GoRouterState.of(context)
                                    .matchedLocation
                                    .contains(navbar.href)
                                ? state
                                    ? Colors.black
                                    : Colors.white
                                : null,
                          ),
                          const SizedBox(width: 10),
                          TextGlobal(
                            message: navbar.label,
                            colorText: GoRouterState.of(context)
                                    .matchedLocation
                                    .contains(navbar.href)
                                ? state
                                    ? Colors.black
                                    : Colors.white
                                : null,
                          )
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ));
      },
    );
  }
}
