import 'package:dio/dio.dart';
import '../network/apiService.dart'; // تأكد المسار صحيح

class ApiService {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: Apiservice.baseUrl, // تأكد من أن هذه القيمة صحيحة
      headers: {
        'Content-Type': 'application/json',
      },
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  static Future<Map<String, dynamic>> forgotPassword(String email) async {
    try {
      final response = await _dio.post(
        'forgot-password', // مش لازم تكتب URL كامل
        queryParameters: {
          'email': email, // الإيميل هنا يتم إضافته كـ query parameter
        },
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        return {
          'error': true,
          'message': 'Server error: Code ${response.statusCode}',
        };
      }
    } catch (e) {
      if (e is DioException) {
        // عرض تفاصيل الخطأ
        return {
          'error': true,
          'message':
              'DioException: ${e.message} | ${e.response?.data ?? 'No response data'}',
        };
      } else {
        return {
          'error': true,
          'message':
              'Unable to connect. Please check your internet connection.',
        };
      }
    }
  }

  // دالة للتحقق من OTP
  static Future<Map<String, dynamic>> verifyOtp(String otp) async {
    try {
      final response = await _dio.post(
        'verify-otp', // مش لازم تكتب URL كامل
        data: {
          'otp_code': otp, // إرسال OTP كـ JSON body
        },
      );

      if (response.statusCode == 200) {
        return response.data; // إرجاع البيانات التي تحتوي على الرسالة أو الخطأ
      } else {
        return {
          'error': true,
          'message': 'Server error: Code ${response.statusCode}',
        };
      }
    } catch (e) {
      if (e is DioException) {
        // عرض تفاصيل الخطأ
        return {
          'error': true,
          'message':
              'DioException: ${e.message} | ${e.response?.data ?? 'No response data'}',
        };
      } else {
        return {
          'error': true,
          'message':
              'Unable to connect. Please check your internet connection.',
        };
      }
    }
  }

  // Get Profile
  static Future<Map<String, dynamic>> getProfile(String token) async {
    try {
      final response = await _dio.get(
        'profile',
        options: Options(
          headers: {
            'Authorization':
                'Bearer $token', // تأكد من أن التوكن يتم إرساله بشكل صحيح
          },
        ),
      );

      // تحقق من حالة الاستجابة
      if (response.statusCode == 200) {
        print('Data received: ${response.data}');
        return response.data;
      } else {
        print('Error: ${response.statusCode} - ${response.statusMessage}');
        return _handleError(response.statusCode, response.data);
      }
    } catch (e) {
      print('Error during request: $e');
      return _handleError(e);
    }
  }

// دالة مساعدة للتعامل مع الأخطاء
  static Map<String, dynamic> _handleError(dynamic error,
      [dynamic responseData]) {
    if (error is DioError) {
      // في حالة كان الخطأ متعلق بـ Dio (مثل خطأ في الاتصال أو الرد من السيرفر)
      return {
        'error': true,
        'message': error.message,
        'response': responseData ?? 'No response data',
      };
    } else {
      // في حالة حدوث استثناءات غير متوقعة
      return {
        'error': true,
        'message': 'An unexpected error occurred.',
      };
    }
  }

  // Update Profile
  static Future<Map<String, dynamic>> updateProfile({
    required String token,
    required String fullName,
    required String phone,
    required String birthday,
    required String country,
    required String gender,
  }) async {
    try {
      final response = await _dio.post(
        'profile/update', // أو لو السيرفر عاملها put استبدل post ب put
        data: {
          "full_name": fullName,
          "phone": phone,
          "birthday": birthday,
          "country": country,
          "gender": gender,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data;
      } else {
        return {
          'error': true,
          'message': 'Server error: Code ${response.statusCode}',
        };
      }
    } catch (e) {
      return _handleError(e);
    }
  }

  // دالة مساعدة لمعالجة الأخطاء بشكل مرتب
}
