import 'package:IT_Way_BD/app/common/custom_simple_appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/it_way_bd_task_controller.dart';
import '../models/it_way_bd_task_model.dart';
import '../widgets/create_it_way_bd_task_popup.dart';

class ITWayBDTaskView extends GetView<ITWayBDTaskController> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }
        // if (controller.tasks.isNotEmpty) {
        //   return Center(child: Text("Error"));
        // }
        if (controller.tasks.isEmpty) {
          return Center(child: Text("No tasks available"));
        }

        return SizedBox(
          child: ListView.builder(
            itemCount: controller.tasks.length,
            itemBuilder: (context, index) {
              ITWayBDTask task = controller.tasks[index];
              return Card(
                child: ListTile(
                  title: Text(task.title ?? "No Title"),
                  subtitle: Text(task.description ?? "No Description"),
                  trailing: Text(task.status ?? "Unknown"),
                ),
              );
            },
          ),
        );
      }, 
      
      ),     /// **Floating Action Button (FAB) to Open Create Task Dialog**
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showCreateTaskDialog(controller);
        },
        child: Icon(Icons.add),
      ),
    );
    
  }
}
