import 'package:flutter/material.dart';

import 'appColors.dart';

class FlowNavigationBar extends StatefulWidget {
  List<IconData> icons = [];
  Color? circleColor, iconColor, activeIconColor;
  double? height, iconSize;
  int? initialIndex;
  int? length;
  final Function(int position) onIndexChangedListener;

  FlowNavigationBar(
      {required this.icons,
      this.circleColor,
      this.iconColor,
      this.activeIconColor,
      this.height = 56,
      this.iconSize = 24,
      this.initialIndex = 0,
      required this.onIndexChangedListener}) {
    iconColor ??= AppColors().themeColor;
    circleColor ??= AppColors().themeColor;
    activeIconColor ??= AppColors().white;
  }

  @override
  _FlowNavigationBarState createState() => _FlowNavigationBarState();
}

class _FlowNavigationBarState extends State<FlowNavigationBar> {
  @override
  Widget build(BuildContext context) {
    int currentIndex = widget.initialIndex ?? 0;
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: widget.height,
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedPositioned(
            left: MediaQuery.of(context).size.width *
                ((currentIndex) / widget.icons.length),
            duration: Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            child: Container(
              width:
                  MediaQuery.of(context).size.width * (1 / widget.icons.length),
              height: widget.height,
              child: Center(
                child: Container(
                  height: 44,
                  width: 44,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(22),
                      color: widget.circleColor),
                ),
              ),
            ),
          ),
          Row(
            children: widget.icons
                .map((e) => SizedBox(
                      width: MediaQuery.of(context).size.width *
                          (1 / widget.icons.length),
                      height: widget.height,
                      child: Center(
                        child: IconButton(
                          onPressed: () {
                            setState(() {
                              currentIndex = widget.icons.indexOf(e);
                              widget.onIndexChangedListener(currentIndex);
                            });
                          },
                          icon: Icon(
                            e,
                          ),
                          iconSize: widget.iconSize,
                          color: currentIndex == widget.icons.indexOf(e)
                              ? widget.activeIconColor
                              : widget.iconColor,
                        ),
                      ),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}
