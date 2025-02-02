import 'dart:developer';

import 'package:get/get.dart';
import '../../../APIs/api_helper.dart';
import '../../../common/utils/task_utils.dart';
import '../models/it_way_bd_task_model.dart';

class ITWayBDTaskController extends GetxController {
  final ApiHelper _apiHelper = Get.find<ApiHelper>();

  var tasks = <ITWayBDTask>[].obs; // Observable list of tasks
 var errorMessage = ''.obs;
  var isLoading = false.obs;
  /// ✅ Track Selected Tab (Default: 0 -> "All")
  var selectedTab = 0.obs;
  @override
  void onInit() {
    super.onInit();
    fetchTasks();

  }

  /// Update Selected Tab
  void updateTab(int index) {
    selectedTab.value = index;
  }

 
  Future<void> fetchTasks() async {
    isLoading(true);
    errorMessage.value = '';
    final result = await _apiHelper.fetchAllTasks();
    result.fold(
      (error) {
         errorMessage.value = error.message;
        Get.snackbar('Error', error.message ?? 'Failed to load tasks');
      },
      (data) {
        tasks.assignAll(data);
        log("data: ${data.first.id}");
      },
    );
    isLoading(false);
  }


  /// Create Task and Update UI
  Future<void> createTask(String title, String description) async {
    isLoading.value = true;

    final response = await _apiHelper.createTask(title, description);
    response.fold(
      (error) {
        Get.snackbar('Error', error.message);
      },
      (newTask) {
        tasks.add(newTask); // ✅ Add new task to the list dynamically
        Get.snackbar('Success', 'Task created successfully!');
        Get.back(); // ✅ Close the dialog after task creation
      },
    );

    isLoading.value = false;
  }
}
