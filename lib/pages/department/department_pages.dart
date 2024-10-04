// ignore_for_file: use_build_context_synchronously

import 'package:attend_smart_admin/bloc/account/account_cubit.dart';
import 'package:attend_smart_admin/bloc/department/department_bloc.dart';
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
import 'package:attend_smart_admin/repository/department/department_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:icons_plus/icons_plus.dart';

class DepartmentPages extends StatefulWidget {
  const DepartmentPages({super.key});

  @override
  State<DepartmentPages> createState() => _DepartmentPagesState();
}

class _DepartmentPagesState extends State<DepartmentPages> {
  var accountData = AccountModel();
  var page = 1;

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
      context.read<DepartmentBloc>().add(DepartmentLoadedEvent(
          idCompany: accountData.idCompany!, page: 1, limit: 5));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, bool>(
      builder: (context, state) {
        return BlocListener<DepartmentBloc, DepartmentState>(
          listener: (context, state) {
            if (state is DepartmentDeleteSuccessState) {
              alertNotification(
                  context: context,
                  type: 'success',
                  message: 'Berhasil menghapus data jabatan.',
                  title: 'Berhasil!');
              context.read<DepartmentBloc>().add(DepartmentLoadedEvent(
                  idCompany: accountData.idCompany!, page: 1, limit: 5));
            }
          },
          child: SingleChildScrollView(
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
                    message: 'Jabatan',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const BreadCrumbGlobal(
                    firstHref: '/jabatan/page',
                    firstTitle: 'Jabatan',
                    typeBreadcrumb: 'List',
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  MediaQuery.of(context).size.width <= 800
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ButtonGlobal(
                              message: 'Tambah Jabatan',
                              onPressed: () {
                                context.namedLocation('/department/create');
                              },
                              colorBtn: blueDefaultLight,
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
                              message: 'Tambah Jabatan',
                              onPressed: () {
                                context.go('/department/create');
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
                  BlocBuilder<DepartmentBloc, DepartmentState>(
                    builder: (context, state) {
                      if (state is DepartmentLoadingState) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is DepartmentErrorState) {
                        return Container();
                      } else if (state is DepartmentEmptyState) {
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
                      } else if (state is DepartmentLoadedState) {
                        return DataTableWidget(
                          listData: state.listDepartment.map((e) => e).toList(),
                          listHeaderTable: DepartmentRepository.listHeaderTable,
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
                              context.go('/department/edit?id=$id');
                            });
                          },
                          onTapDelete: (id) {
                            dialogQuestion(context, onTapYes: () {
                              context
                                  .read<DepartmentBloc>()
                                  .add(DepartmentDeleteEvent(id: id));
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
                            context.read<DepartmentBloc>().add(
                                DepartmentLoadedEvent(
                                    idCompany: accountData.idCompany!,
                                    page: page,
                                    limit: state.limit));
                          },
                          onTapLimit: (limit) {
                            context.read<DepartmentBloc>().add(
                                DepartmentLoadedEvent(
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
  }
}
