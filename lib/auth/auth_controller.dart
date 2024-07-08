import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:uber_bnb_app/core/constants/constants.dart';
import 'package:uber_bnb_app/core/constants/toast_helper.dart';
import 'package:uber_bnb_app/core/routes/routes.dart';
import 'package:uber_bnb_app/core/utils/app_preference.dart';
import 'package:uber_bnb_app/core/utils/navigation.dart';
import 'package:uber_bnb_app/module/authentication/presentation/model/login_model.dart';
import 'package:uber_bnb_app/module/authentication/presentation/model/otp_model.dart';
import 'package:uber_bnb_app/module/authentication/presentation/service/auth_service.dart';
import 'package:uber_bnb_app/module/authentication/presentation/service/social_authentication/apple_auth.dart';
import 'package:uber_bnb_app/module/authentication/presentation/service/social_authentication/facebook_auth.dart';
import 'package:uber_bnb_app/module/authentication/presentation/service/social_authentication/google_auth.dart';

import '../../../profile/presentation/services/profile_services.dart';

class AuthController extends GetxController {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPassController = TextEditingController();
  TextEditingController loginEmailController = TextEditingController();
  TextEditingController loginPasswordController = TextEditingController();
  TextEditingController forgotEmailController = TextEditingController();
  TextEditingController newPassController = TextEditingController();
  TextEditingController newConfirmPassController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  PageController pageController = PageController();
  RxDouble currentPageValue = 0.0.obs;
  Rx<LoginModel?> loginModel = LoginModel().obs;
  Rx<OtpModel?> otpModel = OtpModel().obs;
  RxBool isLoading = false.obs;
  RxBool isSignUpLoading = false.obs;

  final formKeySignIn = GlobalKey<FormState>();
  final formKeySignUp = GlobalKey<FormState>();
  final formKeyForgotPassword = GlobalKey<FormState>();
  final formKeyNewPassword = GlobalKey<FormState>();
  final formKeyNewConfirmPassword = GlobalKey<FormState>();
  final formKeyOTP = GlobalKey<FormState>();

  RxBool isSignInButtonColorEnable = false.obs;

  RxBool isAccept = false.obs;

  @override
  void onInit() async {
    super.onInit();
    pageController.addListener(() {
      currentPageValue.value = pageController.page!;
      log("page  value---> ${pageController.page}");
    });
  }

  Future signUp() async {
    try {
      isSignUpLoading.value = true;
      var response = await AuthService.signUp(
        email: emailController.text,
        password: passwordController.text,
        userName: nameController.text,
      );
      log("Response for signUp---${response}");
      if (response != null) {
        AppToast.toastMessage("SignUp Successfully");
        // setPage(0);
        currentPageValue.value = 0;

        nameController.clear();
        emailController.clear();
        passwordController.clear();
        confirmPassController.clear();
      }
      isSignUpLoading.value = false;
    } catch (e, st) {
      log("Error for sign up---> ${e} ${st}");
      isSignUpLoading.value = false;
      // ToastUtils.Toast(e.toString().split(":")[2], toastColor: AppColors.red);
    } finally {
      isSignUpLoading.value = false;
    }
  }

  Future<void> signIn() async {
    try {
      isLoading.value = true;
      var response = await AuthService.signIn(
        email: loginEmailController.text,
        password: loginPasswordController.text,
      );
      log("Response for signIn---${response}");
      if (response != null) {
        loginModel.value = LoginModel.fromJson(response);
        if (loginModel.value?.apiresponse?.data?.token != '' && loginModel.value?.apiresponse?.data?.token?.isNotEmpty == true) {
          AppPreference.setString(AppConstant.userToken, loginModel.value?.apiresponse?.data?.token ?? '');
          AppPreference.setString(AppConstant.userPass, loginPasswordController.text);
        }
        Navigation.popAndPushNamed(Routes.homeScreen);
        AppToast.toastMessage("SignIn Successfully");
      } else {
        AppToast.toastMessage("Invalid email or password!");
      }
      isLoading.value = false;
    } catch (e, st) {
      log("Error for sign in---> ${e} ${st}");
      isLoading.value = false;
    } finally {
      isLoading.value = false;
    }
    return null;
  }

  Future<void> googleSignIn() async {
    try {
      isLoading.value = true;

      GoogleSignInAuthentication? user = await GoogleSignInAuth.signInGoogle();

      if (user != null) {
        print("Response for signIn---${user.idToken}");
        var response = await AuthService.googleSignIn(
          token: user.idToken ?? "",
        );
        if (response != null) {
          loginModel.value = LoginModel.fromJson(response);
          if (loginModel.value?.apiresponse?.data?.token != '' && loginModel.value?.apiresponse?.data?.token?.isNotEmpty == true) {
            AppPreference.setString(AppConstant.userToken, loginModel.value?.apiresponse?.data?.token ?? '');
          }
          log("Response for signIn---${response}");
          Navigation.popAndPushNamed(Routes.homeScreen);
          AppToast.toastMessage("SignIn Successfully");
        }
        log("Response for signIn---${response}");
        Navigation.popAndPushNamed(Routes.homeScreen);
        AppToast.toastMessage("SignIn Successfully");
      } else {
        AppToast.toastMessage("Google SignIn Failed");
      }
      isLoading.value = false;
    } catch (e, st) {
      log("Error for sign in---> ${e} ${st}");
      isLoading.value = false;
    } finally {
      isLoading.value = false;
    }
    return null;
  }

