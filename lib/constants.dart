import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';


const titleColor = Color(0xFF010F07);
const primaryColor = Color(0xFFF8BBD0);
const accentColor = Color(0xFFFFF8F9);
const bodyTextColor = Color(0xFF868686);
const inputColor = Color(0xFFFBFBFB);

const double defaultPadding = 16;
const Duration kDefaultDuration = Duration(milliseconds: 250);

const TextStyle kButtonTextStyle = TextStyle(
  color: Colors.white,
  fontSize: 14,
  fontWeight: FontWeight.bold,
);

const EdgeInsets kTextFieldPadding = EdgeInsets.symmetric(
  horizontal: defaultPadding,
  vertical: defaultPadding,
);


const OutlineInputBorder kDefaultOutlineInputBorder = OutlineInputBorder(
  borderRadius: BorderRadius.all(Radius.circular(6)),
  borderSide: BorderSide(
    color: Color(0xFFF3F2F2),
  ),
);

const InputDecoration otpInputDecoration = InputDecoration(
  contentPadding: EdgeInsets.zero,
  counterText: "",
  errorStyle: TextStyle(height: 0),
);

const kErrorBorderSide = BorderSide(color: Colors.red, width: 1);


final passwordValidator = MultiValidator([
  RequiredValidator(errorText: 'Mật khẩu là bắt buộc'),
  MinLengthValidator(8, errorText: 'Mật khẩu phải có ít nhất 8 ký tự'),
  PatternValidator(r'(?=.*?[#?!@$%^&*-/])',
      errorText: 'Mật khẩu phải có ít nhất một ký tự đặc biệt')
]);

final emailValidator = MultiValidator([
  RequiredValidator(errorText: 'Email sinh viên là bắt buộc'),
  EmailValidator(errorText: 'Vui lòng nhập email hợp lệ')
]);

final requiredValidator =
    RequiredValidator(errorText: 'Trường này là bắt buộc');
final matchValidator = MatchValidator(errorText: 'Mật khẩu không khớp');

final phoneNumberValidator = MinLengthValidator(10,
    errorText: 'Số điện thoại phải có ít nhất 10 chữ số');


final Center kOrText = Center(
    child: Text("Hoặc", style: TextStyle(color: titleColor.withValues(alpha: 0.7))));

class StorageKeys {
  static const String name = 'profile_name';
  static const String email = 'profile_email';
  static const String phone = 'profile_phone';
  static const String nickname = 'profile_nickname';
  static const String dob = 'profile_date';
  static const String gender = 'profile_gender';
  static const String country = 'profile_country';
}