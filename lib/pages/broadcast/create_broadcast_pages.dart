// ignore_for_file: use_build_context_synchronously

import 'package:attend_smart_admin/bloc/account/account_cubit.dart';
import 'package:attend_smart_admin/bloc/broadcast/broadcast_bloc.dart';
import 'package:attend_smart_admin/bloc/history-attend/history_attend_bloc.dart';
import 'package:attend_smart_admin/bloc/theme/theme_cubit.dart';
import 'package:attend_smart_admin/components/global_alert_component.dart';
import 'package:attend_smart_admin/components/global_breadcrumb_component.dart';
import 'package:attend_smart_admin/components/global_button_component.dart';
import 'package:attend_smart_admin/components/global_color_components.dart';
import 'package:attend_smart_admin/components/global_form_component.dart';
import 'package:attend_smart_admin/components/global_loading_component.dart';
import 'package:attend_smart_admin/components/global_responsive_component.dart';
import 'package:attend_smart_admin/components/global_text_component.dart';
import 'package:attend_smart_admin/models/account_model.dart';
import 'package:attend_smart_admin/models/broadcast_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:image_picker_web/image_picker_web.dart';

class CreateBroadcastPages extends StatefulWidget {
  const CreateBroadcastPages({super.key});

  @override
  State<CreateBroadcastPages> createState() => _CreateBroadcastPagesState();
}

