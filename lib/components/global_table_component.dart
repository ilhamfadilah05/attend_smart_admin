import 'package:flutter/material.dart';
import 'package:number_pagination/number_pagination.dart';

class TableGlobal extends StatelessWidget {
  const TableGlobal(
      {super.key,
      required this.data,
      required this.headers,
      required this.page,
      required this.pageChanged,
      required this.pageTotal,
      required this.widthTable});

  final List<Widget> headers;
  final List<TableRow> data;
  final double widthTable;
  final int pageTotal;
  final int page;
  final Function(int) pageChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Table(
            border: TableBorder.all(
                color: Colors.grey.withOpacity(0.2),
                borderRadius: BorderRadius.circular(5)),
            defaultColumnWidth: FixedColumnWidth(widthTable),
            columnWidths: const {0: FixedColumnWidth(50)},
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: [TableRow(children: headers), ...data],
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          children: [
            Expanded(
              child: NumberPagination(
                onPageChanged: pageChanged,
                totalPages: (pageTotal / 5).ceil(),
                currentPage: page,
                buttonRadius: 5,
                buttonElevation: 2,
                fontSize: 12,
                fontFamily: 'quicksand',
              ),
            ),
          ],
        ),
      ],
    );
  }
}
