import 'package:attend_smart_admin/models/sidebar_model.dart';
import 'package:attend_smart_admin/pages/branch/branch_pages.dart';
import 'package:attend_smart_admin/pages/branch/create_branch_pages.dart';
import 'package:attend_smart_admin/pages/broadcast/broadcast_pages.dart';
import 'package:attend_smart_admin/pages/broadcast/create_broadcast_pages.dart';
import 'package:attend_smart_admin/pages/dashboard/dashboard_pages.dart';
import 'package:attend_smart_admin/pages/department/create_department_pages.dart';
import 'package:attend_smart_admin/pages/department/department_pages.dart';
import 'package:attend_smart_admin/pages/employee/create_employee_pages.dart';
import 'package:attend_smart_admin/pages/employee/employee_pages.dart';
import 'package:attend_smart_admin/pages/history-attend/create_history_attend_pages.dart';
import 'package:attend_smart_admin/pages/history-attend/history_attend_pages.dart';
import 'package:attend_smart_admin/pages/submission/create_submission_pages.dart';
import 'package:attend_smart_admin/pages/submission/submission_pages.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

class NavbarRepository {
  Widget buildPageContent(String location) {
    if (location.contains('/employee/create') ||
        location.contains('/employee/edit')) {
      return const CreateEmployeePages();
    } else if (location.contains('/department/create') ||
        location.contains('/department/edit')) {
      return const CreateDepartmentPages();
    } else if (location.contains('/broadcast/create') ||
        location.contains('/broadcast/edit')) {
      return const CreateBroadcastPages();
    } else if (location.contains('/branch/create') ||
        location.contains('/branch/edit')) {
      return const CreateBranchPages();
    } else if (location.contains('/history/create') ||
        location.contains('/history/edit')) {
      return const CreateHistoryAttendPages();
    } else if (location.contains('/submission/create') ||
        location.contains('/submission/edit')) {
      return const CreateSubmissionPages();
    } else if (location.contains('/employee/page')) {
      return const EmployeePages();
    } else if (location.contains('/department/page')) {
      return const DepartmentPages();
    } else if (location.contains('/broadcast/page')) {
      return const BroadcastPages();
    } else if (location.contains('/branch/page')) {
      return const BranchPages();
    } else if (location.contains('/history/page')) {
      return const HistoryAttendPages();
    } else if (location.contains('/submission/page')) {
      return const SubmissionPages();
    } else {
      return const SizedBox.shrink();
    }
  }

  var listDataSidebar = <SidebarModel>[
    SidebarModel(
        label: 'Dashboard',
        href: '/dashboard/page',
        icon: Iconsax.home_1_outline,
        index: 0),
    SidebarModel(
        label: 'Karyawan',
        href: '/employee/page',
        icon: Iconsax.profile_2user_outline,
        index: 1),
    SidebarModel(
        label: 'Jabatan',
        href: '/department/page',
        icon: Iconsax.folder_2_outline,
        index: 2),
    SidebarModel(),
    SidebarModel(
        label: 'Cabang',
        href: '/branch/page',
        icon: Iconsax.buildings_2_outline,
        index: 0),
    SidebarModel(
        label: 'Histori',
        href: '/history/page',
        icon: BoxIcons.bx_history,
        index: 6),
    SidebarModel(
        label: 'Pengajuan',
        href: '/submission/page',
        icon: Iconsax.pen_remove_outline,
        index: 7),
    SidebarModel(
        label: 'Broadcast',
        href: '/broadcast/page',
        icon: Iconsax.volume_high_outline,
        index: 8),
    SidebarModel(),
    SidebarModel(
        label: 'Keluar', href: '#', icon: Iconsax.logout_outline, index: 11),
  ];

  var listDataWidgetSidebar = [
    const DashboardPages(), // 0
    const EmployeePages(), // 1
    const DepartmentPages(), // 2
    const SizedBox(), // 3
    const BranchPages(), // 4
    const HistoryAttendPages(), // 5
    const SubmissionPages(), // 6
    const BroadcastPages(), // 7
    const SizedBox(), // 8
    const SizedBox(), // 9
    const CreateEmployeePages(), // 10
  ];
}
