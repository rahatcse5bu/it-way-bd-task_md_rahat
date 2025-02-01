import 'package:get/get.dart';
import '../controller/contest_controller.dart';


class ContestBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ContestController());
  }
}
