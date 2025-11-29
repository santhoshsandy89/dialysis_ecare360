import 'package:ecare360/core/constants/app_constants.dart';
import 'package:flutter/material.dart';

class ResponsiveScaffold extends StatelessWidget {
  final Widget mobile;
  final Widget tablet;
  final Widget desktop;

  const ResponsiveScaffold({
    super.key,
    required this.mobile,
    required this.tablet,
    required this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    if (width < AppConstants.mobile) {
      return mobile; // Mobile layout
    } else if (width < AppConstants.tablet) {
      return tablet; // Tablet portrait layout
    } else {
      return desktop; // Large tablet landscape + Desktop layout
    }
  }
}
