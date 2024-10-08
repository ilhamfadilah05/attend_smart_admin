// ignore_for_file: use_build_context_synchronously

import 'package:attend_smart_admin/bloc/account/account_cubit.dart';
import 'package:attend_smart_admin/bloc/history-attend/history_attend_bloc.dart';
import 'package:attend_smart_admin/bloc/theme/theme_cubit.dart';
import 'package:attend_smart_admin/components/global_alert_component.dart';
import 'package:attend_smart_admin/components/global_breadcrumb_component.dart';
import 'package:attend_smart_admin/components/global_color_components.dart';
import 'package:attend_smart_admin/components/global_data_table_component.dart';
import 'package:attend_smart_admin/components/global_dialog_component.dart';
import 'package:attend_smart_admin/components/global_text_component.dart';
import 'package:attend_smart_admin/models/account_model.dart';
import 'package:attend_smart_admin/models/data_table_model.dart';
import 'package:attend_smart_admin/repository/history-attend/history_attend_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:icons_plus/icons_plus.dart';

class HistoryAttendPages extends StatefulWidget {
  const HistoryAttendPages({super.key});

  @override
  State<HistoryAttendPages> createState() => _HistoryAttendPagesState();
}

class _HistoryAttendPagesState extends State<HistoryAttendPages> {
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
      context.read<HistoryAttendBloc>().add(HistoryAttendLoadedEvent(
          idCompany: accountData.idCompany!, page: 1, limit: 5));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, bool>(
      builder: (context, state) {
        return BlocListener<HistoryAttendBloc, HistoryAttendState>(
          listener: (context, stateListener) {
            if (stateListener is HistoryAttendDeleteSuccessState) {
              alertNotification(
                  context: context,
                  type: 'success',
                  message: 'Berhasil menghapus data cabang.',
                  title: 'Berhasil!');
              context.read<HistoryAttendBloc>().add(HistoryAttendLoadedEvent(
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
                    message: 'Histori Absensi',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const BreadCrumbGlobal(
                    firstHref: '/history/page',
                    firstTitle: 'Histori Absensi',
                    typeBreadcrumb: 'List',
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  BlocBuilder<HistoryAttendBloc, HistoryAttendState>(
                    builder: (context, state) {
                      if (state is HistoryAttendLoadingState) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is HistoryAttendErrorState) {
                        return Container();
                      } else if (state is HistoryAttendEmptyState) {
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
                      } else if (state is HistoryAttendLoadedState) {
                        return DataTableWidget(
                          listData:
                              state.listHistoryAttend.map((e) => e).toList(),
                          listHeaderTable:
                              HistoryAttendRepository.listHeaderTable,
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
                              context.go('/history/edit?id=$id');
                            });
                          },
                          onTapDelete: (id) {
                            dialogQuestion(context, onTapYes: () {
                              context
                                  .read<HistoryAttendBloc>()
                                  .add(HistoryAttendDeleteEvent(id: id));
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
                            context.read<HistoryAttendBloc>().add(
                                HistoryAttendLoadedEvent(
                                    idCompany: accountData.idCompany!,
                                    page: page,
                                    limit: state.limit));
                          },
                          onTapLimit: (limit) {
                            context.read<HistoryAttendBloc>().add(
                                HistoryAttendLoadedEvent(
                                    idCompany: accountData.idCompany!,
                                    page: 1,
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
