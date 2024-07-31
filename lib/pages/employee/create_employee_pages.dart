// ignore_for_file: use_build_context_synchronously

import 'package:attend_smart_admin/bloc/account/account_cubit.dart';
import 'package:attend_smart_admin/bloc/branch/branch_bloc.dart';
import 'package:attend_smart_admin/bloc/department/department_bloc.dart';
import 'package:attend_smart_admin/bloc/employee/employee_bloc.dart';
import 'package:attend_smart_admin/bloc/theme/theme_cubit.dart';
import 'package:attend_smart_admin/components/global_breadcrumb_component.dart';
import 'package:attend_smart_admin/components/global_color_components.dart';
import 'package:attend_smart_admin/components/global_text_component.dart';
import 'package:attend_smart_admin/models/account_model.dart';
import 'package:attend_smart_admin/models/employee_model.dart';
import 'package:attend_smart_admin/widgets/employee/create_form_employee.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class CreateEmployeePages extends StatefulWidget {
  const CreateEmployeePages({super.key});

  @override
  State<CreateEmployeePages> createState() => _CreateEmployeePagesState();
}

class _CreateEmployeePagesState extends State<CreateEmployeePages> {
  var name = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var isUpdateEmployee = false;
  var accountData = AccountModel();

  @override
  void initState() {
    getAccountData(context);
    super.initState();
  }

  void getAccountData(BuildContext context) async {
    accountData = await context.read<AccountCubit>().init() ?? AccountModel();

    if (accountData.idCompany == null) {
      context.pushReplacement('/login');
    } else {
      context.read<EmployeeBloc>().add(EmployeeLoadedEvent(
          startData: 1, lastData: 2, idCompany: accountData.idCompany!));

      context.read<CreateEmployeeBloc>().add(CreateEmployeeChangedEvent(
          employeeData: EmployeeModel(name: null), isUpdate: false));
      context
          .read<BranchBloc>()
          .add(BranchLoadedEvent(idCompany: accountData.idCompany!));
      context
          .read<DepartmentBloc>()
          .add(DepartmentLoadedEvent(idCompany: accountData.idCompany!));
    }
  }

  void changeIsUpdateEmployee(bool value) {
    isUpdateEmployee = value;
  }

  @override
  Widget build(BuildContext context) {
    if (GoRouterState.of(context)
        .matchedLocation
        .contains('/karyawan/create')) {
      context.read<CreateEmployeeBloc>().add(CreateEmployeeInitialEvent());
    } else {
      context.read<CreateEmployeeBloc>().add(CreateEmployeeByIdEvent(
          id: GoRouterState.of(context).uri.queryParameters['id']!));
    }

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
                message: 'Tambah Karyawan',
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              const SizedBox(
                height: 10,
              ),
              BreadCrumbGlobal(
                firstHref: '/karyawan/page',
                firstTitle: 'Karyawan',
                typeBreadcrumb:
                    GoRouterState.of(context).uri.queryParameters['id'] == null
                        ? 'Create'
                        : 'Edit',
              ),
              const SizedBox(
                height: 40,
              ),
              // CreateFormEmployee()
              BlocBuilder<CreateEmployeeBloc, CreateEmployeeState>(
                builder: (context, state) {
                  return MediaQuery.of(context).size.width <= 800
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextGlobal(
                                  message: "Input Data Karyawan ",
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                                TextGlobal(
                                    message:
                                        "Silahkan masukkan semua data karyawan."),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            dataFormEmployeeZZ(
                                context, state, isUpdateEmployee, _formKey)
                          ],
                        )
                      : Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextGlobal(
                                  message: "Input Data Karyawan ",
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                                TextGlobal(
                                    message:
                                        "Silahkan masukkan semua data karyawan."),
                              ],
                            ),
                            const SizedBox(
                              width: 40,
                            ),
                            Expanded(
                              child: dataFormEmployeeZZ(
                                  context, state, isUpdateEmployee, _formKey),
                            ),
                          ],
                        );
                },
              )
            ],
          ),
        );
      },
    );
  }
}
