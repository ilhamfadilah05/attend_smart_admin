// ignore: must_be_immutable
// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:convert';

import 'package:attend_smart_admin/components/global_currency_component.dart';
import 'package:attend_smart_admin/components/global_dropdown_button_component.dart';
import 'package:attend_smart_admin/components/global_text_component.dart';
import 'package:attend_smart_admin/models/data_table_model.dart';
import 'package:attend_smart_admin/models/header_table_model.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:intl/intl.dart';
import 'package:web_pagination/web_pagination.dart';

// ignore: must_be_immutable
class DataTableWidget extends StatelessWidget {
  DataTableWidget(
      {super.key,
      required this.listData,
      required this.listHeaderTable,
      required this.dataTableOthers,
      required this.onTapLimit,
      required this.onTapPage,
      this.onTapSort,
      this.isDelete,
      this.isEdit,
      this.isView,
      this.onTapView,
      this.onTapEdit,
      this.onTapDelete,
      this.icon,
      this.onTapIcon,
      this.myIconBuilder,
      this.isDisableLimitPagination});

  List listData;
  List<HeaderTableModel> listHeaderTable;
  DataTableOthersModel dataTableOthers;
  Function(int indexHeader, String key)? onTapSort;
  Function(String limit) onTapLimit;
  Function(int page) onTapPage;
  Function(String id)? onTapView;
  Function(String id)? onTapEdit;
  Function(String id)? onTapDelete;
  bool? isEdit = false;
  bool? isView = false;
  bool? isDelete = false;
  Widget? icon;
  Function(String id)? onTapIcon;
  Widget Function(String? publish, String? id)? myIconBuilder;
  bool? isDisableLimitPagination = false;
  ScrollController controllerScroll = ScrollController();

