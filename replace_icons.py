import os

replacements = {
    "Icons.add": "LucideIcons.plus",
    "Icons.home_outlined": "LucideIcons.home",
    "Icons.show_chart": "LucideIcons.activity",
    "Icons.eco_outlined": "LucideIcons.leaf",
    "Icons.check_box_outlined": "LucideIcons.checkSquare",
    "Icons.person_outline": "LucideIcons.user",
    "Icons.auto_awesome": "LucideIcons.sparkles",
    "Icons.camera_alt": "LucideIcons.camera",
    "Icons.videocam": "LucideIcons.video",
    "Icons.local_fire_department": "LucideIcons.flame",
    "Icons.fitness_center": "LucideIcons.dumbbell",
    "Icons.bakery_dining": "LucideIcons.croissant",
    "Icons.opacity": "LucideIcons.droplets",
    "Icons.remove": "LucideIcons.minus",
    "Icons.filter_alt_outlined": "LucideIcons.filter",
    "Icons.restaurant_outlined": "LucideIcons.utensils",
    "Icons.tune_rounded": "LucideIcons.sliders",
    "Icons.add_rounded": "LucideIcons.plus",
    "Icons.local_fire_department_rounded": "LucideIcons.flame",
    "Icons.chevron_left_rounded": "LucideIcons.chevronLeft",
    "Icons.chevron_right_rounded": "LucideIcons.chevronRight",
    "Icons.check": "LucideIcons.check",
    "Icons.settings_outlined": "LucideIcons.settings",
    "Icons.chevron_right": "LucideIcons.chevronRight",
    "Icons.track_changes": "LucideIcons.target",
    "Icons.bolt": "LucideIcons.zap",
    "Icons.favorite_border": "LucideIcons.heart",
    "Icons.sync": "LucideIcons.refreshCw",
    "Icons.route": "LucideIcons.navigation",
    "Icons.bed": "LucideIcons.bed",
    "Icons.favorite": "LucideIcons.heart",
    "Icons.restaurant": "LucideIcons.utensils",
    "Icons.directions_walk": "LucideIcons.footprints",
    "Icons.medication": "LucideIcons.pill",
    "Icons.water_drop": "LucideIcons.droplet",
    "Icons.event": "LucideIcons.calendar",
    "Icons.notifications_outlined": "LucideIcons.bell",
    "Icons.sentiment_satisfied": "LucideIcons.smile"
}

import glob

for filepath in glob.glob("lib/presentation/screens/*.dart"):
    with open(filepath, "r") as f:
        content = f.read()

    original_content = content
    for old, new in replacements.items():
        content = content.replace(old, new)
        
    if content != original_content:
        # Check if we need to add import
        if "import 'package:lucide_icons/lucide_icons.dart';" not in content:
            lines = content.split('\n')
            import_idx = 0
            for i, line in enumerate(lines):
                if line.startswith("import 'package:flutter/material.dart';"):
                    import_idx = i + 1
                    break
            lines.insert(import_idx, "import 'package:lucide_icons/lucide_icons.dart';")
            content = '\n'.join(lines)
            
        with open(filepath, "w") as f:
            f.write(content)

