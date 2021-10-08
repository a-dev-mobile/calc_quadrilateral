import 'dart:math';

import 'package:calc_quadrilateral/app/config/theme/app_color.dart';
import 'package:calc_quadrilateral/app/constants/const_assets.dart';
import 'package:calc_quadrilateral/app/constants/const_number.dart';
import 'package:calc_quadrilateral/app/features/calculate/view/trapezoid/3/a_angle_w.dart';
import 'package:calc_quadrilateral/app/features/calculate/view/trapezoid/3/a_side_w.dart';
import 'package:calc_quadrilateral/app/features/calculate/view/trapezoid/3/b_angle_w.dart';
import 'package:calc_quadrilateral/app/features/calculate/view/trapezoid/3/b_side_w.dart';
import 'package:calc_quadrilateral/app/features/calculate/view/trapezoid/3/c_side_w.dart';
import 'package:calc_quadrilateral/app/features/calculate/view/trapezoid/3/d_side_w.dart';
import 'package:calc_quadrilateral/app/features/calculate/view/trapezoid/3/h_height_w.dart';

import 'package:flutter/material.dart';

String pathAssestInput = ConstAssetsImageRaster.trapezoidInput;

class TrapezoidImageInputWidget extends StatelessWidget {
  const TrapezoidImageInputWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height * ConstNumber.ratioFigureImage,
      width: size.width,
      child: LayoutBuilder(builder: (context, constraints) {
        var minSize = min(constraints.maxWidth, constraints.maxHeight);

        return Stack(
          alignment: Alignment.center,
          children: [
            SizedBox.expand(
              child: Image(
                fit: BoxFit.contain,
                color: AppColors.text(context),
                image: AssetImage(pathAssestInput),
              ),
            ),
            //all widget text in image

            AsideWidget(
              angle: 0,
              posX: 0,
              posY: 45.7143,
              minSizeImage: minSize,
            ),
            BsideWidget(
              angle: 75.964,
              posX: 36.626,
              posY: -1.563,
              minSizeImage: minSize,
            ),
            CsideWidget(
              angle: 0,
              posX: -0.495,
              posY: -45.525,
              minSizeImage: minSize,
            ),
            DsideWidget(
              angle: -75.964,
              posX: -36.626,
              posY: -1.563,
              minSizeImage: minSize,
            ),
            HheightWidget(
              angle: -90,
              posX: 0,
              posY: 0,
              minSizeImage: minSize,
            ),
            AangleWidget(
              angle: -42 + 90,
              posX: -22.266,
              posY: 26.2,
              minSizeImage: minSize,
            ),
            BangleWidget(
              angle: -52.032,
              posX: 22.266,
              posY: 26.2,
              minSizeImage: minSize,
            ),
          ],
        );
      }),
    );
  }
}
