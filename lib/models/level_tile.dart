import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toast/toast.dart';
import 'package:trivia/colors/app_color.dart';
import 'package:trivia/main.dart';
import 'package:trivia/providers/stage.dart';
import 'package:provider/provider.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class LevelTile extends StatefulWidget {
  const LevelTile({
    super.key,
    required this.level,
  });

  final int level;

  @override
  State<LevelTile> createState() => _LevelTileState();
}

class _LevelTileState extends State<LevelTile> {
  @override
  Widget build(BuildContext context) {
    return Consumer<StageProvider>(builder: (_, stageProvider, child) {
      return widget.level == stageProvider.completedStage + 1
          ? ZoomTapAnimation(
              onTap: () {
                Navigator.pushReplacementNamed(context, "/game");
              },
              child: Container(
                padding: EdgeInsets.all(20.sp),
                margin: EdgeInsets.only(bottom: 20.sp),
                decoration: BoxDecoration(
                  color: stageProvider.completedStage >= widget.level
                      ? AppColor.orange
                      : widget.level == stageProvider.completedStage + 1
                          ? AppColor.orange.withOpacity(.3)
                          : Colors.transparent,
                  border: Border.all(
                    width: 2.sp,
                    color: AppColor.lightRed,
                  ),
                ),
                child: Text(
                  (widget.level).toString(),
                  style: TextStyle(
                    color: AppColor.white,
                    fontSize: 16.sp,
                  ),
                  textAlign: TextAlign.center,
                ),
              )
                  .animate(
                    onPlay: (controller) => controller.repeat(),
                  )
                  .shimmer(
                    delay: 1.5.seconds,
                    duration: 1.seconds,
                  )
                  .animate()
                  .scaleXY(
                    delay: .5.seconds,
                    duration: .2.seconds,
                    begin: 1,
                    end: .8,
                  )
                  .then()
                  .scaleXY(
                    duration: .2.seconds,
                    begin: .8,
                    end: 1.2,
                  )
                  .then()
                  .scaleXY(
                    curve: Curves.bounceIn,
                    duration: .2.seconds,
                    begin: 1.2,
                    end: 1,
                  ),
            )
          : ZoomTapAnimation(
              onTap: () {
                if (stageProvider.completedStage <= 3) {
                  playUnavailable(context);
                  ToastContext().init(context);
                  Toast.show(
                    "Please go to Level ${stageProvider.completedStage + 1}",
                    duration: 2,
                    gravity: 1,
                    textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 20.sp,
                    ),
                  );
                }
              },
              child: Container(
                padding: EdgeInsets.all(20.sp),
                margin: EdgeInsets.only(bottom: 20.sp),
                decoration: BoxDecoration(
                  color: stageProvider.completedStage >= widget.level
                      ? AppColor.orange
                      : widget.level == stageProvider.completedStage + 1
                          ? AppColor.orange.withOpacity(.3)
                          : Colors.transparent,
                  border: Border.all(
                    width: 2.sp,
                    color: AppColor.lightRed,
                  ),
                ),
                child: Text(
                  (widget.level).toString(),
                  style: TextStyle(
                    color: AppColor.white,
                    fontSize: 16.sp,
                  ),
                  textAlign: TextAlign.center,
                ),
              )
                  .animate(
                    onPlay: (controller) => controller.repeat(),
                  )
                  .shimmer(
                    delay: 1.5.seconds,
                    duration: 1.seconds,
                  ),
            );
    });
  }
}