class _CreateBroadcastPagesState extends State<CreateBroadcastPages> {
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
    if (GoRouterState.of(context)
        .matchedLocation
        .contains('/broadcast/create')) {
      context.read<CreateBroadcastBloc>().add(CreateBroadcastInitialEvent());
    } else {
      context.read<CreateBroadcastBloc>().add(CreateBroadcastByIdEvent(
          id: GoRouterState.of(context).uri.queryParameters['id']!));
    }
    return BlocBuilder<ThemeCubit, bool>(
      builder: (context, state) {
        return BlocListener<CreateBroadcastBloc, CreateBroadcastState>(
          listener: (context, state) {
            if (state is CreateBroadcastSuccessState) {
              alertNotification(
                  context: context,
                  type: 'success',
                  message: state.isUpdateBroadcast
                      ? 'Berhasil merubah data broadcast!'
                      : 'Berhasil menambahkan data broadcast!',
                  title: 'Berhasil');
              context.go('/broadcast/page');
            } else if (state is CreateBroadcastErrorState) {
              alertNotification(
                  context: context, type: 'error', message: state.errorMessage);
            } else if (state is CreateBroadcastLoadingState) {
              loadingGlobal(context);
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
                  message: 'Tambah Broadcast',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                const SizedBox(
                  height: 10,
                ),
                BreadCrumbGlobal(
                  firstHref: '/broadcast/page',
                  firstTitle: 'Broadcast',
                  typeBreadcrumb:
                      GoRouterState.of(context).uri.queryParameters['id'] ==
                              null
                          ? 'Create'
                          : 'Edit',
                ),
                const SizedBox(
                  height: 40,
                ),
                BlocBuilder<CreateBroadcastBloc, CreateBroadcastState>(
                  builder: (context, state) {
                    return Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                state.broadcast?.imageBytes != null
                                    ? InkWell(
                                        onTap: () async {
                                          try {
                                            var pickedFile =
                                                await ImagePickerWeb
                                                    .getImageAsBytes();

                                            if (pickedFile == null) return;

                                            var empl = state.broadcast;
                                            if (empl == null) {
                                              empl = BroadcastModel(
                                                  imageBytes: pickedFile);
                                            } else {
                                              empl = empl.copyWith(
                                                  imageBytes: pickedFile);
                                            }

                                            context
                                                .read<CreateBroadcastBloc>()
                                                .add(
                                                    CreateBroadcastChangedEvent(
                                                        broadcastData: empl,
                                                        isUpdate: false));
                                          } catch (e) {
                                            if (kDebugMode) {
                                              print(e.toString());
                                            }
                                          }
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              border: Border.all(
                                                color: Colors.grey
                                                    .withOpacity(0.2),
                                              )),
                                          width: 150,
                                          child: Image.memory(
                                              state.broadcast!.imageBytes!),
                                        ),
                                      )
                                    : state.broadcast?.imageUrl != null
                                        ? InkWell(
                                            onTap: () async {
                                              try {
                                                var pickedFile =
                                                    await ImagePickerWeb
                                                        .getImageAsBytes();

                                                if (pickedFile == null) return;

                                                var empl = state.broadcast;
                                                if (empl == null) {
                                                  empl = BroadcastModel(
                                                      imageBytes: pickedFile);
                                                } else {
                                                  empl = empl.copyWith(
                                                      imageBytes: pickedFile);
                                                }

                                                context
                                                    .read<CreateBroadcastBloc>()
                                                    .add(
                                                        CreateBroadcastChangedEvent(
                                                            broadcastData: empl,
                                                            isUpdate: false));
                                              } catch (e) {
                                                if (kDebugMode) {
                                                  print(e.toString());
                                                }
                                              }
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  border: Border.all(
                                                    color: Colors.grey
                                                        .withOpacity(0.2),
                                                  )),
                                              width: 150,
                                              child: Image.network(
                                                  state.broadcast!.imageUrl!),
                                            ),
                                          )
                                        : InkWell(
                                            onTap: () async {
                                              try {
                                                var pickedFile =
                                                    await ImagePickerWeb
                                                        .getImageAsBytes();

                                                if (pickedFile == null) return;

                                                var empl = state.broadcast;
                                                if (empl == null) {
                                                  empl = BroadcastModel(
                                                      imageBytes: pickedFile);
                                                } else {
                                                  empl = empl.copyWith(
                                                      imageBytes: pickedFile);
                                                }

                                                context
                                                    .read<CreateBroadcastBloc>()
                                                    .add(
                                                        CreateBroadcastChangedEvent(
                                                            broadcastData: empl,
                                                            isUpdate: false));
                                              } catch (e) {
                                                if (kDebugMode) {
                                                  print(e.toString());
                                                }
                                              }
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  border: Border.all(
                                                    color: Colors.grey
                                                        .withOpacity(0.2),
                                                  )),
                                              width: 80,
                                              height: 80,
                                              child: const Icon(
                                                Iconsax.image_outline,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          )
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            ResponsiveForm.responsiveForm(
                              children: [
                                FormGlobal(
                                  title: "Judul",
                                  controller: state.isUpdate == false
                                      ? state.formStatus is InitialFormStatus
                                          ? TextEditingController(text: '')
                                          : null
                                      : TextEditingController(
                                          text: state.broadcast?.title),
                                  onChanged: (p0) {
                                    var empl = state.broadcast;
                                    if (empl == null) {
                                      empl = BroadcastModel(title: p0);
                                    } else {
                                      empl = empl.copyWith(title: p0);
                                    }

                                    context.read<CreateBroadcastBloc>().add(
                                        CreateBroadcastChangedEvent(
                                            broadcastData: empl,
                                            isUpdate: false));
                                  },
                                  validator: (p0) {
                                    if (state.broadcast == null ||
                                        state.broadcast!.title == null) {
                                      return 'Nama harus diisi!';
                                    }

                                    return null;
                                  },
                                ),
                                FormGlobal(
                                  maxLines: 5,
                                  title: "Deskripsi",
                                  controller: state.isUpdate == false
                                      ? state.formStatus is InitialFormStatus
                                          ? TextEditingController(text: '')
                                          : null
                                      : TextEditingController(
                                          text: state.broadcast?.subTitle),
                                  onChanged: (p0) {
                                    var empl = state.broadcast;
                                    if (empl == null) {
                                      empl = BroadcastModel(subTitle: p0);
                                    } else {
                                      empl = empl.copyWith(subTitle: p0);
                                    }

                                    context.read<CreateBroadcastBloc>().add(
                                        CreateBroadcastChangedEvent(
                                            broadcastData: empl,
                                            isUpdate: false));
                                  },
                                  validator: (p0) {
                                    if (state.broadcast == null ||
                                        state.broadcast!.title == null) {
                                      return 'Nama harus diisi!';
                                    }

                                    return null;
                                  },
                                ),
                                const SizedBox(
                                  height: 50,
                                ),
                              ],
                            ),
                            BlocBuilder<AccountCubit, AccountState>(
                              builder: (context, stateAccount) {
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    ButtonGlobal(
                                      message: "Simpan",
                                      onPressed: () {
                                        if (_formKey.currentState!.validate()) {
                                          context
                                              .read<CreateBroadcastBloc>()
                                              .add(
                                                CreateBroadcastAddedEvent(
                                                    broadcastData:
                                                        BroadcastModel.fromJson(
                                                      state.broadcast
                                                              ?.toJson() ??
                                                          {},
                                                    ),
                                                    accountData: stateAccount
                                                            is AccountLoaded
                                                        ? stateAccount.account
                                                        : AccountModel()),
                                              );
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
