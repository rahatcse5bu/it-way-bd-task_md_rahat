import 'package:get/get.dart';
import '../controller/it_way_bd_task_controller.dart';


class ITWayBDTaskBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ITWayBDTaskController());
  }
}
