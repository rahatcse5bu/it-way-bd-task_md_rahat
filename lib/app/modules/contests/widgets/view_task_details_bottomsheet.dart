import 'package:IT_Way_BD/app/common/utils/task_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/it_way_bd_task_model.dart';

/// **View Task BottomSheet**
void showViewTaskBottomSheet(ITWayBDTask task) {
  Get.bottomSheet(
    Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // ✅ Keeps BottomSheet compact
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// **Title**
          Center(
            child: Text(
              "Task Details",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 10),

          /// **Task Title**
          _buildDetailRow("Title:", task.title ?? "No Title"),

          /// **Task Description**
          _buildDetailRow("Description:", task.description ?? "No Description"),

          /// **Task Status**
          _buildDetailRow("Status:", task.status?.toUpperCase() ?? "Unknown"),

          /// **Due Date**
          _buildDetailRow(
              "Due Date:",
              Utils.formatDateToBangla(task.dueDate ?? DateTime.now()) ??
                  "Not Set"),

          SizedBox(height: 15),

          /// **Close Button**
          Center(
            child: ElevatedButton(
              onPressed: () => Get.back(),
              child: Text("Close"),
            ),
          ),
        ],
      ),
    ),
    isScrollControlled: true, // ✅ Allows full-screen height if needed
  );
}

/// **Reusable Row Widget for Task Details**
Widget _buildDetailRow(String label, String value) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 4),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(width: 5),
        Expanded(
          child: Text(
            value,
            style: TextStyle(color: Colors.black87),
            overflow: TextOverflow.ellipsis,
            maxLines: 80, // ✅ Allows multi-line description
          ),
        ),
      ],
    ),
  );
}
