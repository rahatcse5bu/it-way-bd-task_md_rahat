import 'package:IT_Way_BD/app/common/custom_simple_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../common/utils/task_utils.dart';
import '../controller/it_way_bd_task_controller.dart';
import '../models/it_way_bd_task_model.dart';
import '../widgets/create_it_way_bd_task_popup.dart';

class ITWayBDTaskView extends GetView<ITWayBDTaskController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          /// **Tabs Positioned Inside the Body**
          Obx(() => Padding(
                padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 16.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _tabButton("All", 0, controller),
                    _tabButton("Pending", 1, controller),
                    _tabButton("Completed", 2, controller),
                    _tabButton("Deleted", 3, controller),
                  ],
                ),
              )),

          /// **Filtered Task List**
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return Center(child: CircularProgressIndicator());
              }
              if (controller.errorMessage.isNotEmpty) {
                return Center(child: Text(controller.errorMessage.value));
              }

              /// **Filter Tasks Based on Selected Tab**
              List<ITWayBDTask> filteredTasks;
              switch (controller.selectedTab.value) {
                case 1:
                  filteredTasks = controller.tasks
                      .where((task) => task.status == "pending")
                      .toList();
                  break;
                case 2:
                  filteredTasks = controller.tasks
                      .where((task) => task.status == "completed")
                      .toList();
                  break;
                case 3:
                  filteredTasks = controller.tasks
                      .where((task) => task.status == "deleted")
                      .toList();
                  break;
                default:
                  filteredTasks = controller.tasks;
              }

              if (filteredTasks.isEmpty) {
                return Center(child: Text("No tasks available"));
              }

              return ListView.builder(
                itemCount: filteredTasks.length,
                itemBuilder: (context, index) {
                  ITWayBDTask task = filteredTasks[index];
                  return Card(
                    child: ListTile(
                      title: Text(task.title ?? "No Title"),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Divider(),
                          Text(task.description ?? "No Description"),
                          SizedBox(height: 8.h),
                          Text(Utils.formatDateToBangla(
                              DateTime.parse(task.dueDate ?? ''))),
                        ],
                      ),
                      trailing: Text(task.status ?? "Unknown"),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),

      /// **Floating Action Button (FAB) to Open Create Task Dialog**
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showCreateTaskDialog(controller);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  /// **Tab Button Widget**
  Widget _tabButton(String text, int index, ITWayBDTaskController controller) {
    return GestureDetector(
      onTap: () => controller.updateTab(index),
      child: Obx(() => Container(
            padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
            decoration: BoxDecoration(
              color: controller.selectedTab.value == index
                  ? Colors.blue
                  : Colors.grey.shade300,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Text(
              text,
              style: TextStyle(
                color: controller.selectedTab.value == index
                    ? Colors.white
                    : Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          )),
    );
  }
}
