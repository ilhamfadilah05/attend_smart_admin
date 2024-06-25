import 'package:attend_smart_admin/bloc/theme/theme_cubit.dart';
import 'package:attend_smart_admin/components/global_color_components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateDepartmentPages extends StatefulWidget {
  const CreateDepartmentPages({super.key});

  @override
  State<CreateDepartmentPages> createState() => _CreateDepartmentPagesState();
}

class _CreateDepartmentPagesState extends State<CreateDepartmentPages> {
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
            children: [],
          ),
        );
      },
    );
  }
}
