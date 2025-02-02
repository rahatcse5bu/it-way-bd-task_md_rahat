import 'package:get/get.dart';
import '../../it_way_bd_tasks/controller/it_way_bd_task_controller.dart';
import '../controller/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ITWayBDTaskController>(() => ITWayBDTaskController());
    Get.lazyPut<HomeController>(() => HomeController());

  }
}
