import 'package:flutter/material.dart';

class AppColors {
  // Accent
  static const Color accent = Color(0xFF10B981);
  static const Color accentHover = Color(0xFF059669);
  static const Color accentSoft = Color.fromARGB(26, 16, 185, 129);
  static const Color accentSoft2 = Color.fromARGB(46, 16, 185, 129);
  static const Color accentGlow = Color.fromARGB(102, 16, 185, 129);

  // Status
  static const Color easy = Color(0xFF10B981);
  static const Color medium = Color(0xFFF59E0B);
  static const Color hard = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);
  static const Color danger = Color(0xFFEF4444);

  // Dark theme
  static const Color darkBgApp = Color(0xFF020617);
  static const Color darkBgApp2 = Color(0xFF0A0F1D);
  static const Color darkBgCard = Color.fromARGB(140, 30, 41, 59);
  static const Color darkBgCardSolid = Color(0xFF131C2E);
  static const Color darkBgElevated = Color(0xFF1A2438);
  static const Color darkBgOverlay = Color.fromARGB(128, 15, 23, 42);
  static const Color darkBgTab = Color.fromARGB(199, 10, 14, 26);
  static const Color darkBgPill = Color.fromARGB(15, 255, 255, 255);

  static const Color darkFg1 = Color(0xFFF1F5F9);
  static const Color darkFg2 = Color(0xFF94A3B8);
  static const Color darkFg3 = Color(0xFF64748B);
  static const Color darkFgDisabled = Color(0xFF475569);

  static const Color darkBorder = Color.fromARGB(128, 51, 65, 85);
  static const Color darkBorderStrong = Color(0xFF334155);
  static const Color darkBorderSubtle = Color.fromARGB(13, 255, 255, 255);

  static const Color darkShadowSm = Color.fromARGB(46, 0, 0, 0);
  static const Color darkShadowMd = Color.fromARGB(71, 0, 0, 0);
  static const Color darkShadowLg = Color.fromARGB(102, 0, 0, 0);

  // Light theme
  static const Color lightBgApp = Color(0xFFF6F7F9);
  static const Color lightBgApp2 = Color(0xFFFFFFFF);
  static const Color lightBgCard = Color(0xFFFFFFFF);
  static const Color lightBgCardSolid = Color(0xFFFFFFFF);
  static const Color lightBgElevated = Color(0xFFFFFFFF);
  static const Color lightBgOverlay = Color.fromARGB(179, 241, 245, 249);
  static const Color lightBgTab = Color.fromARGB(224, 255, 255, 255);
  static const Color lightBgPill = Color.fromARGB(13, 15, 23, 42);

  static const Color lightFg1 = Color(0xFF0F172A);
  static const Color lightFg2 = Color(0xFF475569);
  static const Color lightFg3 = Color(0xFF64748B);
  static const Color lightFgDisabled = Color(0xFFCBD5E1);

  static const Color lightBorder = Color.fromARGB(18, 15, 23, 42);
  static const Color lightBorderStrong = Color.fromARGB(31, 15, 23, 42);
  static const Color lightBorderSubtle = Color.fromARGB(10, 15, 23, 42);

  static const Color lightShadowSm = Color.fromARGB(10, 15, 23, 42);
  static const Color lightShadowMd = Color.fromARGB(15, 15, 23, 42);
  static const Color lightShadowLg = Color.fromARGB(26, 15, 23, 42);

  // Heat map colors
  static const List<Color> darkHeatMap = [
    Color.fromARGB(20, 148, 163, 184),
    Color.fromARGB(51, 16, 185, 129),
    Color.fromARGB(115, 16, 185, 129),
    Color.fromARGB(179, 16, 185, 129),
    accent,
  ];

  static const List<Color> lightHeatMap = [
    Color.fromARGB(13, 15, 23, 42),
    Color.fromARGB(46, 16, 185, 129),
    Color.fromARGB(102, 16, 185, 129),
    Color.fromARGB(166, 16, 185, 129),
    accent,
  ];
}
