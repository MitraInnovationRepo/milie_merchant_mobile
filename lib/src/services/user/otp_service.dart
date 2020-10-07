import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:foodie_merchant/src/data/model/otp.dart';
import 'package:foodie_merchant/src/util/constant.dart';

class OTPService{
  String backendEndpoint = Constant.backendEndpoint;
  Future<http.Response> verifyOtp(OTP otp) async {
    return http.post(
      '$backendEndpoint/otp/verify',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(otp.toJson()),
    );
  }

    Future<http.Response> resendOtp(phoneNumber) async {
    return http.post(
      '$backendEndpoint/otp/resend/$phoneNumber',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
  }
}