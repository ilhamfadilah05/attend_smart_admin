// ignore_for_file: use_build_context_synchronously

import 'package:attend_smart_admin/bloc/account/account_cubit.dart';
import 'package:attend_smart_admin/bloc/history-attend/history_attend_bloc.dart';
import 'package:attend_smart_admin/bloc/submission/submission_bloc.dart';
import 'package:attend_smart_admin/bloc/theme/theme_cubit.dart';
import 'package:attend_smart_admin/components/global_alert_component.dart';
import 'package:attend_smart_admin/components/global_breadcrumb_component.dart';
import 'package:attend_smart_admin/components/global_button_component.dart';
import 'package:attend_smart_admin/components/global_color_components.dart';
import 'package:attend_smart_admin/components/global_form_component.dart';
import 'package:attend_smart_admin/components/global_text_component.dart';
import 'package:attend_smart_admin/models/account_model.dart';
import 'package:attend_smart_admin/models/submission_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class CreateSubmissionPages extends StatefulWidget {
  const CreateSubmissionPages({super.key});

  @override
  State<CreateSubmissionPages> createState() => _CreateSubmissionPagesState();
}

class _CreateSubmissionPagesState extends State<CreateSubmissionPages> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    getAccountData(context);
    super.initState();
  }

  void getAccountData(BuildContext context) async {
    var accountData =
        await context.read<AccountCubit>().init() ?? AccountModel();

    if (accountData.idCompany == null) {
      Router.neglect(context, () {
        context.pushReplacement('/login');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (GoRouterState.of(context).matchedLocation.contains('/jabatan/create')) {
      context.read<CreateSubmissionBloc>().add(CreateSubmissionInitialEvent());
    } else {
      context.read<CreateSubmissionBloc>().add(CreateSubmissionByIdEvent(
          id: GoRouterState.of(context).uri.queryParameters['id']!));
    }
    return BlocBuilder<ThemeCubit, bool>(
      builder: (context, state) {
        return BlocListener<CreateSubmissionBloc, CreateSubmissionState>(
          listener: (context, state) {
            if (state is CreateSubmissionSuccessState) {
              alertNotification(
                  context: context,
                  type: 'success',
                  message: state.isUpdateSubmission
                      ? 'Berhasil merubah data pengajuan!'
                      : 'Berhasil menambahkan data pengajuan!',
                  title: 'Berhasil');
              context.go('/submission/page');
            } else if (state is CreateSubmissionErrorState) {
              alertNotification(
                  context: context, type: 'error', message: state.errorMessage);
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
                  message: 'Edit Pengajuan',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                const SizedBox(
                  height: 10,
                ),
                BreadCrumbGlobal(
                  firstHref: '/submission/page',
                  firstTitle: 'Pengajuan',
                  typeBreadcrumb:
                      GoRouterState.of(context).uri.queryParameters['id'] ==
                              null
                          ? 'Create'
                          : 'Edit',
                ),
                const SizedBox(
                  height: 40,
                ),
                BlocBuilder<CreateSubmissionBloc, CreateSubmissionState>(
                  builder: (context, state) {
                    return Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 5),
                                  decoration: BoxDecoration(
                                      color:
                                          state.submission?.status == 'pending'
                                              ? Colors.amber
                                              : state.submission?.status ==
                                                      'approved'
                                                  ? Colors.green
                                                  : Colors.grey,
                                      borderRadius: BorderRadius.circular(100)),
                                  child: TextGlobal(
                                    message: state.submission?.status ?? '',
                                    colorText: Colors.white,
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
                                    title: "Nama Karyawan",
                                    isDisabled: true,
                                    controller: state.isUpdate == false
                                        ? state.formStatus is InitialFormStatus
                                            ? TextEditingController(text: '')
                                            : null
                                        : TextEditingController(
                                            text:
                                                state.submission?.nameEmployee),
                                    onChanged: (p0) {
                                      var empl = state.submission;
                                      if (empl == null) {
                                        empl =
                                            SubmissionModel(nameEmployee: p0);
                                      } else {
                                        empl = empl.copyWith(nameEmployee: p0);
                                      }

                                      context.read<CreateSubmissionBloc>().add(
                                          CreateSubmissionChangedEvent(
                                              submissionData: empl,
                                              isUpdate: false));
                                    },
                                    validator: (p0) {
                                      if (state.submission == null ||
                                          state.submission!.nameEmployee ==
                                              null) {
                                        return 'Nama Karyawan harus diisi!';
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
                                    title: "Tipe Pengajuan",
                                    isDisabled: true,
                                    controller: state.isUpdate == false
                                        ? state.formStatus is InitialFormStatus
                                            ? TextEditingController(text: '')
                                            : null
                                        : TextEditingController(
                                            text: state.submission?.type),
                                    onChanged: (p0) {
                                      var empl = state.submission;
                                      if (empl == null) {
                                        empl = SubmissionModel(type: p0);
                                      } else {
                                        empl = empl.copyWith(type: p0);
                                      }

                                      context.read<CreateSubmissionBloc>().add(
                                          CreateSubmissionChangedEvent(
                                              submissionData: empl,
                                              isUpdate: false));
                                    },
                                    validator: (p0) {
                                      if (state.submission == null ||
                                          state.submission!.type == null) {
                                        return 'Nama Karyawan harus diisi!';
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
                                    title: "Tanggal",
                                    isDisabled: true,
                                    controller: state.isUpdate == false
                                        ? state.formStatus is InitialFormStatus
                                            ? TextEditingController(text: '')
                                            : null
                                        : TextEditingController(
                                            text:
                                                "${DateFormat('dd MMM yyyy').format(DateTime.parse(state.submission!.dateStart!))} s/d ${DateFormat('dd MMM yyyy').format(DateTime.parse(state.submission!.dateEnd!))}"),
                                    onChanged: (p0) {
                                      var empl = state.submission;
                                      if (empl == null) {
                                        empl = SubmissionModel(status: p0);
                                      } else {
                                        empl = empl.copyWith(status: p0);
                                      }

                                      context.read<CreateSubmissionBloc>().add(
                                          CreateSubmissionChangedEvent(
                                              submissionData: empl,
                                              isUpdate: false));
                                    },
                                    validator: (p0) {
                                      if (state.submission == null ||
                                          state.submission!.status == null) {
                                        return 'Nama Karyawan harus diisi!';
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
                                    title: "Keterangan",
                                    isDisabled: true,
                                    controller: state.isUpdate == false
                                        ? state.formStatus is InitialFormStatus
                                            ? TextEditingController(text: '')
                                            : null
                                        : TextEditingController(
                                            text: state.submission?.reason),
                                    onChanged: (p0) {
                                      var empl = state.submission;
                                      if (empl == null) {
                                        empl = SubmissionModel(reason: p0);
                                      } else {
                                        empl = empl.copyWith(reason: p0);
                                      }

                                      context.read<CreateSubmissionBloc>().add(
                                          CreateSubmissionChangedEvent(
                                              submissionData: empl,
                                              isUpdate: false));
                                    },
                                    validator: (p0) {
                                      if (state.submission == null ||
                                          state.submission!.reason == null) {
                                        return 'Nama Karyawan harus diisi!';
                                      }

                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            state.submission?.status == 'approved'
                                ? Container()
                                : BlocBuilder<AccountCubit, AccountState>(
                                    builder: (context, stateAccount) {
                                      return Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          ButtonGlobal(
                                            message: "Batalkan Pengajuan",
                                            onPressed: () {},
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          ButtonGlobal(
                                            message: "Terima Pengajuan",
                                            onPressed: () {
                                              if (_formKey.currentState!
                                                  .validate()) {
                                                var dataSubmission =
                                                    state.submission;
                                                dataSubmission?.status =
                                                    'approved';
                                                context
                                                    .read<
                                                        CreateSubmissionBloc>()
                                                    .add(CreateSubmissionAddedEvent(
                                                        submissionData:
                                                            dataSubmission ??
                                                                SubmissionModel(),
                                                        accountData: stateAccount
                                                                is AccountLoaded
                                                            ? stateAccount
                                                                .account
                                                            : AccountModel()));
                                              }
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                          ],
                        ));
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
