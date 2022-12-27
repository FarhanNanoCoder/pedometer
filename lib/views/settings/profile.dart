import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/userController.dart';
import '../../core/appButtons.dart';
import '../../core/appColors.dart';
import '../../core/appInputField.dart';
import '../../core/appText.dart';
import '../../core/appTopBar.dart';
import '../../models/userModel.dart';

class Profile extends StatefulWidget {
  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final _formKey = GlobalKey<FormState>();
  String dob = "";
  final UserController userController = Get.find(tag: 'uc-0');
  List<String> genderList = ["Male", "Female", "Other"];
  String selectedGender = "";
  final _nameController = TextEditingController(),
      _phoneController = TextEditingController(),
      _weightController = TextEditingController(),
      _heightController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _nameController.text = userController.authUser.value?.name ?? "";
    _phoneController.text = userController.authUser.value?.phone ?? "";
    _heightController.text =
        userController.authUser.value?.height.toString() ?? "0";
    _weightController.text =
        userController.authUser.value?.weight.toString() ?? "0";
    setState(() {
      dob = userController.authUser.value?.dob ?? "";
      selectedGender = userController.authUser.value?.gender ?? "";
    });
    userController.getAuthUser();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _weightController.dispose();
    _heightController.dispose();

    super.dispose();
  }

  void onSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();

      userController.authUser.value?.name = _nameController.text.trim();
      userController.authUser.value?.phone = _phoneController.text.trim();
      userController.authUser.value?.dob = dob;
      userController.authUser.value?.gender = selectedGender;
      userController.authUser.value?.weight =
          double.parse(_weightController.text.trim());
      userController.authUser.value?.height =
          double.parse(_heightController.text.trim());

      if (userController.authUser.value != null) {
        userController.setUser(userController.authUser.value!);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Column(
        children: [
          Obx(() {
            return AppTopBar(
              pageTitle: "Profile",
              leftButtonIcon: Icons.arrow_back_ios_new_rounded,
              loading: userController.userLoader.value,
              onLeftButtonTap: () {
                Get.back();
              },
            );
          }),
          Expanded(
              child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: getAuthForm(),
          ))
        ],
      ),
    ));
  }

  Widget getAuthForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: 56,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: AppColors().grey100),
            child: AppText(
                    text:
                        "Registered email: ${userController.authUser.value?.email ?? ""}",
                    color: AppColors().grey600)
                .getText(),
          ),
          const SizedBox(
            height: 24,
          ),
          AppInputField(
              label: '*Name',
              textEditingController: _nameController,
              goNextOnComplete: true,
              maxLength: 100,
              validator: (value) {
                if (value != null) {
                  if (value.length < 3) {
                    return "Too small";
                  } else if (value.length > 100) {
                    return "Too large";
                  }
                }
                return null;
              }).getField(context),
          const SizedBox(
            height: 24,
          ),
        
          GestureDetector(
            onTap: () async {
              // showAppSnackbar(title: "", message: "hi");
              DateTime? date = await showDatePicker(
                context: context,
                initialDate: DateTime.parse(dob),
                firstDate: DateTime(1960, 1, 1, 1),
                lastDate: DateTime.now(),
              );

              if (date != null) {
                setState(() {
                  dob = date.toString().substring(0, 10);
                });
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
              decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border.all(width: 1, color: AppColors().grey300),
                  borderRadius: BorderRadius.circular(8)),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        color: AppColors().grey800,
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      AppText(
                              text: dob != "" ? dob : "Select date",
                              color: dob != ""
                                  ? AppColors().grey800
                                  : AppColors().grey600)
                          .getText(),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 24,
          ),
          AppInputField(
            label: 'Weight (kg)',
            textEditingController: _weightController,
            goNextOnComplete: true,
            textInputType: TextInputType.number,
          ).getField(context),
          const SizedBox(
            height: 36,
          ),
          AppInputField(
            label: 'Height (ft)',
            textEditingController: _heightController,
            goNextOnComplete: true,
            textInputType: TextInputType.number,
          ).getField(context),
          const SizedBox(
            height: 36,
          ),
          DropdownButtonFormField(
              value: selectedGender==""?null:selectedGender,
              decoration: AppInputField.getDefaultInputDecoration(
                hint: "Select gender",
                prefixIcon: Icon(
                  Icons.man_outlined,
                  color: AppColors().grey800,
                ),
              ),
              items: genderList.map((val) {
                return DropdownMenuItem(
                    value: val, child: AppText(text: val).getText());
              }).toList(),
              onChanged: (val) {
                setState(() {
                  selectedGender = val ?? "";
                });
              }),
          const SizedBox(
            height: 36,
          ),
          AppButton(context: context)
              .getTextButton(title: "Save", onPressed: onSubmit)
        ],
      ),
    );
  }
}
