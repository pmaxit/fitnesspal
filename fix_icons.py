import os
import glob

for filepath in glob.glob("lib/presentation/screens/*.dart"):
    with open(filepath, "r") as f:
        content = f.read()

    original = content
    content = content.replace("LucideIcons.plus_rounded", "LucideIcons.plus")
    content = content.replace("LucideIcons.flame_rounded", "LucideIcons.flame")
    content = content.replace("LucideLucideIcons", "LucideIcons")
    content = content.replace("LucideIcons.checkSquare_outlined", "LucideIcons.checkSquare")
    content = content.replace("LucideIcons.sliders_rounded", "LucideIcons.sliders")
    content = content.replace("LucideIcons.chevronLeft_rounded", "LucideIcons.chevronLeft")
    content = content.replace("LucideIcons.chevronRight_rounded", "LucideIcons.chevronRight")
    content = content.replace("const Icon(LucideIcons.", "Icon(LucideIcons.")
    
    if content != original:
        with open(filepath, "w") as f:
            f.write(content)
