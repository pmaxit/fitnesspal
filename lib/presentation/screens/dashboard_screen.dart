import 'package:flutter/material.dart';
import 'package:fitnesspal/core/theme/colors.dart';

class DashboardScreen extends StatelessWidget {
  final bool isDarkMode;

  const DashboardScreen({Key? key, required this.isDarkMode}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBgApp,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header Area ──
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    // Header content will be added in a later task
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ── Hero Card Area ──
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Hero card content will be added in a later task
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ── Metric Grid Area ──
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Metric grid content will be added in a later task
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ── CTA Area ──
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // CTA content will be added in a later task
                  ],
                ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

class _MetricCardData {
  final String label;
  final String value;
  final String unit;
  final double progress;
  final String trend;

  const _MetricCardData({
    required this.label,
    required this.value,
    required this.unit,
    required this.progress,
    required this.trend,
  });
}

class DashboardScreen extends StatelessWidget {
  final bool isDarkMode;

  const DashboardScreen({Key? key, required this.isDarkMode}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBgApp,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header Area ──
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    // Header content will be added in a later task
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ── Hero Card Area ──
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Hero card content will be added in a later task
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ── Metric Grid Area ──
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Metric grid content will be added in a later task
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ── CTA Area ──
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // CTA content will be added in a later task
                  ],
                ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
