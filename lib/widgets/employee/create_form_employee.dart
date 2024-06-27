// ignore_for_file: use_build_context_synchronously, must_be_immutable, no_leading_underscores_for_local_identifiers

import 'dart:convert';

import 'package:attend_smart_admin/bloc/account/account_cubit.dart';
import 'package:attend_smart_admin/bloc/branch/branch_bloc.dart';
import 'package:attend_smart_admin/bloc/department/department_bloc.dart';
import 'package:attend_smart_admin/bloc/employee/employee_bloc.dart';
import 'package:attend_smart_admin/components/global_alert_component.dart';
import 'package:attend_smart_admin/components/global_button_component.dart';
import 'package:attend_smart_admin/components/global_dropdown_button_component.dart';
import 'package:attend_smart_admin/components/global_form_component.dart';
import 'package:attend_smart_admin/models/account_model.dart';
import 'package:attend_smart_admin/models/employee_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:image_picker_web/image_picker_web.dart';

Form dataFormEmployeeZZ(BuildContext context, CreateEmployeeState state,
    bool isUpdateEmployee, GlobalKey<FormState> _formKey) {
  return Form(
    key: _formKey,
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
          context.go('/karyawan/page');
        } else if (state is CreateEmployeeErrorState) {
          alertNotification(
              context: context, type: 'error', message: state.errorMessage);
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              state.employee == null || state.employee!.image == null
                  ? Center(
                      child: InkWell(
                        onTap: () async {
                          var dataImage = await tapChangeImageEmployee(context);
                          if (dataImage != null) {
                            var empl = state.employee;
                            if (empl == null) {
                              empl = EmployeeModel(image: dataImage['image']);
                            } else {
                              empl = empl.copyWith(image: dataImage['image']);
                            }
                            context.read<CreateEmployeeBloc>().add(
                                CreateEmployeeChangedEvent(
                                    employeeData: empl, isUpdate: false));
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(10)),
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
                        var dataImage = await tapChangeImageEmployee(context);
                        if (dataImage != null) {
                          var empl = state.employee;
                          if (empl == null) {
                            empl = EmployeeModel(image: dataImage['image']);
                          } else {
                            empl = empl.copyWith(image: dataImage['image']);
                          }
                          context.read<CreateEmployeeBloc>().add(
                              CreateEmployeeChangedEvent(
                                  employeeData: empl, isUpdate: false));
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
          Row(
            children: [
              Expanded(
                child: FormGlobal(
                  title: "Nama",
                  controller: state.isUpdate == false
                      ? null
                      : TextEditingController(text: state.employee?.name),
                  onChanged: (p0) {
                    isUpdateEmployee = false;
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
                    if (state.employee == null ||
                        state.employee!.name == null) {
                      return 'Nama harus diisi!';
                    }

                    return null;
                  },
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: FormGlobal(
                  title: "NIK",
                  keyboardType: TextInputType.number,
                  controller: state.isUpdate == false
                      ? null
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
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Expanded(
                child: FormGlobal(
                  title: "No. Handphone",
                  controller: state.isUpdate == false
                      ? null
                      : TextEditingController(text: state.employee?.nohp),
                  keyboardType: TextInputType.number,
                  onChanged: (p0) {
                    isUpdateEmployee = false;
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
                    if (state.employee == null ||
                        state.employee!.nohp == null) {
                      return 'No. HP harus diisi!';
                    }

                    return null;
                  },
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: FormGlobal(
                  title: "Alamat",
                  controller: state.isUpdate == false
                      ? null
                      : TextEditingController(text: state.employee?.address),
                  onChanged: (p0) {
                    isUpdateEmployee = false;
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
                    if (state.employee == null ||
                        state.employee!.address == null) {
                      return 'Alamat harus diisi!';
                    }

                    return null;
                  },
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Expanded(
                  child: DropdownGlobal(
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
              )),
              const SizedBox(
                width: 10,
              ),
              BlocBuilder<BranchBloc, BranchState>(
                builder: (context, stateBranch) {
                  var listBranch = <String>[];
                  if (stateBranch is BranchLoadedState) {
                    for (var a in stateBranch.listBranch) {
                      listBranch.add(a.name!);
                    }
                  }
                  return Expanded(
                      child: DropdownGlobal(
                    listItems: listBranch,
                    value: state.employee?.nameBranch,
                    hint: '-- Pilih --',
                    onChanged: (p0) {
                      var empl = state.employee;
                      if (stateBranch is BranchLoadedState) {
                        for (var a in stateBranch.listBranch) {
                          if (a.name == p0) {
                            if (empl == null) {
                              empl = EmployeeModel(idBranch: a.id);
                              empl = EmployeeModel(nameBranch: p0.toString());
                            } else {
                              empl = empl.copyWith(idBranch: a.id);
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
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Expanded(
                child: FormGlobal(
                  title: "Total Cuti",
                  controller: state.isUpdate == false
                      ? null
                      : TextEditingController(text: state.employee?.totalCuti),
                  onChanged: (p0) {
                    isUpdateEmployee = false;
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
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: FormGlobal(
                  title: "Sisa Cuti",
                  controller: state.isUpdate == false
                      ? null
                      : TextEditingController(
                          text: state.employee?.remainingCuti),
                  onChanged: (p0) {
                    isUpdateEmployee = false;
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
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Expanded(child: BlocBuilder<DepartmentBloc, DepartmentState>(
                builder: (context, stateDepartment) {
                  var listDepartment = <String>[];
                  if (stateDepartment is DepartmentLoadedState) {
                    for (var a in stateDepartment.listDepartments) {
                      listDepartment.add(a.name!);
                    }
                  }
                  return DropdownGlobal(
                    listItems: listDepartment,
                    value: state.employee?.department,
                    hint: '-- Pilih --',
                    onChanged: (p0) {
                      var empl = state.employee;
                      if (stateDepartment is DepartmentLoadedState) {
                        for (var a in stateDepartment.listDepartments) {
                          if (a.name == p0) {
                            if (empl == null) {
                              empl = EmployeeModel(department: a.name);
                            } else {
                              empl = empl.copyWith(department: a.name);
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
              )),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                  child: DropdownGlobal(
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
              )),
            ],
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
                        context.read<CreateEmployeeBloc>().add(
                            CreateEmployeeAddedEvent(
                                employeeData: EmployeeModel.fromJson(
                                  state.employee?.toJson() ?? {},
                                ),
                                accountData: stateAccount is AccountLoaded
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
}

Future tapChangeImageEmployee(BuildContext context) async {
  try {
    Uint8List? bytesFromPicker = await ImagePickerWeb.getImageAsBytes();

    String imageBase64 = base64Encode(bytesFromPicker!);

    return {'image': imageBase64};
  } catch (e) {
    alertNotification(
        context: context,
        type: 'error',
        message: 'Tidak ada wajah terdeteksi!');

    return null;
  }
}
