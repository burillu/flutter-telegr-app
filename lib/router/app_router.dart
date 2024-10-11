import 'package:auto_route/auto_route.dart';
import 'package:telegram_app/router/app_router.gr.dart';

// @MaterialAutoRouter(
//   replaceInRouteName: 'Page,Route',
//   preferRelativeImports: false,
//   routes: <AutoRoute>[
//     AutoRoute(page: MainPage, initial: true),
//   ],
// )
// class $AppRouter {}

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
        /// routes go here
        AutoRoute(page: MainRoute.page, initial: true),
        AutoRoute(page: SignInRoute.page, initial: false),
        AutoRoute(page: SignUpRoute.page),
        AutoRoute(page: NewMessageRoute.page),
      ];
}
