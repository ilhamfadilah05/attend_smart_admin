import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'global_text_component.dart';

class BreadCrumbGlobal extends StatelessWidget {
  const BreadCrumbGlobal({
    super.key,
    required this.firstHref,
    required this.firstTitle,
    required this.typeBreadcrumb,
  });

  final String firstHref;
  final String firstTitle;
  final String typeBreadcrumb;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: () {
            Router.neglect(context, () {
              context.go('/dashboard/page');
            });
          },
          child: TextGlobal(
            message: 'Home',
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Container(
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.4), shape: BoxShape.circle),
        ),
        const SizedBox(
          width: 10,
        ),
        InkWell(
          onTap: () {
            Router.neglect(context, () {
              context.go(firstHref);
            });
          },
          child: TextGlobal(
            message: firstTitle,
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Container(
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.4), shape: BoxShape.circle),
        ),
        const SizedBox(
          width: 10,
        ),
        TextGlobal(
          message: typeBreadcrumb,
          colorText: Colors.grey,
        ),
      ],
    );
  }
}
