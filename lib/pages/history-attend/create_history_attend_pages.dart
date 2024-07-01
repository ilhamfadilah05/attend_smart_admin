// ignore_for_file: use_build_context_synchronously, prefer_const_constructors, unused_field, prefer_collection_literals

import 'dart:async';

import 'package:attend_smart_admin/bloc/account/account_cubit.dart';
import 'package:attend_smart_admin/bloc/history-attend/history_attend_bloc.dart';
import 'package:attend_smart_admin/bloc/theme/theme_cubit.dart';
import 'package:attend_smart_admin/components/global_alert_component.dart';
import 'package:attend_smart_admin/components/global_breadcrumb_component.dart';
import 'package:attend_smart_admin/components/global_color_components.dart';
import 'package:attend_smart_admin/components/global_text_component.dart';
import 'package:attend_smart_admin/models/account_model.dart';
import 'package:attend_smart_admin/models/history_attend_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CreateHistoryAttendPages extends StatefulWidget {
  const CreateHistoryAttendPages({super.key});

  @override
  State<CreateHistoryAttendPages> createState() =>
      _CreateHistoryAttendPagesState();
}

class _CreateHistoryAttendPagesState extends State<CreateHistoryAttendPages> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  LatLng latlngPositionMarker = LatLng(-6.400343820250044, 106.77073321452357);

  List<Marker> marker = [];
  CameraPosition? _initialCameraPosition;

  @override
  void initState() {
    getAccountData(context);
    super.initState();
  }

  void getAccountData(BuildContext context) async {
    var accountData =
        await context.read<AccountCubit>().init() ?? AccountModel();

    if (accountData.idCompany == null) {
      context.pushReplacement('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (GoRouterState.of(context).matchedLocation.contains('/cabang/create')) {
      context
          .read<CreateHistoryAttendBloc>()
          .add(CreateHistoryAttendResetEvent());
    } else {
      context.read<CreateHistoryAttendBloc>().add(CreateHistoryAttendByIdEvent(
          id: GoRouterState.of(context).uri.queryParameters['id']!));
    }

    return BlocBuilder<ThemeCubit, bool>(
      builder: (context, state) {
        return BlocListener<CreateHistoryAttendBloc, CreateHistoryAttendState>(
          listener: (context, state) {
            if (state is CreateHistoryAttendSuccessState) {
              alertNotification(
                  context: context,
                  type: 'success',
                  message: state.isUpdateHistoryAttend
                      ? 'Berhasil merubah data cabang!'
                      : 'Berhasil menambahkan data cabang!',
                  title: 'Berhasil');
              context.go('/cabang/page');
            } else if (state is CreateHistoryAttendErrorState) {
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
                  message: 'Tambah Cabang',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                const SizedBox(
                  height: 10,
                ),
                BreadCrumbGlobal(
                  firstHref: '/cabang/page',
                  firstTitle: 'Cabang',
                  typeBreadcrumb:
                      GoRouterState.of(context).uri.queryParameters['id'] ==
                              null
                          ? 'Create'
                          : 'Edit',
                ),
                const SizedBox(
                  height: 40,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextGlobal(
                          message: "Input Data Cabang ",
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        TextGlobal(
                            message: "Silahkan masukkan semua data cabang."),
                      ],
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: _inputDataCabang(),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _inputDataCabang() {
    return BlocBuilder<CreateHistoryAttendBloc, CreateHistoryAttendState>(
      builder: (context, state) {
        return Form(
            key: _formKey,
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 300,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: GoogleMap(
                            mapType: MapType.normal,
                            myLocationEnabled: true,
                            onTap: (argument) {
                              setState(() {
                                marker.clear();
                                marker.add(Marker(
                                    markerId: MarkerId("1"),
                                    position: argument));
                                latlngPositionMarker = argument;
                              });
                              var empl = state.historyAttend;
                              if (empl == null) {
                                empl = HistoryAttendModel(
                                    latLong:
                                        "${latlngPositionMarker.latitude},${latlngPositionMarker.longitude}");
                              } else {
                                empl = empl.copyWith(
                                    latLong:
                                        "${latlngPositionMarker.latitude},${latlngPositionMarker.longitude}");
                              }

                              context.read<CreateHistoryAttendBloc>().add(
                                  CreateHistoryAttendChangedEvent(
                                      historyAttendData: empl,
                                      isUpdate: false));
                            },
                            initialCameraPosition:
                                state.historyAttend?.latLong == null
                                    ? CameraPosition(
                                        target: LatLng(-6.345986064677323,
                                            106.69150610007672),
                                        zoom: 16,
                                      )
                                    : CameraPosition(
                                        target: LatLng(
                                            double.parse(state
                                                .historyAttend!.latLong!
                                                .split(',')[0]),
                                            double.parse(state
                                                .historyAttend!.latLong!
                                                .split(',')[1])),
                                        zoom: 16,
                                      ),
                            markers: Set<Marker>.of(marker.isEmpty == false
                                ? marker
                                : state.historyAttend?.latLong == null
                                    ? []
                                    : [
                                        Marker(
                                            markerId: MarkerId("1"),
                                            position: LatLng(
                                                double.parse(state
                                                        .historyAttend?.latLong!
                                                        .split(',')[0] ??
                                                    '0'),
                                                double.parse(state
                                                        .historyAttend?.latLong!
                                                        .split(',')[1] ??
                                                    '0')))
                                      ]),
                            onMapCreated: (GoogleMapController controller) {
                              _controller.complete(controller);
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                // Row(
                //   children: [
                //     Expanded(
                //       child: FormGlobal(
                //         title: "Nama Cabang",
                //         controller: state.isUpdate == false
                //             ? state.formStatus is InitialFormStatus
                //                 ? TextEditingController(text: '')
                //                 : null
                //             : TextEditingController(text: state.historyAttend?.name),
                //         onChanged: (p0) {
                //           var empl = state.historyAttend;
                //           if (empl == null) {
                //             empl = HistoryAttendModel(name: p0);
                //           } else {
                //             empl = empl.copyWith(name: p0);
                //           }

                //           context.read<CreateHistoryAttendBloc>().add(
                //               CreateHistoryAttendChangedEvent(
                //                   historyAttendData: empl, isUpdate: false));
                //         },
                //         validator: (p0) {
                //           if (state.historyAttend == null ||
                //               state.historyAttend!.name == null) {
                //             return 'Nama harus diisi!';
                //           }

                //           return null;
                //         },
                //       ),
                //     ),
                //     const SizedBox(
                //       width: 10,
                //     ),
                //     Expanded(
                //       child: FormGlobal(
                //         title: "Alamat Cabang",
                //         controller: state.isUpdate == false
                //             ? state.formStatus is InitialFormStatus
                //                 ? TextEditingController(text: '')
                //                 : null
                //             : TextEditingController(
                //                 text: state.historyAttend?.address),
                //         onChanged: (p0) {
                //           var empl = state.historyAttend;
                //           if (empl == null) {
                //             empl = HistoryAttendModel(address: p0);
                //           } else {
                //             empl = empl.copyWith(address: p0);
                //           }

                //           context.read<CreateHistoryAttendBloc>().add(
                //               CreateHistoryAttendChangedEvent(
                //                   historyAttendData: empl, isUpdate: false));
                //         },
                //         validator: (p0) {
                //           if (state.historyAttend == null ||
                //               state.historyAttend!.address == null) {
                //             return 'Alamat harus diisi!';
                //           }

                //           return null;
                //         },
                //       ),
                //     )
                //   ],
                // ),
                // const SizedBox(
                //   height: 10,
                // ),
                // Row(
                //   children: [
                //     Expanded(
                //       child: InkWell(
                //         onTap: () async {
                //           final time = await showTimePicker(
                //               context: context, initialTime: TimeOfDay.now());
                //           var timeInAttendance = time!.format(context);

                //           var empl = state.historyAttend;
                //           if (empl == null) {
                //             empl = HistoryAttendModel(
                //                 timeInAttendance: timeInAttendance
                //                     .replaceAll(' PM', '')
                //                     .replaceAll(" AM", ''));
                //           } else {
                //             empl = empl.copyWith(
                //                 timeInAttendance: timeInAttendance
                //                     .replaceAll(' PM', '')
                //                     .replaceAll(" AM", ''));
                //           }

                //           context.read<CreateHistoryAttendBloc>().add(
                //               CreateHistoryAttendChangedEvent(
                //                   historyAttendData: empl, isUpdate: false));
                //         },
                //         child: FormGlobal(
                //           title: "Jam Masuk",
                //           isDisabled: true,
                //           controller: TextEditingController(
                //               text: state.historyAttend?.timeInAttendance),
                //           onChanged: (p0) {},
                //           validator: (p0) {
                //             if (state.historyAttend == null ||
                //                 state.historyAttend!.timeInAttendance == null) {
                //               return 'Jam Masuk harus diisi!';
                //             }

                //             return null;
                //           },
                //         ),
                //       ),
                //     ),
                //     const SizedBox(
                //       width: 10,
                //     ),
                //     Expanded(
                //       child: InkWell(
                //         onTap: () async {
                //           final time = await showTimePicker(
                //               context: context, initialTime: TimeOfDay.now());
                //           var timeOutAttendance = time!.format(context);
                //           var empl = state.historyAttend;
                //           if (empl == null) {
                //             empl = HistoryAttendModel(
                //                 timeOutAttendance: timeOutAttendance
                //                     .replaceAll(' PM', '')
                //                     .replaceAll(" AM", ''));
                //           } else {
                //             empl = empl.copyWith(
                //                 timeOutAttendance: timeOutAttendance
                //                     .replaceAll(' PM', '')
                //                     .replaceAll(" AM", ''));
                //           }

                //           context.read<CreateHistoryAttendBloc>().add(
                //               CreateHistoryAttendChangedEvent(
                //                   historyAttendData: empl, isUpdate: false));
                //         },
                //         child: FormGlobal(
                //           title: "Jam Keluar",
                //           isDisabled: true,
                //           controller: TextEditingController(
                //               text: state.historyAttend?.timeOutAttendance),
                //           onChanged: (p0) {},
                //           validator: (p0) {
                //             if (state.historyAttend == null ||
                //                 state.historyAttend!.timeOutAttendance == null) {
                //               return 'Jam Keluar harus diisi!';
                //             }

                //             return null;
                //           },
                //         ),
                //       ),
                //     )
                //   ],
                // ),
                // const SizedBox(
                //   height: 10,
                // ),
                // Row(
                //   crossAxisAlignment: CrossAxisAlignment.center,
                //   children: [
                //     SizedBox(
                //       width: 300,
                //       child: FormGlobal(
                //         title: "Radius Absensi",
                //         keyboardType: TextInputType.number,
                //         controller: state.isUpdate == false
                //             ? state.formStatus is InitialFormStatus
                //                 ? TextEditingController(text: '')
                //                 : null
                //             : TextEditingController(
                //                 text: "${state.historyAttend?.radius}"),
                //         onChanged: (p0) {
                //           if (p0 == '') {
                //             return;
                //           }

                //           var empl = state.historyAttend;
                //           if (empl == null) {
                //             empl = HistoryAttendModel(radius: int.parse(p0));
                //           } else {
                //             empl = empl.copyWith(radius: int.parse(p0));
                //           }

                //           context.read<CreateHistoryAttendBloc>().add(
                //               CreateHistoryAttendChangedEvent(
                //                   historyAttendData: empl, isUpdate: false));
                //         },
                //         validator: (p0) {
                //           if (state.historyAttend == null ||
                //               state.historyAttend!.radius == null) {
                //             return 'Alamat harus diisi!';
                //           }

                //           return null;
                //         },
                //       ),
                //     ),
                //     const SizedBox(
                //       width: 10,
                //     ),
                //     Container(
                //         padding: EdgeInsets.only(top: 16),
                //         child: TextGlobal(message: 'Meter'))
                //   ],
                // ),
                // const SizedBox(
                //   height: 20,
                // ),
                // BlocBuilder<AccountCubit, AccountState>(
                //   builder: (context, stateAccount) {
                //     return Row(
                //       mainAxisAlignment: MainAxisAlignment.end,
                //       children: [
                //         ButtonGlobal(
                //           message: "Simpan",
                //           onPressed: () {
                //             if (_formKey.currentState!.validate()) {
                //               context.read<CreateHistoryAttendBloc>().add(
                //                   CreateHistoryAttendAddedEvent(
                //                       historyAttendData: HistoryAttendModel.fromJson(
                //                         state.historyAttend?.toJson() ?? {},
                //                       ),
                //                       accountData: stateAccount is AccountLoaded
                //                           ? stateAccount.account
                //                           : AccountModel()));
                //             }
                //           },
                //         ),
                //       ],
                //     );
                //   },
                // ),
              ],
            ));
      },
    );
  }
}
