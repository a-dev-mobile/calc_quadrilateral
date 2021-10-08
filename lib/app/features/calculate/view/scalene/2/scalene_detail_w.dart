import 'package:calc_quadrilateral/app/config/theme/app_color.dart';
import 'package:calc_quadrilateral/app/constants/const_assets.dart';
import 'package:calc_quadrilateral/app/features/calculate/controllers/scalene_c.dart';
import 'package:calc_quadrilateral/app/shared_components/detail_info/area_perim.dart';
import 'package:calc_quadrilateral/app/shared_components/image_info_w.dart';
import 'package:calc_quadrilateral/app/shared_components/detail_info/detail_item.dart';
import 'package:calc_quadrilateral/app/shared_components/detail_info/detail_title.dart';
import 'package:calc_quadrilateral/app/translations/translate_helper.dart';
import 'package:calc_quadrilateral/app/utils/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:sticky_headers/sticky_headers.dart';

late var c = ScalenequadrilateralController.to;

class ScaleneDetail extends StatelessWidget {
  const ScaleneDetail({Key? key}) : super(key: key);

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
                        patchAsset:
                            ConstAssetsImageRaster.scalenequadrilateralInfo),
                    TextTitleDetail(text: TranslateHelper.sides_height_angles),
                  ],
                ),
              ),
              content: const ScaleneSidesAngles(),
            ),
            StickyHeader(
              header: Container(
                color: AppColors.content(context),
                child: Column(
                  children: [
                    const ImageInfoWidget(
                        patchAsset:
                            ConstAssetsImageRaster.scalenequadrilateralAP),
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
                          patchAsset:
                              ConstAssetsImageRaster.scalenequadrilateralS),
                      TextTitleDetail(
                          text: TranslateHelper.mediana_geom_centroid),
                    ],
                  ),
                ),
                content: const MedianaGeometricCentroid()),
            StickyHeader(
                header: Container(
                  color: AppColors.content(context),
                  child: Column(
                    children: [
                      const ImageInfoWidget(
                          patchAsset:
                              ConstAssetsImageRaster.scalenequadrilateralSr),
                      TextTitleDetail(
                          text: TranslateHelper.bisection_inscribed_circle),
                    ],
                  ),
                ),
                content: const BisectionInscribedCircle()),
            StickyHeader(
                header: Container(
                  color: AppColors.content(context),
                  child: Column(
                    children: [
                      const ImageInfoWidget(
                          patchAsset:
                              ConstAssetsImageRaster.scalenequadrilateralSR),
                      TextTitleDetail(
                          text: TranslateHelper.circumscribed_circle),
                    ],
                  ),
                ),
                content: const CircumscribedCircle()),
          ],
        );
      },
    );
  }
}

class CircumscribedCircle extends StatelessWidget {
  const CircumscribedCircle({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ItemDetail(
          isActive: false,
          leading: 'R',
          subtitle: TranslateHelper.radius_diameter_circumscribed_circle,
          title:
              'r ${c.Rcircum.value} / ⌀ ${AppUtilsNumber.getFormatNumber(c.Rd * 2, c.precisionResult)}',
        ),
        ItemDetail(
          isActive: false,
          leading: 'X',
          subtitle: TranslateHelper.x_cord_SR,
          title: c.xR.value,
        ),
        ItemDetail(
          isActive: false,
          leading: 'Y',
          subtitle: TranslateHelper.y_cord_SR,
          title: c.yR.value,
        ),
      ],
    );
  }
}

class BisectionInscribedCircle extends StatelessWidget {
  const BisectionInscribedCircle({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ItemDetail(
          isActive: false,
          leading: 'la',
          subtitle: '${TranslateHelper.bis_of_side} a',
          title: c.lA.value,
        ),
        ItemDetail(
          isActive: false,
          leading: 'lb',
          subtitle: '${TranslateHelper.bis_of_side} b',
          title: c.lB.value,
        ),
        ItemDetail(
          isActive: false,
          leading: 'lc',
          subtitle: '${TranslateHelper.bis_of_side} c',
          title: c.lC.value,
        ),
        ItemDetail(
          isActive: false,
          leading: 'r',
          subtitle: TranslateHelper.radius_diameter_inscribed_circle,
          title:
              'r ${c.rInscribed.value} / ⌀ ${AppUtilsNumber.getFormatNumber(c.rd * 2, c.precisionResult)}',
        ),
        ItemDetail(
          isActive: false,
          leading: 'X',
          subtitle: TranslateHelper.x_cord_Sr,
          title: c.xr.value,
        ),
        ItemDetail(
          isActive: false,
          leading: 'Y',
          subtitle: TranslateHelper.y_cord_Sr,
          title: c.yr.value,
        ),
      ],
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
          leading: 'ma',
          subtitle: '${TranslateHelper.med_of_side} a',
          title: c.mA.value,
        ),
        ItemDetail(
          isActive: false,
          leading: 'mb',
          subtitle: '${TranslateHelper.med_of_side} b',
          title: c.mB.value,
        ),
        ItemDetail(
          isActive: false,
          leading: 'mc',
          subtitle: '${TranslateHelper.med_of_side} c',
          title: c.mC.value,
        ),
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

class ScaleneSidesAngles extends StatelessWidget {
  const ScaleneSidesAngles({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // AppWidgets.dividerWelcome(),

        ItemDetail(
          isActive: c.isAvailableOneParam(Scalenequadrilateral.aSide),
          leading: 'a',
          subtitle: 'a - ${TranslateHelper.base_quadrilateral}',
          title: c.aSide.value,
        ),
        ItemDetail(
          isActive: c.isAvailableOneParam(Scalenequadrilateral.bSide),
          leading: 'b',
          subtitle: 'b - ${TranslateHelper.sides_quadrilateral}',
          title: c.bSide.value,
        ),
        ItemDetail(
          isActive: c.isAvailableOneParam(Scalenequadrilateral.cSide),
          leading: 'c',
          subtitle: 'c - ${TranslateHelper.sides_quadrilateral}',
          title: c.cSide.value,
        ),
        ItemDetail(
          isActive: c.isAvailableOneParam(Scalenequadrilateral.hHeight),
          leading: 'h',
          subtitle: TranslateHelper.h_height_quadrilateral,
          title: c.hHeight.value,
        ),
        ItemDetail(
          isActive: c.isAvailableOneParam(Scalenequadrilateral.aAngle),
          leading: 'α',
          subtitle: 'α - ${TranslateHelper.internal_angle_degrees}',
          title: c.aAngle.value,
        ),
        ItemDetail(
          isActive: c.isAvailableOneParam(Scalenequadrilateral.bAngle),
          leading: 'β',
          subtitle: 'β - ${TranslateHelper.internal_angle_degrees}',
          title: c.bAngle.value,
        ),
        ItemDetail(
          isActive: c.isAvailableOneParam(Scalenequadrilateral.yAngle),
          leading: 'γ',
          subtitle: 'γ - ${TranslateHelper.internal_angle_degrees}',
          title: c.yAngle.value,
        ),
      ],
    );
  }
}
