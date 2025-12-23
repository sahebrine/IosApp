import 'package:dio/dio.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';

class ApiClient {
  static const String baseUrl = "https://v.zayrix.info";

  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 8),
      receiveTimeout: const Duration(seconds: 8),
      contentType: "application/json",
      validateStatus: (_) => true,
    ),
  );

  static final CookieJar cookieJar = CookieJar();

  static void init() {
    _dio.interceptors.add(CookieManager(cookieJar));
  }

  /// ========================= AUTH =========================

  static Future<bool> login(String username, String password) async {
    final res = await _dio.post(
      "/login",
      data: FormData.fromMap({
        "username": username,
        "password": password,
      }),
      options: Options(
        contentType: "multipart/form-data",
        followRedirects: false,
        validateStatus: (status) => status! < 500,
      ),
    );

    /// نجاح login في Flask = redirect (302)
    return res.statusCode == 302;
  }

  static Future<void> logout() async {
    await _dio.get("/logout");
    cookieJar.deleteAll(); // حذف الجلسة
  }

  /// ========================= KEYS =========================

  static Future<Response> getKeys() async {
    return await _dio.get("/api/list_key");
  }

  static Future<Response> createKey(String duration, String name) async {
    return await _dio.post(
      "/api/add_key",
      data: {
        "duration": duration,
        "name": name,
      },
    );
  }

  static Future<Response> deleteKey(String key) async {
    return await _dio.post(
      "/api/delete_key",
      data: {"key": key},
    );
  }

  static Future<Response> resetKey(String key) async {
    return await _dio.post(
      "/api/reset_key",
      data: {"key": key},
    );
  }

  static Future<Response> extendKey(String key, int days) async {
    return await _dio.post(
      "/api/add_days",
      data: {
        "key": key,
        "days": days,
      },
    );
  }

  static Future<Response> extendAll(int days) async {
    return await _dio.post(
      "/api/add_all",
      data: {"days": days},
    );
  }
}
