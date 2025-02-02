import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:get/get_connect/connect.dart';
import '../constant/app_config.dart';
import '../modules/contests/models/it_way_bd_task_model.dart';

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
      // ✅ Ensure response.body['data'] is correctly casted before mapping
      final List<dynamic> jsonList = response.body['data']; 

      final List<ITWayBDTask> tasks = jsonList
          .map((json) => ITWayBDTask.fromJson(json as Map<String, dynamic>))
          .toList();

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

  // @override
  // Future<Either<CustomError, Response>> verifyOtp(
  //     Map<String, dynamic> data) async {
  //   try {
  //     // Construct the payload as a Map
  //     final payload = data;

  //     // Make the POST request
  //     final Response response = await post('users/verify-otp', payload);

  //     // Handle response based on status code
  //     if (response.statusCode == 200) {
  //       return Right(response); // Successful response
  //     } else {
  //       return Left(
  //         CustomError(
  //           response.statusCode ?? 500,
  //           message: response.body['message'] ?? 'Error verifying OTP',
  //         ),
  //       );
  //     }
  //   } catch (e) {
  //     // Handle exceptions
  //     return Left(CustomError(500, message: 'Network error: $e'));
  //   }
  // }

  
  // @override
  // Future<Either<CustomError, TaskDetailsResponse>> fetchSingleTask(
  //     String taskId) async {
  //   try {
  //     // Make GET request
  //     final response = await get('task/$taskId');

  //     if (response.statusCode == 200 && response.body['success'] == true) {
  //       final data = TaskDetailsResponse.fromJson(response.body['data']);
  //       return Right(data);
  //     } else {
  //       // Handle API error
  //       return Left(CustomError(
  //         response.statusCode,
  //         message:
  //             response.body['message'] ?? 'Failed to fetch task details',
  //       ));
  //     }
  //   } catch (e) {
  //     // Handle network or parsing errors
  //     log('Error fetching single task: $e');
  //     return Left(CustomError(500, message: 'Network error: $e'));
  //   }
  // }

 

 
}
