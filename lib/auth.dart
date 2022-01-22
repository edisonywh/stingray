import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

enum Result {
  ok,
  error,
}

class AuthResult {
  final String message;
  final Result result;

  AuthResult({
    required this.message,
    required this.result,
  });
}

/// Hacker News does not have an official Auth solution, but
/// we can "hack" around it by using regular POST.
class Auth {
  static const baseUrl = "https://news.ycombinator.com";
  static RegExp validationRequired = RegExp(r"Validation required");

  /// Check if user currently has credentials. If there are credentials
  /// saved, we assume the login was successful, hence user should be currently logged in.
  static Future<bool> isLoggedIn() async {
    final storage = new FlutterSecureStorage();

    String? username = await storage.read(key: "username");
    return username != null;
  }

  static Future<String?> currentUser() async {
    final storage = new FlutterSecureStorage();

    return await storage.read(key: "username");
  }

  static Future<AuthResult> vote({required String itemId}) async {
    final url = "$baseUrl/vote";
    if (!await isLoggedIn())
      return AuthResult(
          message: "You must be logged in to vote", result: Result.error);

    final storage = new FlutterSecureStorage();
    String? username = await storage.read(key: "username");
    String? password = await storage.read(key: "password");

    Map body = {
      "acct": username,
      "pw": password,
      "id": itemId,
      "how": "up", // `up` is upvote, `un` is unvote
    };

    final response = await http.post(
      Uri.parse(url),
      body: body,
    );

    // If we get a 302 we assume it's successful
    if (response.statusCode == 302) {
      return AuthResult(message: "Vote success", result: Result.ok);
    } else {
      return AuthResult(message: "Vote failed", result: Result.error);
    }
  }

  static Future<bool> logout() async {
    final storage = new FlutterSecureStorage();

    await storage.delete(key: "username");
    await storage.delete(key: "password");
    return true;
  }

  static Future<AuthResult> login(
      {required String username, required String password}) async {
    final url = "$baseUrl/login";

    Map body = {
      "acct": username,
      "pw": password,
      "goto": 'news',
    };

    final response = await http.post(
      Uri.parse(url),
      body: body,
    );

    // If we get a 302 we assume it's successful
    if (response.statusCode == 302) {
      final storage = new FlutterSecureStorage();

      await storage.write(key: "username", value: username);
      await storage.write(key: "password", value: password);

      return AuthResult(message: "Login success", result: Result.ok);
    } else if (validationRequired.hasMatch(response.body)) {
      // Validation required.
      return AuthResult(
        message: "Login failed due to Captcha. Please try again later.",
        result: Result.error,
      );
    } else {
      return AuthResult(
          message: "Login failed. Did you mistype your credentials?",
          result: Result.error);
    }
  }
}
