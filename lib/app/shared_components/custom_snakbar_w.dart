import 'package:calc_quadrilateral/app/config/theme/app_color.dart';
import 'package:calc_quadrilateral/app/config/theme/app_size.dart';
import 'package:calc_quadrilateral/app/constants/const_color.dart';

import 'package:calc_quadrilateral/app/utils/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomMessageView extends StatelessWidget {
  const CustomMessageView({Key? key, required this.message}) : super(key: key);
  final String message;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppUtils.getWidth(context),
      // color: AppColors.contentRevers(context).withOpacity(0.5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 10.w,
              ),
              Icon(
                Icons.info_outline,
                color: ConstColor.warninng,
                size: AppSize.iconSize,
              ),
              SizedBox(
                width: 2.w,
              ),
              Expanded(
                child: Text(
                  message,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  style: TextStyle(
                      fontSize: 15.sp, color: AppColors.text(context)),
                ),
              ),
            ],
          ),
        ],
      ),
      height: AppUtils.getHeight(context) * 0.06,
    );
  }
}
