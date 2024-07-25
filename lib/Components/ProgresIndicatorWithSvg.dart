import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:semicircle_indicator/semicircle_indicator.dart';

class ProgressIndicatorWithSvg extends StatelessWidget {
  final double screenWidth;
  final double screenHeight;
  final double progress;
  final String assetPath;
  final String text;

  const ProgressIndicatorWithSvg({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
    required this.progress,
    required this.text,
    required this.assetPath,
  });

  @override
  Widget build(BuildContext context) {
    double normalizedProgress = (progress.clamp(0, 100)) / 100;
    return SizedBox(
      width: screenWidth * 0.1,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 0.1 * screenWidth,
            width: 0.1 * screenWidth,
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                SemicircularIndicator(
                  radius: 0.08 * screenWidth, // Adjust the radius accordingly
                  color: Theme.of(context).colorScheme.primary,
                  backgroundColor:
                      Theme.of(context).colorScheme.primary.withOpacity(0.40),
                  strokeWidth: 7, // Adjust the stroke width accordingly
                  progress: normalizedProgress, // Your dynamic progress value

                  contain: false, // Adjust if necessary
                ),
                Positioned(
                  bottom: 0,
                  child: SvgPicture.asset(
                    assetPath,
                    width: 0.06 * screenWidth,
                    height: 0.06 * screenWidth,
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: screenHeight * 0.01,
          ),
          AutoSizeText(
            text,
            style: TextStyle(
              decoration: TextDecoration.none,
              fontSize: 20,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            minFontSize: 5,
            maxFontSize: 35,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.clip,
          ),
        ],
      ),
    );
  }
}
