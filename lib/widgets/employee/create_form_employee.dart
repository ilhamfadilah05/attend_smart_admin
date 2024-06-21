import 'package:attend_smart_admin/bloc/employee/employee_bloc.dart';
import 'package:attend_smart_admin/components/global_button_component.dart';
import 'package:attend_smart_admin/components/global_form_component.dart';
import 'package:attend_smart_admin/components/global_text_component.dart';
import 'package:attend_smart_admin/models/employee_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icons_plus/icons_plus.dart';

class CreateFormEmployee extends StatelessWidget {
  CreateFormEmployee({
    super.key,
  });
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
          Row(
            children: [
              Center(
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
                    context.read<CreateEmployeeBloc>().add(
                        CreateEmployeeChangedEvent(
                            employeeData: EmployeeModel(name: p0)));
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
                  onChanged: (p0) {
                    context.read<CreateEmployeeBloc>().add(
                        CreateEmployeeChangedEvent(
                            employeeData: EmployeeModel(nik: p0)));
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
                    context.read<CreateEmployeeBloc>().add(
                        CreateEmployeeChangedEvent(
                            employeeData: EmployeeModel(nohp: p0)));
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
                    context.read<CreateEmployeeBloc>().add(
                        CreateEmployeeChangedEvent(
                            employeeData: EmployeeModel(address: p0)));
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
                child: FormGlobal(
                  title: "Total Cuti",
                  onChanged: (p0) {},
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
                  onChanged: (p0) {},
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
                child: FormGlobal(
                  title: "Jabatan",
                  onChanged: (p0) {},
                  validator: (p0) {
                    return '';
                  },
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: FormGlobal(
                  title: "Status",
                  onChanged: (p0) {},
                  validator: (p0) {
                    return '';
                  },
                ),
              ),
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
                    context.read<CreateEmployeeBloc>().add(
                        CreateEmployeeAddedEvent(
                            employeeData: state.employee!));
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
