import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pedometer/core/appButtons.dart';
import 'package:pedometer/core/appColors.dart';
import 'package:pedometer/core/appText.dart';
import 'package:pedometer/models/userFitModel.dart';
import 'package:pedometer/services/api/baseApi.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class DashBoard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 24,
            ),
            SvgPicture.asset(
              "assets/images/dashboard.svg",
              width: MediaQuery.of(context).size.width * .5,
            ),
            const SizedBox(
              height: 44,
            ),
            StreamBuilder(
                stream: BaseApi().userFitApi.getUserFitAsStream(
                    id: DateTime.now().toString().substring(0, 10)),
                builder: ((context, snapshot) {
                  if (!snapshot.hasData ||
                      snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors().themeColor,
                      backgroundColor: AppColors().grey300,
                    );
                  } else {
                    if (snapshot.data!.exists) {
                      UserFitModel userFitModel =
                          UserFitModel.fromDocumentSnapshot(snapshot.data!);
                      return Column(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 16),
                            decoration: BoxDecoration(
                                color: AppColors().themeColor,
                                borderRadius: BorderRadius.circular(8)),
                            child: Column(
                              children: [
                                AppText(
                                        text: userFitModel.steps.toString(),
                                        size: 24,
                                        color: AppColors().white,
                                        style: 'bold')
                                    .getText(),
                                const SizedBox(
                                  height: 8,
                                ),
                                AppText(
                                  text: "steps have been completed",
                                  size: 13,
                                  color: AppColors().white,
                                ).getText(),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 24,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                height: 120,
                                width: MediaQuery.of(context).size.width * .4,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 16),
                                decoration: BoxDecoration(
                                    color: AppColors().white,
                                    border: Border.all(
                                        color: AppColors().themeColor,
                                        width: 1,
                                        style: BorderStyle.solid),
                                    borderRadius: BorderRadius.circular(8)),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    AppText(
                                            text: userFitModel.distanceWalked
                                                        .toString()
                                                        .length >
                                                    6
                                                ? userFitModel.distanceWalked
                                                    .toString()
                                                    .substring(0, 6)
                                                : userFitModel.distanceWalked
                                                    .toString(),
                                            size: 24,
                                            color: AppColors().themeColor,
                                            style: 'bold')
                                        .getText(),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    AppText(
                                      text: "km have walked",
                                      size: 12,
                                      color: AppColors().themeDark,
                                    ).getText(),
                                  ],
                                ),
                              ),
                              Container(
                                height: 120,
                                width: MediaQuery.of(context).size.width * .4,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 16),
                                decoration: BoxDecoration(
                                    color: AppColors().white,
                                    border: Border.all(
                                        color: AppColors().themeColor,
                                        width: 1,
                                        style: BorderStyle.solid),
                                    borderRadius: BorderRadius.circular(8)),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    AppText(
                                            text: userFitModel.caloriesBurnt
                                                        .toString()
                                                        .length >
                                                    6
                                                ? userFitModel.caloriesBurnt
                                                    .toString()
                                                    .substring(0, 6)
                                                : userFitModel.caloriesBurnt
                                                    .toString(),
                                            size: 24,
                                            color: AppColors().themeColor,
                                            style: 'bold')
                                        .getText(),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    AppText(
                                      text: "calories have been burnt",
                                      size: 12,
                                      color: AppColors().themeDark,
                                    ).getText(),
                                  ],
                                ),
                              ),
                            ],
                          )
                        ],
                      );
                    } else {
                      BaseApi().userFitApi.setUserFit(
                              userFitModel: UserFitModel(
                            timestamp: Timestamp.fromDate(DateTime.parse(
                                DateTime.now().toString().substring(0, 10))),
                            uid: FirebaseAuth.instance.currentUser?.uid ?? "",
                            id: DateTime.now().toString().substring(0, 10),
                          ));
                      return CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors().themeColor,
                        backgroundColor: AppColors().grey300,
                      );
                    }
                  }
                })),
            const SizedBox(
              height: 56,
            ),
            AppText(
              text: 'Monthly report(Calory burn)',
              style: 'semibold',
              size: 18,
            ).getText(),
            const SizedBox(
              height: 16,
            ),
            StreamBuilder(
                stream:
                    BaseApi().userFitApi.getUserFitHistoryAsStream(count: 30),
                builder: (context, snapshot) {
                  if (!snapshot.hasData ||
                      snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors().themeColor,
                      backgroundColor: AppColors().grey300,
                    );
                  } else {
                    QuerySnapshot querySnapshot = snapshot.data!;
                    List<UserFitModel> userFitList = [];
                    querySnapshot.docs.forEach((element) {
                      userFitList
                          .add(UserFitModel.fromDocumentSnapshot(element));
                    });
                    return Container(
                      child: SfCartesianChart(
                        primaryXAxis: CategoryAxis(),
                        legend: Legend(isVisible: true),
                        tooltipBehavior: TooltipBehavior(enable: true),
                        series: <LineSeries<UserFitModel, String>>[
                          LineSeries<UserFitModel, String>(
                              dataSource: userFitList,
                              xValueMapper: (UserFitModel u, _) => u.id,
                              yValueMapper: (UserFitModel u, _) =>
                                  u.caloriesBurnt,
                              dataLabelSettings:
                                  DataLabelSettings(isVisible: true))
                        ],
                      ),
                    );
                  }
                })
          ],
        ),
      ),
    ));
  }
}
