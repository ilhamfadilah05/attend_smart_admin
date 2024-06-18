import 'package:attend_smart_admin/bloc/session/session_cubit.dart';
import 'package:attend_smart_admin/pages/dashboard_pages.dart';
import 'package:attend_smart_admin/pages/login_pages.dart';
import 'package:attend_smart_admin/routes/route_names.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  final SessionState sessionCubit;

  AppRouter({required this.sessionCubit});
  late final router = GoRouter(
    initialLocation: RouteNames.DASHBOARD,
    routes: [
      GoRoute(
        path: RouteNames.LOGIN,
        builder: (context, state) => const LoginPages(),
      ),
      GoRoute(
        path: '/:name',
        builder: (context, state) => const DashboardPages(),
      ),
    ],
  );
}
