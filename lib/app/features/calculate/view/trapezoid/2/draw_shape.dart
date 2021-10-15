import 'dart:math';

import 'package:calc_quadrilateral/app/config/theme/app_color.dart';
import 'package:calc_quadrilateral/app/features/calculate/controllers/trapezoid_c.dart';
import 'package:calc_quadrilateral/app/utils/app_convert.dart';
import 'package:calc_quadrilateral/app/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
  late var mainContext;
late var c = TrapezoidController.to;

class DrawShape extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    mainContext = context;
    return SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: CustomPaint(
          painter: ShapePainter(),
        ));
  }
}

void drawTrapezoid({
  required Canvas canvas,
  required Size size,
  required Path path,
  required Color color,
}) {
  var paint = Paint()
    ..strokeWidth = 3
    ..color = color
    ..style = PaintingStyle.stroke;

  canvas.drawPath(path, paint);
}

class ShapePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path pathNotScale = getPathNotScaleTrapezoid(size);

    // drawTrapezoid(
    //     canvas: canvas,
    //     color: Colors.amber,
    //     path: getPathNotScaleTrapezoid(size),
    //     size: size);
    Rect b = pathNotScale.getBounds();



    var pathWidth = b.width;
    var pathHeight = b.height;
    var screenWidth = size.width;
    var screenHeight = size.height;
    var xScale = screenWidth / pathWidth;
    var yScale = screenHeight / pathHeight;
    drawTrapezoid(
        canvas: canvas,
        color: AppColors.contentRevers(mainContext),
        path: getPathScaleTrapezoid(size, xScale, yScale),
        size: size);

    // var pathMain = Path();
    // pathMain.moveTo(0, size.height);

    // x = c.aSideD * xScale;
    // y = size.height;
    // pathMain.lineTo(x, y);

    // x = (c.aSideD - (c.bSideD * cos(AppConvert.toRadian(c.bAngleD))));
    // y = size.height - c.hHeightD * yScale;
    // pathMain.lineTo(x, y);

    // x = x - c.cSideD;
    // y = size.height - c.hHeightD;
    // pathMain.lineTo(x, y);

    // pathMain.close();

    // // getPath(size);
    // canvas.drawPath(pathNotScale, paint);
    // canvas.drawRect(b,paint);
  }

  Path getPathNotScaleTrapezoid(Size size) {
    double x;
    double y;
    var path = Path();
    path.moveTo(0, size.height);

    x = c.aSideD;
    y = size.height;
    path.lineTo(x, y);

    x = c.aSideD - (c.bSideD * cos(AppConvert.toRadian(c.bAngleD)));
    y = size.height - c.hHeightD;
    path.lineTo(x, y);

    x = (x - c.cSideD);
    y = (size.height - c.hHeightD);
    path.lineTo(x, y);

    path.close();

    return path;
  }

  Path getPathScaleTrapezoid(Size size, double xScale, double yScale) {
    double x;
    double y;
    var path = Path();
    path.moveTo(0, (size.height));
    var minScale = min(xScale, yScale);
    x = c.aSideD;
    y = size.height;
    path.lineTo(x * minScale, y);

    x = c.aSideD - (c.bSideD * cos(AppConvert.toRadian(c.bAngleD)));
    y = size.height - c.hHeightD * minScale;
    path.lineTo(x * minScale, y);

    x = (x - c.cSideD);
    y = size.height - c.hHeightD * minScale;
    path.lineTo(x * minScale, y);

    path.close();
    return path;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
