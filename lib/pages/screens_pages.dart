import 'package:attend_smart_admin/bloc/account/account_cubit.dart';
import 'package:attend_smart_admin/bloc/theme/theme_cubit.dart';
import 'package:attend_smart_admin/components/global_color_components.dart';
import 'package:attend_smart_admin/components/global_text_component.dart';
import 'package:attend_smart_admin/pages/branch/branch_pages.dart';
import 'package:attend_smart_admin/pages/branch/create_branch_pages.dart';
import 'package:attend_smart_admin/pages/department/create_department_pages.dart';
import 'package:attend_smart_admin/pages/department/department_pages.dart';
import 'package:attend_smart_admin/pages/employee/create_employee_pages.dart';
import 'package:attend_smart_admin/pages/employee/employee_pages.dart';
import 'package:attend_smart_admin/widgets/navbar/navbar.dart';
import 'package:attend_smart_admin/widgets/screens/headers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ScreensPages extends StatefulWidget {
  const ScreensPages({super.key});

  @override
  State<ScreensPages> createState() => _ScreensPagesState();
}

class _ScreensPagesState extends State<ScreensPages> {
  @override
  void initState() {
    super.initState();
    context.read<AccountCubit>().init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const HeadersScreen(),
          BlocBuilder<ThemeCubit, bool>(
            builder: (context, state) {
              return Container(
                height: 100,
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: state ? blueDefaultDark : blueDefaultLight),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextGlobal(
                      message: 'Selamat Datang,',
                      fontSize: 12,
                    ),
                    TextGlobal(
                      message: "Super Admin PT. Ilham Ganteng Sejahtera",
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    )
                  ],
                ),
              );
            },
          ),
          Expanded(
            child: Transform.translate(
              offset: Offset(
                  0, MediaQuery.of(context).size.width <= 800 ? 10 : -24),
              child: BlocBuilder<ThemeCubit, bool>(
                builder: (context, state) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Stack(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            MediaQuery.of(context).size.width <= 800
                                ? Container()
                                : const NavbarWidget(),
                            Expanded(
                                child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  GoRouterState.of(context)
                                          .matchedLocation
                                          .contains('/karyawan')
                                      ? GoRouterState.of(context)
                                                  .matchedLocation
                                                  .contains(
                                                      '/karyawan/create') ||
                                              GoRouterState.of(context)
                                                  .matchedLocation
                                                  .contains('/karyawan/edit')
                                          ? const CreateEmployeePages()
                                          : const EmployeePages()
                                      : GoRouterState.of(context)
                                              .matchedLocation
                                              .contains('/jabatan')
                                          ? GoRouterState.of(context)
                                                      .matchedLocation
                                                      .contains(
                                                          '/jabatan/create') ||
                                                  GoRouterState.of(context)
                                                      .matchedLocation
                                                      .contains('/jabatan/edit')
                                              ? const CreateDepartmentPages()
                                              : const DepartmentPages()
                                          : GoRouterState.of(context)
                                                  .matchedLocation
                                                  .contains('/cabang')
                                              ? GoRouterState.of(context)
                                                          .matchedLocation
                                                          .contains(
                                                              '/cabang/create') ||
                                                      GoRouterState.of(context)
                                                          .matchedLocation
                                                          .contains('/cabang/edit')
                                                  ? const CreateBranchPages()
                                                  : const BranchPages()
                                              : Container()
                                ],
                              ),
                            ))
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
