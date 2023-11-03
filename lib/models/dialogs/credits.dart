import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:trivia/colors/app_color.dart';
import 'package:trivia/models/dialogs/game.dart';

showCreditsDialog(BuildContext context) {
  showGameDialog(
    context,
    isExitable: true,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "CREDITS",
          style: TextStyle(
            color: Colors.yellow,
            fontSize: 30.sp,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 20.h),
        Consumer<ShowProvider>(
          builder: (context, value, _) {
            final scrollController = ScrollController();

            scrollController.addListener(() {
              if (scrollController.offset <
                  scrollController.position.maxScrollExtent) {
                value.setShow(true);
              } else {
                value.setShow(false);
              }
            });

            return Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.bottomCenter,
              children: [
                SizedBox(
                  height: 200.h,
                  child: SingleChildScrollView(
                    controller: scrollController,
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        Text(
                          "DEVELOPER",
                          style: TextStyle(
                            color: Colors.yellow,
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          "Somtochukwu Ukaegbe",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.sp,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 20.h),
                        Text(
                          "PROJECT MANAGER",
                          style: TextStyle(
                            color: Colors.yellow,
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          "Chux Edoga",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.sp,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 20.h),
                        Text(
                          "GAME TEAM",
                          style: TextStyle(
                            color: Colors.yellow,
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          "Victor Anya (Team Lead)",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.sp,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          "Somtochukwu Obi",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.sp,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 20.h),
                        Text(
                          "CONTENT CREATORS",
                          style: TextStyle(
                            color: Colors.yellow,
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          "Raphael",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.sp,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          "Vincent",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.sp,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          "Emmanuela",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.sp,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          "Izuchukwu",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.sp,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          "Chioma",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.sp,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 20.h),
                        Text(
                          "GRAPHICS / UI DESIGN",
                          style: TextStyle(
                            color: Colors.yellow,
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          "Harrison Illodiuba",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.sp,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 20.h),
                        Text(
                          "ANIMATIONS",
                          style: TextStyle(
                            color: Colors.yellow,
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          "Somtochukwu Ukaegbe",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.sp,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 20.h),
                        Text(
                          "MUSIC / SOUND EFFECTS",
                          style: TextStyle(
                            color: Colors.yellow,
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          "Art of Silence - Uniq",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.sp,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          "Sound Effects from Pixabay",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.sp,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
                value.show
                    ? Positioned(
                        child: RotatedBox(
                          quarterTurns: 3,
                          child: Icon(
                            Icons.arrow_back,
                            color: AppColor.yellow,
                            size: 25.sp,
                          ),
                        ),
                      )
                        .animate(onPlay: (controller) {
                          controller.repeat();
                        })
                        .moveY(
                          delay: 2.seconds,
                          duration: .5.seconds,
                          begin: 0,
                          end: -10.h,
                        )
                        .then()
                        .moveY(
                          curve: Curves.bounceOut,
                          duration: .3.seconds,
                          begin: 0,
                          end: 10.h,
                        )
                    : const SizedBox(),
              ],
            );
          },
        ),
        SizedBox(height: 30.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 30.sp,
              height: 30.sp,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100.r),
                child: Image.asset("assets/images/digital-dreams-logo.png"),
              ),
            ),
            SizedBox(width: 10.w),
            Text(
              "DIGITAL DREAMS LTD",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.sp,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ],
    ),
  );
}

class ShowProvider extends ChangeNotifier {
  bool show = true;

  void setShow(bool value) {
    show = value;
    notifyListeners();
  }
}