  @override
  Widget build(BuildContext context) {
    return listData.isEmpty
        ? Center(
            child: Column(
              children: [
                const SizedBox(
                  height: 50,
                ),
                const Icon(
                  IonIcons.warning,
                  size: 100,
                  color: Colors.grey,
                ),
                const SizedBox(
                  height: 10,
                ),
                TextGlobal(
                  message: "Tidak ada data",
                  colorText: Colors.grey,
                )
              ],
            ),
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Scrollbar(
                thickness: 10,
                controller: controllerScroll,
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  controller: controllerScroll,
                  scrollDirection: Axis.horizontal,
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(5)),
                        child: Row(
                          children:
                              List.generate(listHeaderTable.length, (index) {
                            var data = listHeaderTable[index];
                            return InkWell(
                              focusColor: Colors.grey.withOpacity(0.1),
                              highlightColor: Colors.grey.withOpacity(0.1),
                              splashColor: Colors.grey.withOpacity(0.1),
                              onTap: data.sorting == null
                                  ? null
                                  : () {
                                      onTapSort!(index, data.key ?? '');
                                    },
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(5),
                                        topRight: Radius.circular(5)),
                                    border: Border(
                                      top: BorderSide(
                                          color: Colors.grey.withOpacity(0.2)),
                                      bottom: BorderSide(
                                          color: Colors.grey.withOpacity(0.2)),
                                      left: index == 0
                                          ? BorderSide(
                                              color:
                                                  Colors.grey.withOpacity(0.2))
                                          : BorderSide.none,
                                      right: index == listHeaderTable.length - 1
                                          ? BorderSide(
                                              color:
                                                  Colors.grey.withOpacity(0.2))
                                          : BorderSide.none,
                                    )),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                child: SizedBox(
                                  width: data.width ?? 200,
                                  child: Row(
                                    children: [
                                      TextGlobal(
                                        message: data.label ?? '',
                                        fontSize: 13,
                                      ),
                                      data.sorting == null
                                          ? Container()
                                          : Row(
                                              children: [
                                                const SizedBox(
                                                  width: 2,
                                                ),
                                                Icon(
                                                  data.sorting!
                                                      ? Icons.arrow_upward
                                                      : Icons.arrow_downward,
                                                  size: 12,
                                                ),
                                              ],
                                            )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                      Column(
                        children: List.generate(listData.length, (index) {
                          var data = listData[index];
                          return Container(
                            decoration: BoxDecoration(
                                border: Border(
                              bottom: BorderSide(
                                  color: Colors.grey.withOpacity(0.2)),
                              left: BorderSide(
                                  color: Colors.grey.withOpacity(0.2)),
                              right: BorderSide(
                                  color: Colors.grey.withOpacity(0.2)),
                            )),
                            child: Row(
                              children: List.generate(listHeaderTable.length,
                                  (indexHeader) {
                                var dataHeader = listHeaderTable[indexHeader];
                                String multipleKey = '';
                                if (dataHeader.type == 'price') {
                                  if (dataHeader.key!.split('+').length > 1) {
                                    String amount =
                                        dataHeader.key!.split('+')[0];
                                    String amount2 =
                                        dataHeader.key!.split('+')[1];
                                    int parsedAmount =
                                        data[amount].runtimeType == String
                                            ? int.parse(data[amount])
                                            : data[amount];
                                    int parsedAmount2 =
                                        data[amount2].runtimeType == String
                                            ? int.parse(data[amount2])
                                            : data[amount2];
                                    String formattedCurrency =
                                        CurrencyFormat.convertToIdr(
                                            parsedAmount + parsedAmount2, 0);
                                    multipleKey = 'Rp$formattedCurrency';
                                  }
                                }
                                return dataHeader.key == 'action'
                                    ? isView == false &&
                                            isEdit == false &&
                                            isDelete == false
                                        ? Container()
                                        : Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20, vertical: 10),
                                            child: SizedBox(
                                              width: dataHeader.width ?? 200,
                                              child: Row(
                                                children: [
                                                  myIconBuilder != null
                                                      ? Row(
                                                          children: [
                                                            myIconBuilder!(
                                                                data['published_at'] ==
                                                                        null
                                                                    ? 'Unpublish'
                                                                    : 'Publish',
                                                                data['id']),
                                                            const SizedBox(
                                                              width: 10,
                                                            )
                                                          ],
                                                        )
                                                      : Container(),
                                                  InkWell(
                                                      onTap: () {
                                                        if (onTapIcon != null) {
                                                          onTapIcon!(
                                                              data['id']);
                                                        }
                                                      },
                                                      child:
                                                          icon ?? Container()),
                                                  isView == true
                                                      ? InkWell(
                                                          onTap: () {
                                                            if (onTapView !=
                                                                null) {
                                                              onTapView!(
                                                                  data['id']);
                                                            }
                                                          },
                                                          child: Container(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(5),
                                                              decoration: BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              5),
                                                                  color: Colors
                                                                      .blue),
                                                              child: const Icon(
                                                                Iconsax
                                                                    .eye_outline,
                                                                color: Colors
                                                                    .white,
                                                                size: 17,
                                                              )),
                                                        )
                                                      : Container(),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  isEdit == true
                                                      ? InkWell(
                                                          onTap: () {
                                                            if (onTapEdit !=
                                                                null) {
                                                              onTapEdit!(
                                                                  data['id']);
                                                            }
                                                          },
                                                          child: Container(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(5),
                                                              decoration: BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              5),
                                                                  color: Colors
                                                                          .blue[
                                                                      800]),
                                                              child: const Icon(
                                                                Iconsax
                                                                    .edit_outline,
                                                                color: Colors
                                                                    .white,
                                                                size: 17,
                                                              )),
                                                        )
                                                      : Container(),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  isDelete == true
                                                      ? InkWell(
                                                          onTap: () {
                                                            if (onTapDelete !=
                                                                null) {
                                                              onTapDelete!(
                                                                  data['id']);
                                                            }
                                                          },
                                                          child: Container(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(5),
                                                              decoration: BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              5),
                                                                  color: Colors
                                                                      .red),
                                                              child: const Icon(
                                                                Iconsax
                                                                    .trash_outline,
                                                                color: Colors
                                                                    .white,
                                                                size: 17,
                                                              )),
                                                        )
                                                      : Container()
                                                ],
                                              ),
                                            ),
                                          )
                                    : dataHeader.type == 'image' &&
                                            data[dataHeader.key] != null
                                        ? InkWell(
                                            onTap: () {
                                              showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return Material(
                                                      type: MaterialType
                                                          .transparency,
                                                      child: Center(
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            SizedBox(
                                                              width: 300,
                                                              child: data[dataHeader
                                                                          .key]
                                                                      .contains(
                                                                          'https://')
                                                                  ? Image
                                                                      .network(
                                                                      "${data[dataHeader.key] ?? data[dataHeader.asKeyNull]}",
                                                                      errorBuilder: (context,
                                                                          error,
                                                                          stackTrace) {
                                                                        return SizedBox(
                                                                          width:
                                                                              dataHeader.width ?? 200,
                                                                          child:
                                                                              const Icon(
                                                                            Iconsax.image_outline,
                                                                            color:
                                                                                Colors.grey,
                                                                          ),
                                                                        );
                                                                      },
                                                                    )
                                                                  : Image
                                                                      .memory(
                                                                      base64Decode(
                                                                          "${data[dataHeader.key] ?? data[dataHeader.asKeyNull]}"),
                                                                      errorBuilder: (context,
                                                                          error,
                                                                          stackTrace) {
                                                                        return SizedBox(
                                                                          width:
                                                                              dataHeader.width ?? 200,
                                                                          child:
                                                                              const Icon(
                                                                            Iconsax.image_outline,
                                                                            color:
                                                                                Colors.grey,
                                                                          ),
                                                                        );
                                                                      },
                                                                    ),
                                                            ),
                                                            const SizedBox(
                                                              height: 20,
                                                            ),
                                                            InkWell(
                                                                onTap: () =>
                                                                    Navigator.pop(
                                                                        context),
                                                                child:
                                                                    const Icon(
                                                                  Icons.close,
                                                                  color: Colors
                                                                      .white,
                                                                )),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  });
                                            },
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20,
                                                      vertical: 10),
                                              child: SizedBox(
                                                width: dataHeader.width ?? 200,
                                                child: data[dataHeader.key]
                                                        .contains('https://')
                                                    ? Image.network(
                                                        "${data[dataHeader.key] ?? data[dataHeader.asKeyNull]}",
                                                        errorBuilder: (context,
                                                            error, stackTrace) {
                                                          return SizedBox(
                                                            width: dataHeader
                                                                    .width ??
                                                                200,
                                                            child: const Icon(
                                                              Iconsax
                                                                  .image_outline,
                                                              color:
                                                                  Colors.grey,
                                                            ),
                                                          );
                                                        },
                                                      )
                                                    : Image.memory(
                                                        base64Decode(
                                                            "${data[dataHeader.key] ?? data[dataHeader.asKeyNull]}"),
                                                        errorBuilder: (context,
                                                            error, stackTrace) {
                                                          return SizedBox(
                                                            width: dataHeader
                                                                    .width ??
                                                                200,
                                                            child: const Icon(
                                                              Iconsax
                                                                  .image_outline,
                                                              color:
                                                                  Colors.grey,
                                                            ),
                                                          );
                                                        },
                                                      ),
                                              ),
                                            ),
                                          )
                                        : Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20, vertical: 10),
                                            child: SizedBox(
                                              width: dataHeader.width ?? 200,
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                      child: TextGlobal(
                                                    message: dataHeader.type ==
                                                            'date'
                                                        ? data[dataHeader.key] ==
                                                                null
                                                            ? '-'
                                                            : DateFormat('dd/MM/yyyy, HH:mm').format(data[dataHeader.key]
                                                                        .runtimeType ==
                                                                    String
                                                                ? DateTime.parse(
                                                                    data[dataHeader
                                                                        .key])
                                                                : data[dataHeader
                                                                    .key])
                                                        : dataHeader.type ==
                                                                'price'
                                                            ? dataHeader.key!
                                                                        .split(
                                                                            '+')
                                                                        .length >
                                                                    1
                                                                ? multipleKey
                                                                : "Rp${CurrencyFormat.convertToIdr(data[dataHeader.key].runtimeType == String ? int.parse(data[dataHeader.key] ?? '0') : data[dataHeader.key] ?? 0, 0)}"
                                                            : dataHeader.key ==
                                                                    'published_at'
                                                                ? data[dataHeader.key] == null
                                                                    ? 'Tidak Publish'
                                                                    : "Publish"
                                                                : dataHeader.type == "double-key-date"
                                                                    ? "${DateFormat('dd MMMM yyyy', 'id_ID').format(DateTime.parse(data[dataHeader.key!.split(',')[0]]))} s/d ${DateFormat('dd MMMM yyyy', 'id_ID').format(DateTime.parse(data[dataHeader.key!.split(',')[1]]))}"
                                                                    : "${data[dataHeader.key] ?? data[dataHeader.asKeyNull] ?? '-'}",
                                                    fontSize: 12,
                                                    maxLines: 2,
                                                    textOverflow:
                                                        TextOverflow.ellipsis,
                                                  ))
                                                ],
                                              ),
                                            ),
                                          );
                              }),
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              isDisableLimitPagination == true
                  ? Container()
                  : SizedBox(
                      child: Row(
                        children: [
                          SizedBox(
                            child: Row(
                              children: [
                                WebPaginationWidget(
                                  actualPage: dataTableOthers.page!,
                                  countToDisplay:
                                      MediaQuery.of(context).size.width < 800
                                          ? 2
                                          : 5,
                                  totalPages:
                                      MediaQuery.of(context).size.width < 800
                                          ? (dataTableOthers.pageSize! /
                                                  dataTableOthers.limit!)
                                              .ceil()
                                          : (dataTableOthers.pageSize! /
                                                  dataTableOthers.limit!)
                                              .ceil(),
                                  buttonColor:
                                      const Color.fromARGB(255, 140, 188, 228)
                                          .withOpacity(0.1),
                                  buttonTextColor: Colors.white,
                                  onPageChange: (page) {
                                    onTapPage(page);
                                  },
                                  webPaginationItemBuilder: (context, page,
                                      ButtonType type, onPressed) {
                                    return type == ButtonType.go_to_start
                                        ? InkWell(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            onTap: onPressed,
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 5),
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 3),
                                              decoration: BoxDecoration(
                                                  color: const Color.fromARGB(
                                                          255, 140, 188, 228)
                                                      .withOpacity(0.1),
                                                  borderRadius:
                                                      BorderRadius.circular(3)),
                                              child: Center(
                                                child:
                                                    TextGlobal(message: "<<"),
                                              ),
                                            ),
                                          )
                                        : type == ButtonType.go_to_end
                                            ? InkWell(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                onTap: onPressed,
                                                child: Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 10,
                                                      vertical: 5),
                                                  margin: const EdgeInsets
                                                      .symmetric(horizontal: 3),
                                                  decoration: BoxDecoration(
                                                      color:
                                                          const Color.fromARGB(
                                                                  255,
                                                                  140,
                                                                  188,
                                                                  228)
                                                              .withOpacity(0.1),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              3)),
                                                  child: Center(
                                                    child: TextGlobal(
                                                        message: ">>"),
                                                  ),
                                                ),
                                              )
                                            : type == ButtonType.less
                                                ? InkWell(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    onTap: onPressed,
                                                    child: Container(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 10,
                                                          vertical: 5),
                                                      margin: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 3),
                                                      decoration: BoxDecoration(
                                                          color: const Color
                                                                  .fromARGB(255,
                                                                  140, 188, 228)
                                                              .withOpacity(0.1),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(3)),
                                                      child: Center(
                                                        child: TextGlobal(
                                                            message: "<"),
                                                      ),
                                                    ),
                                                  )
                                                : type == ButtonType.normal
                                                    ? InkWell(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                        onTap: onPressed,
                                                        child: Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal:
                                                                      10,
                                                                  vertical: 5),
                                                          margin:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal:
                                                                      3),
                                                          decoration: BoxDecoration(
                                                              color: page ==
                                                                      dataTableOthers
                                                                          .page
                                                                  ? Colors.black
                                                                  : const Color
                                                                          .fromARGB(
                                                                          255,
                                                                          140,
                                                                          188,
                                                                          228)
                                                                      .withOpacity(
                                                                          0.1),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5)),
                                                          child: Center(
                                                            child: TextGlobal(
                                                              message: "$page",
                                                              fontSize: 12,
                                                              colorText: page ==
                                                                      dataTableOthers
                                                                          .page
                                                                  ? Colors.white
                                                                  : Colors
                                                                      .black,
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    : type == ButtonType.plus
                                                        ? InkWell(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5),
                                                            onTap: onPressed,
                                                            child: Container(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          10,
                                                                      vertical:
                                                                          5),
                                                              margin:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          3),
                                                              decoration: BoxDecoration(
                                                                  color: const Color
                                                                          .fromARGB(
                                                                          255,
                                                                          140,
                                                                          188,
                                                                          228)
                                                                      .withOpacity(
                                                                          0.1),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              5)),
                                                              child: Center(
                                                                child:
                                                                    TextGlobal(
                                                                        message:
                                                                            ">"),
                                                              ),
                                                            ),
                                                          )
                                                        : Container();
                                  },
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                MediaQuery.of(context).size.width < 900
                                    ? Container()
                                    : TextGlobal(
                                        message:
                                            "Show ${(dataTableOthers.page! - 1) * dataTableOthers.limit! + 1} to ${(((dataTableOthers.page! - 1) * dataTableOthers.limit! + 1)) + dataTableOthers.limit! - 1} of ${dataTableOthers.totalData}",
                                        fontSize: 11,
                                        colorText: Colors.grey,
                                      )
                              ],
                            ),
                          ),
                          const Spacer(),
                          MediaQuery.of(context).size.width < 800
                              ? Container()
                              : Row(
                                  children: [
                                    TextGlobal(
                                      message: 'Limit :',
                                      fontSize: 12,
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    SizedBox(
                                      width: 100,
                                      child: DropdownGlobal(
                                          theme: 'theme1',
                                          listItems: const [
                                            '5',
                                            '10',
                                            '20',
                                            '50',
                                            '100'
                                          ],
                                          value:
                                              dataTableOthers.limit.toString(),
                                          onChanged: (value) {
                                            onTapLimit(value.toString());
                                          }),
                                    )
                                  ],
                                ),
                        ],
                      ),
                    ),
              MediaQuery.of(context).size.width > 800
                  ? Container()
                  : isDisableLimitPagination == true
                      ? Container()
                      : const SizedBox(
                          height: 10,
                        ),
              MediaQuery.of(context).size.width > 800
                  ? Container()
                  : isDisableLimitPagination == true
                      ? Container()
                      : TextGlobal(
                          message:
                              "Show ${(dataTableOthers.page! - 1) * dataTableOthers.limit! + 1} to ${(((dataTableOthers.page! - 1) * dataTableOthers.limit! + 1)) + dataTableOthers.limit! - 1} of ${dataTableOthers.totalData}",
                          fontSize: 11,
                          colorText: Colors.grey,
                        ),
              MediaQuery.of(context).size.width > 800
                  ? Container()
                  : const SizedBox(
                      height: 10,
                    ),
              MediaQuery.of(context).size.width > 800
                  ? Container()
                  : isDisableLimitPagination == true
                      ? Container()
                      : Row(
                          children: [
                            TextGlobal(
                              message: 'Limit :',
                              fontSize: 12,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            SizedBox(
                              width: 100,
                              child: DropdownGlobal(
                                  theme: 'theme1',
                                  listItems: const [
                                    '5',
                                    '10',
                                    '20',
                                    '50',
                                    '100'
                                  ],
                                  value: dataTableOthers.limit.toString(),
                                  onChanged: (value) {
                                    onTapLimit(value.toString());
                                  }),
                            )
                          ],
                        ),
            ],
          );
  }
}
