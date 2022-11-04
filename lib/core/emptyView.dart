import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'appText.dart';

class EmptyView extends StatelessWidget {
  const EmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 44,
        ),
        SvgPicture.asset(
          "assets/images/empty.svg",
          width: MediaQuery.of(context).size.width * 0.7,
        ),
        const SizedBox(
          height: 44,
        ),
        AppText(text: "No data found").getText(),
      ],
    );
  }
}
