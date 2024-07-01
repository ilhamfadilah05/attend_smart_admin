// ignore_for_file: use_build_context_synchronously

import 'package:attend_smart_admin/bloc/account/account_cubit.dart';
import 'package:attend_smart_admin/bloc/history-attend/history_attend_bloc.dart';
import 'package:attend_smart_admin/bloc/theme/theme_cubit.dart';
import 'package:attend_smart_admin/components/global_alert_component.dart';
import 'package:attend_smart_admin/components/global_breadcrumb_component.dart';
import 'package:attend_smart_admin/components/global_button_component.dart';
import 'package:attend_smart_admin/components/global_color_components.dart';
import 'package:attend_smart_admin/components/global_table_component.dart';
import 'package:attend_smart_admin/components/global_text_component.dart';
import 'package:attend_smart_admin/models/account_model.dart';
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
  var page = 1;

  @override
  void initState() {
    getAccountData(context);
    super.initState();
  }

  void getAccountData(BuildContext context) async {
    accountData = await context.read<AccountCubit>().init() ?? AccountModel();

    if (accountData.idCompany == null) {
      context.pushReplacement('/login');
    } else {
      context
          .read<HistoryAttendBloc>()
          .add(HistoryAttendLoadedEvent(idCompany: accountData.idCompany!));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, bool>(
      builder: (context, state) {
        return BlocListener<HistoryAttendBloc, HistoryAttendState>(
          listener: (context, state) {
            if (state is HistoryAttendDeleteSuccessState) {
              alertNotification(
                  context: context,
                  type: 'success',
                  message: 'Berhasil menghapus data cabang.',
                  title: 'Berhasil!');
              context.read<HistoryAttendBloc>().add(
                  HistoryAttendLoadedEvent(idCompany: accountData.idCompany!));
            }
          },
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
                  firstHref: '/history-attend/page',
                  firstTitle: 'Histori Absensi',
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
                            message: 'Tambah Histori',
                            onPressed: () {
                              context.namedLocation('/history-attend/create');
                            },
                            colorBtn: blueDefaultLight,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          ButtonGlobal(
                            message: 'Filter',
                            onPressed: () {},
                          ),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ButtonGlobal(
                            message: 'Tambah Histori Absensi',
                            onPressed: () {
                              context.go('/history-attend/create');
                            },
                            colorBtn: blueDefaultLight,
                          ),
                          ButtonGlobal(
                            message: 'Filter',
                            onPressed: () {},
                          ),
                        ],
                      ),
                const SizedBox(
                  height: 20,
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
                      return FutureBuilder(
                        future: listDataTableHistoryAttend(
                            state.listHistoryAttend, context),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return Container();
                          } else if (snapshot.hasData) {
                            var listDataHistoryAttend = snapshot.data;
                            return TableGlobal(
                                data: listDataHistoryAttend!,
                                headers: listHeaderTableHistoryAttend,
                                page: page,
                                pageChanged: (p0) {
                                  setState(() {
                                    page = p0;
                                  });
                                  context.read<HistoryAttendBloc>().add(
                                      HistoryAttendLoadedEvent(
                                          idCompany: accountData.idCompany!));
                                },
                                pageTotal: 0,
                                widthTable:
                                    MediaQuery.of(context).size.width <= 800
                                        ? 150
                                        : 200);
                          }

                          return Center(child: TextGlobal(message: 'message'));
                        },
                      );
                    }

                    return Container();
                  },
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