  Future<void> facebookSignIn() async {
    try {
      isLoading.value = true;

      AccessToken? accessToken = await FaceBookLogin.logInWithFacebook();

      if (accessToken != null) {
        var response = await AuthService.faceBookSignIn(
          token: accessToken.token,
        );
        if (response != null) {
          loginModel.value = LoginModel.fromJson(response);
          if (loginModel.value?.apiresponse?.data?.token != '' && loginModel.value?.apiresponse?.data?.token?.isNotEmpty == true) {
            AppPreference.setString(AppConstant.userToken, loginModel.value?.apiresponse?.data?.token ?? '');
          }
          print("Response for signIn---${accessToken.token}");
          print("Response for response---${response}");
          Navigation.popAndPushNamed(Routes.homeScreen);
          AppToast.toastMessage("SignIn Successfully");
        }
      } else {
        AppToast.toastMessage("Facebook SignIn Failed");
      }

      isLoading.value = false;
    } catch (e, st) {
      log("Error for sign in---> ${e} ${st}");
      isLoading.value = false;
    } finally {
      isLoading.value = false;
    }
    return null;
  }

  Future<void> appleSignIn() async {
    try {
      isLoading.value = true;

      AuthorizationCredentialAppleID? accessToken = await AppleLogin.logInWithApple();

      if (accessToken != null) {
        log("Response for signIn---${accessToken}");
        var response = await AuthService.appleSignIn(
            appleId: accessToken.userIdentifier ?? "", appleToken: accessToken.identityToken!, email: accessToken.email ?? "");
        log("Response for response---${response}");
        Navigation.popAndPushNamed(Routes.homeScreen);
        AppToast.toastMessage("SignIn Successfully");
      } else {
        AppToast.toastMessage("Apple SignIn Failed");
      }

      isLoading.value = false;
    } catch (e, st) {
      log("Error for sign in---> ${e} ${st}");
      isLoading.value = false;
    } finally {
      isLoading.value = false;
    }
    return null;
  }

  Future<void> forgotPassword() async {
    try {
      isLoading.value = true;
      var response = await AuthService.forgotPassword(email: forgotEmailController.text);
      currentPageValue.value = 3;
      AppToast.toastMessage("Email register successfully");
      isLoading.value = false;
      print('response:- $response');
    } catch (e, st) {
      log("Error for forgotPassword---> ${e} ${st}");
      isLoading.value = false;
    } finally {
      isLoading.value = false;
    }
    return null;
  }

  Future<void> changePassword() async {
    try {
      isLoading.value = true;
      final result = await AuthService.changePassOtpVerification(
        email: ProfileServices.getUserDataModel.apiResponse?.data?.email ?? '',
        otp: otpController.text,
      );

      // loginModel.value = LoginModel.fromJson(response);
      // setPage(4);
      if (result != null) {
        currentPageValue.value = 4;
        AppToast.toastMessage("OTP verified successfully");
      }
      otpController.clear();
      isLoading.value = false;
    } catch (e, st) {
      log("Error for otpVerification---> ${e} ${st}");
      isLoading.value = false;
    } finally {
      isLoading.value = false;
    }
    return null;
  }

  Future<void> otpVerification() async {
    try {
      isLoading.value = true;
      final result = await AuthService.otpVerification(
        email: forgotEmailController.text,
        otp: otpController.text,
      );
      otpModel.value = OtpModel.fromJson(result['apiresponse']);
      //
      // loginModel.value = LoginModel.fromJson(response);
      // setPage(4);
      if (otpModel.value?.data?.isNotEmpty == true) {
        currentPageValue.value = 4;
        AppToast.toastMessage("OTP verified successfully");
      }
      otpController.clear();
      isLoading.value = false;
    } catch (e, st) {
      log("Error for otpVerification---> ${e} ${st}");
      isLoading.value = false;
    } finally {
      isLoading.value = false;
    }
    return null;
  }

  Future<void> confirmPassword() async {
    try {
      isLoading.value = true;
      final result = await AuthService.createNewPass(
        email: forgotEmailController.text,
        newPassword: newPassController.text,
        token: otpModel.value?.data.toString() ?? "",
      );
      currentPageValue.value = 0;
      // forgotEmailController.clear();
      newPassController.clear();
      newConfirmPassController.clear();
      AppToast.toastMessage("Password change successfully");
      isLoading.value = false;
      print('result :-$result');
    } catch (e, st) {
      log("Error for confirmPassword---> ${e} ${st}");
      isLoading.value = false;
    } finally {
      isLoading.value = false;
    }
    return null;
  }
}
