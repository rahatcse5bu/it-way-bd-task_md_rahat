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
            /// **Search Bar**
          Padding(
            padding: EdgeInsets.all(10.h),
            child: TextField(
              onChanged: controller.updateSearchQuery,
              decoration: InputDecoration(

                hintText: "Search tasks...",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey, width: 1),

                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
            ),
          ),
          /// **Tabs Positioned Inside the Body**
          Padding(
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
              ),

          /// **Filtered Task List**
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return Center(child: CircularProgressIndicator());
              }
              if (controller.errorMessage.isNotEmpty) {
                return Center(child: Text(controller.errorMessage.value));
              }
              /// **Get Filtered Tasks (by Tab & Search)**
              List<ITWayBDTask> filteredTasks = controller.filteredTasks;

              // switch (controller.selectedTab.value) {
              //   case 1:
              //     filteredTasks = controller.tasks
              //         .where((task) => task.status?.toLowerCase() == "pending")
              //         .toList();
              //     break;
              //   case 2:
              //     filteredTasks = controller.tasks
              //         .where(
              //             (task) => task.status?.toLowerCase() == "completed")
              //         .toList();
              //     break;
              //   case 3:
              //     filteredTasks = controller.tasks
              //         .where((task) => task.status?.toLowerCase() == "deleted")
              //         .toList();
              //     break;
              //   default:
              //     filteredTasks = controller.tasks;
              // }

              if (filteredTasks.isEmpty) {
                return Center(child: Text("No tasks available"));
              }

              return ListView.builder(
                itemCount: filteredTasks.length,
                itemBuilder: (context, index) {
                  ITWayBDTask task = filteredTasks[index];

                  /// **Determine Border Color**
                  Color borderColor = _getBorderColor(task);
                  return Card(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: borderColor, width: 1),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: ListTile(
                      title: Text(
                        task.title ?? "No Title",
                        style: TextStyle(
                          decoration: task.status == "completed"
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                          // ✅ Strikethrough for completed
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Divider(),
                          Text(
                            task.description ?? "No Description",
                            style: TextStyle(
                              decoration: task.status == "completed"
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                              // ✅ Strikethrough for completed
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(Utils.formatDateToBangla(
                              DateTime.parse(task.dueDate ?? ''))),
                        ],
                      ),
                      trailing: Text(
                        task.status?.toUpperCase() ?? "Unknown",
                        style: TextStyle(color: _getBorderColor(task)),
                      ),
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

  /// **Determine the Border Color for Each Task**
  Color _getBorderColor(ITWayBDTask task) {
    DateTime now = DateTime.now();
    DateTime? dueDate =
        task.dueDate != null ? DateTime.parse(task.dueDate!) : null;

    if (task.status == "completed") {
      return Colors.green; // ✅ Completed → Green
    } else if (dueDate != null && dueDate.isBefore(now)) {
      return Colors.red; // ❌ Expired & Not Completed → Red
    } else {
      return Colors.grey; // 🔘 Default (Pending or Future Due Date) → Grey
    }
  }
}
