import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:get/get_connect/connect.dart';
import '../constant/app_config.dart';
import '../modules/contest-details/models/contest_details_model.dart';
import '../modules/contests/models/contest_model.dart';
import '../modules/exam-types/models/exam_type_model.dart';
import '../modules/login/models/login_request_model.dart';
import '../modules/login/models/login_response_model.dart';
import '../modules/questions/models/question_model.dart';
import '../modules/register/models/register_model.dart';
import '../modules/subjects/models/subjects_model.dart';
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

  // @override
  // Future<Either<CustomError, List<JobCategory>>> getJobCategories() async {
  //   // final baseUrl = httpClient.baseUrl ?? 'unknown';
  //   // log('url: ${baseUrl}job-categories');
  //   log("Base URL being used: ${httpClient.baseUrl}"); // Debugging
  //   // final baseUrl = httpClient.baseUrl ?? '${AppConfig.baseUrl}${AppConfig.apiVersion}/';
  //   try {
  //     // log('Making API call to: ${baseUrl}job-categories/');
  //     Response response = await get('job-categories/');
  //     log('API response status: 1 ${response.statusCode}, body: ${response.body}');
  //     if (response.statusCode == null) response = await get("job-categories/");
  //     if (response.statusCode == null) response = await get("job-categories/");
  //     if (response.statusCode == null) response = await get("job-categories/");
  //     log('API response status: ${response.statusCode}, body: ${response.body}');
  //     if (response.statusCode == 200) {
  //       List<JobCategory> categories = (response.body['data'] as List)
  //           .map((item) => JobCategory.fromJson(item))
  //           .toList();
  //       return Right(categories);
  //     } else {
  //       return Left(CustomError(response.statusCode,
  //           message: response.statusText ?? 'Error'));
  //     }
  //   } catch (e) {
  //     log('API error: $e');
  //     return Left(CustomError(500, message: 'Network error: $e'));
  //   }
  // }

  @override
  Future<Either<CustomError, List<ExamType>>> getExamTypes() async {
    final response = await get('exam-types');
    if (response.statusCode == 200) {
      try {
        List<ExamType> examTypes = (response.body['data'] as List)
            .map((item) => ExamType.fromJson(item))
            .toList();
        return Right(examTypes);
      } catch (e) {
        return Left(
            CustomError(response.statusCode, message: 'Parsing error: $e'));
      }
    } else {
      return Left(CustomError(response.statusCode,
          message: response.statusText ?? 'Error'));
    }
  }

  @override
  Future<Either<CustomError, List<Contest>>> fetchAllContests() async {
    try {
      final response = await get('contests');
      if (response.statusCode == 200 && response.body['success'] == true) {
        final List<dynamic> data = response.body['data'];
        final contests = data.map((json) => Contest.fromJson(json)).toList();
        return Right(contests);
      } else {
        return Left(CustomError(response.statusCode,
            message: response.body['message'] ?? 'Failed to fetch contests'));
      }
    } catch (e) {
      log('Error fetching contests: $e');
      return Left(CustomError(500, message: 'Network error: $e'));
    }
  }

  @override
  Future<Either<CustomError, List<Question>>> fetchAllQuestions() async {
    try {
      final response = await get('questions');
      if (response.statusCode == 200 && response.body['success'] == true) {
        final List<dynamic> data = response.body['data'];
        final questions = data.map((json) => Question.fromJson(json)).toList();
        return Right(questions);
      } else {
        return Left(CustomError(response.statusCode,
            message: response.body['message'] ?? 'Failed to fetch questions'));
      }
    } catch (e) {
      log('Error fetching questions: $e');
      return Left(CustomError(500, message: 'Network error: $e'));
    }
  }

  // @override
  // Future<Either<CustomError, SingleContest>> fetchSingleContest(
  //     String contestId) async {
  //   try {
  //     final response = await get('contests/$contestId');
  //     if (response.statusCode == 200 && response.body['success'] == true) {
  //       return Right(SingleContest.fromJson(response.body['data']));
  //     } else {
  //       return Left(
  //         CustomError(
  //           response.statusCode,
  //           message: response.body['message'] ?? 'Failed to fetch contest',
  //         ),
  //       );
  //     }
  //   } catch (e) {
  //     return Left(CustomError(500, message: 'Network error: $e'));
  //   }
  // }

  @override
  Future<Either<CustomError, Response>> verifyOtp(
      Map<String, dynamic> data) async {
    try {
      // Construct the payload as a Map
      final payload = data;

      // Make the POST request
      final Response response = await post('users/verify-otp', payload);

      // Handle response based on status code
      if (response.statusCode == 200) {
        return Right(response); // Successful response
      } else {
        return Left(
          CustomError(
            response.statusCode ?? 500,
            message: response.body['message'] ?? 'Error verifying OTP',
          ),
        );
      }
    } catch (e) {
      // Handle exceptions
      return Left(CustomError(500, message: 'Network error: $e'));
    }
  }

  @override
  Future<Either<CustomError, Response>> registerContest(
      String contestId) async {
    try {
      // Fetch the Bearer token from storage
      final token = await StorageHelper.getToken();

      // Ensure the token is not null
      if (token == null) {
        return Left(CustomError(401, message: 'Unauthorized: No token found'));
      }

      // Set up the payload
      final payload = {"contest": contestId};

      // Add Authorization header
      final headers = {
        'Authorization': 'Bearer $token',
      };

      // Make the POST request
      final response =
          await post('register-contests', payload, headers: headers);

      // Handle the response
      if (response.statusCode == 200) {
        return Right(response); // Successful response
      } else {
        return Left(CustomError(
          response.statusCode ?? 500,
          message: response.body['message'] ?? 'Error registering contest',
        ));
      }
    } catch (e) {
      // Handle exceptions
      log('Error registering contest: $e');
      return Left(CustomError(500, message: 'Network error: $e'));
    }
  }

  @override
  Future<Either<CustomError, List<Contest>>> fetchRecentContests(
      {String contestType = "recent"}) async {
    try {
      // Make the GET request to fetch recent contests
      final response = await get('contests/?contestType=$contestType');

      if (response.statusCode == 200 && response.body['success'] == true) {
        // Parse the response data into a list of Contest models
        final List<dynamic> data = response.body['data'];
        final contests = data.map((json) => Contest.fromJson(json)).toList();
        return Right(contests); // Return the list of contests
      } else {
        // Handle API errors
        return Left(CustomError(
          response.statusCode,
          message:
              response.body['message'] ?? 'Failed to fetch recent contests',
        ));
      }
    } catch (e) {
      // Handle any network or parsing errors
      log('Error fetching recent contests: $e');
      return Left(CustomError(500, message: 'Network error: $e'));
    }
  }

  @override
  Future<Either<CustomError, ContestDetailsResponse>> fetchSingleContest(
      String contestId) async {
    try {
      // Make GET request
      final response = await get('contests/$contestId');

      if (response.statusCode == 200 && response.body['success'] == true) {
        // Parse the response into SingleContestResponse
        final data = ContestDetailsResponse.fromJson(response.body['data']);
        return Right(data);
      } else {
        // Handle API error
        return Left(CustomError(
          response.statusCode,
          message:
              response.body['message'] ?? 'Failed to fetch contest details',
        ));
      }
    } catch (e) {
      // Handle network or parsing errors
      log('Error fetching single contest: $e');
      return Left(CustomError(500, message: 'Network error: $e'));
    }
  }

 
  @override
  Future<Either<CustomError, List<Subjects>>> fetchSubjects() async {
    try {
      final response = await get('subjects');

      if (response.statusCode == 200 && response.body['success'] == true) {
        final List<dynamic> data = response.body['data'];
        final categories = data.map((json) => Subjects.fromJson(json)).toList();
        return Right(categories);
      } else {
        return Left(CustomError(
          response.statusCode,
          message: response.body['message'] ?? 'Failed to fetch categories',
        ));
      }
    } catch (e) {
      log('Error fetching categories: $e');
      return Left(CustomError(500, message: 'Network error: $e'));
    }
  }


 
}
