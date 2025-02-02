import 'package:IT_Way_BD/app/common/custom_simple_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../common/utils/task_utils.dart';
import '../controller/it_way_bd_task_controller.dart';
import '../models/it_way_bd_task_model.dart';
import '../widgets/create_it_way_bd_task_bottomsheet.dart';
import '../widgets/edit_task_bottomsheet.dart';
import '../widgets/view_task_details_bottomsheet.dart';

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

              return RefreshIndicator(
                onRefresh: () async {
                  await controller.fetchTasks(); // ✅ Refresh data from API
                },
                child: ListView.builder(
                  physics:
                      AlwaysScrollableScrollPhysics(), // ✅ Ensure pull-to-refresh works
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
                        onTap: () {
                          showViewTaskBottomSheet(
                              task); // ✅ Open View Task Popup
                        },
                        title: Text(
                          task.title ?? "No Title",
                          maxLines: 1, // ✅ Restrict to 1 line
                          overflow:
                              TextOverflow.ellipsis, // ✅ Add ellipsis (...)
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
                              maxLines: 1, // ✅ Restrict to 1 line
                              overflow:
                                  TextOverflow.ellipsis, // ✅ Add ellipsis (...)
                              style: TextStyle(
                                decoration: task.status == "completed"
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                                // ✅ Strikethrough for completed
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Text(Utils.formatDateToBangla(
                                task.dueDate ?? DateTime.now())),
                          ],
                        ),
                        // trailing: Text(
                        //   task.status?.toUpperCase() ?? "Unknown",
                        //   style: TextStyle(color: _getBorderColor(task)),
                        // ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            task.status == "completed"
                                ? Icon(Icons.check, color: Colors.green)
                                : IconButton(
                                    icon: Icon(Icons.check_box_outline_blank),
                                    onPressed: () {
                                      controller.markAsCompleted(task.id);
                                    },
                                  ),
                            PopupMenuButton<String>(
                              onSelected: (String choice) {
                                if (choice == "Edit") {
                                  showEditTaskBottomSheet(task, controller);
                                } else if (choice == "Delete") {
                                  controller.deleteTask(task.id);
                                }
                              },
                              itemBuilder: (BuildContext context) => [
                                /// **Edit Option**
                                PopupMenuItem<String>(
                                  value: "Edit",
                                  child: Row(
                                    children: [
                                      Icon(Icons.edit, color: Colors.blue),
                                      SizedBox(width: 10),
                                      Text("Edit"),
                                    ],
                                  ),
                                ),

                                /// **Delete Option**
                                PopupMenuItem<String>(
                                  value: "Delete",
                                  child: Row(
                                    children: [
                                      Icon(Icons.delete, color: Colors.red),
                                      SizedBox(width: 10),
                                      Text("Delete"),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            /// **Edit Button (Opens BottomSheet)**
                            // IconButton(
                            //   icon: Icon(Icons.edit, color: Colors.blue),
                            //   onPressed: () {
                            //     showEditTaskBottomSheet(
                            //         task, controller); // ✅ Open Edit Popup
                            //   },
                            // ),
                            // IconButton(
                            //   icon: Icon(Icons.delete, color: Colors.red),
                            //   onPressed: () {
                            //     controller.deleteTask(task.id);
                            //   },
                            // ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            }),
          ),
          SizedBox(height: 70.h,)
        ],
      ),

      /// **Floating Action Button (FAB) to Open Create Task Dialog**
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showCreateTaskBottomSheet(controller);
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
    DateTime? dueDate = task.dueDate != null ? task.dueDate : null;

    if (task.status == "completed") {
      return Colors.green; // ✅ Completed → Green
    } else if (dueDate != null && dueDate.isBefore(now)) {
      return Colors.red; // ❌ Expired & Not Completed → Red
    } else {
      return Colors.grey; // 🔘 Default (Pending or Future Due Date) → Grey
    }
  }
}
