import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/it_way_bd_task_controller.dart';

/// **GetX BottomSheet for Creating a Task**
void showCreateTaskBottomSheet(ITWayBDTaskController taskController) {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descController = TextEditingController();

  Get.bottomSheet(
    Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // ✅ Makes bottom sheet fit content
        children: [
          Text(
            "Create Task",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),

          /// **Task Title Input**
          TextField(
            controller: titleController,
            decoration: InputDecoration(
              labelText: "Task Title",
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 10),

          /// **Task Description Input**
          TextField(
            controller: descController,
            maxLines: 5, // ✅ Increases Height (Allows More Text)
            decoration: InputDecoration(
              labelText: "Description",
              border: OutlineInputBorder(),
              alignLabelWithHint: true, // ✅ Aligns Label to Top
            ),
          ),
          SizedBox(height: 15),

          /// **Action Buttons**
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              /// **Cancel Button**
              ElevatedButton(
                onPressed: () {
                  Get.back(); // ✅ Close BottomSheet
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                child: Text("Cancel"),
              ),

              /// **Create Button**
              ElevatedButton(
                onPressed: () {
                  if (titleController.text.isNotEmpty &&
                      descController.text.isNotEmpty) {
                    taskController.createTask(
                        titleController.text, descController.text);
                    Get.back(); // ✅ Close BottomSheet after creation
                  } else {
                    Get.snackbar(
                        "Error", "Title and Description are required!");
                  }
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                child: Text("Create", style: TextStyle(color: Colors.white),),
              ),
            ],
          ),
        ],
      ),
    ),
    isScrollControlled: true, // ✅ Allows full-screen height if needed
  );
}
