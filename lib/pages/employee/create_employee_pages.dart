// ignore_for_file: use_build_context_synchronously, must_be_immutable

import 'dart:convert';

import 'package:attend_smart_admin/bloc/account/account_cubit.dart';
import 'package:attend_smart_admin/bloc/branch/branch_bloc.dart';
import 'package:attend_smart_admin/bloc/department/department_bloc.dart';
import 'package:attend_smart_admin/bloc/employee/employee_bloc.dart';
import 'package:attend_smart_admin/bloc/history-attend/history_attend_bloc.dart';
import 'package:attend_smart_admin/bloc/theme/theme_cubit.dart';
import 'package:attend_smart_admin/components/global_alert_component.dart';
import 'package:attend_smart_admin/components/global_breadcrumb_component.dart';
import 'package:attend_smart_admin/components/global_button_component.dart';
import 'package:attend_smart_admin/components/global_color_components.dart';
import 'package:attend_smart_admin/components/global_dropdown_button_component.dart';
import 'package:attend_smart_admin/components/global_form_component.dart';
import 'package:attend_smart_admin/components/global_responsive_component.dart';
import 'package:attend_smart_admin/components/global_text_component.dart';
import 'package:attend_smart_admin/models/account_model.dart';
import 'package:attend_smart_admin/models/employee_model.dart';
import 'package:attend_smart_admin/widgets/employee/create_form_employee.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:icons_plus/icons_plus.dart';

class CreateEmployeePages extends StatefulWidget {
  const CreateEmployeePages({super.key});

  @override
  State<CreateEmployeePages> createState() => _CreateEmployeePagesState();
}

