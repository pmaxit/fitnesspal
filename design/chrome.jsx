// FitnessPal — chrome (header, tabbar, status helpers)
const {
  IconHome, IconActivity, IconPlate, IconLeaf, IconCheckSquare, IconUser,
  IconBell, IconSparkles, IconChevR,
} = window;

function FpHeader({ eyebrow, title, sub, actions, dense }) {
  return (
    <div className="fp-hdr" style={dense ? { padding: '6px 22px 8px' } : {}}>
      <div style={{ minWidth: 0, flex: 1 }}>
        {eyebrow && <div className="fp-hdr-eyebrow">{eyebrow}</div>}
        <div className="fp-hdr-title">{title}</div>
        {sub && <div className="fp-hdr-sub">{sub}</div>}
      </div>
      {actions && <div className="fp-hdr-actions">{actions}</div>}
    </div>
  );
}

function FpTabBar({ active, onChange }) {
  const tabs = [
    { id: 'dashboard', icon: IconHome, label: 'Home' },
    { id: 'activity', icon: IconActivity, label: 'Activity' },
    { id: 'meals', icon: IconLeaf, label: 'Meals' },
    { id: 'habits', icon: IconCheckSquare, label: 'Habits' },
    { id: 'profile', icon: IconUser, label: 'Profile' },
  ];
  return (
    <div className="fp-tabbar">
      {tabs.map(t => {
        const I = t.icon;
        const isActive = active === t.id;
        return (
          <button key={t.id} className={`fp-tab ${isActive ? 'active' : ''}`} onClick={() => onChange?.(t.id)}>
            <span className="fp-tab-icon"><I size={22} stroke={isActive ? 2.25 : 1.75}/></span>
            <span>{t.label}</span>
          </button>
        );
      })}
    </div>
  );
}

// Reusable progress ring (svg)
function FpRing({ value, max = 100, size = 64, stroke = 6, color, children, ariaLabel }) {
  const r = (size - stroke) / 2;
  const c = 2 * Math.PI * r;
  const off = c * (1 - value / max);
  return (
    <svg className="fp-ring" width={size} height={size} aria-label={ariaLabel}>
      <circle className="fp-ring-track" cx={size/2} cy={size/2} r={r} strokeWidth={stroke}/>
      <circle
        className="fp-ring-fill"
        cx={size/2} cy={size/2} r={r}
        strokeWidth={stroke}
        strokeDasharray={c}
        strokeDashoffset={off}
        style={color ? { stroke: color, filter: `drop-shadow(0 0 6px ${color}55)` } : undefined}
      />
      {children && (
        <foreignObject x="0" y="0" width={size} height={size} style={{ transform: 'rotate(90deg)', transformOrigin: 'center' }}>
          <div style={{
            width: size, height: size,
            display: 'flex', alignItems: 'center', justifyContent: 'center',
            transform: 'rotate(-90deg)',
          }}>{children}</div>
        </foreignObject>
      )}
    </svg>
  );
}

Object.assign(window, { FpHeader, FpTabBar, FpRing });
