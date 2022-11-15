import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';

import '../app_icons.dart';

class CommonRatingBar extends StatefulWidget {
  final double initialRating;
  final bool isDisabled;
  final double itemSize;
  final ValueSetter<double>? getRating;
  const CommonRatingBar(
      {Key? key,
      this.initialRating = 0,
      this.isDisabled = true,
      this.itemSize = 35,
      this.getRating})
      : super(key: key);

  @override
  State<CommonRatingBar> createState() => _CommonRatingBarState();
}

class _CommonRatingBarState extends State<CommonRatingBar> {
  @override
  Widget build(BuildContext context) {
    return RatingBar.builder(
        initialRating: widget.initialRating,
        minRating: 1,
        direction: Axis.horizontal,
        itemCount: 5,
        itemSize: widget.itemSize,
        glow: false,
        ignoreGestures: widget.isDisabled,
        itemPadding: const EdgeInsets.symmetric(horizontal: 2),
        itemBuilder: (context, _) {
          return SvgPicture.asset(AppIcon.starIcon);
        },
        onRatingUpdate: (rating) {
          if (widget.getRating != null) {
            widget.getRating!(rating);
          }
        });
  }
}
