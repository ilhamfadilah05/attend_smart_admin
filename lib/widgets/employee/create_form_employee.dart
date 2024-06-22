// ignore_for_file: use_build_context_synchronously, must_be_immutable

import 'dart:convert';

import 'package:attend_smart_admin/bloc/employee/employee_bloc.dart';
import 'package:attend_smart_admin/components/global_alert_component.dart';
import 'package:attend_smart_admin/components/global_button_component.dart';
import 'package:attend_smart_admin/components/global_dropdown_button_component.dart';
import 'package:attend_smart_admin/components/global_form_component.dart';
import 'package:attend_smart_admin/components/global_text_component.dart';
import 'package:attend_smart_admin/models/employee_model.dart';
import 'package:attend_smart_admin/models/facefeatures_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:image_picker_web/image_picker_web.dart';

class CreateFormEmployee extends StatelessWidget {
  CreateFormEmployee({
    super.key,
  });
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  FaceFeaturesModel? faceFeatures;

  Future tapChangeImageEmployee(BuildContext context) async {
    try {
      Uint8List? bytesFromPicker = await ImagePickerWeb.getImageAsBytes();

      String imageBase64 = base64Encode(bytesFromPicker!);
      // final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      // if (image == null) return;
      // var image0 = File(image.path);

      // var imageBase64 = base64Encode(image0.readAsBytesSync());

      return {'image': imageBase64};
    } catch (e) {
      alertNotification(
          context: context,
          type: 'error',
          message: 'Tidak ada wajah terdeteksi!');

      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateEmployeeBloc, CreateEmployeeState>(
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
                          message: "Silahkan masukkan semua data karyawan."),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  dataFormEmployee(context, state)
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
                          message: "Silahkan masukkan semua data karyawan."),
                    ],
                  ),
                  const SizedBox(
                    width: 40,
                  ),
                  Expanded(
                    child: dataFormEmployee(context, state),
                  ),
                ],
              );
      },
    );
  }

  Form dataFormEmployee(BuildContext context, CreateEmployeeState state) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextGlobal(message: '${state.employee?.toJson()}'),
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
                                CreateEmployeeChangedEvent(employeeData: empl));
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
                              CreateEmployeeChangedEvent(employeeData: empl));
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
                  onChanged: (p0) {
                    var empl = state.employee;
                    if (empl == null) {
                      empl = EmployeeModel(name: p0);
                    } else {
                      empl = empl.copyWith(name: p0);
                    }

                    context
                        .read<CreateEmployeeBloc>()
                        .add(CreateEmployeeChangedEvent(employeeData: empl));
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
                  onChanged: (p0) {
                    var empl = state.employee;

                    if (empl == null) {
                      empl = EmployeeModel(nik: p0);
                    } else {
                      empl = empl.copyWith(nik: p0);
                    }

                    context
                        .read<CreateEmployeeBloc>()
                        .add(CreateEmployeeChangedEvent(employeeData: empl));
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
                  onChanged: (p0) {
                    var empl = state.employee;
                    if (empl == null) {
                      empl = EmployeeModel(nohp: p0);
                    } else {
                      empl = empl.copyWith(nohp: p0);
                    }
                    context
                        .read<CreateEmployeeBloc>()
                        .add(CreateEmployeeChangedEvent(employeeData: empl));
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
                  onChanged: (p0) {
                    var empl = state.employee;
                    if (empl == null) {
                      empl = EmployeeModel(address: p0);
                    } else {
                      empl = empl.copyWith(address: p0);
                    }
                    context
                        .read<CreateEmployeeBloc>()
                        .add(CreateEmployeeChangedEvent(employeeData: empl));
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
                  context
                      .read<CreateEmployeeBloc>()
                      .add(CreateEmployeeChangedEvent(employeeData: empl));
                },
                title: 'Jenis Kelamin',
              )),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                  child: DropdownGlobal(
                listItems: const ['Cabang Sawangan', 'Cabang Bedahan'],
                value: state.employee?.nameBranch,
                hint: '-- Pilih --',
                onChanged: (p0) {
                  var empl = state.employee;
                  if (empl == null) {
                    empl = EmployeeModel(nameBranch: p0.toString());
                  } else {
                    empl = empl.copyWith(nameBranch: p0.toString());
                  }
                  context
                      .read<CreateEmployeeBloc>()
                      .add(CreateEmployeeChangedEvent(employeeData: empl));
                },
                title: 'Cabang',
              )),
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
                  onChanged: (p0) {
                    var empl = state.employee;
                    if (empl == null) {
                      empl = EmployeeModel(totalCuti: p0);
                    } else {
                      empl = empl.copyWith(totalCuti: p0);
                    }
                    context
                        .read<CreateEmployeeBloc>()
                        .add(CreateEmployeeChangedEvent(employeeData: empl));
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
                  onChanged: (p0) {
                    var empl = state.employee;
                    if (empl == null) {
                      empl = EmployeeModel(remainingCuti: p0);
                    } else {
                      empl = empl.copyWith(remainingCuti: p0);
                    }
                    context
                        .read<CreateEmployeeBloc>()
                        .add(CreateEmployeeChangedEvent(employeeData: empl));
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
              Expanded(
                  child: DropdownGlobal(
                listItems: const ['IT Support', 'Finance', 'HRD', 'OB'],
                value: state.employee?.workingPosition,
                hint: '-- Pilih --',
                onChanged: (p0) {
                  var empl = state.employee;
                  if (empl == null) {
                    empl = EmployeeModel(workingPosition: p0.toString());
                  } else {
                    empl = empl.copyWith(workingPosition: p0.toString());
                  }
                  context
                      .read<CreateEmployeeBloc>()
                      .add(CreateEmployeeChangedEvent(employeeData: empl));
                },
                title: 'Jabatan',
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
                  context
                      .read<CreateEmployeeBloc>()
                      .add(CreateEmployeeChangedEvent(employeeData: empl));
                },
                title: 'Status',
              )),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ButtonGlobal(
                message: "Simpan",
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    print("STATE : ${state.employee?.toJson()}");
                    context.read<CreateEmployeeBloc>().add(
                        CreateEmployeeAddedEvent(
                            employeeData: EmployeeModel.fromJson(
                                state.employee?.toJson() ?? {})));
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
