import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:trivia/colors/app_color.dart';
import 'package:trivia/models/pop_scope.dart';

showLoadingDialog(BuildContext context) {
  showDialog(
      context: context,
      builder: (context) {
        return Theme(
          data: Theme.of(context).copyWith(
            dialogBackgroundColor: Colors.transparent,
          ),
          child: WillPopScope(
            onWillPop: () => onWillPop(context, true),
            child: Dialog(
                elevation: 0,
                shadowColor: Colors.transparent,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                insetAnimationCurve: Curves.bounceInOut,
                insetAnimationDuration: const Duration(milliseconds: 300),
                child: SpinKitThreeBounce(
                  color: AppColor.wrong,
                  size: 50.w,
                )),
          ),
        );
      });
}
