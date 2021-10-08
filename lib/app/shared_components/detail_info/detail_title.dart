import 'package:calc_quadrilateral/app/config/theme/app_style.dart';
import 'package:flutter/material.dart';

class TextTitleDetail extends StatelessWidget {
  const TextTitleDetail({
    Key? key,
    required this.text,
  }) : super(key: key);
  final String text;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: AppStyleText.titleText(context),
      ),
    );
  }
}
