import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:noteflow/core/constants/app_colors.dart';
import 'package:noteflow/core/constants/app_strings.dart';

class BmiScreen extends StatefulWidget {
  const BmiScreen({super.key});

  @override
  State<BmiScreen> createState() => _BmiScreenState();
}

class _BmiScreenState extends State<BmiScreen> {
  var wtController = TextEditingController();
  var ftController = TextEditingController();
  var inController = TextEditingController();
  var result = '';
  var bgColor = AppColors.whiteColor;

  @override

  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: CustomAppBarWidget(screenTitle: AppStrings.yourBMICalculator, isDrawerOpen: false, onMenuTap: () {}, onBackTap: () {}),
      //backgroundColor: AppColors.babyBlue,
      body: Container(
        color: bgColor,
        child: Center(
          child: SizedBox(
            width: 300,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  AppStrings.yourBMICalculator,
                  style: TextStyle(
                    color: AppColors.blackColor,
                    fontWeight: FontWeight.w800,
                    fontSize: 25,
                    decoration: TextDecoration.underline,
                  ),
                ),
                SizedBox(height: 10),

                ///Weight Controller
                TextFormField(
                  controller: wtController,
                  validator: (value) => value!.isEmpty ? 'Enter Weight' : null,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                    prefixIconColor: AppColors.blackColor,
                    fillColor: AppColors.blackColor,
                    focusColor: AppColors.blackColor,
                    border: OutlineInputBorder(),
                    label: Text(AppStrings.enterYourWeight),
                    prefixIcon: Icon(Icons.line_weight),
                  ),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 10),

                ///Height ft Controller
                TextFormField(
                  controller: ftController,
                  validator:
                      (value) => value!.isEmpty ? 'Enter Height in Feet' : null,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                    prefixIconColor: AppColors.blackColor,
                    fillColor: AppColors.blackColor,
                    focusColor: AppColors.blackColor,
                    border: OutlineInputBorder(),
                    label: Text(AppStrings.enterYourHeightFt),
                    prefixIcon: Icon(Icons.height),
                  ),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 10),

                ///Height in Controller
                TextFormField(
                  controller: inController,
                  validator:
                      (value) =>
                          value!.isEmpty ? 'Enter Height in Inches' : null,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                    prefixIconColor: AppColors.blackColor,
                    fillColor: AppColors.blackColor,
                    focusColor: AppColors.blackColor,
                    border: OutlineInputBorder(borderSide: BorderSide(color: AppColors.blackColor)),
                    label: Text(AppStrings.enterYourHeightIn),
                    prefixIcon: Icon(Icons.height),
                  ),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 20),

                /// Calculate BMI
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.blackColor,
                    side: const BorderSide(color: AppColors.blackColor)
                  ),
                  onPressed: () {
                    var wt = wtController.text.toString();
                    var ft = ftController.text.toString();
                    var inch = inController.text.toString();
                    if (wt != '' && ft != '' && inch != '') {
                      var iwt = int.parse(wt);
                      var ift = int.parse(ft);
                      var iInch = int.parse(inch);

                      var tInch = (ift * 12) + iInch;
                      var tCm = tInch * 2.54;
                      var tM = tCm / 100;
                      var bmi = iwt / (tM * tM);

                      var msg = '';
                      if (bmi > 25) {
                        bgColor = Colors.orange.shade200;
                        msg = AppStrings.youAreOverweight;
                      } else if (bmi < 18) {
                        bgColor = Colors.red.shade200;
                        msg = AppStrings.youAreUnderweight;
                      } else {
                        bgColor = Colors.green.shade200;
                        msg = AppStrings.youAreHealthy;
                      }

                      setState(
                        () =>
                            result =
                                '$msg \n Your BMI is: ${bmi.toStringAsFixed(2)}',
                      );
                      print('Your BMI is: ${bmi.toStringAsFixed(2)}');
                    }
                  },
                  child: Text(
                    AppStrings.calculateBMI,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: AppColors.blackColor,
                    ),
                  ),
                ),

                SizedBox(height: 10),
                Text(
                  result,
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.w800),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
