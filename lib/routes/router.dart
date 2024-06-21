import 'package:attend_smart_admin/bloc/session/session_cubit.dart';
import 'package:attend_smart_admin/pages/login/login_pages.dart';
import 'package:attend_smart_admin/pages/screens_pages.dart';
import 'package:attend_smart_admin/routes/route_names.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  final SessionState sessionCubit;

  AppRouter({required this.sessionCubit});
  late final router = GoRouter(
    initialLocation: sessionCubit is UserAuthenticated
        ? RouteNames.DASHBOARD
        : RouteNames.LOGIN,
    routes: [
      GoRoute(
        path: RouteNames.LOGIN,
        builder: (context, state) => const LoginPages(),
      ),
      GoRoute(
        path: '/:name/:subName',
        builder: (context, state) => const ScreensPages(),
      ),
    ],
  );
}
