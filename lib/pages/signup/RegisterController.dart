import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:proximaride_app/consts/const_api.dart';
import 'package:proximaride_app/pages/login/LoginProvider.dart';
import 'package:proximaride_app/pages/signup/SignupProvider.dart';
import 'package:proximaride_app/services/service.dart';
import 'package:proximaride_app/utils/error_message_helper.dart';

class RegisterController extends GetxController {
  late TextEditingController firstNameTextController,
      lastNameTextController,
      emailTextController,
      passwordTextController,
      confirmPasswordTextController;

  final Map<String, FocusNode> focusNodes = {};

  var showToolTip = false.obs;
  var showOverly = false.obs;
  var isLoading = false.obs;
  var isPasswordVisible = false.obs;
  var isConfirmPasswordVisible = false.obs;
  var switchValue = false.obs;

  final secureStorage = const FlutterSecureStorage();
  final serviceController = Get.find<Service>();
  var showHideText = true.obs;
  var errorList = List.empty(growable: true).obs;
  final errors = [].obs;
  var regionId = "".obs;
  var passwordCheckList = [].obs;
  var confirmPasswordCheckList = [].obs;
  var scrollField = false;
  ScrollController scrollController = ScrollController();
  var labelTextDetail = {}.obs;
  var validationMessageDetail = {}.obs;

  @override
  void onInit() async {
    // TODO: implement onInit
    super.onInit();

    await getLabelTextDetail();
    firstNameTextController = TextEditingController();
    lastNameTextController = TextEditingController();
    emailTextController = TextEditingController();
    passwordTextController = TextEditingController();
    confirmPasswordTextController = TextEditingController();

    for (int i = 1; i <= 5; i++) {
      focusNodes[i.toString()] = FocusNode();
      // Attach the onFocusChange listener
      focusNodes[i.toString()]?.addListener(() {
        if (!focusNodes[i.toString()]!.hasFocus) {
          // Field has lost focus, trigger validation
          if (i == 1) {
            validateField(
              'first_name',
              firstNameTextController.text,
            );
          } else if (i == 2) {
            validateField(
              'last_name',
              lastNameTextController.text,
            );
          } else if (i == 3) {
            validateField('email', emailTextController.text, type: 'email');
          } else if (i == 4) {
            validateField('password', passwordTextController.text,
                type: 'password');
          } else if (i == 5) {
            validateField(
                'password_confirmation', confirmPasswordTextController.text,
                type: 'confirmPassword');
          }
        }
      });
    }

    checkPassword();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    scrollController.dispose();
    // emailTextController.dispose();
    // passwordTextController.dispose();
    // firstNameTextController.dispose();
    // lastNameTextController.dispose();
    // confirmPasswordTextController.dispose();
  }

  Future<void> getLabelTextDetail() async {
    try {
      isLoading(true);
      await LoginProvider()
          .getLabelTextDetail(serviceController.langId.value, signUpPage)
          .then((resp) async {
        if (resp['status'] != null && resp['status'] == "Success") {
          if (resp['data'] != null && resp['data']['signupPage'] != null) {
            labelTextDetail.addAll(resp['data']['signupPage']);
          }

          if (resp['data'] != null &&
              resp['data']['validationMessages'] != null) {
            validationMessageDetail.addAll(resp['data']['validationMessages']);
          }

          var getLanguage = serviceController.languages.firstWhereOrNull(
              (element) => element['id'] == serviceController.langId.value);
          if (getLanguage != null) {
            serviceController.langIcon.value = getLanguage['flag_icon'];
            serviceController.lang.value = getLanguage['abbreviation'];
          }
        }
        isLoading(false);
      }, onError: (error) {
        serviceController.showDialogue(error.toString());
        isLoading(false);
      });
    } catch (exception) {
      serviceController.showDialogue(exception.toString());
      isLoading(false);
    }
  }

