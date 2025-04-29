import 'dart:io';

import 'package:dio/dio.dart';
import '../network/apiService.dart'; // تأكد المسار صحيح

class ApiService {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: Apiservice.baseUrl, // تأكد من أن هذه القيمة صحيحة
      headers: {
        'Content-Type': 'application/json',
      },
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
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

  static Future<Map<String, dynamic>> resetPassword({
    required String code,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      final response = await _dio.post(
        'reset-password', // رابط API لإعادة تعيين كلمة المرور
        data: {
          'code': code, // إرسال كود إعادة تعيين كلمة المرور
          'password': password, // كلمة المرور الجديدة
          'password_confirmation': passwordConfirmation, // تأكيد كلمة المرور
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

  static Future<Map<String, dynamic>> updateProfile({
    required String token,
    required String fullName,
    required String phone,
    required String birthday,
    required String country,
    required String gender,
    File? avatar, // خلي بالك ضفنا هنا ملف الصورة
  }) async {
    try {
      FormData formData = FormData.fromMap({
        "full_name": fullName,
        "phone": phone,
        "birthday": birthday,
        "country": country,
        "gender": gender,
        if (avatar != null)
          "avatar": await MultipartFile.fromFile(
            avatar.path,
            filename: avatar.path.split('/').last,
          ),
      });

      final response = await _dio.post(
        'profile/update',
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
            'Content-Type': 'multipart/form-data',
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

  static Future<Map<String, dynamic>> updateAvatar({
    required String token,
    required File avatar,
  }) async {
    try {
      FormData formData = FormData.fromMap({
        "avatar": await MultipartFile.fromFile(
          avatar.path,
          filename: avatar.path.split('/').last,
        ),
      });

      final response = await _dio.post(
        'user/update-avatar',
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
            'Content-Type': 'multipart/form-data',
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

  static Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      final response = await _dio.post(
        'register', // رابط التسجيل
        data: {
          'email': email,
          'password': password,
          'password_confirmation': passwordConfirmation,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json', // تحديد نوع البيانات المُرسلة
            'Accept':
                'application/json', // تحديد نوع البيانات المتوقعة من السيرفر
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // إذا تم إنشاء المستخدم بنجاح
        return response.data;
      } else {
        // التحقق من وجود رسالة خطأ مع تفاصيل
        if (response.data != null && response.data['errors'] != null) {
          // على سبيل المثال: لو تم التحقق من أن الإيميل موجود
          if (response.data['errors']['email'] != null) {
            return {
              'error': true,
              'message': 'The email has already been taken.',
            };
          }
        }

        return {
          'error': true,
          'message': 'Server error: Code ${response.statusCode}',
        };
      }
    } catch (e) {
      if (e is DioException) {
        // استخراج المزيد من التفاصيل من الاستثناء
        print('DioError: ${e.response?.data}');
      }
      print('Error: $e');
      return _handleError(e);
    }
  }

  static Future<Map<String, dynamic>> resendOtp({required String email}) async {
    try {
      final response = await _dio.post(
        'resend-otp', // مش لازم URL كامل لإنك مجهز baseUrl
        data: {
          'email': email, // إرسال الإيميل في البودي
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

}
