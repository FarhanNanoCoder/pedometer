import 'package:flutter/material.dart';

import 'appColors.dart';
import 'appText.dart';

class AppTopBar extends StatelessWidget {
  IconData? leftButtonIcon = Icons.arrow_back_ios_rounded, rightButtonIcon;
  String? pageTitle;
  Function()? onLeftButtonTap;
  Function()? onRightButtonTap;
  Color? iconColor, backgroundColor;
  bool loading = false;
  // ScrollController? scrollController;

  AppTopBar({
    Key? key,
    this.leftButtonIcon,
    this.rightButtonIcon,
    this.pageTitle,
    this.onLeftButtonTap,
    this.onRightButtonTap,
    this.iconColor,
    this.backgroundColor = Colors.transparent,
    this.loading=false,
  }) {
    if (this.iconColor == null) {
      this.iconColor = AppColors().themeDark;
    }
  }

  @override
  Widget build(BuildContext context) {
    // double offset = scrollController?.offset ?? 0;
    // double offsetModified = (offset > 1) ? 1 : offset;

    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            width: MediaQuery.of(context).size.width,
            height: 56,
            color: backgroundColor,
            child: Stack(
              children: [
                leftButtonIcon != null
                    ? Align(
                        alignment: const Alignment(-1, 0),
                        child: Material(
                          color: Colors.transparent,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(44)),
                          clipBehavior: Clip.antiAlias,
                          child: SizedBox(
                            height: 56,
                            width: 56,
                            child: IconButton(
                              onPressed: () {
                                onLeftButtonTap!();
                              },
                              icon: Icon(leftButtonIcon),
                              iconSize: 24,
                              color: iconColor,
                            ),
                          ),
                        ),
                      )
                    : const SizedBox(
                        width: 24,
                        height: 24,
                      ),
                pageTitle != null
                    ? Center(
                        child: AppText(
                                text: pageTitle,
                                size: 16,
                                style: 'medium',
                                color: iconColor)
                            .getText(),
                      )
                    : const SizedBox(
                        width: 24,
                        height: 24,
                      ),
                rightButtonIcon != null
                    ? Align(
                        alignment: const Alignment(1, 0),
                        child: Material(
                          color: Colors.transparent,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(44)),
                          clipBehavior: Clip.antiAlias,
                          child: SizedBox(
                            height: 56,
                            width: 56,
                            child: IconButton(
                              onPressed: () {
                                onRightButtonTap!();
                              },
                              icon: Icon(rightButtonIcon),
                              iconSize: 24,
                              color: iconColor,
                            ),
                          ),
                        ),
                      )
                    : const SizedBox(
                        width: 24,
                        height: 24,
                      ),
              ],
            ),
          ),
          loading? SizedBox(
            width: MediaQuery.of(context).size.width,
            child: LinearProgressIndicator(
              minHeight: 2,
              backgroundColor: Colors.transparent,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors().themeColor),
            ),
          ):const SizedBox(
            height: 2,
          )
        ],
      ),
    );
  }
}
