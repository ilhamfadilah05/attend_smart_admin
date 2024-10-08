// ignore_for_file: use_build_context_synchronously

import 'package:attend_smart_admin/bloc/account/account_cubit.dart';
import 'package:attend_smart_admin/bloc/broadcast/broadcast_bloc.dart';
import 'package:attend_smart_admin/bloc/employee/employee_bloc.dart';
import 'package:attend_smart_admin/bloc/theme/theme_cubit.dart';
import 'package:attend_smart_admin/components/global_alert_component.dart';
import 'package:attend_smart_admin/components/global_breadcrumb_component.dart';
import 'package:attend_smart_admin/components/global_button_component.dart';
import 'package:attend_smart_admin/components/global_color_components.dart';
import 'package:attend_smart_admin/components/global_data_table_component.dart';
import 'package:attend_smart_admin/components/global_dialog_component.dart';
import 'package:attend_smart_admin/components/global_loading_component.dart';
import 'package:attend_smart_admin/components/global_random_string_component.dart';
import 'package:attend_smart_admin/components/global_text_component.dart';
import 'package:attend_smart_admin/models/account_model.dart';
import 'package:attend_smart_admin/models/broadcast_model.dart';
import 'package:attend_smart_admin/models/data_table_model.dart';
import 'package:attend_smart_admin/models/employee_model.dart';
import 'package:attend_smart_admin/repository/broadcast/broadcast_repository.dart';
import 'package:attend_smart_admin/utilities/push_notification_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:icons_plus/icons_plus.dart';

class BroadcastPages extends StatefulWidget {
  const BroadcastPages({super.key});

  @override
  State<BroadcastPages> createState() => _BroadcastPagesState();
}

class _BroadcastPagesState extends State<BroadcastPages> {
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
      context.read<BroadcastBloc>().add(BroadcastLoadedEvent(
          idCompany: accountData.idCompany!, page: 1, limit: 5));
      context.read<EmployeeBloc>().add(EmployeeLoadedEvent(
          idCompany: accountData.idCompany!, page: 1, limit: 1000));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, bool>(
      builder: (context, state) {
        return BlocListener<BroadcastBloc, BroadcastState>(
          listener: (context, state) {
            if (state is BroadcastDeleteSuccessState) {
              alertNotification(
                  context: context,
                  type: 'success',
                  message: 'Berhasil menghapus data broadcast.',
                  title: 'Berhasil!');
              context.read<BroadcastBloc>().add(BroadcastLoadedEvent(
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
                    message: 'Broadcast',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const BreadCrumbGlobal(
                    firstHref: '/broadcast/page',
                    firstTitle: 'Broadcast',
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
                              message: 'Tambah Broadcast',
                              onPressed: () {
                                Router.neglect(context, () {
                                  context.go('/broadcast/create');
                                });
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
                              message: 'Tambah Broadcast',
                              onPressed: () {
                                Router.neglect(context, () {
                                  context.go('/broadcast/create');
                                });
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
                  BlocBuilder<BroadcastBloc, BroadcastState>(
                    builder: (context, state) {
                      if (state is BroadcastLoadingState) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is BroadcastErrorState) {
                        return Container();
                      } else if (state is BroadcastEmptyState) {
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
                      } else if (state is BroadcastLoadedState) {
                        return BlocBuilder<EmployeeBloc, EmployeeState>(
                          builder: (context, stateEmployee) {
                            var listEmployee = <EmployeeModel>[];
                            if (stateEmployee is EmployeeLoadedState) {
                              listEmployee = stateEmployee.listEmployee
                                  .map((e) => EmployeeModel.fromJson(e))
                                  .toList();
                            }
                            return DataTableWidget(
                              listData:
                                  state.listBroadcast.map((e) => e).toList(),
                              listHeaderTable:
                                  BroadcastRepository.listHeaderTable,
                              dataTableOthers: DataTableOthersModel(
                                page: state.page,
                                pageSize: state.lengthData,
                                limit: state.limit,
                                totalData: state.lengthData,
                              ),
                              isEdit: true,
                              isDelete: true,
                              onTapIcon: (id) {
                                dialogQuestion(context, onTapYes: () {
                                  sendNotificationToEmployee(
                                      context,
                                      listEmployee,
                                      BroadcastModel.fromJson(state
                                          .listBroadcast
                                          .firstWhere((element) =>
                                              element['id'] == id)));
                                },
                                    message:
                                        "Apakah kamu yakin ingin mengirim broadcast ini ke semua karyawan?");
                              },
                              icon: Container(
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.green),
                                  child: const Icon(
                                    Iconsax.send_1_outline,
                                    color: Colors.white,
                                    size: 17,
                                  )),
                              onTapEdit: (id) {
                                Router.neglect(context, () {
                                  context.go('/broadcast/edit?id=$id');
                                });
                              },
                              onTapDelete: (id) {
                                dialogQuestion(context, onTapYes: () {
                                  context.read<BroadcastBloc>().add(
                                      BroadcastDeleteEvent(
                                          dataBroadcast:
                                              BroadcastModel.fromJson(state
                                                  .listBroadcast
                                                  .firstWhere((element) =>
                                                      element['id'] == id))));
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
                                context.read<BroadcastBloc>().add(
                                    BroadcastLoadedEvent(
                                        idCompany: accountData.idCompany!,
                                        page: page,
                                        limit: state.limit));
                              },
                              onTapLimit: (limit) {
                                context.read<BroadcastBloc>().add(
                                    BroadcastLoadedEvent(
                                        idCompany: accountData.idCompany!,
                                        page: 1,
                                        limit: int.parse(limit)));
                              },
                              onTapSort: (indexHeader, key) {},
                            );
                          },
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

  void sendNotificationToEmployee(BuildContext context,
      List<EmployeeModel> listEmployee, BroadcastModel dataBroadcast) async {
    Navigator.pop(context);
    loadingGlobal(context);
    for (var employee in listEmployee) {
      var dataSendBroadcast = BroadcastSendModel(
          id: "broadcast_send_${employee.id}_${getRandomString(4)}",
          idBroadcast: dataBroadcast.id,
          idEmployee: employee.id,
          nameEmployee: employee.name,
          title: dataBroadcast.title,
          body: dataBroadcast.subTitle,
          image: dataBroadcast.imageUrl,
          tokenNotif: employee.tokenNotif);
      PushNotificationService.sendNotificationToEmployee(
          dataSendBroadcast, context);
      BroadcastRepository().addBroadcastSend(broadcast: dataSendBroadcast);
    }
    Navigator.pop(context);
    alertNotification(
        context: context,
        type: "success",
        message: "Berhasil mengirim notifikasi!");
  }
}
