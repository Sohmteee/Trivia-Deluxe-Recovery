import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trivia/colors/app_color.dart';
import 'package:trivia/models/game_background.dart';

class CreateProfileScreen extends StatefulWidget {
  const CreateProfileScreen({super.key});

  @override
  State<CreateProfileScreen> createState() => _CreateProfileScreenState();
}

class _CreateProfileScreenState extends State<CreateProfileScreen> {
  final pageController = PageController();
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GameBackground(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 40.h),
        child: Column(
          children: [
            Center(
              child: Text(
                "Create Profile",
                style: TextStyle(
                  color: AppColor.yellow,
                  fontSize: 50.sp,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              child: PageView(
                controller: pageController,
                onPageChanged: (value) {},
                children: [
                  Column(
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.person,
                            color: AppColor.orange,
                          ),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: TextField(
                              controller: controller,
                              style: TextStyle(
                                color: AppColor.yellow,
                                fontSize: 18.sp,
                              ),
                              onChanged: (value) {
                                setState(() {});
                              },
                              // onSubmitted: widget.onSubmitted,
                              textCapitalization: TextCapitalization.words,
                              // : TextCapitalization.none,
                              textInputAction: TextInputAction.done,
                              decoration: InputDecoration(
                                labelText: "Enter username",
                                labelStyle: TextStyle(
                                  color: AppColor.orange,
                                  fontSize: 20.sp,
                                ),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.person,
                            color: AppColor.orange,
                          ),
                          SizedBox(width: 10.w),
                          DropdownButton(
                            hint: Text(
                              "Choose your gender",
                              style: TextStyle(
                                color: AppColor.orange,
                                fontSize: 20.sp,
                              ),
                            ),
                            dropdownColor: AppColor.orange,
                            items: [
                              DropdownMenuItem(
                                value: "male",
                                child: Text(
                                  "Male",
                                  style: TextStyle(
                                    color: AppColor.white,
                                    fontSize: 18.sp,
                                  ),
                                ),
                              ),
                              DropdownMenuItem(
                                value: "female",
                                child: Text(
                                  "Female",
                                  style: TextStyle(
                                    color: AppColor.white,
                                    fontSize: 18.sp,
                                  ),
                                ),
                              ),
                            ],
                            onChanged: (value) {},
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