  void validateField(String fieldName, String fieldValue,
      {String type = 'string', bool isRequired = true, int wordsLimit = 50}) {
    errors.removeWhere((element) => element['title'] == fieldName);
    List<String> errorList = [];

    if (isRequired && fieldValue.isEmpty) {
      final fieldLabels = {
        "first_name": labelTextDetail['first_name_error'] ?? "First name",
        "last_name": labelTextDetail['last_name_error'] ?? "Last name",
        "email": labelTextDetail['email_error'] ?? "Email",
        "password": labelTextDetail['password_error'] ?? "Password",
        "password_confirmation": labelTextDetail['confirm_password_error'] ?? "Confirm password",
      };
      
      String displayName = fieldLabels[fieldName] ?? fieldName;
      String message = ErrorMessageHelper.getErrorMessage(
        validationMessages: validationMessageDetail,
        validationType: 'required',
        fieldName: displayName,
      );

      errorList.add(message);
      errors.add({
        'title': fieldName,
        'eList': errorList,
      });
      return;
    }

    errorList.clear();
    switch (type) {
      case 'password':
        if (checkPassword()) {
          String message = ErrorMessageHelper.getErrorMessage(
            validationMessages: validationMessageDetail,
            validationType: 'regex',
            fieldName: labelTextDetail['password_error'] ?? "password",
            fallbackMessage: 'The password format is invalid; The password length should be at least 8 characters and must include one lower case, one uppercase, one number, and one special character',
          );
          errorList.add(message);
        }
        break;

      case 'confirmPassword':
        if (passwordTextController.text != confirmPasswordTextController.text) {
          String message = ErrorMessageHelper.getErrorMessage(
            validationMessages: validationMessageDetail,
            validationType: 'confirmed',
            fieldName: labelTextDetail['confirm_password_error'] ?? "confirm password",
            fallbackMessage: 'Password and confirm password does not match',
          );
          errorList.add(message);
        }
        break;

      case 'email':
        if (!isValidEmail(fieldValue)) {
          var message = validationMessageDetail['email'];
          errorList.add(message ?? '$fieldName must be a valid format');
        }
        break;
      case 'numeric':
        if (fieldValue.isNotEmpty && double.tryParse(fieldValue) == null) {
          errorList.add('$fieldName must be a number');
        }
        break;
      case 'date':
        if (fieldValue.isNotEmpty && DateTime.tryParse(fieldValue) == null) {
          errorList.add('$fieldName must be a valid date');
        }
        break;
      case 'time':
        if (fieldValue.isNotEmpty &&
            !RegExp(r'^\d{2}:\d{2}$').hasMatch(fieldValue)) {
          errorList.add('$fieldName must be in the format HH:MM');
        }
        break;
      case 'max_words':
        if (fieldValue.isNotEmpty &&
            fieldValue.split(' ').length > wordsLimit) {
          errorList.add('$fieldName must have at most $wordsLimit words');
        }
        break;
      default:
        break;
    }

    if (errorList.isNotEmpty) {
      errors.add({
        'title': fieldName,
        'eList': errorList,
      });
    }
    update();
  }

  bool isValidEmail(String email) {
    // Regular expression for email validation
    final RegExp emailRegExp =
        RegExp(r'^[a-zA-Z0-9._-]+@[a-zA-Z0-9]+\.[a-zA-Z]{2,}$');
    return emailRegExp.hasMatch(email);
  }

