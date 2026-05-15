// Inline Lucide-style icons. 1.5px stroke, currentColor, rounded.
// We only ship what FitnessPal uses.

const Ico = ({ size = 18, stroke = 1.75, children, ...p }) => (
  <svg
    xmlns="http://www.w3.org/2000/svg"
    width={size} height={size}
    viewBox="0 0 24 24"
    fill="none"
    stroke="currentColor"
    strokeWidth={stroke}
    strokeLinecap="round"
    strokeLinejoin="round"
    {...p}
  >{children}</svg>
);

// nav / chrome
const IconHome = (p) => <Ico {...p}><path d="M3 11l9-8 9 8M5 10v10a1 1 0 0 0 1 1h3v-6h6v6h3a1 1 0 0 0 1-1V10"/></Ico>;
const IconActivity = (p) => <Ico {...p}><path d="M22 12h-4l-3 9L9 3l-3 9H2"/></Ico>;
const IconPlate = (p) => <Ico {...p}><circle cx="12" cy="12" r="9"/><circle cx="12" cy="12" r="4"/></Ico>;
const IconLeaf = (p) => <Ico {...p}><path d="M6 21c0-8 5-13 14-14-1 9-6 14-14 14z"/><path d="M6 21c2-5 5-8 10-10"/></Ico>;
const IconCheckSquare = (p) => <Ico {...p}><polyline points="9 11 12 14 22 4"/><path d="M21 12v7a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11"/></Ico>;
const IconUser = (p) => <Ico {...p}><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/></Ico>;

