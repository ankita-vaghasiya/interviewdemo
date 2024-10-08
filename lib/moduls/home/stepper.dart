import 'package:ellusho/modules/dashboad/counsellor/controller/stepper_controller.dart';
import 'package:ellusho/modules/dashboad/counsellor/presentation/step1.dart';
import 'package:ellusho/modules/dashboad/counsellor/presentation/step2.dart';
import 'package:ellusho/modules/dashboad/counsellor/presentation/step3.dart';
import 'package:ellusho/modules/dashboad/counsellor/presentation/step4.dart';
import 'package:ellusho/modules/dashboad/counsellor/widget/ripple_animation.dart';
import 'package:ellusho/utils/app_colors.dart';
import 'package:ellusho/utils/assets.dart';
import 'package:ellusho/utils/navigation_utils/navigation.dart';
import 'package:ellusho/utils/navigation_utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../widget/round_buttton.dart';

// ignore: must_be_immutable
class PetStepperScreen extends StatelessWidget {
  PetStepperScreen({Key? key}) : super(key: key);

  final StepperController stepperController = Get.put(StepperController());

  double per = 0;
  List sliderList = [
    Step1(),
    Step2(),
    Step3(),
    Step4(),
  ];


  RxInt selectedIndex = 0.obs;
  RxInt likeIndex = 0.obs;
  RxString error = " ".obs;
  final PageController pageController = PageController();
  static const _kDuration = Duration(milliseconds: 350);
  static const _kCurve = Curves.ease;
  RxList<FillingModel> iconList = <FillingModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    getData();
  }

  openPage(int page) {
    pageController.animateToPage(
      page,
      duration: _kDuration,
      curve: _kCurve,
    );
    pageController.animateToPage(
      page,
      duration: _kDuration,
      curve: _kCurve,
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: AppColors.backgroundColor,
        systemNavigationBarColor: AppColors.backgroundColor,
      ),
    );
    return Scaffold(
      backgroundColor: AppColors.ff1F2430Color,
      body: WillPopScope(
        onWillPop: () async {
          if (stepperController.selectedIndex.value > 0) {
            return stepperController.openPage(stepperController.selectedIndex.value - 1);
          } else {
            return true;
          }
        },
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                ImagesAsset.background,
              ),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 80.w, top: 6.h),
                child: InkWell(
                  onTap: () {
                    if (stepperController.selectedIndex.value > 0) {
                      stepperController.openPage(stepperController.selectedIndex.value - 1);
                    } else {
                      stepperController.dispose();
                      Navigation.popupUtil(Routes.dashBoard);
                    }
                  },
                  child: CircleAvatar(
                    backgroundColor: AppColors.lightGreyColor,
                    child: Icon(
                      Icons.close,
                      color: AppColors.whiteColor,
                    ),
                  ),
                ),
              ),
              RippleEffect(
                height: 3.h,
                radius: 5,
                color: Colors.red,
              ),
              Expanded(
                child: PageView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: sliderList.length,
                  controller: stepperController.pageController,
                  onPageChanged: (int page) {
                    stepperController.selectedIndex.value = page;
                    stepperController.openPage(page);
                  },
                  itemBuilder: (context, i) {
                    return sliderList[i];
                  },
                ),
              ),
              Obx(
                    () => RoundButton(
                  percent:
                  (stepperController.selectedIndex.value.toDouble() + 1) /
                      4,
                  onTap: () {
                    if (stepperController.selectedIndex.value <= 2) {
                      stepperController.openPage(
                          stepperController.selectedIndex.value + 1);
                    } else {
                      print(
                          "stepperController.selectedIndex.value---->>>${stepperController.selectedIndex.value}");
                    }
                  },
                  icon: Icon(
                    stepperController.selectedIndex.value > 2
                        ? Icons.check
                        : Icons.arrow_forward_sharp,
                    color: AppColors.whiteColor,
                  ),
                ),
              ),
              SizedBox(height: 8.h),
            ],
          ),
        ),
      ),
    );
  }
}