  signup(context, screenHeight) async {
    try {
      scrollField = false;
      errors.clear(); // Clear previous errors

      // Validate all fields
      validateFirstName();
      validateLastName();
      validateEmail();
      validatePassword();
      validateConfirmPassword();
      // _validateTermsAcceptance();

      // If there are validation errors, don't proceed
      if (errors.isNotEmpty) {
        return;
      }

      showOverly(true);
      SignupProvider()
          .registerUser(
              firstNameTextController.text.trim(),
              lastNameTextController.text.trim(),
              emailTextController.text.trim(),
              passwordTextController.text,
              confirmPasswordTextController.text,
              serviceController.langId.value)
          .then((resp) async {
        errorList.clear();
        errors.clear();

        if (resp['status'] != null && resp['status'] == "Error") {
          serviceController.showDialogue(resp['message'].toString());
        } else if (resp['errors'] != null) {
          _handleServerErrors(resp['errors'], context, screenHeight);
        } else if (resp['status'] != null && resp['status'] == "Success") {
          serviceController.loginUserDetail.clear();
          secureStorage.deleteAll();
          serviceController.showDialogue(resp['message'].toString(),
              path: '/login', off: 1);
        }

        showOverly(false);
      }, onError: (err) {
        showOverly(false);
        serviceController.showDialogue(err.toString());
      });
    } catch (exception) {
      serviceController.showDialogue(exception.toString());
    }
  }

// Validation helper methods
  void validateFirstName() {
    String firstName = firstNameTextController.text.trim();

    if (firstName.isEmpty) {
      _addError("first_name", ['First name is required'], 1);
    } else if (firstName.length < 2) {
      _addError(
          "first_name", ['First name must be at least 2 characters long'], 1);
    } else if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(firstName)) {
      _addError(
          "first_name", ['First name can only contain letters and spaces'], 1);
    }
  }

  void validateLastName() {
    String lastName = lastNameTextController.text.trim();

    if (lastName.isEmpty) {
      _addError("last_name", ['Last name is required'], 2);
    } else if (lastName.length < 2) {
      _addError(
          "last_name", ['Last name must be at least 2 characters long'], 2);
    } else if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(lastName)) {
      _addError(
          "last_name", ['Last name can only contain letters and spaces'], 2);
    }
  }

  void validateEmail() {
    String email = emailTextController.text.trim();

    if (email.isEmpty) {
      _addError("email", ['Email is required'], 3);
    } else if (!_isValidEmail(email)) {
      _addError("email", ['Enter a valid email e.g test@example.com'], 3);
    }
  }

  void validatePassword() {
    String password = passwordTextController.text;
    List<String> checkList = [];

    if (password.length >= 8) checkList.add("length");
    if (RegExp(r'[a-z]').hasMatch(password)) checkList.add("small");
    if (RegExp(r'[A-Z]').hasMatch(password)) checkList.add("capital");
    if (RegExp(r'[0-9]').hasMatch(password)) checkList.add("number");
    if (RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password))
      checkList.add("special");

    passwordCheckList.value = checkList;

    List<String> passwordErrors = [];

    if (password.isEmpty) {
      passwordErrors.add('Password is required');
    } else {
      if (!checkList.contains("length"))
        passwordErrors.add('Password must be at least 8 characters');
      if (!checkList.contains("small"))
        passwordErrors.add('Must contain lowercase letter');
      if (!checkList.contains("capital"))
        passwordErrors.add('Must contain uppercase letter');
      if (!checkList.contains("number"))
        passwordErrors.add('Must contain a number');
      if (!checkList.contains("special"))
        passwordErrors.add('Must contain special character');
    }

    if (passwordErrors.isNotEmpty) {
      _addError("password", passwordErrors, 4);
    }
  }

  List<String> getPasswordChecklist() {
    String password = passwordTextController.text;
    List<String> checklist = [];

    if (password.length >= 8) checklist.add("length");
    if (RegExp(r'[a-z]').hasMatch(password)) checklist.add("small");
    if (RegExp(r'[A-Z]').hasMatch(password)) checklist.add("capital");
    if (RegExp(r'[0-9]').hasMatch(password)) checklist.add("number");
    if (RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password))
      checklist.add("special");

    return checklist;
  }

  // void validateConfirmPassword() {
  //   String password = passwordTextController.text;
  //   String confirmPassword = confirmPasswordTextController.text;

  //   if (confirmPassword.isEmpty) {
  //     _addError("password_confirmation", ['Confirm password is required'], 5);
  //   } else if (password != confirmPassword) {
  //     _addError("password_confirmation", ['Passwords do not match'], 5);
  //   }
  // }
  void validateConfirmPassword() {
    String password = passwordTextController.text;
    String confirmPassword = confirmPasswordTextController.text;

    if (confirmPassword.isEmpty) {
      _addError("password_confirmation", ['Confirm password is required'], 5);
    } else if (password != confirmPassword) {
      if (!passwordCheckList.contains("match")) {
        passwordCheckList.add("match");
      }
      _addError("password_confirmation", ['Passwords do not match'], 5);
    } else {
      passwordCheckList.remove("match");
    }
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
        .hasMatch(email);
  }

  void _addError(String title, List<String> errorList, int scrollPosition) {
    var err = {'title': title, 'eList': errorList};
    errors.add(err);

    // if (scrollField == false) {
    //   scrollError(context, scrollPosition, screenHeight);
    //   scrollField = true;
    // }
  }

  void _handleServerErrors(
      Map<String, dynamic> serverErrors, context, screenHeight) {
    scrollField = false;

    if (serverErrors['first_name'] != null) {
      _addError("first_name", List<String>.from(serverErrors['first_name']), 1);
    }
    if (serverErrors['last_name'] != null) {
      _addError("last_name", List<String>.from(serverErrors['last_name']), 2);
    }
    if (serverErrors['email'] != null) {
      _addError("email", List<String>.from(serverErrors['email']), 3);
    }
    if (serverErrors['password'] != null) {
      _addError("password", List<String>.from(serverErrors['password']), 4);
    }
    if (serverErrors['password_confirmation'] != null) {
      _addError("password_confirmation",
          List<String>.from(serverErrors['password_confirmation']), 5);
    }
  }
  // signup(context, screenHeight) async {
  //   try {
  //     scrollField = false;

  //     if (firstNameTextController.text.isEmpty ||
  //         lastNameTextController.text.isEmpty ||
  //         emailTextController.text.isEmpty ||
  //         passwordTextController.text.isEmpty ||
  //         confirmPasswordTextController.text.isEmpty ||
  //         switchValue.value == false) {
  //       if (firstNameTextController.text.isEmpty) {
  //         var message = validationMessageDetail['required'];
  //         message = message.replaceAll(":Attribute",
  //             labelTextDetail['first_name_error'] ?? 'First name');
  //         var err = {
  //           'title': "first_name",
  //           'eList': ['First name field is required']
  //           // 'eList' : [message ?? 'First name field is required']
  //         };
  //         errors.add(err);
  //         if (scrollField == false) {
  //           scrollError(context, 1, screenHeight);
  //           scrollField = true;
  //         }
  //       }

  //       if (lastNameTextController.text.isEmpty) {
  //         var message = validationMessageDetail['required'];
  //         message = message.replaceAll(
  //             ":Attribute", labelTextDetail['last_name_error'] ?? 'Last name');
  //         var err = {
  //           'title': "last_name",
  //           'eList': ['Last name field is required']
  //         };
  //         errors.add(err);
  //         if (scrollField == false) {
  //           scrollError(context, 2, screenHeight);
  //           scrollField = true;
  //         }
  //       }

  //       if (emailTextController.text.isEmpty) {
  //         var message = validationMessageDetail['required'];
  //         message = message.replaceAll(
  //             ":Attribute", labelTextDetail['email_error'] ?? 'Email');
  //         var err = {
  //           'title': "email",
  //           'eList': ['Email field is required']
  //         };
  //         errors.add(err);
  //         if (scrollField == false) {
  //           scrollError(context, 3, screenHeight);
  //           scrollField = true;
  //         }
  //       }

  //       if (passwordTextController.text.isEmpty) {
  //         var message = validationMessageDetail['required'];
  //         message = message.replaceAll(
  //             ":Attribute", labelTextDetail['password_error'] ?? 'Password');
  //         var err = {
  //           'title': "password",
  //           'eList': ['Password field is required']
  //         };
  //         errors.add(err);
  //         if (scrollField == false) {
  //           scrollError(context, 4, screenHeight);
  //           scrollField = true;
  //         }
  //       }

  //       if (confirmPasswordTextController.text.isEmpty) {
  //         var message = validationMessageDetail['required'];
  //         message = message.replaceAll(":Attribute",
  //             labelTextDetail['confirm_password_error'] ?? 'Confirm password');
  //         var err = {
  //           'title': "password_confirmation",
  //           'eList': [message ?? 'Confirm password field is required']
  //         };
  //         errors.add(err);
  //         if (scrollField == false) {
  //           scrollError(context, 5, screenHeight);
  //           scrollField = true;
  //         }
  //       }

  //       return;
  //     }
  //     showOverly(true);
  //     SignupProvider()
  //         .registerUser(
  //             firstNameTextController.text,
  //             lastNameTextController.text,
  //             emailTextController.text.trim(),
  //             passwordTextController.text,
  //             confirmPasswordTextController.text,
  //             serviceController.langId.value)
  //         .then((resp) async {
  //       errorList.clear();
  //       errors.clear();

  //       if (resp['status'] != null && resp['status'] == "Error") {
  //         serviceController.showDialogue(resp['message'].toString());
  //       } else if (resp['errors'] != null) {
  //         if (resp['errors']['first_name'] != null) {
  //           var err = {
  //             'title': "first_name",
  //             'eList': resp['errors']['first_name']
  //           };
  //           errors.add(err);
  //           if (scrollField == false) {
  //             scrollError(context, 1, screenHeight);
  //             scrollField = true;
  //           }
  //         }
  //         if (resp['errors']['last_name'] != null) {
  //           var err = {
  //             'title': "last_name",
  //             'eList': resp['errors']['last_name']
  //           };
  //           errors.add(err);
  //           if (scrollField == false) {
  //             scrollError(context, 2, screenHeight);
  //             scrollField = true;
  //           }
  //         }
  //         if (resp['errors']['email'] != null) {
  //           var err = {'title': "email", 'eList': resp['errors']['email']};
  //           errors.add(err);
  //           if (scrollField == false) {
  //             scrollError(context, 3, screenHeight);
  //             scrollField = true;
  //           }
  //         }
  //         if (resp['errors']['password'] != null) {
  //           var err = {
  //             'title': "password",
  //             'eList': resp['errors']['password']
  //           };
  //           errors.add(err);
  //           if (scrollField == false) {
  //             scrollError(context, 4, screenHeight);
  //             scrollField = true;
  //           }
  //         }
  //         if (resp['errors']['password_confirmation'] != null) {
  //           var err = {
  //             'title': "password_confirmation",
  //             'eList': resp['errors']['password_confirmation']
  //           };
  //           errors.add(err);
  //           if (scrollField == false) {
  //             scrollError(context, 5, screenHeight);
  //             scrollField = true;
  //           }
  //         }
  //       } else if (resp['status'] != null && resp['status'] == "Success") {
  //         // Get.offAllNamed('/login');
  //         serviceController.loginUserDetail.clear();
  //         secureStorage.deleteAll();
  //         serviceController.showDialogue(resp['message'].toString(),
  //             path: '/login', off: 1);
  //       }

  //       showOverly(false);
  //     }, onError: (err) {
  //       showOverly(false);
  //       serviceController.showDialogue(err.toString());
  //     });
  //   } catch (exception) {
  //     serviceController.showDialogue(exception.toString());
  //   }
  // }

  Future signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser =
        await GoogleSignIn(scopes: ["profile", "email"]).signIn();
    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    var userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);
    var email = userCredential.user?.email;
    var name = userCredential.user?.displayName;
    var photoUrl = userCredential.user?.photoURL;
    var uId = userCredential.user?.uid;
    await socialLogin('google', email, name, photoUrl, uId);
  }

  Future signInWithFacebook() async {
    // Trigger the sign-in flow
    final LoginResult loginResult = await FacebookAuth.instance.login();

    // Create a credential from the access token
    final OAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(loginResult.accessToken!.tokenString);

    // Once signed in, return the UserCredential
    var userCredential = await FirebaseAuth.instance
        .signInWithCredential(facebookAuthCredential);
    User? user = userCredential.user;
    var email = user?.email;
    var name = user?.displayName;
    var photoUrl = user?.photoURL;
    var uId = user?.uid;
    await socialLogin('facebook', email, name, photoUrl, uId);
  }

  getUserInfo(data) {
    try {
      showOverly(true);
      LoginProvider().linkedInUserInfo(data['access_token']).then((resp) async {
        var email = resp['email'];
        var name = resp['name'];
        var photoUrl = resp['picture'];
        var uId = resp['sub'];
        await socialLogin('linkedIn', email, name, photoUrl, uId);
      }, onError: (err) {
        showOverly(false);
        serviceController.showDialogue(err.toString());
      });
    } catch (exception) {
      serviceController.showDialogue(exception.toString());
    }
  }

  socialLogin(type, email, name, photoUrl, typeId) async {
    try {
      showOverly(true);
      LoginProvider()
          .socialLogin(type, email, name, photoUrl, typeId,
              serviceController.langId.value)
          .then((resp) async {
        errorList.clear();
        errors.clear();

        if (resp['status'] != null && resp['status'] == "Error") {
          serviceController.showDialogue(resp['message'].toString());
        } else if (resp['errors'] != null) {
          if (resp['errors']['type'] != null) {
            errorList.addAll(resp['errors']['type']);
            errors.add('type');
          }
          if (resp['errors']['type_id'] != null) {
            errorList.addAll(resp['errors']['type_id']);
            errors.add('type_id');
          }
          if (resp['errors']['user_name'] != null) {
            errorList.addAll(resp['errors']['user_name']);
            errors.add('user_name');
          }
          if (resp['errors']['email'] != null) {
            errorList.addAll(resp['errors']['email']);
            errors.add('email');
          }
          if (resp['errors']['photourl'] != null) {
            errorList.addAll(resp['errors']['photourl']);
            errors.add('photourl');
          }
        } else if (resp['status'] != null && resp['status'] == "Success") {
          serviceController.languages.clear();
          if (resp['data'] != null && resp['data']['languages'] != null) {
            serviceController.languages.addAll(resp['data']['languages']);
          }

          secureStorage.write(key: "token", value: resp['data']['token']);
          serviceController.token = resp['data']['token'];
          serviceController.loginUserDetail['id'] =
              int.parse(resp['data']['id'].toString());
          serviceController.loginUserDetail['first_name'] =
              resp['data']['first_name'].toString();
          serviceController.loginUserDetail['last_name'] =
              resp['data']['last_name'].toString();
          serviceController.loginUserDetail['gender'] =
              resp['data']['gender'].toString();
          serviceController.loginUserDetail['profile_image'] =
              resp['data']['profile_image'].toString();
          serviceController.loginUserDetail['profile_original_image'] =
              resp['data']['profile_original_image'].toString();
          serviceController.loginUserDetail['email'] =
              resp['data']['email'].toString();
          serviceController.loginUserDetail['step'] =
              resp['data']['step'] == null
                  ? "1"
                  : resp['data']['step'].toString();
          serviceController.loginUserDetail['langId'] =
              resp['data']['langId'].toString();
          serviceController.loginUserDetail['driver_liscense'] =
              resp['data']['driver_liscense'].toString();
          serviceController.langId.value =
              int.parse(resp['data']['langId'].toString());
          serviceController.loginUserDetail['driver_average_rating'] =
              resp['data']['driver_average_rating'] != null
                  ? resp['data']['driver_average_rating'].toString()
                  : "0.0";
          serviceController.loginUserDetail['passenger_average_rating'] =
              resp['data']['passenger_average_rating'] != null
                  ? resp['data']['passenger_average_rating'].toString()
                  : "0.0";
          serviceController.loginUserDetail['user_average_rating'] =
              resp['data']['user_average_rating'] != null
                  ? resp['data']['user_average_rating'].toString()
                  : "0.0";
          serviceController.loginUserDetail['driver_total_ratings'] =
              resp['data']['driver_total_ratings'] != null
                  ? resp['data']['driver_total_ratings'].toString()
                  : "0";
          serviceController.loginUserDetail['passenger_total_ratings'] =
              resp['data']['passenger_total_ratings'] != null
                  ? resp['data']['passenger_total_ratings'].toString()
                  : "0";
          serviceController.loginUserDetail['user_total_ratings'] =
              resp['data']['user_total_ratings'] != null
                  ? resp['data']['user_total_ratings'].toString()
                  : "0";

          secureStorage.write(
              key: "userInfo",
              value: jsonEncode(serviceController.loginUserDetail));

          var getLanguage = serviceController.languages.firstWhereOrNull(
              (element) => element['id'] == serviceController.langId.value);
          if (getLanguage != null) {
            serviceController.langIcon.value = getLanguage['flag_icon'];
            serviceController.lang.value = getLanguage['abbreviation'];
          }

          if (serviceController.loginUserDetail['step'] == "0") {
            Get.toNamed('/login');
          } else if (serviceController.loginUserDetail['step'] == "1") {
            Get.offAllNamed('/stage_one');
          } else if (serviceController.loginUserDetail['step'] == "2") {
            Get.offAllNamed('/stage_two');
          } else if (serviceController.loginUserDetail['step'] == "3") {
            Get.offAllNamed('/stage_three_vehicle');
          } else if (serviceController.loginUserDetail['step'] == "4") {
            Get.offAllNamed('/stage_four');
          } else if (serviceController.loginUserDetail['step'] == "5") {
            Get.offAllNamed('/navigation');
          } else {
            Get.offAllNamed('/navigation');
          }
          // Get.offAllNamed('/navigation');
        }
        showOverly(false);
      }, onError: (err) {
        showOverly(false);
        serviceController.showDialogue(err.toString());
      });
    } catch (exception) {
      serviceController.showDialogue(exception.toString());
    }
  }

  checkPassword() {
    var pass = passwordTextController.text;
    bool small = false, capital = false, special = false, number = false;

    for (int i = 0; i < pass.length; i++) {
      if (RegExp(r'[a-z]').hasMatch(pass[i])) {
        small = true;
      }
      if (RegExp(r'[A-Z]').hasMatch(pass[i])) {
        capital = true;
      }
      if (RegExp(r'[0-9]').hasMatch(pass[i])) {
        number = true;
      }
      if (RegExp(r'[^a-zA-Z0-9]').hasMatch(pass[i])) {
        special = true;
      }
    }

    if (pass.length >= 8 && small && capital && number && special) {
      return false;
    }
    return true;
  }

  checkConfirmPassword() {
    var pass = confirmPasswordTextController.text;
    bool small = false, capital = false, special = false, number = false;

    for (int i = 0; i < pass.length; i++) {
      if (RegExp(r'[a-z]').hasMatch(pass[i])) {
        small = true;
      }
      if (RegExp(r'[A-Z]').hasMatch(pass[i])) {
        capital = true;
      }
      if (RegExp(r'[0-9]').hasMatch(pass[i])) {
        number = true;
      }
      if (RegExp(r'[^a-zA-Z0-9]').hasMatch(pass[i])) {
        special = true;
      }
    }

    if (small) {
      confirmPasswordCheckList.remove('small');
    } else {
      if (!confirmPasswordCheckList.contains('small')) {
        confirmPasswordCheckList.add('small');
      }
    }

    if (capital) {
      confirmPasswordCheckList.remove('capital');
    } else {
      if (!confirmPasswordCheckList.contains('capital')) {
        confirmPasswordCheckList.add('capital');
      }
    }

    if (number) {
      confirmPasswordCheckList.remove('number');
    } else {
      if (!confirmPasswordCheckList.contains('number')) {
        confirmPasswordCheckList.add('number');
      }
    }

    if (special) {
      confirmPasswordCheckList.remove('special');
    } else {
      if (!confirmPasswordCheckList.contains('special')) {
        confirmPasswordCheckList.add('special');
      }
    }

    if (pass.length >= 8) {
      confirmPasswordCheckList.remove('length');
    } else {
      if (!confirmPasswordCheckList.contains('length')) {
        confirmPasswordCheckList.add('length');
      }
    }

    if (passwordTextController.text == confirmPasswordTextController.text) {
      confirmPasswordCheckList.remove('match');
    } else {
      if (!confirmPasswordCheckList.contains('match')) {
        confirmPasswordCheckList.add('match');
      }
    }

    confirmPasswordCheckList.refresh();
  }

  scrollError(context, position, screenHeight) {
    position = position * 150.0;
    if (MediaQuery.of(context).viewInsets.bottom > 0) {
      // Keyboard is visible, adjust the scroll to avoid the keyboard
      position -= 150.0; // Adjust as per your requirement
    }

    // Scroll to the calculated position with some margin
    scrollController.animateTo(
      position - screenHeight / 4, // This adjusts the position dynamically
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }
}
