import 'package:attend_smart_admin/bloc/department/department_bloc.dart';
import 'package:attend_smart_admin/bloc/theme/theme_cubit.dart';
import 'package:attend_smart_admin/components/global_breadcrumb_component.dart';
import 'package:attend_smart_admin/components/global_button_component.dart';
import 'package:attend_smart_admin/components/global_color_components.dart';
import 'package:attend_smart_admin/components/global_table_component.dart';
import 'package:attend_smart_admin/components/global_text_component.dart';
import 'package:attend_smart_admin/repository/department/department_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:icons_plus/icons_plus.dart';

class DepartmentPages extends StatefulWidget {
  const DepartmentPages({super.key});

  @override
  State<DepartmentPages> createState() => _DepartmentPagesState();
}

class _DepartmentPagesState extends State<DepartmentPages> {
  @override
  void initState() {
    context.read<DepartmentBloc>().add(const DepartmentLoadedEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, bool>(
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: state ? blueDefaultDark : Colors.white,
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: Colors.grey.withOpacity(0.2))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextGlobal(
                message: 'Jabatan',
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              const SizedBox(
                height: 10,
              ),
              const BreadCrumbGlobal(
                firstHref: '/jabatan/page',
                firstTitle: 'Jabatan',
                typeBreadcrumb: 'List',
              ),
              const SizedBox(
                height: 40,
              ),
              MediaQuery.of(context).size.width <= 800
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ButtonGlobal(
                          message: 'Tambah Jabatan',
                          onPressed: () {
                            context.namedLocation('/jabatan/create');
                          },
                          colorBtn: blueDefaultLight,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        ButtonGlobal(
                          message: 'Filter',
                          onPressed: () {},
                        ),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ButtonGlobal(
                          message: 'Tambah Jabatan',
                          onPressed: () {
                            context.go('/jabatan/create');
                          },
                          colorBtn: blueDefaultLight,
                        ),
                        ButtonGlobal(
                          message: 'Filter',
                          onPressed: () {},
                        ),
                      ],
                    ),
              const SizedBox(
                height: 20,
              ),
              BlocBuilder<DepartmentBloc, DepartmentState>(
                builder: (context, state) {
                  if (state is DepartmentLoadingState) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is DepartmentErrorState) {
                    return Container();
                  } else if (state is DepartmentEmptyState) {
                    return Center(
                      child: SizedBox(
                        child: Column(
                          children: [
                            const Icon(
                              Iconsax.search_status_outline,
                              size: 100,
                              color: Colors.grey,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TextGlobal(
                              message: "Data karyawan tidak ditemukan",
                              colorText: Colors.grey,
                            ),
                          ],
                        ),
                      ),
                    );
                  } else if (state is DepartmentLoadedState) {
                    return FutureBuilder(
                      future: listDataTableDepartment(state.listDepartments),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Container();
                        } else if (snapshot.hasData) {
                          var listDataDepartment = snapshot.data;
                          return TableGlobal(
                              data: listDataDepartment!,
                              headers: listHeaderTableDepartment,
                              page: 1,
                              pageChanged: (p0) {},
                              pageTotal: listDataDepartment.length,
                              widthTable:
                                  MediaQuery.of(context).size.width <= 800
                                      ? 220
                                      : 400);
                        }

                        return Center(child: TextGlobal(message: 'message'));
                      },
                    );
                  }

                  return Container();
                },
              )
            ],
          ),
        );
      },
    );
  }
}
