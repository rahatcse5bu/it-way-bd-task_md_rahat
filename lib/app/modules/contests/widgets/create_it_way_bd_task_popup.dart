
  import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/it_way_bd_task_controller.dart';

/// **GetX Dialog for Creating a Task**
   void   showCreateTaskDialog(ITWayBDTaskController taskController) {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController descController = TextEditingController();

    Get.defaultDialog(
      title: "Create Task",
      content: Column(
        children: [
          TextField(
            controller: titleController,
            decoration: InputDecoration(labelText: "Task Title"),
          ),
          SizedBox(height: 10),
          TextField(
            controller: descController,
            decoration: InputDecoration(labelText: "Description"),
          ),
        ],
      ),
      textConfirm: "Create",
      textCancel: "Cancel",
      confirmTextColor: Colors.white,
      onConfirm: () {
        if (titleController.text.isNotEmpty &&
            descController.text.isNotEmpty) {
          taskController.createTask(titleController.text, descController.text);
        } else {
          Get.snackbar("Error", "Title and Description are required!");
        }
      },
    );
  }