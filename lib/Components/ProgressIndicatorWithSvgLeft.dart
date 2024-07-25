import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:semicircle_indicator/semicircle_indicator.dart';

class ProgressIndicatorWithSvgLeft extends StatelessWidget {
  final double screenWidth;
  final double screenHeight;
  final double progress;
  final String assetPath;
  final String text;
  final String titleText;

  const ProgressIndicatorWithSvgLeft({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
    required this.progress,
    required this.text,
    required this.assetPath,
    required this.titleText,
  });

  @override
  Widget build(BuildContext context) {
    double svgSize = 0.06 * screenWidth;
    double indicatorSize = 0.07 * screenHeight;
    double normalizedProgress = (progress.clamp(0, 100)) / 100;
    return SizedBox(
      width: screenWidth * 0.4,
      child: Column(
        children: [
          AutoSizeText(
            titleText,
            style: TextStyle(
              decoration: TextDecoration.none,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            minFontSize: 5,
            maxFontSize: 30,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.clip,
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Theme.of(context).colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: Offset(0, 1),
                ),
              ],
            ),
            width: screenWidth * 0.4,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: indicatorSize,
                  width: 0.2 * screenWidth,
                  child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      SemicircularIndicator(
                        radius: indicatorSize / 2,
                        color: Theme.of(context).colorScheme.primary,
                        backgroundColor: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.40),
                        strokeWidth: 8,
                        progress: normalizedProgress,
                        bottomPadding: 0,
                        contain: false,
                      ),
                      Positioned(
                        top: 30,
                        child: SvgPicture.asset(
                          assetPath,
                          width: svgSize,
                          height: svgSize,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: 0.01 * screenWidth,
                    right: 0.04 * screenWidth,
                  ), // Adjust padding as needed
                  child: AutoSizeText(
                    text,
                    style: TextStyle(
                      decoration: TextDecoration.none,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    minFontSize: 5,
                    maxFontSize: 30,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.clip,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
