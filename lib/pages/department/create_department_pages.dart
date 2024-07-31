// ignore_for_file: use_build_context_synchronously

import 'package:attend_smart_admin/bloc/account/account_cubit.dart';
import 'package:attend_smart_admin/bloc/department/department_bloc.dart';
import 'package:attend_smart_admin/bloc/history-attend/history_attend_bloc.dart';
import 'package:attend_smart_admin/bloc/theme/theme_cubit.dart';
import 'package:attend_smart_admin/components/global_alert_component.dart';
import 'package:attend_smart_admin/components/global_breadcrumb_component.dart';
import 'package:attend_smart_admin/components/global_button_component.dart';
import 'package:attend_smart_admin/components/global_color_components.dart';
import 'package:attend_smart_admin/components/global_form_component.dart';
import 'package:attend_smart_admin/components/global_text_component.dart';
import 'package:attend_smart_admin/models/account_model.dart';
import 'package:attend_smart_admin/models/department_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class CreateDepartmentPages extends StatefulWidget {
  const CreateDepartmentPages({super.key});

  @override
  State<CreateDepartmentPages> createState() => _CreateDepartmentPagesState();
}

class _CreateDepartmentPagesState extends State<CreateDepartmentPages> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    getAccountData(context);
    super.initState();
  }

  void getAccountData(BuildContext context) async {
    var accountData =
        await context.read<AccountCubit>().init() ?? AccountModel();

    if (accountData.idCompany == null) {
      context.pushReplacement('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (GoRouterState.of(context).matchedLocation.contains('/jabatan/create')) {
      context.read<CreateDepartmentBloc>().add(CreateDepartmentInitialEvent());
    } else {
      context.read<CreateDepartmentBloc>().add(CreateDepartmentByIdEvent(
          id: GoRouterState.of(context).uri.queryParameters['id']!));
    }
    return BlocBuilder<ThemeCubit, bool>(
      builder: (context, state) {
        return BlocListener<CreateDepartmentBloc, CreateDepartmentState>(
          listener: (context, state) {
            if (state is CreateDepartmentSuccessState) {
              alertNotification(
                  context: context,
                  type: 'success',
                  message: state.isUpdateDepartment
                      ? 'Berhasil merubah data jabatan!'
                      : 'Berhasil menambahkan data jabatan!',
                  title: 'Berhasil');
              context.go('/jabatan/page');
            } else if (state is CreateDepartmentErrorState) {
              alertNotification(
                  context: context, type: 'error', message: state.errorMessage);
            }
          },
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: state ? blueDefaultDark : Colors.white,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: Colors.grey.withOpacity(0.2))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextGlobal(
                  message: 'Tambah Jabatan',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                const SizedBox(
                  height: 10,
                ),
                BreadCrumbGlobal(
                  firstHref: '/jabatan/page',
                  firstTitle: 'Jabatan',
                  typeBreadcrumb:
                      GoRouterState.of(context).uri.queryParameters['id'] ==
                              null
                          ? 'Create'
                          : 'Edit',
                ),
                const SizedBox(
                  height: 40,
                ),
                BlocBuilder<CreateDepartmentBloc, CreateDepartmentState>(
                  builder: (context, state) {
                    return Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            FormGlobal(
                              title: "Nama Jabatan",
                              controller: state.isUpdate == false
                                  ? state.formStatus is InitialFormStatus
                                      ? TextEditingController(text: '')
                                      : null
                                  : TextEditingController(
                                      text: state.department?.name),
                              onChanged: (p0) {
                                var empl = state.department;
                                if (empl == null) {
                                  empl = DepartmentModel(name: p0);
                                } else {
                                  empl = empl.copyWith(name: p0);
                                }

                                context.read<CreateDepartmentBloc>().add(
                                    CreateDepartmentChangedEvent(
                                        departmentData: empl, isUpdate: false));
                              },
                              validator: (p0) {
                                if (state.department == null ||
                                    state.department!.name == null) {
                                  return 'Nama harus diisi!';
                                }

                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            BlocBuilder<AccountCubit, AccountState>(
                              builder: (context, stateAccount) {
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    ButtonGlobal(
                                      message: "Simpan",
                                      onPressed: () {
                                        if (_formKey.currentState!.validate()) {
                                          context
                                              .read<CreateDepartmentBloc>()
                                              .add(CreateDepartmentAddedEvent(
                                                  departmentData:
                                                      DepartmentModel.fromJson(
                                                    state.department
                                                            ?.toJson() ??
                                                        {},
                                                  ),
                                                  accountData: stateAccount
                                                          is AccountLoaded
                                                      ? stateAccount.account
                                                      : AccountModel()));
                                        }
                                      },
                                    ),
                                  ],
                                );
                              },
                            ),
                          ],
                        ));
                  },
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