// actions
const IconBell = (p) => <Ico {...p}><path d="M6 8a6 6 0 0 1 12 0c0 7 3 9 3 9H3s3-2 3-9"/><path d="M10.3 21a1.94 1.94 0 0 0 3.4 0"/></Ico>;
const IconSparkles = (p) => <Ico {...p}><path d="M12 3l1.5 4.5L18 9l-4.5 1.5L12 15l-1.5-4.5L6 9l4.5-1.5z"/><path d="M19 14l.8 2.2L22 17l-2.2.8L19 20l-.8-2.2L16 17l2.2-.8z"/><path d="M5 17l.6 1.6L7 19l-1.4.4L5 21l-.6-1.6L3 19l1.4-.4z"/></Ico>;
const IconChevR = (p) => <Ico {...p}><polyline points="9 6 15 12 9 18"/></Ico>;
const IconChevL = (p) => <Ico {...p}><polyline points="15 6 9 12 15 18"/></Ico>;
const IconPlus = (p) => <Ico {...p}><line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/></Ico>;
const IconFlame = (p) => <Ico {...p}><path d="M8.5 14.5A2.5 2.5 0 0 0 11 17a3 3 0 0 1-3-3c0-1 1-3.5 3-5.5 2 2 3 4.5 3 5.5a3 3 0 0 1-3 3 2.5 2.5 0 0 0 2.5-2.5C13.5 12 12 10 12 8.5c0-2 1-3.5 2.5-4.5C16 5 19 8 19 13a7 7 0 0 1-14 0c0-2 1-4 2-5 0 1.5.5 3 1.5 4z"/></Ico>;
const IconDrop = (p) => <Ico {...p}><path d="M12 2.5c-3 4-7 8-7 12a7 7 0 1 0 14 0c0-4-4-8-7-12z"/></Ico>;
const IconHeart = (p) => <Ico {...p}><path d="M20.8 4.6a5.5 5.5 0 0 0-7.8 0L12 5.6l-1-1a5.5 5.5 0 0 0-7.8 7.8l1 1L12 21l7.8-7.6 1-1a5.5 5.5 0 0 0 0-7.8z"/></Ico>;
const IconMoon = (p) => <Ico {...p}><path d="M21 12.8A9 9 0 1 1 11.2 3a7 7 0 0 0 9.8 9.8z"/></Ico>;
const IconSun = (p) => <Ico {...p}><circle cx="12" cy="12" r="4"/><path d="M12 2v2M12 20v2M4.93 4.93l1.41 1.41M17.66 17.66l1.41 1.41M2 12h2M20 12h2M4.93 19.07l1.41-1.41M17.66 6.34l1.41-1.41"/></Ico>;
const IconDumbbell = (p) => <Ico {...p}><path d="M14.4 14.4L9.6 9.6"/><path d="M18.66 17.66l-2.12 2.12-3.54-3.54"/><path d="M21.5 14.5l-1.41 1.41"/><path d="M3.5 9.5l1.41-1.41"/><path d="M5.34 6.34L3.22 8.46l3.54 3.54"/><path d="M2.5 9.5l1.41 1.41"/><path d="M20.5 14.5l1.41-1.41"/></Ico>;
const IconRun = (p) => <Ico {...p}><circle cx="13" cy="4" r="2"/><path d="M4 22l5-7 4-2 2-4M9 15l2 3M19 11l-5-2"/></Ico>;
const IconBed = (p) => <Ico {...p}><path d="M2 18v-9M2 13h20v5M22 18v-5a3 3 0 0 0-3-3H11v6M6 13a2 2 0 1 0 0-4 2 2 0 0 0 0 4z"/></Ico>;
const IconMic = (p) => <Ico {...p}><rect x="9" y="2" width="6" height="12" rx="3"/><path d="M5 10a7 7 0 0 0 14 0M12 17v4"/></Ico>;
const IconCam = (p) => <Ico {...p}><path d="M23 19V8a2 2 0 0 0-2-2h-3.2l-1.5-2h-5.6L9.2 6H6a2 2 0 0 0-2 2v11a2 2 0 0 0 2 2h15a2 2 0 0 0 2-2z"/><circle cx="12" cy="13" r="3.5"/></Ico>;
const IconType = (p) => <Ico {...p}><polyline points="4 7 4 4 20 4 20 7"/><line x1="9" y1="20" x2="15" y2="20"/><line x1="12" y1="4" x2="12" y2="20"/></Ico>;
const IconFilter = (p) => <Ico {...p}><polygon points="22 3 2 3 10 12.5 10 19 14 21 14 12.5 22 3"/></Ico>;
const IconBolt = (p) => <Ico {...p}><polygon points="13 2 3 14 12 14 11 22 21 10 12 10 13 2"/></Ico>;
const IconNote = (p) => <Ico {...p}><path d="M14 3H6a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V9z"/><polyline points="14 3 14 9 20 9"/></Ico>;
const IconPill = (p) => <Ico {...p}><path d="M10.5 20.5a7 7 0 0 1-7-7 7 7 0 0 1 7-7 7 7 0 0 1 7 7 7 7 0 0 1-7 7z"/><line x1="8.5" y1="8.5" x2="15.5" y2="15.5"/></Ico>;
const IconTrend = (p) => <Ico {...p}><polyline points="22 6 13.5 14.5 8.5 9.5 2 16"/><polyline points="16 6 22 6 22 12"/></Ico>;
const IconShield = (p) => <Ico {...p}><path d="M12 2L3 6v6c0 5.5 3.8 10.4 9 11 5.2-.6 9-5.5 9-11V6l-9-4z"/></Ico>;
const IconSettings = (p) => <Ico {...p}><circle cx="12" cy="12" r="3"/><path d="M19.4 15a1.65 1.65 0 0 0 .33 1.82l.06.06a2 2 0 1 1-2.83 2.83l-.06-.06a1.65 1.65 0 0 0-1.82-.33 1.65 1.65 0 0 0-1 1.51V21a2 2 0 1 1-4 0v-.09a1.65 1.65 0 0 0-1-1.51 1.65 1.65 0 0 0-1.82.33l-.06.06a2 2 0 1 1-2.83-2.83l.06-.06a1.65 1.65 0 0 0 .33-1.82 1.65 1.65 0 0 0-1.51-1H3a2 2 0 1 1 0-4h.09a1.65 1.65 0 0 0 1.51-1 1.65 1.65 0 0 0-.33-1.82l-.06-.06a2 2 0 1 1 2.83-2.83l.06.06a1.65 1.65 0 0 0 1.82.33h0a1.65 1.65 0 0 0 1-1.51V3a2 2 0 1 1 4 0v.09a1.65 1.65 0 0 0 1 1.51h0a1.65 1.65 0 0 0 1.82-.33l.06-.06a2 2 0 1 1 2.83 2.83l-.06.06a1.65 1.65 0 0 0-.33 1.82v0a1.65 1.65 0 0 0 1.51 1H21a2 2 0 1 1 0 4h-.09a1.65 1.65 0 0 0-1.51 1z"/></Ico>;
const IconTarget = (p) => <Ico {...p}><circle cx="12" cy="12" r="10"/><circle cx="12" cy="12" r="6"/><circle cx="12" cy="12" r="2"/></Ico>;
const IconScan = (p) => <Ico {...p}><path d="M3 7V5a2 2 0 0 1 2-2h2M17 3h2a2 2 0 0 1 2 2v2M21 17v2a2 2 0 0 1-2 2h-2M7 21H5a2 2 0 0 1-2-2v-2"/><line x1="7" y1="12" x2="17" y2="12"/></Ico>;
const IconRefresh = (p) => <Ico {...p}><polyline points="23 4 23 10 17 10"/><polyline points="1 20 1 14 7 14"/><path d="M3.5 9a9 9 0 0 1 14.85-3.36L23 10M1 14l4.64 4.36A9 9 0 0 0 20.5 15"/></Ico>;
const IconSmile = (p) => <Ico {...p}><circle cx="12" cy="12" r="10"/><path d="M8 14s1.5 2 4 2 4-2 4-2"/><line x1="9" y1="9" x2="9.01" y2="9"/><line x1="15" y1="9" x2="15.01" y2="9"/></Ico>;
const IconLock = (p) => <Ico {...p}><rect x="3" y="11" width="18" height="11" rx="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/></Ico>;
const IconDevice = (p) => <Ico {...p}><rect x="5" y="2" width="14" height="20" rx="2"/><line x1="12" y1="18" x2="12.01" y2="18"/></Ico>;
const IconPath = (p) => <Ico {...p}><circle cx="6" cy="6" r="3"/><circle cx="18" cy="18" r="3"/><path d="M9 6h6a3 3 0 0 1 3 3v0a3 3 0 0 1-3 3H9a3 3 0 0 0-3 3v0a3 3 0 0 0 3 3"/></Ico>;
const IconWaves = (p) => <Ico {...p}><path d="M2 6c1.5 0 1.5 2 3 2s1.5-2 3-2 1.5 2 3 2 1.5-2 3-2 1.5 2 3 2 1.5-2 3-2 1.5 2 3 2"/><path d="M2 12c1.5 0 1.5 2 3 2s1.5-2 3-2 1.5 2 3 2 1.5-2 3-2 1.5 2 3 2 1.5-2 3-2 1.5 2 3 2"/><path d="M2 18c1.5 0 1.5 2 3 2s1.5-2 3-2 1.5 2 3 2 1.5-2 3-2 1.5 2 3 2 1.5-2 3-2 1.5 2 3 2"/></Ico>;

Object.assign(window, {
  IconHome, IconActivity, IconPlate, IconLeaf, IconCheckSquare, IconUser,
  IconBell, IconSparkles, IconChevR, IconChevL, IconPlus, IconFlame,
  IconDrop, IconHeart, IconMoon, IconSun, IconDumbbell, IconRun, IconBed,
  IconMic, IconCam, IconType, IconFilter, IconBolt, IconNote, IconPill,
  IconTrend, IconShield, IconSettings, IconTarget, IconScan, IconRefresh,
  IconSmile, IconLock, IconDevice, IconPath, IconWaves,
});
