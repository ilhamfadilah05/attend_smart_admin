import 'package:attend_smart_admin/bloc/employee/employee_bloc.dart';
import 'package:attend_smart_admin/bloc/theme/theme_cubit.dart';
import 'package:attend_smart_admin/components/global_breadcrumb_component.dart';
import 'package:attend_smart_admin/components/global_button_component.dart';
import 'package:attend_smart_admin/components/global_color_components.dart';
import 'package:attend_smart_admin/components/global_table_component.dart';
import 'package:attend_smart_admin/components/global_text_component.dart';
import 'package:attend_smart_admin/repository/employee/employee_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class EmployeePages extends StatefulWidget {
  const EmployeePages({super.key});

  @override
  State<EmployeePages> createState() => _EmployeePagesState();
}

class _EmployeePagesState extends State<EmployeePages> {
  @override
  void initState() {
    context
        .read<EmployeeBloc>()
        .add(const EmployeeLoadedEvent(startData: 1, lastData: 100));
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
                message: 'Karyawan',
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              const SizedBox(
                height: 10,
              ),
              const BreadCrumbGlobal(
                firstHref: '/karyawan/page',
                firstTitle: 'Karyawan',
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
                          message: 'Tambah Karyawan',
                          onPressed: () {
                            // context.go('/karyawan/create');
                            context.namedLocation('/karyawan/create');
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
                          message: 'Tambah Karyawan',
                          onPressed: () {
                            context.go('/karyawan/create');
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
              BlocBuilder<EmployeeBloc, EmployeeState>(
                builder: (context, state) {
                  if (state is EmployeeLoadingState) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is EmployeeErrorState) {
                    return Container();
                  } else if (state is EmployeeLoadedState) {
                    return FutureBuilder(
                      future: listDataTableEmployee(state.listEmployee),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Container();
                        } else if (snapshot.hasData) {
                          var listDataEmployee = snapshot.data;
                          return TableGlobal(
                              data: listDataEmployee!,
                              headers: listHeaderTableEmployee,
                              page: 1,
                              pageChanged: (p0) {},
                              pageTotal: listDataEmployee.length,
                              widthTable:
                                  MediaQuery.of(context).size.width <= 800
                                      ? 140
                                      : 190);
                        }

                        return Container();
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
