import 'package:attend_smart_admin/bloc/branch/branch_bloc.dart';
import 'package:attend_smart_admin/bloc/department/department_bloc.dart';
import 'package:attend_smart_admin/bloc/employee/employee_bloc.dart';
import 'package:attend_smart_admin/components/global_button_component.dart';
import 'package:attend_smart_admin/components/global_dropdown_button_component.dart';
import 'package:attend_smart_admin/components/global_form_component.dart';
import 'package:attend_smart_admin/components/global_text_component.dart';
import 'package:attend_smart_admin/models/account_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icons_plus/icons_plus.dart';

// ignore: must_be_immutable
class FilterEmployeePages extends StatefulWidget {
  FilterEmployeePages({super.key, required this.accountData});

  AccountModel accountData;

  @override
  State<FilterEmployeePages> createState() => _FilterEmployeePagesState();
}

class _FilterEmployeePagesState extends State<FilterEmployeePages> {
  String? name;
  String? department;
  String? branch;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: SizedBox(
        width: 400,
        child: Material(
          color: Colors.white,
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(5)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: Row(
                    children: [
                      const Icon(
                        Iconsax.filter_bold,
                        color: Colors.black,
                        size: 30,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      TextGlobal(
                        message: "Filter",
                        colorText: Colors.black,
                        fontSize: 18,
                      ),
                    ],
                  ),
                ),
                const Divider(
                  thickness: 1,
                ),
                Expanded(
                    child: Container(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 5),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        FormGlobal(
                          controller: TextEditingController(text: name),
                          title: "Nama",
                          onChanged: (p0) => name = p0,
                        ),
                        const SizedBox(
                          height: 10,
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
                              value: department,
                              hint: '-- Pilih --',
                              onChanged: (p0) {
                                setState(() {
                                  department = p0.toString();
                                });
                              },
                              title: 'Jabatan',
                            );
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
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
                              value: branch,
                              hint: '-- Pilih --',
                              onChanged: (p0) {
                                setState(() {
                                  branch = p0.toString();
                                });
                              },
                              title: 'Cabang',
                            ));
                          },
                        ),
                      ],
                    ),
                  ),
                )),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                      border: Border(
                          top:
                              BorderSide(color: Colors.grey.withOpacity(0.1)))),
                  height: 80,
                  child: Row(
                    children: [
                      Expanded(
                          child: ButtonGlobal(
                              variant: 'outline',
                              hoverColor: Colors.grey.withOpacity(0.1),
                              message: "Hapus Filter",
                              onPressed: () {
                                Navigator.of(context).pop();
                                setState(() {
                                  name = null;
                                  department = null;
                                  branch = null;
                                });

                                context.read<EmployeeBloc>().add(
                                    EmployeeLoadedEvent(
                                        idCompany:
                                            widget.accountData.idCompany!,
                                        page: 1,
                                        limit: 5,
                                        searchName: name,
                                        searchDepartment: department,
                                        searchBranch: branch));
                              })),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: ButtonGlobal(
                          message: "Submit",
                          onPressed: () {
                            Navigator.of(context).pop();
                            context.read<EmployeeBloc>().add(
                                EmployeeLoadedEvent(
                                    idCompany: widget.accountData.idCompany!,
                                    page: 1,
                                    limit: 5,
                                    searchName: name,
                                    searchDepartment: department,
                                    searchBranch: branch));
                          },
                          width: double.infinity,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
