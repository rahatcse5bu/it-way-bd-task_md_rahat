import 'package:get/get.dart';
import '../../contests/controller/contest_controller.dart';
import '../../search-page/controller/search_controller.dart';
import '../controller/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ContestController>(() => ContestController());
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<SearchPageController>(() => SearchPageController());

  }
}