class _CreateEmployeePagesState extends State<CreateEmployeePages> {
  var accountData = AccountModel();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    getAccountData(context);
    super.initState();
  }

  void getAccountData(BuildContext context) async {
    accountData = await context.read<AccountCubit>().init() ?? AccountModel();

    if (accountData.idCompany == null) {
      Router.neglect(context, () {
        context.pushReplacement('/login');
      });
    } else {
      context.read<EmployeeBloc>().add(EmployeeLoadedEvent(
          idCompany: accountData.idCompany ?? '', page: 1, limit: 5));

      context.read<BranchBloc>().add(BranchLoadedEvent(
          idCompany: accountData.idCompany!, page: 1, limit: 1000));
      context.read<DepartmentBloc>().add(DepartmentLoadedEvent(
          idCompany: accountData.idCompany!, page: 1, limit: 1000));
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (GoRouterState.of(context)
          .matchedLocation
          .contains('/employee/edit')) {
        context.read<CreateEmployeeBloc>().add(CreateEmployeeByIdEvent(
            id: GoRouterState.of(context).uri.queryParameters['id']!));
      } else {
        context.read<CreateEmployeeBloc>().add(CreateEmployeeInitialEvent());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, bool>(
      builder: (context, state) {
        return SingleChildScrollView(
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
                  message: 'Tambah Karyawan',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                const SizedBox(
                  height: 10,
                ),
                BreadCrumbGlobal(
                  firstHref: '/employee/page',
                  firstTitle: 'Karyawan',
                  typeBreadcrumb:
                      GoRouterState.of(context).uri.queryParameters['id'] ==
                              null
                          ? 'Create'
                          : 'Edit',
                ),
                const SizedBox(
                  height: 40,
                ),
                FormCreateEditEmployee(
                  formKey: _formKey,
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

class FormCreateEditEmployee extends StatelessWidget {
  const FormCreateEditEmployee({super.key, required this.formKey});

  final GlobalKey<FormState> formKey;

  @override
  Widget build(BuildContext context) {
    return SizedBox(child: BlocBuilder<CreateEmployeeBloc, CreateEmployeeState>(
      builder: (context, state) {
        return state.formStatus is LoadingFormStatus
            ? const Center(
                child: Column(
                  children: [
                    SizedBox(
                      height: 100,
                    ),
                    CircularProgressIndicator(
                      color: blueDefaultDark,
                    ),
                  ],
                ),
              )
            : Form(
                key: formKey,
                child: BlocListener<CreateEmployeeBloc, CreateEmployeeState>(
                  listener: (context, state) {
                    if (state is CreateEmployeeSuccessState) {
                      alertNotification(
                          context: context,
                          type: 'success',
                          message: state.isUpdateEmployee
                              ? 'Berhasil mengupdate data karyawan.'
                              : 'Berhasil menambahkan data karyawan.',
                          title: 'Berhasil!');
                      context.go('/employee/page');
                    } else if (state is CreateEmployeeErrorState) {
                      alertNotification(
                          context: context,
                          type: 'error',
                          message: state.errorMessage);
                    }
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          state.employee == null ||
                                  state.employee!.image == null
                              ? Center(
                                  child: InkWell(
                                    onTap: () async {
                                      var dataImage =
                                          await tapChangeImageEmployee(context);
                                      if (dataImage != null) {
                                        var empl = state.employee;
                                        if (empl == null) {
                                          empl = EmployeeModel(
                                              image: dataImage['image']);
                                        } else {
                                          empl = empl.copyWith(
                                              image: dataImage['image']);
                                        }
                                        context.read<CreateEmployeeBloc>().add(
                                            CreateEmployeeChangedEvent(
                                                employeeData: empl,
                                                isUpdate: false));
                                      }
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(20),
                                      decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.grey),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: const Center(
                                        child: Icon(
                                          Iconsax.gallery_add_outline,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              : InkWell(
                                  onTap: () async {
                                    var dataImage =
                                        await tapChangeImageEmployee(context);
                                    if (dataImage != null) {
                                      var empl = state.employee;
                                      if (empl == null) {
                                        empl = EmployeeModel(
                                            image: dataImage['image']);
                                      } else {
                                        empl = empl.copyWith(
                                            image: dataImage['image']);
                                      }
                                      context.read<CreateEmployeeBloc>().add(
                                          CreateEmployeeChangedEvent(
                                              employeeData: empl,
                                              isUpdate: false));
                                    }
                                  },
                                  child: SizedBox(
                                      height: 200,
                                      child: Image.memory(
                                        base64Decode(state.employee!.image!),
                                        fit: BoxFit.fill,
                                      )),
                                ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SectionInputDataEmployee(
                        state: state,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SectionInputDataWorkingEmployee(state: state),
                      const SizedBox(
                        height: 20,
                      ),
                      BlocBuilder<AccountCubit, AccountState>(
                        builder: (context, stateAccount) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              state.formStatus is LoadingButtonStatus
                                  ? const SizedBox(
                                      width: 50,
                                      height: 50,
                                      child: CircularProgressIndicator(
                                        color: Colors.black,
                                      ),
                                    )
                                  : ButtonGlobal(
                                      message: "Simpan",
                                      onPressed: () {
                                        if (formKey.currentState!.validate()) {
                                          context
                                              .read<CreateEmployeeBloc>()
                                              .add(CreateEmployeeAddedEvent(
                                                  employeeData:
                                                      EmployeeModel.fromJson(
                                                    state.employee?.toJson() ??
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
                  ),
                ),
              );
      },
    ));
  }
}

class SectionInputDataEmployee extends StatelessWidget {
  SectionInputDataEmployee({super.key, required this.state});

  CreateEmployeeState state;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.withOpacity(0.2)),
          borderRadius: BorderRadius.circular(5)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextGlobal(
            message: "Input Data Diri Karyawan",
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          TextGlobal(
            message: 'Masukkan data diri karyawan disini.',
            fontSize: 12,
            colorText: Colors.grey,
          ),
          const SizedBox(
            height: 20,
          ),
          ResponsiveForm.responsiveForm(children: [
            FormGlobal(
              title: "Nama",
              controller: state.isUpdate == false
                  ? state.formStatus is InitialFormStatus
                      ? TextEditingController(text: '')
                      : null
                  : TextEditingController(text: state.employee?.name),
              onChanged: (p0) {
                var empl = state.employee;
                if (empl == null) {
                  empl = EmployeeModel(name: p0);
                } else {
                  empl = empl.copyWith(name: p0);
                }
                context.read<CreateEmployeeBloc>().add(
                    CreateEmployeeChangedEvent(
                        employeeData: empl, isUpdate: false));
              },
              validator: (p0) {
                if (state.employee == null || state.employee!.name == null) {
                  return 'Nama harus diisi!';
                }

                return null;
              },
            ),
            FormGlobal(
              title: "NIK",
              keyboardType: TextInputType.number,
              controller: state.isUpdate == false
                  ? state.formStatus is InitialFormStatus
                      ? TextEditingController(text: '')
                      : null
                  : TextEditingController(text: state.employee?.nik),
              onChanged: (p0) {
                var empl = state.employee;

                if (empl == null) {
                  empl = EmployeeModel(nik: p0);
                } else {
                  empl = empl.copyWith(nik: p0);
                }

                context.read<CreateEmployeeBloc>().add(
                    CreateEmployeeChangedEvent(
                        employeeData: empl, isUpdate: false));
              },
              validator: (p0) {
                if (state.employee == null || state.employee!.nik == null) {
                  return 'NIK harus diisi!';
                }

                return null;
              },
            ),
            FormGlobal(
              title: "No. Handphone",
              controller: state.isUpdate == false
                  ? state.formStatus is InitialFormStatus
                      ? TextEditingController(text: '')
                      : null
                  : TextEditingController(text: state.employee?.nohp),
              keyboardType: TextInputType.number,
              onChanged: (p0) {
                var empl = state.employee;
                if (empl == null) {
                  empl = EmployeeModel(nohp: p0);
                } else {
                  empl = empl.copyWith(nohp: p0);
                }
                context.read<CreateEmployeeBloc>().add(
                    CreateEmployeeChangedEvent(
                        employeeData: empl, isUpdate: false));
              },
              validator: (p0) {
                if (state.employee == null || state.employee!.nohp == null) {
                  return 'No. HP harus diisi!';
                }

                return null;
              },
            ),
            FormGlobal(
              title: "Alamat",
              controller: state.isUpdate == false
                  ? state.formStatus is InitialFormStatus
                      ? TextEditingController(text: '')
                      : null
                  : TextEditingController(text: state.employee?.address),
              onChanged: (p0) {
                var empl = state.employee;
                if (empl == null) {
                  empl = EmployeeModel(address: p0);
                } else {
                  empl = empl.copyWith(address: p0);
                }
                context.read<CreateEmployeeBloc>().add(
                    CreateEmployeeChangedEvent(
                        employeeData: empl, isUpdate: false));
              },
              validator: (p0) {
                if (state.employee == null || state.employee!.address == null) {
                  return 'Alamat harus diisi!';
                }

                return null;
              },
            ),
            DropdownGlobal(
              listItems: const ['LAKI-LAKI', 'PEREMPUAN'],
              value: state.employee?.gender,
              hint: '-- Pilih --',
              onChanged: (p0) {
                var empl = state.employee;
                if (empl == null) {
                  empl = EmployeeModel(gender: p0.toString());
                } else {
                  empl = empl.copyWith(gender: p0.toString());
                }
                context.read<CreateEmployeeBloc>().add(
                    CreateEmployeeChangedEvent(
                        employeeData: empl, isUpdate: false));
              },
              title: 'Jenis Kelamin',
            )
          ])
        ],
      ),
    );
  }
}

class SectionInputDataWorkingEmployee extends StatelessWidget {
  SectionInputDataWorkingEmployee({super.key, required this.state});

  CreateEmployeeState state;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.withOpacity(0.2)),
          borderRadius: BorderRadius.circular(5)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextGlobal(
            message: "Input Data Pekerjaan Karyawan",
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          TextGlobal(
            message: 'Masukkan data pekerjaan karyawan disini.',
            fontSize: 12,
            colorText: Colors.grey,
          ),
          const SizedBox(
            height: 20,
          ),
          ResponsiveForm.responsiveForm(children: [
            BlocBuilder<BranchBloc, BranchState>(
              builder: (context, stateBranch) {
                var listBranch = <String>[];
                if (stateBranch is BranchLoadedState) {
                  for (var a in stateBranch.listBranch) {
                    listBranch.add(a['name'] ?? '');
                  }
                }
                return SizedBox(
                    child: DropdownGlobal(
                  listItems: listBranch,
                  value: state.employee?.nameBranch,
                  hint: '-- Pilih --',
                  onChanged: (p0) {
                    var empl = state.employee;
                    if (stateBranch is BranchLoadedState) {
                      for (var a in stateBranch.listBranch) {
                        if (a['name'] == p0) {
                          if (empl == null) {
                            empl = EmployeeModel(idBranch: a['id']);
                            empl = EmployeeModel(nameBranch: p0.toString());
                          } else {
                            empl = empl.copyWith(idBranch: a['id']);
                            empl = empl.copyWith(nameBranch: p0.toString());
                          }
                        }
                      }
                    }

                    context.read<CreateEmployeeBloc>().add(
                        CreateEmployeeChangedEvent(
                            employeeData: empl!, isUpdate: false));
                  },
                  title: 'Cabang',
                ));
              },
            ),
            FormGlobal(
              title: "Total Cuti",
              controller: state.isUpdate == false
                  ? state.formStatus is InitialFormStatus
                      ? TextEditingController(text: '')
                      : null
                  : TextEditingController(text: state.employee?.totalCuti),
              onChanged: (p0) {
                var empl = state.employee;
                if (empl == null) {
                  empl = EmployeeModel(totalCuti: p0);
                } else {
                  empl = empl.copyWith(totalCuti: p0);
                }
                context.read<CreateEmployeeBloc>().add(
                    CreateEmployeeChangedEvent(
                        employeeData: empl, isUpdate: false));
              },
              validator: (p0) {
                return null;
              },
              keyboardType: TextInputType.number,
            ),
            FormGlobal(
              title: "Sisa Cuti",
              controller: state.isUpdate == false
                  ? state.formStatus is InitialFormStatus
                      ? TextEditingController(text: '')
                      : null
                  : TextEditingController(text: state.employee?.remainingCuti),
              onChanged: (p0) {
                var empl = state.employee;
                if (empl == null) {
                  empl = EmployeeModel(remainingCuti: p0);
                } else {
                  empl = empl.copyWith(remainingCuti: p0);
                }
                context.read<CreateEmployeeBloc>().add(
                    CreateEmployeeChangedEvent(
                        employeeData: empl, isUpdate: false));
              },
              validator: (p0) {
                return null;
              },
              keyboardType: TextInputType.number,
            ),
            BlocBuilder<DepartmentBloc, DepartmentState>(
              builder: (context, stateDepartment) {
                var listDepartment = <String>[];
                if (stateDepartment is DepartmentLoadedState) {
                  for (var a in stateDepartment.listDepartment) {
                    listDepartment.add(a['name']);
                  }
                }
                return DropdownGlobal(
                  listItems: listDepartment,
                  value: state.employee?.department,
                  hint: '-- Pilih --',
                  onChanged: (p0) {
                    var empl = state.employee;
                    if (stateDepartment is DepartmentLoadedState) {
                      for (var a in stateDepartment.listDepartment) {
                        if (a['name'] == p0) {
                          if (empl == null) {
                            empl = EmployeeModel(department: a['name']);
                          } else {
                            empl = empl.copyWith(department: a['name']);
                          }
                        }
                      }
                    }
                    context.read<CreateEmployeeBloc>().add(
                        CreateEmployeeChangedEvent(
                            employeeData: empl!, isUpdate: false));
                  },
                  title: 'Jabatan',
                );
              },
            ),
            DropdownGlobal(
              listItems: const ['Tetap', 'Kontrak', 'Magang'],
              value: state.employee?.workingStatus,
              hint: '-- Pilih --',
              onChanged: (p0) {
                var empl = state.employee;
                if (empl == null) {
                  empl = EmployeeModel(workingStatus: p0.toString());
                } else {
                  empl = empl.copyWith(workingStatus: p0.toString());
                }
                context.read<CreateEmployeeBloc>().add(
                    CreateEmployeeChangedEvent(
                        employeeData: empl, isUpdate: false));
              },
              title: 'Status',
            )
          ]),
        ],
      ),
    );
  }
}
