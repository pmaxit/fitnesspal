import 'package:flutter/material.dart';
import 'package:fitnesspal/core/theme/colors.dart';

class AvatarWidget extends StatefulWidget {
  final bool isDarkMode;

  const AvatarWidget({Key? key, required this.isDarkMode}) : super(key: key);

  @override
  State<AvatarWidget> createState() => _AvatarWidgetState();
}

class _AvatarWidgetState extends State<AvatarWidget> {
  String _selectedTime = 'Today';

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDarkMode;
    final bgCard = isDark ? AppColors.darkBgCard : AppColors.lightBgCard;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final fg1 = isDark ? AppColors.darkFg1 : AppColors.lightFg1;
    final fg2 = isDark ? AppColors.darkFg2 : AppColors.lightFg2;
    final fg3 = isDark ? AppColors.darkFg3 : AppColors.lightFg3;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: bgCard,
        border: Border.all(color: border),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          // Avatar stage
          Container(
            height: 260,
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.topCenter,
                radius: 0.8,
                colors: [
                  isDark
                    ? Colors.green.withOpacity(0.16)
                    : Colors.green.withOpacity(0.08),
                  Colors.transparent,
                ],
              ),
            ),
            child: Center(
              child: _buildStylizedAvatar(isDark),
            ),
          ),
          // Time slider
          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkBgPill : AppColors.lightBgPill,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Row(
                    children: [
                      _timeTab('Today', fg1, fg2),
                      _timeTab('+4 weeks', fg1, fg2),
                      _timeTab('+12 weeks', fg1, fg2),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Projected progress',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: _selectedTime == 'Today' ? '+0 lbs' : '+3-5 lbs',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.accent,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _timeTab(String label, Color fg1, Color fg2) {
    final isActive = _selectedTime == label;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTime = label),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          decoration: BoxDecoration(
            color: isActive ? AppColors.accent : Colors.transparent,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isActive ? Colors.white : fg2,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStylizedAvatar(bool isDark) {
    // Simplified SVG-like body visualization
    return Stack(
      alignment: Alignment.center,
      children: [
        // Body glow
        Container(
          width: 120,
          height: 180,
          decoration: BoxDecoration(
            gradient: RadialGradient(
              colors: [
                AppColors.accent.withOpacity(0.2),
                AppColors.accent.withOpacity(0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(60),
          ),
        ),
        // Body shape
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Head
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isDark
                  ? AppColors.darkBgCardSolid
                  : AppColors.lightBgCardSolid,
                border: Border.all(
                  color: isDark
                    ? AppColors.darkBorderStrong
                    : AppColors.lightBorderStrong,
                ),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(height: 8),
            // Torso
            Container(
              width: 50,
              height: 70,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.accent.withOpacity(0.3),
                    AppColors.accent.withOpacity(0.5),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isDark
                    ? AppColors.darkBorderStrong
                    : AppColors.lightBorderStrong,
                ),
              ),
            ),
            const SizedBox(height: 6),
            // Legs
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _legColumn(),
                const SizedBox(width: 8),
                _legColumn(),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _legColumn() {
    return Column(
      children: [
        Container(
          width: 16,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.accent.withOpacity(0.25),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        Container(
          width: 18,
          height: 12,
          decoration: BoxDecoration(
            color: AppColors.accent.withOpacity(0.2),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ],
    );
  }
}
