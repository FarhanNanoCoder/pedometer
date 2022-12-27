import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pedometer/core/appText.dart';
import 'package:pedometer/models/userFitModel.dart';
import 'package:pedometer/services/api/baseApi.dart';

import '../../core/appColors.dart';

class History extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(text: "| Hisotry of past 7 days", size: 20, style: 'bold')
                .getText(),
            const SizedBox(
              height: 16,
            ),
            Expanded(
              child: StreamBuilder(
                  stream: BaseApi().userFitApi.getUserFitHistoryAsStream(),
                  builder: ((context, snapshot) {
                    if (!snapshot.hasData ||
                        snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors().themeColor,
                        backgroundColor: AppColors().grey300,
                      );
                    } else {
                      QuerySnapshot querySnapshot = snapshot.data!;
                      int totalSteps = 0;
                      double totalCaloriesBurnt = 0.0;
                      double totalDistanceWalked = 0.0;

                      querySnapshot.docs.forEach((element) {
                        totalSteps +=
                            UserFitModel.fromDocumentSnapshot(element).steps;
                        totalCaloriesBurnt +=
                            UserFitModel.fromDocumentSnapshot(element)
                                .caloriesBurnt;
                        totalDistanceWalked +=
                            UserFitModel.fromDocumentSnapshot(element)
                                .distanceWalked;
                      });
                      return SingleChildScrollView(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 16),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                  color: AppColors().grey200,
                                  width: 1,
                                  style: BorderStyle.solid)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: querySnapshot.size,
                                  itemBuilder: ((context, index) {
                                    UserFitModel userFitModel =
                                        UserFitModel.fromDocumentSnapshot(
                                            querySnapshot.docs[index]);
                                    return Container(
                                      child: Row(
                                        children: [
                                          AppText(
                                                  text:
                                                      "${userFitModel.id ?? ""}:")
                                              .getText(),
                                          const SizedBox(
                                            width: 4,
                                          ),
                                          AppText(
                                                  text: userFitModel.steps
                                                      .toString(),
                                                  style: 'semibold')
                                              .getText(),
                                          AppText(
                                            text: " steps | ",
                                          ).getText(),
                                          AppText(
                                                  text: userFitModel
                                                              .caloriesBurnt
                                                              .toString()
                                                              .length >
                                                          4
                                                      ? userFitModel
                                                          .caloriesBurnt
                                                          .toString()
                                                          .substring(0, 4)
                                                      : userFitModel
                                                          .caloriesBurnt
                                                          .toString(),
                                                  style: 'semibold')
                                              .getText(),
                                          AppText(
                                            text: " cal | ",
                                          ).getText(),
                                          AppText(
                                                  text: userFitModel
                                                              .distanceWalked
                                                              .toString()
                                                              .length >
                                                          5
                                                      ? userFitModel
                                                          .distanceWalked
                                                          .toString()
                                                          .substring(0, 5)
                                                      : userFitModel
                                                          .distanceWalked
                                                          .toString(),
                                                  style: 'semibold')
                                              .getText(),
                                          AppText(
                                            text: " km",
                                          ).getText(),
                                        ],
                                      ),
                                    );
                                  })),
                              const SizedBox(
                                height: 16,
                              ),
                              Container(
                                height: 1,
                                width: MediaQuery.of(context).size.width,
                                color: AppColors().grey300,
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              Row(
                                children: [
                                  AppText(text: "Total: ").getText(),
                                  AppText(
                                          text: totalSteps.toString(),
                                          style: 'semibold')
                                      .getText(),
                                  AppText(text: " steps | ").getText(),
                                  AppText(text: "Distance: ").getText(),
                                  AppText(
                                          text:
                                              "${totalDistanceWalked.toString().length > 5 ? totalDistanceWalked.toString().substring(0, 5) : totalDistanceWalked.toString()} km",
                                          style: 'semibold')
                                      .getText(),
                                ],
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 16),
                                decoration: BoxDecoration(
                                    color: AppColors().grey100,
                                    border: Border.all(
                                        width: 1,
                                        color: AppColors().grey300,
                                        style: BorderStyle.solid),
                                    borderRadius: BorderRadius.circular(4)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    AppText(
                                            text: "Total calories burnt",
                                            color: AppColors().themeColor,
                                            size: 14)
                                        .getText(),
                                    AppText(
                                      text:
                                          totalCaloriesBurnt.toString().length >
                                                  10
                                              ? totalCaloriesBurnt
                                                  .toString()
                                                  .substring(0, 10)
                                              : totalCaloriesBurnt.toString(),
                                      style: 'bold',
                                      size: 24,
                                      color: AppColors().themeColor,
                                    ).getText(),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 24,
                              ),
                              AppText(
                                      text: "| This month",
                                      size: 20,
                                      style: 'bold')
                                  .getText(),
                              const SizedBox(
                                height: 16,
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 16),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    color: AppColors().themeColor),
                                child: StreamBuilder(
                                    stream: BaseApi()
                                        .userFitApi
                                        .getUserFitHistoryAsStream(count: 30),
                                    builder: ((context, monthSnapshot) {
                                      if (!monthSnapshot.hasData ||
                                          monthSnapshot.connectionState ==
                                              ConnectionState.waiting) {
                                        return CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: AppColors().themeColor,
                                          backgroundColor: AppColors().grey300,
                                        );
                                      } else {
                                        int monthSteps = 0;
                                        double monthCaloriesBurnt = 0.0;
                                        double monthDistanceWalked = 0.0;
                                        monthSnapshot.data!.docs
                                            .forEach((element) {
                                          monthSteps +=
                                              UserFitModel.fromDocumentSnapshot(
                                                      element)
                                                  .steps;
                                          monthCaloriesBurnt +=
                                              UserFitModel.fromDocumentSnapshot(
                                                      element)
                                                  .caloriesBurnt;
                                          monthDistanceWalked +=
                                              UserFitModel.fromDocumentSnapshot(
                                                      element)
                                                  .distanceWalked;
                                        });
                                        return Column(
                                          children: [
                                            AppText(
                                                    text: monthSteps.toString(),
                                                    color: AppColors().white,
                                                    size: 36,
                                                    style: 'bold')
                                                .getText(),
                                            const SizedBox(
                                              height: 2,
                                            ),
                                            const SizedBox(
                                              height: 4,
                                            ),
                                            AppText(
                                                    size: 12,
                                                    text:
                                                        "steps have been counted",
                                                    color: AppColors().white)
                                                .getText(),
                                            const SizedBox(
                                              height: 8,
                                            ),
                                            const SizedBox(
                                              height: 16,
                                            ),
                                            Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              height: 1,
                                              color: AppColors().white,
                                            ),
                                            const SizedBox(
                                              height: 8,
                                            ),
                                            const SizedBox(
                                              height: 16,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                AppText(
                                                        size: 14,
                                                        text: "Distance (km): ",
                                                        color:
                                                            AppColors().white)
                                                    .getText(),
                                                AppText(
                                                        size: 14,
                                                        text: monthDistanceWalked
                                                                    .toString()
                                                                    .length >
                                                                8
                                                            ? monthDistanceWalked
                                                                .toString()
                                                                .substring(0, 8)
                                                            : monthDistanceWalked
                                                                .toString(),
                                                        style: 'semibold',
                                                        color:
                                                            AppColors().white)
                                                    .getText()
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                AppText(
                                                        size: 14,
                                                        text:
                                                            "Calories burnt (kcal): ",
                                                        color:
                                                            AppColors().white)
                                                    .getText(),
                                                AppText(
                                                        size: 14,
                                                        text:
                                                            "${monthCaloriesBurnt.toString().length > 8 ? (monthCaloriesBurnt * .001).toString().substring(0, 8) : (monthCaloriesBurnt*.001).toString()}",
                                                        style: 'semibold',
                                                        color:
                                                            AppColors().white)
                                                    .getText()
                                              ],
                                            )
                                          ],
                                        );
                                      }
                                    })),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                  })),
            )
          ],
        ),
      ),
    ));
  }
}
