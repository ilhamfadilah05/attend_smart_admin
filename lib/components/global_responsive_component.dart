import 'package:flutter/material.dart';

class ResponsiveForm {
  static const mobileSize = 400;
  static Widget responsiveForm(
      {required List<Widget> children,
      double verticalSpace = 16,
      double horizontalSpace = 16}) {
    return LayoutBuilder(builder: (context, constraints) {
      int count = (constraints.maxWidth ~/ (mobileSize * .8)) == 0
          ? 1
          : (constraints.maxWidth ~/ (mobileSize * .8));
      int mod = children.length % count;

      // Buat list widget berdasarkan jumlah kolom
      List<Widget> list = List.generate((children.length ~/ count), (index) {
        return Padding(
          padding: EdgeInsets.only(top: index == 0 ? 0 : verticalSpace),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(count, (index2) {
              int i = index2 + (index * count);

              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                      right: index2 == count - 1 ? 0 : horizontalSpace),
                  child: children[i],
                ),
              );
            }),
          ),
        );
      });
      if (mod > 0) {
        list.add(Padding(
          padding: EdgeInsets.only(top: verticalSpace),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(count, (index) {
              if (mod == 0) {
                return const Spacer();
              }
              var widget = children[children.length - mod];
              mod--;
              return Expanded(
                  child: Padding(
                padding: EdgeInsets.only(
                  right: horizontalSpace,
                ),
                child: widget,
              ));
            }),
          ),
        ));
      }
      return Column(
        children: list,
      );
    });
  }
}
