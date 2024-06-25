import 'package:attend_smart_admin/bloc/branch/branch_bloc.dart';
import 'package:attend_smart_admin/bloc/department/department_bloc.dart';
import 'package:attend_smart_admin/bloc/employee/employee_bloc.dart';
import 'package:attend_smart_admin/bloc/theme/theme_cubit.dart';
import 'package:attend_smart_admin/components/global_breadcrumb_component.dart';
import 'package:attend_smart_admin/components/global_color_components.dart';
import 'package:attend_smart_admin/components/global_text_component.dart';
import 'package:attend_smart_admin/models/employee_model.dart';
import 'package:attend_smart_admin/widgets/employee/create_form_employee.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateEmployeePages extends StatefulWidget {
  const CreateEmployeePages({super.key});

  @override
  State<CreateEmployeePages> createState() => _CreateEmployeePagesState();
}

class _CreateEmployeePagesState extends State<CreateEmployeePages> {
  @override
  void initState() {
    super.initState();
    context.read<BranchBloc>().add(const BranchLoadedEvent());
    context.read<DepartmentBloc>().add(const DepartmentLoadedEvent());
  }

  @override
  void dispose() {
    context.read<CreateEmployeeBloc>().add(CreateEmployeeInitialEvent());
    super.dispose();
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
                message: 'Tambah Karyawan',
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              const SizedBox(
                height: 10,
              ),
              const BreadCrumbGlobal(
                firstHref: '/karyawan/page',
                firstTitle: 'Karyawan',
                typeBreadcrumb: 'Create',
              ),
              const SizedBox(
                height: 40,
              ),
              CreateFormEmployee()
            ],
          ),
        );
      },
    );
  }
}
