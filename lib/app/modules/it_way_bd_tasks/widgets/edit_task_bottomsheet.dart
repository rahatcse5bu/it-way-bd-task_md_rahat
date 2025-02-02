import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/it_way_bd_task_controller.dart';
import '../models/it_way_bd_task_model.dart';

/// **Edit Task BottomSheet**
void showEditTaskBottomSheet(
    ITWayBDTask task, ITWayBDTaskController taskController) {
  final TextEditingController titleController =
      TextEditingController(text: task.title);
  final TextEditingController descController =
      TextEditingController(text: task.description);

  /// **Status Options**
  final List<String> statusOptions = ["pending", "completed", "progress"];
  var selectedStatus = (task.status ?? "pending").obs; // ✅ Safe default value

  /// **Due Date Picker**
  var selectedDueDate = Rx<DateTime>(task.dueDate ?? DateTime.now());

  Get.bottomSheet(
    Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // ✅ Keeps BottomSheet compact
        children: [
          Text(
            "Edit Task",
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
            maxLines: 4, // ✅ Increased height
            decoration: InputDecoration(
              labelText: "Description",
              border: OutlineInputBorder(),
              alignLabelWithHint: true,
            ),
          ),
          SizedBox(height: 10),

          /// **Status Dropdown**
          Obx(() => DropdownButtonFormField<String>(
                value: selectedStatus.value,
                onChanged: (newValue) {
                  selectedStatus.value = newValue!; // ✅ Update selected status
                },
                decoration: InputDecoration(
                  labelText: "Status",
                  border: OutlineInputBorder(),
                ),
                items: statusOptions.map((String status) {
                  return DropdownMenuItem(
                    value: status,
                    child: Text(status),
                  );
                }).toList(),
              )),
          SizedBox(height: 10),

          /// **Due Date Picker**
          Obx(() => GestureDetector(
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: Get.context!,
                    initialDate: selectedDueDate.value,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (pickedDate != null) {
                    selectedDueDate.value =
                        pickedDate; // ✅ Now it's assigned correctly
                  }
                },
                child: TextField(
                  controller: TextEditingController(
                      text: "${selectedDueDate.value.toLocal()}".split(" ")[0]),
                  enabled: false,
                  decoration: InputDecoration(
                    labelText: "Due Date",
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                ),
              )),
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

              /// **Save Button**
              ElevatedButton(
                onPressed: () {
                  if (titleController.text.isNotEmpty &&
                      descController.text.isNotEmpty) {
                    taskController.editTask(
                        task.id,
                        titleController.text,
                        descController.text,
                        selectedStatus.value!,
                        selectedDueDate.value
                            .toIso8601String() // ✅ Send ISO8601 date format
                        );
                  } else {
                    Get.snackbar("Error",
                        "Title, Description, Status, and Due Date are required!");
                  }
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                child: Text(
                  "Save",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
    isScrollControlled: true, // ✅ Allows full-screen height if needed
  );
}
