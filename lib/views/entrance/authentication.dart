import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pedometer/core/appButtons.dart';
import 'package:pedometer/core/appColors.dart';
import 'package:pedometer/core/appInputField.dart';
import 'package:pedometer/core/appTopBar.dart';
import 'package:pedometer/models/userModel.dart';
import 'package:pedometer/services/api/baseApi.dart';

class Authentication extends StatefulWidget {
  bool isLoginState = false;

  Authentication({required this.isLoginState});

  @override
  State<Authentication> createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {
  final _formKey = GlobalKey<FormState>();
  bool hidePassword = true;
  bool loading = false;
  bool hideConfirmPassword = true;
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _nameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      setState(() {
        loading = true;
      });
      UserCredential? res;
      if (!widget.isLoginState) {
        //send llogin credential
        res = await BaseApi().userApi.createAuthUserWithEmailAndPassword(
            userModel: UserModel(
              name: _nameController.text.trim(),
              email: _emailController.text.trim(),
            ),
            password: _passwordController.text.trim());
      } else {
        //send register credentials
        res = await BaseApi().userApi.signInUser(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim());
      }

      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Column(
        children: [
          AppTopBar(
            loading: loading,
            pageTitle: widget.isLoginState ? "Sign in" : "Register",
            leftButtonIcon: Icons.arrow_back_ios_new_rounded,
            onLeftButtonTap: () {
              Get.back();
            },
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: Column(
              children: [getAuthForm()],
            ),
          )
        ],
      ),
    ));
  }

  Widget getAuthForm() {
    return Form(
        key: _formKey,
        child: Column(
          children: [
            !widget.isLoginState
                ? AppInputField(
                    hint: "Name",
                    textEditingController: _nameController,
                    textInputType: TextInputType.text,
                    goNextOnComplete: true,
                    // maxLength: 100,
                    prefixIcon: Icon(
                      Icons.person_outline,
                      color: AppColors().grey800,
                    ),
                    validator: (value) {
                      return value != null && value.length > 5
                          ? null
                          : 'Too short';
                    },
                  ).getField(context)
                : const SizedBox(height: 0),
            const SizedBox(
              height: 24,
            ),
            AppInputField(
              hint: 'Email',
              textEditingController: _emailController,
              textInputType: TextInputType.emailAddress,
              goNextOnComplete: true,
              // maxLength: 200,
              prefixIcon: Icon(
                Icons.email_outlined,
                color: AppColors().grey800,
              ),
              validator: (value) {
                return EmailValidator.validate(value ?? "")
                    ? null
                    : 'Invalid email';
              },
            ).getField(context),
            const SizedBox(
              height: 24,
            ),
            AppInputField(
              hint: 'Password',
              textEditingController: _passwordController,
              textInputType: TextInputType.visiblePassword,
              goNextOnComplete: true,
              // maxLength: 200,
              obscureText: hidePassword,
              prefixIcon: Icon(
                Icons.password,
                color: AppColors().grey800,
              ),
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    hidePassword = !hidePassword;
                  });
                },
                icon: Icon(
                  hidePassword
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: AppColors().grey800,
                ),
              ),
              validator: (value) =>
                  ((value?.trim().length ?? 0) >= 8) ? null : 'Too short',
            ).getField(context),
            const SizedBox(
              height: 24,
            ),
            !widget.isLoginState
                ? AppInputField(
                    hint: 'Confirm password',
                    textEditingController: _confirmPasswordController,
                    textInputType: TextInputType.visiblePassword,
                    goNextOnComplete: false,
                    // maxLength: 200,
                    obscureText: hideConfirmPassword,
                    prefixIcon: Icon(
                      Icons.password,
                      color: AppColors().grey800,
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          hideConfirmPassword = !hideConfirmPassword;
                        });
                      },
                      icon: Icon(
                        hideConfirmPassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: AppColors().grey800,
                      ),
                    ),
                    validator: (value) {
                      String pass1 = _passwordController.text;
                      String pass2 = _confirmPasswordController.text;
                      if (pass1 != '' && pass1 != pass2) {
                        return 'Password not matched';
                      }
                      return null;
                    },
                  ).getField(context)
                : Container(),
            const SizedBox(
              height: 24,
            ),
            AppButton(context: context).getTextButton(
                title: widget.isLoginState ? 'Login' : 'Register',
                onPressed: () {
                  submitForm();
                })
          ],
        ));
  }
}
