// ignore_for_file: use_build_context_synchronously

import 'package:attend_smart_admin/bloc/account/account_cubit.dart';
import 'package:attend_smart_admin/bloc/sidebar/sidebar_bloc.dart';
import 'package:attend_smart_admin/bloc/theme/theme_cubit.dart';
import 'package:attend_smart_admin/components/global_dialog_component.dart';
import 'package:attend_smart_admin/components/global_initials_name_component.dart';
import 'package:attend_smart_admin/components/global_text_component.dart';
import 'package:attend_smart_admin/repository/navbar/navbar_repository.dart';
import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScreensPages extends StatefulWidget {
  const ScreensPages({super.key});

  @override
  State<ScreensPages> createState() => _ScreensPagesState();
}

class _ScreensPagesState extends State<ScreensPages> {
  var displayMode = SideMenuDisplayMode.open;
  SideMenuController sideController = SideMenuController();
  PageController pageController = PageController();

  @override
  void initState() {
    pageController = PageController(
      initialPage: 0,
      keepPage: true,
    );
    super.initState();
    context.read<AccountCubit>().init();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      changeDisplaySidebar(GoRouterState.of(context).matchedLocation);
    });
  }

  void changeDisplaySidebar(String location) {
    if (location.contains('/dashboard')) {
      setState(() {
        sideController.changePage(0);
      });
    } else if (location.contains('/employee')) {
      setState(() {
        sideController.changePage(1);
      });
    } else if (location.contains('/department')) {
      setState(() {
        sideController.changePage(2);
      });
    } else if (location.contains('/branch')) {
      setState(() {
        sideController.changePage(4);
      });
    } else if (location.contains('/history')) {
      setState(() {
        sideController.changePage(5);
      });
    } else if (location.contains('/submission')) {
      setState(() {
        sideController.changePage(6);
      });
    } else if (location.contains('/broadcast')) {
      setState(() {
        sideController.changePage(7);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<ThemeCubit, bool>(
        builder: (context, state) {
          return BlocBuilder<SidebarBloc, SidebarState>(
            builder: (context, stateSidebar) {
              return Row(
                children: [
                  SideMenu(
                      // showToggle: true,
                      controller: sideController,
                      style: SideMenuStyle(
                        decoration: BoxDecoration(
                            border: Border(
                                right: BorderSide(
                                    color: Colors.grey.withOpacity(0.2)))),
                        displayMode: MediaQuery.of(context).size.width < 600
                            ? SideMenuDisplayMode.compact
                            : displayMode,
                        openSideMenuWidth: 240,
                        showHamburger: false,
                        backgroundColor: Colors.white,
                        hoverColor: Colors.black.withOpacity(0.1),
                        selectedHoverColor: Colors.black.withOpacity(0.7),
                        selectedColor: Colors.black,
                        selectedTitleTextStyleExpandable: const TextStyle(
                          color: Colors.black,
                          fontSize: 13,
                        ),
                        iconSizeExpandable: 17,
                        selectedIconColorExpandable: Colors.black,
                        itemOuterPadding:
                            const EdgeInsets.symmetric(horizontal: 10),
                        unselectedIconColorExpandable:
                            Colors.black.withOpacity(0.5),
                        toggleColor: Colors.black,
                        selectedTitleTextStyle: const TextStyle(
                            color: Colors.white,
                            fontFamily: 'quicksand',
                            fontSize: 13),
                        unselectedIconColor: Colors.black.withOpacity(0.5),
                        unselectedTitleTextStyle: const TextStyle(
                          color: Colors.black,
                          fontSize: 13,
                          fontFamily: 'quicksand',
                        ),
                        selectedIconColor: Colors.white,
                        iconSize: 17,
                      ),
                      title: Container(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  child: ConstrainedBox(
                                    constraints: BoxConstraints(
                                      maxHeight: displayMode ==
                                                  SideMenuDisplayMode.compact ||
                                              MediaQuery.of(context)
                                                      .size
                                                      .width <
                                                  600
                                          ? 40
                                          : 70,
                                      maxWidth: displayMode ==
                                                  SideMenuDisplayMode.compact ||
                                              MediaQuery.of(context)
                                                      .size
                                                      .width <
                                                  600
                                          ? 40
                                          : 70,
                                    ),
                                    child: InkWell(
                                      onTap: () {
                                        if (displayMode ==
                                            SideMenuDisplayMode.open) {
                                          setState(() {
                                            displayMode =
                                                SideMenuDisplayMode.compact;
                                          });
                                        } else {
                                          setState(() {
                                            displayMode =
                                                SideMenuDisplayMode.open;
                                          });
                                        }
                                      },
                                      child: Image.asset(
                                        'assets/images/logo_attend.png',
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            ConstrainedBox(
                              constraints: const BoxConstraints(
                                maxHeight: 150,
                                maxWidth: 150,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color:
                                                  Colors.grey.withOpacity(0.2)),
                                          child: TextGlobal(
                                            message: getInitials("Admin"),
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        // ignore: unrelated_type_equality_checks
                                        displayMode ==
                                                    SideMenuDisplayMode
                                                        .compact ||
                                                MediaQuery.of(context)
                                                        .size
                                                        .width <
                                                    600
                                            ? Container()
                                            : TextGlobal(
                                                message: "Admin",
                                                textAlign: TextAlign.center,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                        displayMode ==
                                                    SideMenuDisplayMode
                                                        .compact ||
                                                MediaQuery.of(context)
                                                        .size
                                                        .width <
                                                    600
                                            ? Container()
                                            : TextGlobal(
                                                message: 'admin@admin.com',
                                                fontSize: 11,
                                                textAlign: TextAlign.center,
                                                colorText: Colors.grey,
                                              ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Divider(
                              indent: 8.0,
                              endIndent: 8.0,
                              color: Colors.grey.withOpacity(0.2),
                            ),
                          ],
                        ),
                      ),
                      items: List.generate(
                          NavbarRepository().listDataSidebar.length, (index) {
                        var data = NavbarRepository().listDataSidebar[index];
                        return data.label == null
                            ? SideMenuItem(
                                builder: (context, displayMode) {
                                  return Divider(
                                    endIndent: 2,
                                    indent: 2,
                                    color: Colors.grey.withOpacity(0.2),
                                  );
                                },
                              )
                            : SideMenuItem(
                                title: data.label,
                                icon: Icon(data.icon),
                                onTap: (index, sideMenuController) async {
                                  SharedPreferences sharedPrefs =
                                      await SharedPreferences.getInstance();
                                  if (data.href == '#') {
                                    dialogQuestion(context, onTapYes: () {
                                      sharedPrefs.remove('token');
                                      sharedPrefs.remove('dataUser');
                                      sharedPrefs.clear();
                                      Router.neglect(context, () {
                                        context.pushReplacement('/login');
                                      });
                                    },
                                        message:
                                            "Apakah anda yakin ingin keluar dari CMS Sistem Absensi Attend Smart?",
                                        icon: const Icon(
                                          Icons.logout,
                                          color: Colors.red,
                                          size: 80,
                                        ));
                                    return;
                                  }
                                  setState(() {
                                    sideController.changePage(index);
                                    pageController.jumpToPage(index);
                                  });
                                  Router.neglect(context, () {
                                    context.go(data.href ?? '/');
                                  });
                                },
                              );
                      })),
                  const VerticalDivider(
                    width: 0,
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Expanded(
                          child: SizedBox(
                            child: PageView(
                              scrollDirection: Axis.horizontal,
                              controller: pageController,
                              physics: const NeverScrollableScrollPhysics(),
                              children: List.generate(
                                  NavbarRepository()
                                      .listDataWidgetSidebar
                                      .length, (index) {
                                return NavbarRepository().buildPageContent(
                                    GoRouterState.of(context).matchedLocation);
                              }),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
