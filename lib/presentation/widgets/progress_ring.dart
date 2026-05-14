import 'package:flutter/material.dart';
import 'package:fitnesspal/core/theme/colors.dart';

class ProgressRing extends StatelessWidget {
  final double percentage;
  final double size;
  final String label;
  final String value;
  final String unit;
  final Color? trackColor;
  final Color? fillColor;
  final Color? glowColor;
  final double strokeWidth;
  final Widget? centerWidget;

  const ProgressRing({
    Key? key,
    required this.percentage,
    this.size = 110,
    required this.label,
    required this.value,
    required this.unit,
    this.trackColor,
    this.fillColor,
    this.glowColor,
    this.strokeWidth = 8,
    this.centerWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final track = trackColor ?? (isDark ? AppColors.darkBorder : AppColors.lightBorder);
    final fill = fillColor ?? AppColors.accent;

    return Column(
      children: [
        SizedBox(
          width: size,
          height: size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(
                painter: RingPainter(
                  trackColor: track,
                  fillColor: fill,
                  percentage: percentage,
                  strokeWidth: strokeWidth,
                  glowColor: glowColor,
                ),
                size: Size(size, size),
              ),
              centerWidget ??
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            value,
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 2),
                            child: Text(
                              unit,
                              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
            ],
          ),
        ),
        SizedBox(height: 8),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
}

class RingPainter extends CustomPainter {
  final Color trackColor;
  final Color fillColor;
  final double percentage;
  final double strokeWidth;
  final Color? glowColor;
  final double glowRadius;

  RingPainter({
    required this.trackColor,
    required this.fillColor,
    required this.percentage,
    this.strokeWidth = 8,
    this.glowColor,
    this.glowRadius = 8,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Draw track
    paint.color = trackColor;
    canvas.drawCircle(center, radius, paint);

    const startAngle = -3.14159 / 2;
    final sweepAngle = (2 * 3.14159) * (percentage / 100);

    // Draw glow layer (behind fill)
    if (glowColor != null) {
      final glowPaint = Paint()
        ..strokeWidth = strokeWidth
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..color = glowColor!
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, glowRadius);

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        glowPaint,
      );
    }

    // Draw fill
    paint.color = fillColor;
    paint.shader = SweepGradient(
      colors: [fillColor.withOpacity(0.5), fillColor],
    ).createShader(Rect.fromCircle(center: center, radius: radius));

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(RingPainter oldDelegate) =>
    oldDelegate.percentage != percentage ||
    oldDelegate.fillColor != fillColor ||
    oldDelegate.trackColor != trackColor ||
    oldDelegate.strokeWidth != strokeWidth ||
    oldDelegate.glowColor != glowColor ||
    oldDelegate.glowRadius != glowRadius;
}

    // Draw fill
    paint.color = fillColor;
    paint.shader = SweepGradient(
      colors: [fillColor.withOpacity(0.5), fillColor],
    ).createShader(Rect.fromCircle(center: center, radius: radius));

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(RingPainter oldDelegate) =>
    oldDelegate.percentage != percentage ||
    oldDelegate.fillColor != fillColor ||
    oldDelegate.trackColor != trackColor ||
    oldDelegate.strokeWidth != strokeWidth ||
    oldDelegate.glowColor != glowColor ||
    oldDelegate.glowRadius != glowRadius;
}
