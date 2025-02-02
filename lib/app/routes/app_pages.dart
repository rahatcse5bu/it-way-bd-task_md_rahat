import 'package:get/get.dart';
import '../modules/it_way_bd_tasks/bindings/it_way_bd_task_binding.dart';
import '../modules/it_way_bd_tasks/views/it_way_bd_task_view.dart';
import '../modules/home/binding/home_binding.dart';
import '../modules/home/view/home_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/register/bindings/register_binding.dart';
import '../modules/register/views/register_view.dart';

import '../modules/splash/views/splash_view.dart';

class Routes {
  static const splash = '/splash';
  static const register = '/register';
  static const emailVarification = '/email-varification';
  static const login = '/login';
  static const profile = '/profile';
  static const home = '/home';
  static const tasks = '/tasks';

  // Dynamic route generator for single task
  static String singleTask(String id) => '/task/$id';
}

class AppPages {
  static const initial = Routes.home;

  static final routes = [
    GetPage(
      name: Routes.splash,
      page: () => const SplashView(),
    ),

    GetPage(
      name: Routes.register,
      page: () => RegisterView(),
      binding: RegisterBinding(),
    ),

    GetPage(
      name: Routes.login,
      page: () => LoginView(),
      binding: LoginBinding(),
    ),

    GetPage(
      name: Routes.home,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),


    GetPage(
      name: Routes.tasks,
      page: () =>  ITWayBDTaskView(),
      binding: ITWayBDTaskBinding(),
    ),
 
  ];
}
