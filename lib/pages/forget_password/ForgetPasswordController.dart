import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:proximaride_app/consts/const_api.dart';
import 'package:proximaride_app/pages/forget_password/ForgetPasswordProvider.dart';
import 'package:proximaride_app/pages/stages/StageProvider.dart';
import 'package:proximaride_app/services/service.dart';

class ForgetPasswordController extends GetxController {
  late TextEditingController emailTextEditingController;

  var isOverlayLoading = false.obs;
  var isLoading = false.obs;

  final serviceController = Get.find<Service>();

  var errors = [].obs;

  var labelTextDetail = {}.obs;
  var validationMessageDetail = {}.obs;

  @override
  void onInit() async {
    // TODO: implement onInit
    super.onInit();
    emailTextEditingController = TextEditingController();
    isLoading(true);
    await getLabelTextDetail();
    isLoading(false);
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    emailTextEditingController.dispose();
  }

  Future<void> getLabelTextDetail() async {
    try {
      await StageProvider()
          .getLabelTextDetail(serviceController.langId.value,
              forgotPasswordSetting, serviceController.token)
          .then((resp) async {
        if (resp['status'] != null && resp['status'] == "Success") {
          if (resp['data'] != null &&
              resp['data']['forgotPasswordPage'] != null) {
            labelTextDetail.addAll(resp['data']['forgotPasswordPage']);
          }
          if (resp['data'] != null && resp['data']['messages'] != null) {
            validationMessageDetail.addAll(resp['data']['messages']);
          }
        }
      }, onError: (error) {
        serviceController.showDialogue(error.toString());
        isLoading(false);
      });
    } catch (exception) {
      serviceController.showDialogue(exception.toString());
      isLoading(false);
    }
  }

  forgetPassword() async {
    try {
      // if(emailTextEditingController.text.isEmpty){
      //   if (emailTextEditingController.text.isEmpty) {
      //     var err = {
      //       'title': "email",
      //       'eList' : [labelTextDetail['email_error'] ?? 'E-mail field is required']
      //     };
      //     errors.add(err);
      //   }
      //   return;
      // }
      errors.clear();
      validateEmail();
      if (errors.isNotEmpty) {
        return;
      }

      isOverlayLoading(true);
      ForgetPasswordProvider()
          .forgetPassword(
        emailTextEditingController.text,
      )
          .then((resp) async {
        if (resp['status'] != null && resp['status'] == "Error") {
          var err = {
            'title': "email",
            'eList': [resp['message'].toString()]
          };
          errors.add(err);
        } else if (resp['errors'] != null) {
          if (resp['errors']['email'] != null) {
            var err = {'title': "email", 'eList': resp['errors']['email']};
            errors.add(err);
          }
        } else if (resp['status'] != null && resp['status'] == "Success") {
          Get.offAllNamed('/thank_you/forgot_password');
        }
        isOverlayLoading(false);
      }, onError: (error) {
        isOverlayLoading(false);
        serviceController.showDialogue(error.toString());
      });
    } catch (exception) {
      isOverlayLoading(false);
      serviceController.showDialogue(exception.toString());
    }
  }

  void validateEmail() {
    String email = emailTextEditingController.text.trim();

    if (email.isEmpty) {
      _addError("email", ['Email is required'], 3);
    } else if (!isValidEmail(email)) {
      _addError("email", ['Please enter a valid email address'], 3);
    }
  }

  bool isValidEmail(String email) {
    // Regular expression for email validation
    final RegExp emailRegExp =
        RegExp(r'^[a-zA-Z0-9._-]+@[a-zA-Z0-9]+\.[a-zA-Z]{2,}$');
    return emailRegExp.hasMatch(email);
  }

  void _addError(String title, List<String> errorList, int scrollPosition) {
    var err = {'title': title, 'eList': errorList};
    errors.add(err);

    // if (scrollField == false) {
    //   scrollError(context, scrollPosition, screenHeight);
    //   scrollField = true;
    // }
  }
}
