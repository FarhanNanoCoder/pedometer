import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../core/appButtons.dart';
import '../../core/appInputField.dart';
import '../../core/appTopBar.dart';
import '../../models/problemModel.dart';
import '../../services/api/baseApi.dart';


class FeedbackView extends StatefulWidget {
  const FeedbackView({super.key});
  @override
  State<FeedbackView> createState() => _FeedbackViewState();
}

class _FeedbackViewState extends State<FeedbackView> {
  final _feedbackController = TextEditingController();
  bool loader = false;
  @override
  void dispose() {
    super.dispose();
    _feedbackController.dispose();
  }

  void onSubmit() async {
    if (_feedbackController.text.trim() != "") {
      setState(() {
        loader = true;
      });
      await BaseApi()
          .extraApi
          .createProblem(ProblemModel(
            created_by: FirebaseAuth.instance.currentUser?.uid ?? "",
            problem: _feedbackController.text.trim(),
          ))
          .then((value) {
        setState(() {
          loader = false;
        });
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
            pageTitle: "Report problem",
            leftButtonIcon: Icons.arrow_back_ios_new_rounded,
            loading: loader,
            onLeftButtonTap: () {
              Get.back();
            },
          ),
          Expanded(
              child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: Column(
              children: [
                const SizedBox(
                  height: 24,
                ),
                SvgPicture.asset(
                  "assets/images/feedback.svg",
                  width: MediaQuery.of(context).size.width * 0.7,
                ),
                const SizedBox(
                  height: 56,
                ),
                AppInputField(
                        textEditingController: _feedbackController,
                        maxLines: 10,
                        minLines: 5,
                        hint: "Write problem..",
                        textInputType: TextInputType.multiline)
                    .getField(context),
                const SizedBox(
                  height: 24,
                ),
                AppButton(context: context)
                    .getTextButton(title: "Submit", onPressed: onSubmit)
              ],
            ),
          ))
        ],
      ),
    ));
  }
}
