import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:template/common/app_colors.dart';

class ProgressView extends StatefulWidget {
  const ProgressView({Key? key}) : super(key: key);

  @override
  _ProgressViewState createState() => _ProgressViewState();
}

class _ProgressViewState extends State<ProgressView> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(80.0),
      child: SizedBox(
        width: 70.0,
        height: 70.0,
        child: SizedBox(
          height: 60.0,
          width: 60.0,
          child: SpinKitCircle(color: AppColors.bgBlue, size: 60),
        ),
      ),
    );
  }
}
