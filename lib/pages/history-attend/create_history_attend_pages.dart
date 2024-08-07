// ignore_for_file: use_build_context_synchronously, prefer_const_constructors, unused_field, prefer_collection_literals, unused_element

import 'dart:async';

import 'package:attend_smart_admin/bloc/account/account_cubit.dart';
import 'package:attend_smart_admin/bloc/history-attend/history_attend_bloc.dart';
import 'package:attend_smart_admin/bloc/theme/theme_cubit.dart';
import 'package:attend_smart_admin/components/global_alert_component.dart';
import 'package:attend_smart_admin/components/global_breadcrumb_component.dart';
import 'package:attend_smart_admin/components/global_color_components.dart';
import 'package:attend_smart_admin/components/global_form_component.dart';
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
    if (GoRouterState.of(context)
        .matchedLocation
        .contains('/history-attend/create')) {
      // context
      //     .read<CreateHistoryAttendBloc>()
      //     .add(CreateHistoryAttendResetEvent());
    } else {
      context.read<CreateHistoryAttendBloc>().add(CreateHistoryAttendByIdEvent(
          id: GoRouterState.of(context).uri.queryParameters['id']!));
    }

    return BlocBuilder<ThemeCubit, bool>(
      builder: (context, stateTheme) {
        return BlocListener<CreateHistoryAttendBloc, CreateHistoryAttendState>(
          listener: (context, stateTheme) {
            if (stateTheme is CreateHistoryAttendSuccessState) {
              alertNotification(
                  context: context,
                  type: 'success',
                  message: stateTheme.isUpdateHistoryAttend
                      ? 'Berhasil merubah data cabang!'
                      : 'Berhasil menambahkan data cabang!',
                  title: 'Berhasil');
              context.go('/cabang/page');
            } else if (stateTheme is CreateHistoryAttendErrorState) {
              alertNotification(
                  context: context,
                  type: 'error',
                  message: stateTheme.errorMessage);
            }
          },
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: stateTheme ? blueDefaultDark : Colors.white,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: Colors.grey.withOpacity(0.2))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextGlobal(
                  message: 'Edit Histori Absensi',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                const SizedBox(
                  height: 10,
                ),
                BreadCrumbGlobal(
                  firstHref: '/history-attend/page',
                  firstTitle: 'Histori absensi',
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
                          message: "Edit Data Histori",
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        TextGlobal(
                            message: "Silahkan edit data histori disini"),
                      ],
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: SizedBox(
                        child: BlocBuilder<CreateHistoryAttendBloc,
                            CreateHistoryAttendState>(
                          builder: (context, state) {
                            return Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: FormGlobal(
                                        title: "Nama Karyawan",
                                        controller: TextEditingController(
                                            text: state
                                                .historyAttend?.nameEmployee),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: FormGlobal(
                                        title: "Jabatan",
                                        controller: TextEditingController(
                                            text: state
                                                .historyAttend?.department),
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: FormGlobal(
                                        title: "Nama Perusahaan",
                                        controller: TextEditingController(
                                            text: state
                                                .historyAttend?.nameCompany),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: FormGlobal(
                                        title: "Nama Cabang",
                                        controller: TextEditingController(
                                            text: state
                                                .historyAttend?.nameBranch),
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: FormGlobal(
                                        title: "Tipe Absen",
                                        controller: TextEditingController(
                                            text:
                                                state.historyAttend?.tipeAbsen),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: FormGlobal(
                                        title: "Status Absen",
                                        controller: TextEditingController(
                                            text: state
                                                .historyAttend?.delayedAttend),
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: FormGlobal(
                                        title: "Tanggal Absensi",
                                        controller: TextEditingController(
                                            text: state
                                                .historyAttend?.dateAttend),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: FormGlobal(
                                        title: "Waktu Absensi",
                                        controller: TextEditingController(
                                            text: state
                                                .historyAttend?.timeAttend),
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: FormGlobal(
                                        title: "Lokasi Absensi",
                                        controller: TextEditingController(
                                            text: state
                                                .historyAttend?.locationAttend),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: FormGlobal(
                                        title: "Longitude & Latitude",
                                        controller: TextEditingController(
                                            text: state.historyAttend?.latLong),
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                              ],
                            );
                          },
                        ),
                      ),
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
              ],
            ));
      },
    );
  }
}
