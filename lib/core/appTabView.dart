import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'appColors.dart';
import 'appText.dart';

class AppTabView extends StatefulWidget {
  List<IconData> icons = [];
  List<Widget> views = [];
  AppTabView({
    super.key,
    required this.icons,
    required this.views,
  });

  @override
  State<AppTabView> createState() => _AppTabViewState();
}

class _AppTabViewState extends State<AppTabView> {
  int currentPosition = 0;
  Widget currentTab() {
    if (currentPosition < widget.views.length) {
      return widget.views[currentPosition];
    }else{
      return AppText(text: "Out of bound").getText();
    }
  }

  double  getXAlignment(){
    if(widget.icons.isEmpty|| widget.icons.length==1){
      return 0;
    }else if(widget.icons.length==2){
      List<double> xParams = [-1.0,1.0];
      return xParams[currentPosition];
    }else if(widget.icons.length==3){
      List<double> xParams = [-1.0,0.0,1.0];
      return xParams[currentPosition];
    }else if(widget.icons.length==4){
      List<double> xParams = [-1.0,-0.5,0.5,1.0];
      return xParams[currentPosition];
    }else if(widget.icons.length==5){
      List<double> xParams = [-1.0,-0.5,0,0.5,1.0];
      return xParams[currentPosition];
    }else{
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          // margin: const EdgeInsets.symmetric(horizontal: 22),
          width: MediaQuery.of(context).size.width,
          height: 56,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: Colors.transparent,
            border: Border.all(width: 0,color: AppColors().grey200),
          ),
          child: Stack(
            children: [
              AnimatedAlign(
                alignment: Alignment(getXAlignment(),1),
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                child: Container(
                  width: (MediaQuery.of(context).size.width-48)*(1/widget.icons.length),
                  height: 2,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(1),
                      color: AppColors().themeColor,
                  ),
                ),
              ),
              Row(
                children: widget.icons.map((e,) => SizedBox(
                  height: 56,
                  width: (MediaQuery.of(context).size.width-48)*(1/widget.icons.length),
                  child: IconButton(
                    onPressed: (){
                      setState(() {
                        currentPosition = widget.icons.indexOf(e);
                      });
                    },
                    icon: Icon(e),
                    iconSize: 24,
                    color:currentPosition == widget.icons.indexOf(e)? AppColors().themeColor:AppColors().themeMatteBlue,
                  ),
                )).toList(),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16,),
        Expanded(child: currentTab()),
      ],
    );
  }
}
