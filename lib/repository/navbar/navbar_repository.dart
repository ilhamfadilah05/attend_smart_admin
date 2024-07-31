import 'package:attend_smart_admin/models/navbar_model.dart';
import 'package:icons_plus/icons_plus.dart';

List<NavbarModel> listNavbar() {
  return [
    NavbarModel(
      name: 'dashboard',
      label: 'Dashboard',
      icon: Iconsax.home_1_outline,
      href: '/dashboard',
    ),
    NavbarModel(
      name: 'karyawan',
      label: 'Karyawan',
      icon: Iconsax.profile_2user_outline,
      href: '/karyawan',
    ),
    NavbarModel(
      name: 'jabatan',
      label: 'Jabatan',
      icon: Iconsax.folder_2_outline,
      href: '/jabatan',
    ),
    NavbarModel(
      name: 'cabang',
      label: 'Cabang',
      icon: Iconsax.buildings_2_outline,
      href: '/cabang',
    ),
    NavbarModel(
      name: 'histori',
      label: 'Histori Absen',
      icon: BoxIcons.bx_history,
      href: '/history-attend',
    ),
    NavbarModel(
      name: 'cuti',
      label: 'Pengajuan',
      icon: Iconsax.pen_remove_outline,
      href: '/pengajuan',
    ),
    NavbarModel(
      name: 'broadcast',
      label: 'Broadcast',
      icon: Iconsax.volume_high_outline,
      href: '/broadcast',
    ),
    NavbarModel(
      name: 'user',
      label: 'User',
      icon: Iconsax.user_octagon_outline,
      href: '/user',
    ),
  ];
}
