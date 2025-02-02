import 'dart:developer';
import 'package:dartz/dartz.dart';
import 'package:get/get_connect/connect.dart';
import '../constant/app_config.dart';
import '../modules/it_way_bd_tasks/models/it_way_bd_task_model.dart';
import '../modules/login/models/login_request_model.dart';
import '../modules/login/models/login_response_model.dart';
import '../modules/register/models/register_model.dart';
import '../storage/storage_helper.dart';
import 'api_helper.dart';
import 'custom_error.dart';

class ApiHelperImpl extends GetConnect implements ApiHelper {
  @override
  void onInit() {
    super.onInit(); // Ensure this is called to properly set up GetConnect.

    log("url: ${'${AppConfig.baseUrl}${AppConfig.apiVersion}/'}");
    httpClient.baseUrl = '${AppConfig.baseUrl}${AppConfig.apiVersion}/';
    httpClient.timeout = const Duration(seconds: AppConfig.timeoutDuration);
    log("ApiHelperImpl initialized with baseUrl: ${httpClient.baseUrl}");
    httpClient.defaultContentType = 'application/json';
    httpClient.addRequestModifier<Object?>((request) async {
      final token = await StorageHelper.getToken(); // Fetch token
      if (token != null) {
        request.headers['Authorization'] = 'Bearer $token'; // Add Bearer token
      }
      log('Request: ${request.method} ${request.url}');
      log('Headers: ${request.headers}');
      log('Body: ${request.bodyBytes}');
      return request;
    });

    httpClient.addResponseModifier<Object?>((request, response) {
      log('Response: ${response.statusCode}, Body: ${response.body}');
      return response;
    });
  }

  Future<Either<CustomError, T>> _convert<T>(
      Response response, T Function(Map<String, dynamic>) fromJson) async {
    if (response.statusCode == 200) {
      try {
        return Right(fromJson(response.body));
      } catch (e) {
        return Left(
            CustomError(response.statusCode, message: 'Parsing error: $e'));
      }
    } else {
      return Left(
          CustomError(response.statusCode, message: '${response.statusText}'));
    }
  }

  @override
  Future<Either<CustomError, Response<dynamic>>> register(
      RegisterRequestModel register) async {
    final response = await post('users', register.toJson());
    // You can handle the response directly or transform it as needed.
    if (response.statusCode == 200) {
      return Right(response); // Return the raw response.
    } else {
      return Left(
          CustomError(response.statusCode, message: '${response.statusText}'));
    }
  }

  @override
  Future<Either<CustomError, LoginResponseModel>> login(
      LoginRequestModel payload) async {
    final response = await post('users/login', payload.toJson());

    if (response.statusCode == 200 && response.body['success'] == true) {
      try {
        return Right(LoginResponseModel.fromJson(response.body));
      } catch (e) {
        return Left(CustomError(
          response.statusCode,
          message: 'Parsing error: $e',
        ));
      }
    } else {
      return Left(CustomError(
        response.statusCode,
        message: response.body['message'] ?? 'Unknown error occurred',
      ));
    }
  }

  @override
  Future<Either<CustomError, List<ITWayBDTask>>> fetchAllTasks() async {
    try {
      final response = await get('tasks');

      if (response.statusCode == 200 && response.body['success'] == true) {
        // ✅ Explicitly cast response.body['data'] to a List<Map<String, dynamic>>
        final List<dynamic> jsonList = response.body['data'];

        // ✅ Map JSON data safely to ITWayBDTask objects
        final List<ITWayBDTask> tasks = jsonList.map((item) {
          return ITWayBDTask.fromJson(item as Map<String, dynamic>);
        }).toList();

        return Right(tasks);
      } else {
        return Left(CustomError(response.statusCode ?? 500,
            message: response.body['message'] ?? 'Failed to fetch tasks'));
      }
    } catch (e) {
      log('Error fetching tasks: $e');
      return Left(CustomError(500, message: 'Network error: $e'));
    }
  }

  /// Create New Task
  @override
  Future<Either<CustomError, ITWayBDTask>> createTask(
      String title, String description, String dueDate) async {
    try {
      final response = await post('tasks', {
        "title": title,
        "description": description,
        "status": "pending",
        "dueDate": DateTime.now().toIso8601String()
      });

      if (response.statusCode == 201 && response.body['success'] == true) {
        final ITWayBDTask newTask = ITWayBDTask.fromJson(response.body['data']);
        return Right(newTask);
      } else {
        return Left(CustomError(response.statusCode ?? 500,
            message: response.body['message'] ?? 'Failed to create task'));
      }
    } catch (e) {
      log('Error creating task: $e');
      return Left(CustomError(500, message: 'Network error: $e'));
    }
  }

  /// **Mark Task as Completed (PUT Request)**
  @override
  Future<Either<CustomError, ITWayBDTask>> markTaskAsCompleted(
      String taskId) async {
    try {
      final response = await put('tasks/$taskId', {"status": "completed"});

      if (response.statusCode == 200 && response.body['success'] == true) {
        final updatedTask = ITWayBDTask.fromJson(response.body['data']);
        return Right(updatedTask);
      } else {
        return Left(CustomError(response.statusCode ?? 500,
            message:
                response.body['message'] ?? 'Failed to update task status'));
      }
    } catch (e) {
      log('Error marking task as completed: $e');
      return Left(CustomError(500, message: 'Network error: $e'));
    }
  }

  /// **Edit Task (PUT Request)**
  @override
  Future<Either<CustomError, ITWayBDTask>> editTask(String taskId, String title,
      String description, String status, String dueDate) async {
    try {
      final response = await put('tasks/$taskId', {
        "title": title,
        "description": description,
        "status": status,
        "dueDate": dueDate, // ✅ Now dueDate can be changed
      });

      if (response.statusCode == 200 && response.body['success'] == true) {
        final updatedTask = ITWayBDTask.fromJson(response.body['data']);
        return Right(updatedTask);
      } else {
        return Left(CustomError(response.statusCode ?? 500,
            message: response.body['message'] ?? 'Failed to update task'));
      }
    } catch (e) {
      log('Error updating task: $e');
      return Left(CustomError(500, message: 'Network error: $e'));
    }
  }

  /// **Delete Task (DELETE Request)**
  @override
  Future<Either<CustomError, String>> deleteTask(String taskId) async {
    try {
      final response = await delete('tasks/$taskId');

      if (response.statusCode == 200 && response.body.containsKey('message')) {
        return Right("Task deleted successfully");
      } else {
        return Left(CustomError(response.statusCode ?? 500,
            message: response.body['message'] ?? 'Failed to delete task'));
      }
    } catch (e) {
      log('Error deleting task: $e');
      return Left(CustomError(500, message: 'Network error: $e'));
    }
  }
}
