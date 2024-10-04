// ignore_for_file: use_build_context_synchronously

import 'package:attend_smart_admin/bloc/account/account_cubit.dart';
import 'package:attend_smart_admin/bloc/employee/employee_bloc.dart';
import 'package:attend_smart_admin/bloc/theme/theme_cubit.dart';
import 'package:attend_smart_admin/components/global_alert_component.dart';
import 'package:attend_smart_admin/components/global_breadcrumb_component.dart';
import 'package:attend_smart_admin/components/global_button_component.dart';
import 'package:attend_smart_admin/components/global_color_components.dart';
import 'package:attend_smart_admin/components/global_data_table_component.dart';
import 'package:attend_smart_admin/components/global_dialog_component.dart';
import 'package:attend_smart_admin/components/global_text_component.dart';
import 'package:attend_smart_admin/models/account_model.dart';
import 'package:attend_smart_admin/models/data_table_model.dart';
import 'package:attend_smart_admin/repository/employee/employee_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:icons_plus/icons_plus.dart';

class EmployeePages extends StatefulWidget {
  const EmployeePages({super.key});

  @override
  State<EmployeePages> createState() => _EmployeePagesState();
}

class _EmployeePagesState extends State<EmployeePages> {
  var accountData = AccountModel();
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, bool>(
      builder: (context, state) {
        return BlocBuilder<AccountCubit, AccountState>(
          builder: (context, stateAcco) {
            return BlocListener<EmployeeBloc, EmployeeState>(
              listener: (context, state) {
                if (state is EmployeeDeleteSuccessState) {
                  alertNotification(
                      context: context,
                      type: 'success',
                      message: 'Berhasil menghapus data karyawan.',
                      title: 'Berhasil!');
                  context.read<EmployeeBloc>().add(EmployeeLoadedEvent(
                      idCompany: accountData.idCompany ?? '',
                      page: 1,
                      limit: 5));
                }
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: state ? blueDefaultDark : Colors.white,
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: Colors.grey.withOpacity(0.2))),
                child: SingleChildScrollView(
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
                        firstHref: '/employee/page',
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
                                BlocBuilder<CreateEmployeeBloc,
                                    CreateEmployeeState>(
                                  builder: (context, stateCreateEmployee) {
                                    return ButtonGlobal(
                                      message: 'Tambah Karyawan',
                                      onPressed: () {
                                        context.go('/employee/create');
                                      },
                                      colorBtn: blueDefaultLight,
                                    );
                                  },
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                // ButtonGlobal(
                                //   message: 'Filter',
                                //   onPressed: () {},
                                // ),
                              ],
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ButtonGlobal(
                                  message: 'Tambah Karyawan',
                                  onPressed: () {
                                    context.go('/employee/create');
                                  },
                                  colorBtn: blueDefaultLight,
                                ),
                                // ButtonGlobal(
                                //   message: 'Filter',
                                //   onPressed: () {},
                                // ),
                              ],
                            ),
                      const SizedBox(
                        height: 20,
                      ),
                      BlocBuilder<EmployeeBloc, EmployeeState>(
                        builder: (context, state) {
                          if (state is EmployeeLoadingState) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (state is EmployeeErrorState) {
                            return Container();
                          } else if (state is EmployeeEmptyState) {
                            return Center(
                              child: SizedBox(
                                child: Column(
                                  children: [
                                    const Icon(
                                      Iconsax.search_status_outline,
                                      size: 100,
                                      color: Colors.grey,
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    TextGlobal(
                                      message: "Data karyawan tidak ditemukan",
                                      colorText: Colors.grey,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          } else if (state is EmployeeLoadedState) {
                            return DataTableWidget(
                              listData:
                                  state.listEmployee.map((e) => e).toList(),
                              listHeaderTable:
                                  EmployeeRepository.listHeaderTable,
                              dataTableOthers: DataTableOthersModel(
                                page: state.page,
                                pageSize: state.lengthData,
                                limit: state.limit,
                                totalData: state.lengthData,
                              ),
                              isEdit: true,
                              isDelete: true,
                              onTapEdit: (id) {
                                Router.neglect(context, () {
                                  context.go('/employee/edit?id=$id');
                                });
                              },
                              onTapDelete: (id) {
                                dialogQuestion(context, onTapYes: () {
                                  context.read<EmployeeBloc>().add(
                                      EmployeeDeleteEvent(
                                          dataEmployee: state.listEmployee
                                              .firstWhere((element) =>
                                                  element.id == id)));
                                  Navigator.pop(context);
                                },
                                    icon: const Icon(
                                      Iconsax.trash_bold,
                                      color: Colors.red,
                                      size: 100,
                                    ),
                                    message:
                                        'Apakah anda yakin ingin menghapus data ini?');
                              },
                              onTapPage: (page) {
                                context.read<EmployeeBloc>().add(
                                    EmployeeLoadedEvent(
                                        idCompany: accountData.idCompany!,
                                        page: page,
                                        limit: state.limit));
                              },
                              onTapLimit: (limit) {
                                context.read<EmployeeBloc>().add(
                                    EmployeeLoadedEvent(
                                        idCompany: accountData.idCompany!,
                                        page: state.page,
                                        limit: int.parse(limit)));
                              },
                              onTapSort: (indexHeader, key) {},
                            );
                          }

                          return Container();
                        },
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
