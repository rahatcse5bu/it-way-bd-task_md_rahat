import 'package:dartz/dartz.dart';
import 'package:get/get.dart';
import '../modules/it_way_bd_tasks/models/it_way_bd_task_model.dart';
import '../modules/login/models/login_request_model.dart';
import '../modules/login/models/login_response_model.dart';
import '../modules/register/models/register_model.dart';
import 'custom_error.dart';

abstract class ApiHelper {
  // Future<Either<CustomError, LoginResponse>> login(LoginRequestModel login);
  Future<Either<CustomError, LoginResponseModel>> login(
      LoginRequestModel payload);

  Future<Either<CustomError, Response>> register(RegisterRequestModel register);

  Future<Either<CustomError, List<ITWayBDTask>>> fetchAllTasks();

  Future<Either<CustomError, ITWayBDTask>> createTask(
      String title, String description, String dueDate);
  Future<Either<CustomError, ITWayBDTask>> markTaskAsCompleted(String taskId);
    Future<Either<CustomError, ITWayBDTask>> editTask(
      String taskId, String title, String description, String status, String dueDate);
  Future<Either<CustomError, String>> deleteTask(String taskId);
}
