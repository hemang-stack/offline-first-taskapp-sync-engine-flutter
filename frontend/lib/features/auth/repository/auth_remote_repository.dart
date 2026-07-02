import 'dart:convert';
import 'package:frontend/core/common/utils/constants.dart';
import 'package:frontend/core/services/sp_service.dart';
import 'package:frontend/features/auth/repository/auth_local_repository.dart';
import 'package:frontend/models/user_models.dart';
import 'package:http/http.dart' as http;


class AuthRemoteRepository {
  final spService = SpService();
  final authLocalRepository = AuthLocalRepository();

  Future<UserModels> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final res = await http.post(
        Uri.parse('${Constants.backendUri}/auth/signup'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'name': name, 'email': email, 'password': password}),
      );

      if (res.statusCode != 201) {
        throw jsonDecode(res.body)['msg'];
      }

      return UserModels.fromJson(res.body);
    } catch (e) {
      throw (e).toString();
    }
  }

  Future<UserModels> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${Constants.backendUri}/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );
      if (response.statusCode == 200) {
        return UserModels.fromMap(jsonDecode(response.body));
      } else {
        final body = jsonDecode(response.body);

        throw body['message'] ?? 'Login failed!!';
      }
    } catch (e) {
      throw e.toString();
    }
  }

  Future<UserModels?> getUserData() async {
    try {
      final token = await spService.getToken();

      if (token == null) {
        return null;
      }

      final res = await http.post(
        Uri.parse('${Constants.backendUri}/auth/tokenIsValid'),
        headers: {'Content-Type': 'application/json', 'x-auth-token': token},
      );

      if (res.statusCode != 200 || jsonDecode(res.body) == false) {
        return null;
      }

      final userResponse = await http.get(
        Uri.parse('${Constants.backendUri}/auth'),
        headers: {'Content-Type': 'application/json', 'x-auth-token': token},
      );

      if (userResponse.statusCode != 200) {
        throw jsonDecode(userResponse.body)['error'];
      }

      return UserModels.fromJson(userResponse.body);
    } catch (e) {
      final user = await authLocalRepository.getUser();
      print(user);
      return user;
    }
  }
}
