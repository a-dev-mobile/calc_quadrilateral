import 'package:calc_quadrilateral/app/config/theme/app_color.dart';
import 'package:calc_quadrilateral/app/constants/const_assets.dart';
import 'package:calc_quadrilateral/app/features/calculate/controllers/trapezoid_c.dart';
import 'package:calc_quadrilateral/app/shared_components/detail_info/area_perim.dart';
import 'package:calc_quadrilateral/app/shared_components/image_info_w.dart';
import 'package:calc_quadrilateral/app/shared_components/detail_info/detail_item.dart';
import 'package:calc_quadrilateral/app/shared_components/detail_info/detail_title.dart';
import 'package:calc_quadrilateral/app/translations/translate_helper.dart';
import 'package:calc_quadrilateral/app/utils/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:sticky_headers/sticky_headers.dart';

late var c = TrapezoidController.to;

class TrapezoidDetail extends StatelessWidget {
  const TrapezoidDetail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        return Column(
          children: [
            StickyHeader(
              header: Container(
                color: AppColors.content(context),
                child: Column(
                  children: [
                    const ImageInfoWidget(
                        patchAsset: ConstAssetsImageRaster.trapezoidInfo),
                    TextTitleDetail(text: TranslateHelper.sides_height_angles),
                  ],
                ),
              ),
              content: const TrapezoidSidesAngles(),
            ),
            StickyHeader(
              header: Container(
                color: AppColors.content(context),
                child: Column(
                  children: [
                    const ImageInfoWidget(
                        patchAsset: ConstAssetsImageRaster.trapezoidAP),
                    TextTitleDetail(text: TranslateHelper.area_perim),
                  ],
                ),
              ),
              content: AreaPerimeter(
                area: c.area.value,
                perimeter: c.perimeter.value,
              ),
            ),
            StickyHeader(
                header: Container(
                  color: AppColors.content(context),
                  child: Column(
                    children: [
                      const ImageInfoWidget(
                          patchAsset: ConstAssetsImageRaster.trapezoidS),
                      TextTitleDetail(
                          text: TranslateHelper.mediana_geom_centroid),
                    ],
                  ),
                ),
                content: const MedianaGeometricCentroid()),

          
          ],
        );
      },
    );
  }
}


class MedianaGeometricCentroid extends StatelessWidget {
  const MedianaGeometricCentroid({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
    
        ItemDetail(
          isActive: false,
          leading: 'X',
          subtitle: TranslateHelper.x_cord_S,
          title: c.xSPoint.value,
        ),
        ItemDetail(
          isActive: false,
          leading: 'Y',
          subtitle: TranslateHelper.y_cord_S,
          title: c.ySPoint.value,
        ),
      ],
    );
  }
}

class TrapezoidSidesAngles extends StatelessWidget {
  const TrapezoidSidesAngles({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // AppWidgets.dividerWelcome(),

        ItemDetail(
          isActive: c.isAvailableOneParam(Trapezoid.aSide),
          leading: 'a',
          subtitle: 'a - ${TranslateHelper.base_quadrilateral}',
          title: c.aSide.value,
        ),
        ItemDetail(
          isActive: c.isAvailableOneParam(Trapezoid.bSide),
          leading: 'b',
          subtitle: 'b - ${TranslateHelper.sides_quadrilateral}',
          title: c.bSide.value,
        ),
        ItemDetail(
          isActive: c.isAvailableOneParam(Trapezoid.cSide),
          leading: 'c',
          subtitle: 'c - ${TranslateHelper.sides_quadrilateral}',
          title: c.cSide.value,
        ),
         ItemDetail(
          isActive: c.isAvailableOneParam(Trapezoid.cSide),
          leading: 'd',
          subtitle: 'd - ${TranslateHelper.sides_quadrilateral}',
          title: c.cSide.value,
        ),
        ItemDetail(
          isActive: c.isAvailableOneParam(Trapezoid.hHeight),
          leading: 'h',
          subtitle: TranslateHelper.h_height_quadrilateral,
          title: c.hHeight.value,
        ),
        ItemDetail(
          isActive: c.isAvailableOneParam(Trapezoid.aAngle),
          leading: 'α',
          subtitle: 'α - ${TranslateHelper.internal_angle_degrees}',
          title: c.aAngle.value,
        ),
        ItemDetail(
          isActive: c.isAvailableOneParam(Trapezoid.bAngle),
          leading: 'β',
          subtitle: 'β - ${TranslateHelper.internal_angle_degrees}',
          title: c.bAngle.value,
        ),
      
      ],
    );
  }
}
