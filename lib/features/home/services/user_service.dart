import 'package:dio/dio.dart';
import 'package:flutter_assignment/core/services/api_routes.dart';
import 'package:flutter_assignment/core/services/base_api_client.dart';
import 'package:flutter_assignment/features/home/models/user_model.dart';

class UserService {
  final BaseApiClient _apiClient;

  UserService(this._apiClient);

  Future<List<User>> getUsers() async {
    try {
      final response = await _apiClient.dio.get(ApiRoutes.users);
      if (response.data is List) {
        return (response.data as List).map((e) => User.fromJson(e)).toList();
      }
      return [];
    } on DioException catch (e) {
      final message = await _apiClient.handleError(e);
      throw Exception(message);
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }
}
