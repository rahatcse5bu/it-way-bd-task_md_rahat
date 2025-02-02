import 'package:dartz/dartz.dart';
import 'package:get/get.dart';
import '../modules/contests/models/it_way_bd_task_model.dart';
import '../modules/login/models/login_request_model.dart';
import '../modules/login/models/login_response_model.dart';
import '../modules/register/models/register_model.dart';
import 'custom_error.dart';

abstract class ApiHelper {
  // Future<Either<CustomError, LoginResponse>> login(LoginRequestModel login);
  Future<Either<CustomError, LoginResponseModel>> login(
      LoginRequestModel payload);

  Future<Either<CustomError, Response>> register(RegisterRequestModel register);
  // Future<Either<CustomError, List<JobCircular>>> fetchJobCirculars();
  // Future<Either<CustomError, List<JobCategory>>> getJobCategories();
  // Future<Either<CustomError, List<ExamType>>> getExamTypes();
  Future<Either<CustomError, List<ITWayBDTask>>> fetchAllTasks();
  // Future<Either<CustomError, List<Question>>> fetchAllQuestions();
// Future<Either<CustomError, SingleContest>> fetchSingleContest(String contestId);
  // Future<Either<CustomError, Response>> verifyOtp(Map<String, dynamic> data);
  // Future<Either<CustomError, UserProfile>> getUserProfile(String userId);
  // Future<Either<CustomError, Response>> registerContest(String contestId);
  // Future<Either<CustomError, List<ITWayBDTask>>> fetchRecentContests();
  // Future<Either<CustomError, TaskDetailsResponse>> fetchSingleTask(
  //     String taskId);
  // Future<Either<CustomError, List<SubjectTopics>>>
  //     fetchSubCategoriesByCategoryId(String categoryId);
    Future<Either<CustomError, ITWayBDTask>> createTask(
      String title, String description);
      Future<Either<CustomError, ITWayBDTask>> markTaskAsCompleted(String taskId);
        Future<Either<CustomError, String>> deleteTask(String taskId);
}
