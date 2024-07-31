// ignore_for_file: use_build_context_synchronously

import 'package:attend_smart_admin/bloc/account/account_cubit.dart';
import 'package:attend_smart_admin/bloc/submission/submission_bloc.dart';
import 'package:attend_smart_admin/bloc/theme/theme_cubit.dart';
import 'package:attend_smart_admin/components/global_alert_component.dart';
import 'package:attend_smart_admin/components/global_breadcrumb_component.dart';
import 'package:attend_smart_admin/components/global_color_components.dart';
import 'package:attend_smart_admin/components/global_table_component.dart';
import 'package:attend_smart_admin/components/global_text_component.dart';
import 'package:attend_smart_admin/models/account_model.dart';
import 'package:attend_smart_admin/repository/submission/submission_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:icons_plus/icons_plus.dart';

class SubmissionPages extends StatefulWidget {
  const SubmissionPages({super.key});

  @override
  State<SubmissionPages> createState() => _SubmissionPagesState();
}

class _SubmissionPagesState extends State<SubmissionPages> {
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
          .read<SubmissionBloc>()
          .add(SubmissionLoadedEvent(idCompany: accountData.idCompany!));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, bool>(
      builder: (context, state) {
        return BlocListener<SubmissionBloc, SubmissionState>(
          listener: (context, state) {
            if (state is SubmissionDeleteSuccessState) {
              alertNotification(
                  context: context,
                  type: 'success',
                  message: 'Berhasil menghapus data jabatan.',
                  title: 'Berhasil!');
              context.read<SubmissionBloc>().add(
                  SubmissionLoadedEvent(idCompany: accountData.idCompany!));
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
                  message: 'Pengajuan',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                const SizedBox(
                  height: 10,
                ),
                const BreadCrumbGlobal(
                  firstHref: '/pengajuan/page',
                  firstTitle: 'Pengajuan',
                  typeBreadcrumb: 'List',
                ),
                const SizedBox(
                  height: 40,
                ),
                BlocBuilder<SubmissionBloc, SubmissionState>(
                  builder: (context, state) {
                    if (state is SubmissionLoadingState) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is SubmissionErrorState) {
                      return Container();
                    } else if (state is SubmissionEmptyState) {
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
                                message: "Data Pengajuan tidak ditemukan",
                                colorText: Colors.grey,
                              ),
                            ],
                          ),
                        ),
                      );
                    } else if (state is SubmissionLoadedState) {
                      return FutureBuilder(
                        future: listDataTableSubmission(
                            state.listSubmission, context),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return Container();
                          } else if (snapshot.hasData) {
                            var listDataSubmission = snapshot.data;
                            return TableGlobal(
                                data: listDataSubmission!,
                                headers: listHeaderTableSubmission,
                                page: page,
                                pageChanged: (p0) {
                                  setState(() {
                                    page = p0;
                                  });
                                  context
                                      .read<SubmissionBloc>()
                                      .add(SubmissionLoadedEvent(
                                        idCompany: accountData.idCompany!,
                                      ));
                                },
                                pageTotal: state.listSubmission.length,
                                widthTable:
                                    MediaQuery.of(context).size.width <= 800
                                        ? 100
                                        : 190);
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
