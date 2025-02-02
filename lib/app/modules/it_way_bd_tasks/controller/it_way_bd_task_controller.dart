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

  /// ✅ Track Search Query
  var searchQuery = ''.obs;
  @override
  void onInit() {
    super.onInit();
    fetchTasks();
  }

  /// Update Selected Tab
  void updateTab(int index) {
    selectedTab.value = index;
  }

  /// Update Search Query
  void updateSearchQuery(String query) {
    log("Query: $query");
    searchQuery.value = query.toLowerCase();
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
  Future<void> createTask(String title, String description,String dueDate) async {
    isLoading.value = true;

    final response = await _apiHelper.createTask(title, description,dueDate );
    response.fold(
      (error) {
        Get.snackbar('Error', error.message);
      },
      (newTask) {
        tasks.add(newTask); // ✅ Add new task to the list dynamically
     /// **Ensure UI Updates Before Closing BottomSheet**
      Future.delayed(Duration(milliseconds: 300), () {
        Get.back(); // ✅ Close the bottom sheet after task creation
        Get.snackbar('Success', 'Task created successfully!');
      });
      },
    );

    isLoading.value = false;
  }

  /// **Mark Task as Completed**
  Future<void> markAsCompleted(String taskId) async {
    isLoading.value = true;

    final response = await _apiHelper.markTaskAsCompleted(taskId);
    response.fold(
      (error) {
        Get.snackbar('Error', error.message);
      },
      (updatedTask) {
        // ✅ Find the task & update its status in the list
        int index = tasks.indexWhere((task) => task.id == taskId);
        if (index != -1) {
          tasks[index] = updatedTask;
        }
        Get.snackbar('Success', 'Task marked as completed!');
      },
    );

    isLoading.value = false;
  }

  /// **Edit Task with Due Date**
  Future<void> editTask(String taskId, String newTitle, String newDescription,
      String newStatus, String newDueDate) async {
    isLoading.value = true;

    final response = await _apiHelper.editTask(
        taskId, newTitle, newDescription, newStatus, newDueDate);
    response.fold(
      (error) {
        Get.snackbar('Error', error.message);
      },
      (updatedTask) {
        int index = tasks.indexWhere((task) => task.id == taskId);
        if (index != -1) {
          tasks[index] = updatedTask;
          //  Get.snackbar('Success', 'Task updated successfully!');
          // Get.back(); // ✅ Close BottomSheet after editing
        }
      },
    );

    /// **Delay Snackbar to Ensure UI Refresh Completes**
    Future.delayed(Duration(milliseconds: 200), () {
      Get.back(); // ✅ Close BottomSheet after editing
      Get.snackbar('Success', 'Task updated successfully!');
    });
    isLoading.value = false;
  }

  /// **Delete Task**
  Future<void> deleteTask(String taskId) async {
    isLoading.value = true;

    final response = await _apiHelper.deleteTask(taskId);
    response.fold(
      (error) {
        Get.snackbar('Error', error.message);
      },
      (successMessage) {
        // ✅ Remove the task from the list
        tasks.removeWhere((task) => task.id == taskId);
        Get.snackbar('Success', successMessage);
      },
    );

    isLoading.value = false;
  }

  /// Get Filtered Tasks Based on Tab and Search Query
  List<ITWayBDTask> get filteredTasks {
    List<ITWayBDTask> filtered = tasks;

    // Filter by Tab
    switch (selectedTab.value) {
      case 1:
        filtered = tasks.where((task) => task.status == "pending").toList();
        break;
      case 2:
        filtered = tasks.where((task) => task.status == "completed").toList();
        break;
      case 3:
        filtered = tasks.where((task) => task.status == "deleted").toList();
        break;
    }

    // Apply Search Filter
    if (searchQuery.value.isNotEmpty) {
      filtered = filtered
          .where((task) =>
              (task.title ?? "").toLowerCase().contains(searchQuery.value) ||
              (task.description ?? "")
                  .toLowerCase()
                  .contains(searchQuery.value))
          .toList();
    }

    return filtered;
  }
}
